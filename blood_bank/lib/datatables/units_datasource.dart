import 'package:blood_bank/providers/units_providers.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';

import 'package:blood_bank/models/http/units_response.dart';
import 'package:provider/provider.dart';

class UnitsDataTableSource extends DataTableSource {
  final List<Unit> units;
  final BuildContext context;

  UnitsDataTableSource(this.units, this.context);

  @override
  DataRow? getRow(int index) {
    final unit = units[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text("${unit.id}")),
        DataCell(Text("${unit.type}")),
        DataCell(Text("${unit.bloodType}")),
        DataCell(Text("${unit.expiredAt}")),
        DataCell(Icon(
            unit.canTransfer ? Icons.done_outline : Icons.cancel_outlined)),
        DataCell(Icon(
            unit.isAltruistUnit ? Icons.done_outline : Icons.cancel_outlined)),
        DataCell(Text(
            "${(unit.donorGender == "Male") ? "Hombre" : (unit.donorGender == "Female") ? "Mujer" : "Otro genero"}")),
        DataCell(Text("${unit.donorAge}")),
        DataCell(
          Row(
            children: [
              // IconButton(
              //   onPressed: () {
              //     // showModalBottomSheet(
              //     //   backgroundColor: Colors.transparent,
              //     //   context: context,
              //     //   builder: (context) => CapacityModal(
              //     //     capacity: capacity,
              //     //   ),
              //     // );
              //   },
              //   icon: Icon(Icons.edit_outlined),
              // ),
              IconButton(
                onPressed: () {
                  String reason = "";
                  final dialog = AlertDialog(
                    title: Text(
                        "¿Estás seguro de expirar o dar de baja la unidad de sangre?"),
                    content: TextField(
                      onChanged: (value) => reason = value,
                      decoration: InputDecoration(
                          hintText: "Razón de baja o expiración"),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("No"),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (reason != null && reason.isNotEmpty) {
                            await Provider.of<UnitsProvider>(context,
                                    listen: false)
                                .deleteUnit(unit.id, reason);
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text("Sí, realizar operación"),
                      ),
                    ],
                  );
                  showDialog(context: context, builder: (_) => dialog);
                },
                icon: Icon(Mdi.waterRemoveOutline, color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => units.length;

  @override
  int get selectedRowCount => 0;
}
