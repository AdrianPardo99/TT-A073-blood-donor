import 'package:blood_bank/datatables/transfers_datasource.dart';
import 'package:blood_bank/providers/auth_provider.dart';
import 'package:blood_bank/providers/transfers_provider.dart';
import 'package:blood_bank/ui/buttons/custon_icon_button.dart';
import 'package:blood_bank/ui/modals/transfer_modal.dart';
import 'package:flutter/material.dart';

import 'package:blood_bank/ui/cards/white_card.dart';
import 'package:blood_bank/ui/labels/custom_labels.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class TransfersView extends StatefulWidget {
  @override
  State<TransfersView> createState() => _TransfersViewState();
}

class _TransfersViewState extends State<TransfersView> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  @override
  void initState() {
    super.initState();
    Provider.of<TransfersProvider>(context, listen: false).getTransfers();
  }

  @override
  Widget build(BuildContext context) {
    final transfers = Provider.of<TransfersProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    return Container(
      child: Center(
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [
            PaginatedDataTable(
              onRowsPerPageChanged: (value) {
                setState(() {
                  _rowsPerPage = value ?? 10;
                });
              },
              rowsPerPage: _rowsPerPage,
              columns: [
                DataColumn(
                  label: Text("ID"),
                  numeric: true,
                ),
                DataColumn(
                  label: Text("Estatus"),
                ),
                DataColumn(
                  label: Text("Origen"),
                ),
                DataColumn(
                  label: Text("Destino"),
                ),
                DataColumn(
                  label: Text("Fecha esperada"),
                ),
                DataColumn(
                  label: Text("Receptor"),
                ),
                DataColumn(
                  label: Text("Tipo de unidad"),
                ),
                DataColumn(
                  label: Text("Acciones"),
                ),
              ],
              source: TransfersDataTableSource(transfers.transfers, context, 0),
              header: Text(
                "Transferencias hechas en el centro ${auth.user?.center.name}",
                maxLines: 2,
              ),
              actions: [
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      CustomIconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (_) => TransferCreateModal(),
                          );
                        },
                        text: "Crear transferencia",
                        icon: Mdi.mapMarkerPlusOutline,
                        color: Color(0xFF003F66),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Text(
            //   "Transferencias relizadas en el centro",
            //   style: CustomLabels.h1,
            // ),
            // SizedBox(height: 10),
            // Wrap(
            //   crossAxisAlignment: WrapCrossAlignment.center,
            //   direction: Axis.horizontal,
            //   children: [
            //     WhiteCard(
            //       width: 170,
            //       title: 'Crear transferencia',
            //       child: Center(
            //         child: Icon(Mdi.mapMarkerPlusOutline),
            //       ),
            //     ),
            //     WhiteCard(
            //       width: 170,
            //       title: 'Cancelar',
            //       child: Center(
            //         child: Icon(Mdi.cancel),
            //       ),
            //     ),
            //     WhiteCard(
            //       width: 170,
            //       title: 'Siguiente status',
            //       child: Center(
            //         child: Icon(Mdi.commentArrowRightOutline),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
