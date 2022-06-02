import 'package:blood_bank/models/http/transfer_list_response.dart';
import 'package:blood_bank/providers/transfers_provider.dart';
import 'package:blood_bank/ui/modals/transfer_petition_detail_modal.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class TransfersDataTableSource extends DataTableSource {
  final List<Transfer> transfers;
  final BuildContext context;
  /* If 0 is transfers and if 1 is petitions */
  final int typeTable;

  TransfersDataTableSource(this.transfers, this.context, this.typeTable);

  final status = {
    "Created": {
      "name": "Creado",
      "color": Color.fromARGB(255, 255, 167, 59),
      "fontColor": Colors.white,
      "nextStatus": "Confirmed",
    },
    "Confirmed": {
      "name": "Confirmado",
      "color": Colors.lightGreen,
      "fontColor": Colors.white,
      "nextStatus": "Prepared",
    },
    "Prepared": {
      "name": "Preparado",
      "color": Colors.blue,
      "fontColor": Colors.white,
      "nextStatus": "Sending",
    },
    "Sending": {
      "name": "Enviando",
      "color": Color.fromARGB(255, 62, 73, 198),
      "fontColor": Colors.white,
      "nextStatus": "In transit",
    },
    "In transit": {
      "name": "En camino",
      "color": Color.fromARGB(255, 62, 73, 198),
      "fontColor": Colors.white,
      "nextStatus": "Arrived",
    },
    "Arrived": {
      "name": "Llegando",
      "color": Color.fromARGB(255, 187, 141, 4),
      "fontColor": Colors.white,
      "nextStatus": "Verifying",
    },
    "Verifying": {
      "name": "Verificando",
      "color": Colors.green,
      "fontColor": Colors.white,
      "nextStatus": "Finished",
    },
    "Finished": {
      "name": "Finalizado",
      "color": Colors.green,
      "fontColor": Colors.white,
      "nextStatus": null,
    },
    "Cancelled": {
      "name": "Cancelado",
      "color": Colors.red,
      "fontColor": Colors.white,
      "nextStatus": null,
    },
  };
  final can_cancel = ["Created", "Confirmed", "Prepared"];

  @override
  DataRow? getRow(int index) {
    final can_change = (typeTable == 0)
        ? ["In transit", "Arrived", "Verifying"]
        : ["Created", "Confirmed", "Prepared", "Sending"];
    tz.initializeTimeZones();
    final location = tz.getLocation('America/Mexico_City');
    final transfer = transfers[index];
    final color = (status[transfer.status]!["color"] as Color);
    final prov = Provider.of<TransfersProvider>(context, listen: false);
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text("${transfer.id}")),
        DataCell(Container(
            decoration: BoxDecoration(
              border: Border.all(color: color, width: 5),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Text("${status[transfer.status]!["name"]}"))),
        DataCell(Text("${transfer.origin.name}")),
        DataCell(Text("${transfer.destination.name}")),
        DataCell(Text("${tz.TZDateTime.from(transfer.deadline, location)}")),
        DataCell(Text("${transfer.receptorBloodType}")),
        DataCell(Text("${transfer.unitType}")),
        DataCell(
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  if (typeTable == 0) await prov.getDetailTransfer(transfer.id);
                  if (typeTable == 1) await prov.getDetailPetition(transfer.id);
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => TransferModal(
                      transfer: prov.transferDetail,
                      status: (status[transfer.status]!["name"] as String),
                      type: typeTable,
                    ),
                  );
                },
                icon: Icon(Icons.desktop_windows_outlined),
              ),
              if (can_change.contains(transfer.status))
                IconButton(
                  onPressed: () async {
                    await prov.nextStatus(typeTable, transfer.id);
                    notifyListeners();
                  },
                  icon: Icon(Mdi.commentArrowRightOutline),
                ),
              if (can_cancel.contains(transfer.status))
                IconButton(
                  onPressed: () async {
                    final dialog = AlertDialog(
                      title:
                          Text("¿Estás seguro de cancelar la transferencia?"),
                      content: Text(
                          "¿Cancelar ${(typeTable == 0) ? "solicitud de transferencia" : "petición recibida"} #${transfer.id}?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text("No"),
                        ),
                        TextButton(
                          onPressed: () async {
                            // await Provider.of<CapabilitiesProvider>(context,
                            //         listen: false)
                            //     .deleteCapacity(capacity.id);
                            await prov.cancelTransfer(typeTable, transfer.id);
                            notifyListeners();

                            Navigator.of(context).pop();
                          },
                          child: Text("Sí, cancelar"),
                        ),
                      ],
                    );
                    showDialog(context: context, builder: (_) => dialog);
                  },
                  icon: Icon(Icons.cancel_outlined),
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
  int get rowCount => transfers.length;

  @override
  int get selectedRowCount => 0;
}
