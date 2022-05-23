import 'package:blood_bank/datatables/transfers_datasource.dart';
import 'package:blood_bank/providers/auth_provider.dart';
import 'package:blood_bank/providers/transfers_provider.dart';
import 'package:flutter/material.dart';

import 'package:blood_bank/ui/cards/white_card.dart';
import 'package:blood_bank/ui/labels/custom_labels.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class PetitionsView extends StatefulWidget {
  @override
  State<PetitionsView> createState() => _PetitionsViewState();
}

class _PetitionsViewState extends State<PetitionsView> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  @override
  void initState() {
    super.initState();
    Provider.of<TransfersProvider>(context, listen: false).getPetitions();
  }

  @override
  Widget build(BuildContext context) {
    final petitions = Provider.of<TransfersProvider>(context);
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
              source: TransfersDataTableSource(petitions.petitions, context, 1),
              header: Text(
                "Peticiones recibidas en el centro ${auth.user?.center.name}",
                maxLines: 2,
              ),
            ),
            // Text(
            //   "Peticiones de transferencia recibidas",
            //   style: CustomLabels.h1,
            // ),
            // SizedBox(height: 10),
            // WhiteCard(
            //   title: "Lista de peticions",
            //   child: Text("Hola mundo"),
            // ),
            // Wrap(
            //   crossAxisAlignment: WrapCrossAlignment.center,
            //   direction: Axis.horizontal,
            //   children: [
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
