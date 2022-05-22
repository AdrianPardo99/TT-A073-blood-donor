import 'package:blood_bank/models/http/units_response.dart';
import 'package:blood_bank/providers/units_providers.dart';
import 'package:blood_bank/services/notification_service.dart';
import 'package:blood_bank/ui/buttons/custom_outlined.dart';
import 'package:blood_bank/ui/inputs/custom_date_inputs.dart';
import 'package:blood_bank/ui/inputs/custom_inputs.dart';
import 'package:blood_bank/ui/inputs/custom_select_inputs.dart';
import 'package:blood_bank/ui/labels/custom_labels.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class UnitModal extends StatefulWidget {
  final Unit? unit;

  const UnitModal({super.key, this.unit});

  @override
  State<UnitModal> createState() => _UnitModalState();
}

class _UnitModalState extends State<UnitModal> {
  int? id;
  int edadDonador = 0;
  String tipo = "", tipoSangre = "", fechaExpirado = "", generoDonador = "";
  bool transferible = true, altruista = true;
  final List<Map<String, dynamic>> tipos = [
        {
          "value": "ST",
          "label": "ST (Sangre total)",
        },
        {
          "value": "CE",
          "label": "CE (Concentrado de eritrorcitos)",
        },
        {"value": "CP", "label": "CP (Concentrado de plaquetas)"},
        {"value": "PF", "label": "PF (Plasma fresco)"},
        {
          "value": "PDFL",
          "label": "PDFL (Plasma desprovisto de factores lábiles)",
        },
        {
          "value": "CRIO",
          "label": "CRIO (Crioprecipitado)",
        }
      ],
      generos = [
        {
          "value": "m",
          "label": "Hombre",
        },
        {
          "value": "f",
          "label": "Mujer",
        },
        {
          "value": "o",
          "label": "Otro",
        }
      ],
      abo = [
        {
          "value": "o-",
          "label": "O-",
        },
        {
          "value": "o+",
          "label": "O+",
        },
        {
          "value": "a-",
          "label": "A-",
        },
        {
          "value": "a+",
          "label": "A+",
        },
        {
          "value": "b-",
          "label": "B-",
        },
        {
          "value": "b+",
          "label": "B+",
        },
        {
          "value": "ab-",
          "label": "AB-",
        },
        {
          "value": "ab+",
          "label": "AB+",
        },
      ];

  @override
  void initState() {
    super.initState();
    id = widget.unit?.id;
    tipo = widget.unit?.type ?? "";
    tipoSangre = widget.unit?.bloodType ?? "";
    fechaExpirado = widget.unit?.expiredAt ?? "";
    generoDonador = widget.unit?.donorGender ?? "";
    edadDonador = widget.unit?.donorAge ?? 0;
    transferible = widget.unit?.canTransfer ?? true;
    altruista = widget.unit?.isAltruistUnit ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final unitProvider = Provider.of<UnitsProvider>(context, listen: false);
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
                widget.unit?.type ?? "Agregar unidad",
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
          CustomSelectInput(
            items: tipos,
            text: "Tipo de unidad",
            icon: Mdi.bloodBag,
            onChanged: (val) {
              tipo = val;
            },
          ),
          const SizedBox(height: 10),
          CustomSelectInput(
            items: abo,
            text: "Tipo de sangre",
            onChanged: (val) {
              tipoSangre = val;
            },
          ),
          const SizedBox(height: 10),
          CustomDateInput(
            text: "Fecha de expiración",
            onChanged: (val) {
              final format = DateFormat("yyyy-MM-dd");
              fechaExpirado = format.format(val);
            },
          ),
          CheckboxListTile(
            activeColor: Colors.white,
            checkColor: Colors.black,
            value: transferible,
            contentPadding: EdgeInsets.all(0),
            onChanged: (val) {
              setState(
                () {
                  transferible = !transferible;
                },
              );
            },
            title: Text(
              "Transferible",
              style: TextStyle(color: Colors.white),
            ),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            activeColor: Colors.white,
            checkColor: Colors.black,
            value: altruista,
            contentPadding: EdgeInsets.all(0),
            onChanged: (val) {
              setState(
                () {
                  altruista = !altruista;
                },
              );
            },
            title: Text(
              "Donación altruista",
              style: TextStyle(color: Colors.white),
            ),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CustomSelectInput(
            items: generos,
            text: "Genero del donador",
            icon: Icons.transgender_outlined,
            onChanged: (val) {
              generoDonador = val;
            },
          ),
          SizedBox(height: 10),
          /* Edad del donador */
          TextFormField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              if (int.tryParse(value) != null) edadDonador = int.parse(value);
              if (int.tryParse(value) == null && value.isNotEmpty)
                NotificationService.showSnackbarError(
                    "Por favor ingresa numeros");
            },
            initialValue: (widget.unit?.id != null) ? "$edadDonador" : "",
            decoration: CustomInputs.loginInputDecoration(
              hint: "#",
              label: "Edad del donador",
              icon: Icons.cake_outlined,
            ),
            style: TextStyle(color: Colors.white),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            alignment: Alignment.center,
            child: CustomOutlinedButton(
              onPressed: () async {
                bool flagPass = true;
                if (id == null && flagPass) {
                  /*Create */
                  await unitProvider.newUnit(tipo, tipoSangre, fechaExpirado,
                      transferible, altruista, generoDonador, edadDonador);
                  Navigator.of(context).pop();
                }
              },
              text: "Guardar",
              color: Colors.white,
            ),
          ),
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
