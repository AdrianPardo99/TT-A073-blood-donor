import datetime

from rest_framework import serializers

from django.utils.translation import pgettext_lazy

from blood_center.models import CenterTransfer, CenterTransferUnit, Unit
from ..blood_center.serializers import CenterDetailSerializer
from ..units.serializers import (
    UnitDetailSerializer,
    UnitListSerializer,
    UnitPlasmaListSerializer,
    UnitErythrocyteListSerializer,
)
from core.services.platelets import Client as PlateletsClient
from core.services.plasma import Client as PlasmaClient
from core.services.erythrocyte import Client as ErythrocyteClient
from core.utils import create_array_random, create_array_from_random


class CenterTransferUnitListSerializer(serializers.ModelSerializer):
    unit = UnitDetailSerializer()

    class Meta:
        model = CenterTransferUnit
        fields = [
            "id",
            "unit",
        ]


class CenterTransferUnitDetailListSerializer(serializers.ModelSerializer):
    unit = UnitListSerializer()

    class Meta:
        model = CenterTransferUnit
        fields = [
            "id",
            "unit",
        ]


class CenterTransferSerializer(serializers.ModelSerializer):
    class Meta:
        model = CenterTransfer
        fields = [
            "deadline",
            "type_deadline",
            "name",
            "comment",
            "receptor_blood_type",
            "unit_type",
            "qty",
        ]

    def create(self, validated_data):
        timestamp = datetime.datetime.now().__str__().replace(" ", "T")
        f = open(f"data_{timestamp}.txt", "a")
        request = self.context.get("request")
        center = self.context.get("center")
        deadline = validated_data.get("deadline")
        type_deadline = validated_data.get("type_deadline")
        name = validated_data.get("name")
        comment = validated_data.get("comment")
        receptor_blood_type = validated_data.get("receptor_blood_type")
        unit_type = validated_data.get("unit_type")
        qty = validated_data.get("qty")

        centers = []
        units = []
        final_unit = []
        transfer_units = []
        transfers = []
        platelets = PlateletsClient()
        plasma = PlasmaClient()
        erythrocyte = ErythrocyteClient()
        f.write(f"Total de unidades: {qty}\n")
        f.write(f"Realizado por: {request.user}\n")
        f.write(f"Receptor: {receptor_blood_type}\nTipo de unidad: {unit_type}\n")
        # Check platelets microservice for distance
        f.write("Entra a obtener centros distintos\n")
        for external in center.obtain_distinct_centers():
            if platelets.check_information(
                center, external, int(validated_data.get("type_deadline"))
            ):
                f.write("Entro en platelets\n")
                # Check if has units for transfer
                if external.units.filter(
                    type=unit_type, is_available=True, is_expired=False
                ).exists():

                    centers.append(external)

        if len(centers) > 0:
            array_centers = create_array_random(len(centers))
            # f.write("Crea arreglo")
            for i in range(len(array_centers)):
                if array_centers[i] == 1:
                    if (
                        not centers[i]
                        .units.filter(
                            type=unit_type,
                            is_available=True,
                            is_expired=False,
                            can_transfer=True,
                            expired_at__gt=deadline,
                        )
                        .exists()
                    ):
                        array_centers[i] = 0
            # f.write("Limpia centros")
            array_units = create_array_from_random(array_centers, qty)
            f.write("Creo unidades\n")
            # Next create a payload for plasma API
            f.write("Agrega utilidades\n")
            for i in range(len(array_units)):
                if array_units[i] != 0:
                    unit = UnitPlasmaListSerializer(
                        centers[i].units.filter(
                            type=unit_type,
                            is_available=True,
                            is_expired=False,
                            can_transfer=True,
                            expired_at__gt=deadline,
                        ),
                        many=True,
                    )
                    f.write(f"Plasma iteracion {i} con payload:\n{unit.data}\n")
                    units = plasma.check_information(
                        receptor_blood_type.upper(), array_units[i], unit
                    )
                    final_unit.append(units)
                else:
                    final_unit.append([])

            # Here we need to create payload for erythrocyte API
            f.write("Obtiene respuestas\n")
            for i in range(len(final_unit)):
                if len(final_unit[i]) > 0:
                    units = UnitErythrocyteListSerializer(
                        final_unit[i],
                        many=True,
                    )
                    f.write(f"Envia payload para mochila\n{units.data}")
                    resp = erythrocyte.check_information(
                        array_units[i],
                        units,
                    )
                    f.write("Recibe")
                    transfer_units_subarr = []
                    for unit_tra in resp:
                        transfer_units_subarr.append(unit_tra.get("id"))
                    transfer_units.append(
                        {
                            "center": centers[i],
                            "qty": array_units[i],
                            "id": transfer_units_subarr,
                        }
                    )
            f.write("Obtuvo\n")
            # Crear aqui las distintas transferencias, y listo
            # Para iterar para cada transferencia, se crea,
            #  --  Origen de quien recibira la notificación
            #  --  Destino de center (quien crea la transfer)
            # Resto de datos del modelo sin bronca (Salvar)
            # Para transfer Unit
            # se toma transfer, se accede a otro_centro del arreglo de transfer_unit (Al hacer save() no esta disponible la unidad...)
            # Se itera sobre cada id para ver que ahi pertenecen y hacer transferencia de unidad
            # Se retorna solo transfer
            f.write(f"Crea transferencias\n{transfer_units}")
            transfer = CenterTransfer()
            for other_center in transfer_units:
                if len(other_center.get("id")) > 0:
                    transfer = CenterTransfer(
                        deadline=deadline,
                        type_deadline=type_deadline,
                        name=name,
                        comment=comment,
                        receptor_blood_type=receptor_blood_type,
                        unit_type=unit_type,
                        qty=other_center.get("qty"),
                        origin=other_center.get("center"),
                        destination=center,
                    )
                    transfer.save()
                    for unit_id in other_center.get("id"):
                        unit = Unit.objects.filter(pk=unit_id)
                        if unit.exists():
                            transfer_unit = CenterTransferUnit(
                                transfer=transfer, unit=unit.first()
                            )
                            transfer_unit.reserve_unit()
                            transfer_unit.save()
                    transfers.append(transfer)
        f.close()
        return transfers


class CenterTransferDetailSerializer(serializers.ModelSerializer):
    origin = CenterDetailSerializer()
    destination = CenterDetailSerializer()
    status = serializers.CharField(source="get_status_display")
    type_deadline = serializers.CharField(source="get_type_deadline_display")
    receptor_blood_type = serializers.CharField(
        source="get_receptor_blood_type_display"
    )
    units = CenterTransferUnitListSerializer(many=True)
    unit_type = serializers.CharField(source="get_unit_type_display")

    class Meta:
        model = CenterTransfer
        fields = [
            "id",
            "origin",
            "destination",
            "status",
            "deadline",
            "type_deadline",
            "name",
            "comment",
            "receptor_blood_type",
            "unit_type",
            "qty",
            "units",
        ]


class CenterTransferListSerializer(serializers.ModelSerializer):
    origin = CenterDetailSerializer()
    destination = CenterDetailSerializer()
    status = serializers.CharField(source="get_status_display")
    type_deadline = serializers.CharField(source="get_type_deadline_display")
    receptor_blood_type = serializers.CharField(
        source="get_receptor_blood_type_display"
    )
    unit_type = serializers.CharField(source="get_unit_type_display")

    class Meta:
        model = CenterTransfer
        fields = [
            "id",
            "origin",
            "destination",
            "status",
            "deadline",
            "type_deadline",
            "receptor_blood_type",
            "unit_type",
        ]
