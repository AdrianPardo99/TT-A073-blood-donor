import 'package:blood_bank/models/http/transfer_detail_response.dart';
import 'package:blood_bank/providers/transfers_provider.dart';
import 'package:blood_bank/ui/buttons/custon_icon_button.dart';
import 'package:blood_bank/ui/labels/custom_labels.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class TransferModal extends StatelessWidget {
  final TransferDetailResponse transfer;
  final String status;
  final int type;

  const TransferModal(
      {super.key,
      required this.transfer,
      required this.status,
      required this.type});

  @override
  Widget build(BuildContext context) {
    final format = DateFormat("yyyy-MM-ddThh:mm");
    final incident = Provider.of<TransfersProvider>(context);
    final size = MediaQuery.of(context).size;
    tz.initializeTimeZones();
    final location = tz.getLocation('America/Mexico_City');
    return Container(
      padding: EdgeInsets.all(20),
      height: size.height,
      decoration: buildBoxDecoration(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Transferencia ${transfer.id}",
                style: CustomLabels.h1.copyWith(color: Colors.white),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Divider(color: Colors.white.withOpacity(0.3)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (size.width >= 1200) SizedBox(width: (size.width / 3) - 110),
              Icon(Mdi.hospitalBuilding, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "Origen: ${transfer.origin.name}",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (size.width >= 1200) SizedBox(width: (size.width / 3) - 110),
              Icon(Icons.local_hospital_outlined, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "Destino: ${transfer.destination.name}",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (size.width >= 1200) SizedBox(width: (size.width / 3) - 110),
              Icon(Mdi.listStatus, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "Estatus: ${status}",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (size.width >= 1200) SizedBox(width: (size.width / 3) - 110),
              Icon(Mdi.calendarClock, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "Fecha de espera: ${format.format(tz.TZDateTime.from(transfer.deadline, location))}",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (size.width >= 1200) SizedBox(width: (size.width / 3) - 110),
              Icon(Mdi.informationOutline, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "Nombre de la transferencia: ${transfer.name}",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (size.width >= 1200) SizedBox(width: (size.width / 3) - 110),
              Icon(Mdi.informationOutline, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "Comentarios: ${transfer.comment}",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (size.width >= 1200) SizedBox(width: (size.width / 3) - 110),
              Icon(Mdi.bloodBag, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "Unidad(es) solicitadas: ${transfer.unitType}",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (size.width >= 1200) SizedBox(width: (size.width / 3) - 110),
              Icon(Icons.bloodtype_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "Tipo de sangre del receptor: ${transfer.receptorBloodType}",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (size.width >= 1200) SizedBox(width: (size.width / 3) - 110),
              Icon(Mdi.waterPlus, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "Cantidad de unidad(es): ${transfer.qty}",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          SizedBox(height: 10),
          for (int i = 0; i < transfer.units.length; i++) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (size.width >= 1200) SizedBox(width: (size.width / 3) - 110),
                Icon(Icons.medication_outlined, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  "Unidad ${transfer.units[i].unit.id} ${transfer.units[i].unit.bloodType}",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      CustomIconButton(
                        onPressed: () {
                          String reason = "";
                          final dialog = AlertDialog(
                            title: Text("Agregando incidencia"),
                            content: TextField(
                              onChanged: (value) => reason = value,
                              decoration: InputDecoration(
                                  hintText: "Describir la incidencia"),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text("Cancelar"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  if (reason != null && reason.isNotEmpty) {
                                    incident.createIncident(type, transfer.id,
                                        transfer.units[i].id, reason);
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: Text("Agregar"),
                              ),
                            ],
                          );
                          showDialog(context: context, builder: (_) => dialog);
                        },
                        text:
                            "Agregar incidecia con unidad ${transfer.units[i].unit.id}",
                        icon: Mdi.bellPlusOutline,
                        color: Color(0xFF003F66),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ]
        ],
      ),
    );
  }

  BoxDecoration buildBoxDecoration() => BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: Color(0xFF396E8F),
        boxShadow: [
          BoxShadow(color: Colors.black26),
        ],
      );
}
