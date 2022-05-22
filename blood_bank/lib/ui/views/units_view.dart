import 'package:blood_bank/datatables/units_datasource.dart';
import 'package:blood_bank/providers/auth_provider.dart';
import 'package:blood_bank/providers/units_providers.dart';
import 'package:blood_bank/ui/buttons/custon_icon_button.dart';
import 'package:blood_bank/ui/modals/units_modal.dart';
import 'package:flutter/material.dart';

import 'package:blood_bank/ui/cards/white_card.dart';
import 'package:blood_bank/ui/labels/custom_labels.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class UnitsView extends StatefulWidget {
  @override
  State<UnitsView> createState() => _UnitsViewState();
}

class _UnitsViewState extends State<UnitsView> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  @override
  void initState() {
    super.initState();
    Provider.of<UnitsProvider>(context, listen: false).getUnits();
  }

  @override
  Widget build(BuildContext context) {
    final units = Provider.of<UnitsProvider>(context);
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
                  label: Text("Tipo de unidad"),
                ),
                DataColumn(
                  label: Text("Tipo de sangre"),
                ),
                DataColumn(
                  label: Text("Fecha de expiración"),
                ),
                DataColumn(
                  label: Text("Transferible"),
                ),
                DataColumn(
                  label: Text("Donación altruista"),
                ),
                DataColumn(
                  label: Text("Genero del donante"),
                ),
                DataColumn(
                  label: Text("Edad del donante"),
                  numeric: true,
                ),
                DataColumn(label: Text("Acciones")),
              ],
              source: UnitsDataTableSource(units.units, context),
              header: Text(
                "Unidades del centro ${auth.user?.center.name}",
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
                            builder: (_) => UnitModal(unit: null),
                          );
                        },
                        text: "Agregar unidad",
                        icon: Mdi.waterPlusOutline,
                        color: Color(0xFF003F66),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Text(
            //   "Unidades del centro",
            //   style: CustomLabels.h1,
            // ),
            // SizedBox(height: 10),
            // Wrap(
            //   crossAxisAlignment: WrapCrossAlignment.center,
            //   direction: Axis.horizontal,
            //   children: [
            //     WhiteCard(
            //       width: 170,
            //       title: 'Unidades de sangre',
            //       child: Center(
            //         child: Icon(Mdi.bloodBag),
            //       ),
            //     ),
            //     WhiteCard(
            //       width: 170,
            //       title: 'Agregar unidad de sangre',
            //       child: Center(
            //         child: Icon(Mdi.waterPlusOutline),
            //       ),
            //     ),
            //     WhiteCard(
            //       width: 170,
            //       title: 'Remover unidad de sangre',
            //       child: Center(
            //         child: Icon(Mdi.waterRemoveOutline),
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
