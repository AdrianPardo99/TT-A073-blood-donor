import 'package:blood_bank/providers/auth_provider.dart';
import 'package:blood_bank/ui/modals/capacity_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:blood_bank/datatables/capabilities_datasource.dart';
import 'package:blood_bank/ui/buttons/custon_icon_button.dart';
import 'package:blood_bank/providers/capabilities_providers.dart';

class DashboardView extends StatefulWidget {
  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  @override
  void initState() {
    super.initState();
    Provider.of<CapabilitiesProvider>(context, listen: false).getCapabilities();
  }

  @override
  Widget build(BuildContext context) {
    final capabilities = Provider.of<CapabilitiesProvider>(context);
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
                  label: Text("Cantidad mínima"),
                  numeric: true,
                ),
                DataColumn(
                  label: Text("Cantidad máxima"),
                  numeric: true,
                ),
                DataColumn(
                  label: Text("Acciones"),
                ),
              ],
              source: CapabilitiesDataTableSource(
                  capabilities.capabilities, context),
              header: Text(
                "Capacidad del centro ${auth.user?.center.name}",
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
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (_) => CapacityModal(capacity: null),
                          );
                        },
                        text: "Agregar capacidad",
                        icon: Icons.add_outlined,
                        color: Color(0xFF003F66),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
