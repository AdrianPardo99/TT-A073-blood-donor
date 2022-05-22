import 'package:blood_bank/providers/capabilities_providers.dart';
import 'package:blood_bank/ui/modals/capacity_modal.dart';
import 'package:flutter/material.dart';
import 'package:blood_bank/models/http/capabilities_response.dart';
import 'package:provider/provider.dart';

class CapabilitiesDataTableSource extends DataTableSource {
  final List<Capability> capabilities;
  final BuildContext context;

  CapabilitiesDataTableSource(this.capabilities, this.context);

  @override
  DataRow getRow(int index) {
    final capacity = capabilities[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text("${capacity.id}")),
        DataCell(Text(capacity.type)),
        DataCell(Text("${capacity.minQty}")),
        DataCell(Text("${capacity.maxQty}")),
        DataCell(
          Row(
            children: [
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) => CapacityModal(
                      capacity: capacity,
                    ),
                  );
                },
                icon: Icon(Icons.edit_outlined),
              ),
              IconButton(
                onPressed: () {
                  final dialog = AlertDialog(
                    title: Text("¿Estás seguro de eliminarlo?"),
                    content: Text("¿Borrar definitivamente ${capacity.type}?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("No"),
                      ),
                      TextButton(
                        onPressed: () async {
                          await Provider.of<CapabilitiesProvider>(context,
                                  listen: false)
                              .deleteCapacity(capacity.id);
                          Navigator.of(context).pop();
                        },
                        child: Text("Sí, borrar"),
                      ),
                    ],
                  );
                  showDialog(context: context, builder: (_) => dialog);
                },
                icon: Icon(Icons.delete_outline, color: Colors.red),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => capabilities.length;

  @override
  int get selectedRowCount => 0;
}
