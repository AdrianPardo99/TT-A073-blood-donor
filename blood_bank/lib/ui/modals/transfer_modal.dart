import 'package:blood_bank/providers/transfers_provider.dart';
import 'package:blood_bank/services/notification_service.dart';
import 'package:blood_bank/ui/buttons/custom_outlined.dart';
import 'package:blood_bank/ui/inputs/custom_datetime_inputs.dart';
import 'package:blood_bank/ui/inputs/custom_inputs.dart';
import 'package:blood_bank/ui/inputs/custom_select_inputs.dart';
import 'package:blood_bank/ui/labels/custom_labels.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class TransferCreateModal extends StatefulWidget {
  const TransferCreateModal({super.key});

  @override
  State<TransferCreateModal> createState() => _TransferCreateModalState();
}

class _TransferCreateModalState extends State<TransferCreateModal> {
  String name = "",
      comment = "",
      receptor = "",
      unidad = "",
      typeDeadline = "",
      deadline = "";
  int qty = 0;
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
      ],
      deadlines = [
        {
          "value": "1",
          "label": "Prioridad muy baja",
        },
        {
          "value": "2",
          "label": "Prioridad baja",
        },
        {
          "value": "3",
          "label": "Prioridad media",
        },
        {
          "value": "4",
          "label": "Prioridad alta",
        },
        {
          "value": "5",
          "label": "Prioridad máxima",
        },
      ];
  @override
  Widget build(BuildContext context) {
    tz.initializeTimeZones();
    final location = tz.getLocation('America/Mexico_City');
    final size = MediaQuery.of(context).size;
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
                "Solicitud de transferencia",
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
          CustomDateTimeField(
            text: "Fecha esperada de llegada",
            onChanged: (value) {
              deadline = tz.TZDateTime.from(value, location).toString();
            },
          ),
          const SizedBox(height: 10),
          CustomSelectInput(
            items: tipos,
            text: "Tipo de unidad",
            icon: Mdi.bloodBag,
            onChanged: (val) {
              unidad = val;
            },
          ),
          const SizedBox(height: 10),
          CustomSelectInput(
            items: abo,
            text: "Tipo de sangre",
            onChanged: (val) {
              receptor = val;
            },
          ),
          const SizedBox(height: 10),
          CustomSelectInput(
            items: deadlines,
            text: "Prioridad",
            icon: Mdi.clockOutline,
            onChanged: (val) {
              typeDeadline = val;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              if (int.tryParse(value) != null) qty = int.parse(value);

              if (int.tryParse(value) == null && value.isNotEmpty)
                NotificationService.showSnackbarError(
                    "Por favor ingresa numeros");
            },
            decoration: CustomInputs.loginInputDecoration(
              hint: "#",
              label: "Cantidad de unidades",
              icon: Mdi.water,
            ),
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          TextFormField(
            onChanged: (value) {
              if (value != null) name = value;
            },
            decoration: CustomInputs.loginInputDecoration(
              hint: "Título para la transferencia",
              label: "Nombre",
              icon: Mdi.developerBoard,
            ),
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          TextFormField(
            onChanged: (value) {
              if (value != null) comment = value;
            },
            decoration: CustomInputs.loginInputDecoration(
              hint: "Comentario",
              label: "Comentarios",
              icon: Mdi.commentEditOutline,
            ),
            style: TextStyle(color: Colors.white),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            alignment: Alignment.center,
            child: CustomOutlinedButton(
              onPressed: () async {
                bool flag = true;
                if (qty <= 0 &&
                    name.isEmpty &&
                    comment.isEmpty &&
                    receptor.isEmpty &&
                    unidad.isEmpty &&
                    typeDeadline.isEmpty &&
                    deadline.isEmpty) {
                  NotificationService.showSnackbarError(
                      "Por favor llenar todos los campos");
                  flag = false;
                }
                if (flag) {
                  await Provider.of<TransfersProvider>(context, listen: false)
                      .newTransfer(qty, name, comment, receptor, unidad,
                          typeDeadline, deadline);
                  //Navigator.of(context).pop();
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
