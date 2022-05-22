import 'package:blood_bank/providers/capabilities_providers.dart';
import 'package:blood_bank/services/notification_service.dart';
import 'package:blood_bank/ui/buttons/custom_outlined.dart';
import 'package:blood_bank/ui/inputs/custom_inputs.dart';
import 'package:blood_bank/ui/inputs/custom_select_inputs.dart';
import 'package:blood_bank/ui/labels/custom_labels.dart';
import 'package:flutter/material.dart';
import 'package:blood_bank/models/http/capabilities_response.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class CapacityModal extends StatefulWidget {
  final Capability? capacity;

  const CapacityModal({
    super.key,
    this.capacity,
  });

  @override
  State<CapacityModal> createState() => _CapacityModalState();
}

class _CapacityModalState extends State<CapacityModal> {
  String tipo = "";
  int? id;
  int minQty = 0, maxQty = 0;

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
  ];

  @override
  void initState() {
    super.initState();
    id = widget.capacity?.id;
    tipo = widget.capacity?.type ?? "";
    minQty = widget.capacity?.minQty ?? 0;
    maxQty = widget.capacity?.maxQty ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final capacityProvider =
        Provider.of<CapabilitiesProvider>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(20),
      height: 500,
      decoration: buildBoxDecoration(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.capacity?.type ?? "Nueva capacidad",
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
          /* Input when create */
          if (widget.capacity?.id == null) ...[
            CustomSelectInput(
              items: tipos,
              text: "Tipo de unidad",
              onChanged: (val) {
                tipo = val;
              },
            ),
            const SizedBox(height: 20)
          ],
          /* For Min Qty */
          TextFormField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              if (int.tryParse(value) != null) minQty = int.parse(value);

              if (int.tryParse(value) == null && value.isNotEmpty)
                NotificationService.showSnackbarError(
                    "Por favor ingresa numeros");
            },
            initialValue: (widget.capacity?.id != null) ? "$minQty" : "",
            decoration: CustomInputs.loginInputDecoration(
              hint: "#",
              label: "Cantidad mínima",
              icon: Mdi.waterMinus,
            ),
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          /* For Max Qty */
          TextFormField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              if (int.tryParse(value) != null) maxQty = int.parse(value);
              if (int.tryParse(value) == null && value.isNotEmpty)
                NotificationService.showSnackbarError(
                    "Por favor ingresa numeros");
            },
            initialValue: (widget.capacity?.id != null) ? "$maxQty" : "",
            decoration: CustomInputs.loginInputDecoration(
              hint: "#",
              label: "Cantidad máxima",
              icon: Mdi.waterPlus,
            ),
            style: TextStyle(color: Colors.white),
          ),
          /* For Sumbmit button */
          Container(
            margin: EdgeInsets.only(top: 30),
            alignment: Alignment.center,
            child: CustomOutlinedButton(
              onPressed: () async {
                bool flagPass = true;
                if (minQty > maxQty) {
                  NotificationService.showSnackbarError(
                      "Error la cantidad mínima no debe ser mayor a la cantidad máxima");
                  flagPass = false;
                }
                if (id == null && flagPass) {
                  /*Create */
                  await capacityProvider.newCapacity(tipo, minQty, maxQty);
                  Navigator.of(context).pop();
                }
                if (id != null && flagPass) {
                  /* Update */
                  await capacityProvider.updateCapacity(id!, minQty, maxQty);
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
