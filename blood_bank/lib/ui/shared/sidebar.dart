import 'package:blood_bank/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:blood_bank/ui/shared/widgets/logo.dart';
import 'package:blood_bank/ui/shared/widgets/text_separator.dart';
import 'package:blood_bank/ui/shared/widgets/menu_item.dart';
import 'package:blood_bank/providers/side_menu_provider.dart';
import 'package:blood_bank/router/router.dart';
import 'package:blood_bank/services/navigation_service.dart';

class Sidebar extends StatelessWidget {
  void navigateTo(String nameRoute) {
    NavigationService.navigateTo(nameRoute);
    SideMenuProvider.closeMenu();
  }

  @override
  Widget build(BuildContext context) {
    final sideMenuProvider = Provider.of<SideMenuProvider>(context);
    return Container(
      width: 200,
      height: double.infinity,
      decoration: buildBoxDecoration(),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Logo(),
          SizedBox(
            height: 50,
          ),
          TextSeparator(text: "Administrar"),
          CustomMenuItem(
            isActive: sideMenuProvider.currentPage == Flurorouter.dbRoute,
            text: "Capacidad",
            icon: Icons.equalizer_outlined,
            onPressed: () => navigateTo(Flurorouter.dbRoute),
          ),
          CustomMenuItem(
            isActive: sideMenuProvider.currentPage == Flurorouter.unitsRoute,
            text: "Unidades",
            icon: Icons.local_hospital_outlined,
            onPressed: () => navigateTo(Flurorouter.unitsRoute),
          ),
          SizedBox(
            height: 50,
          ),
          TextSeparator(text: "Operaciones"),
          CustomMenuItem(
            isActive:
                sideMenuProvider.currentPage == Flurorouter.transfersRoute,
            text: "Transferencias",
            icon: Icons.send_outlined,
            onPressed: () => navigateTo(Flurorouter.transfersRoute),
          ),
          CustomMenuItem(
            isActive:
                sideMenuProvider.currentPage == Flurorouter.petitionsRoute,
            text: "Peticiones",
            icon: Icons.call_received_outlined,
            onPressed: () => navigateTo(Flurorouter.petitionsRoute),
          ),
          SizedBox(
            height: 50,
          ),
          CustomMenuItem(
            text: "Cerrar sesión",
            icon: Icons.logout_outlined,
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }

  BoxDecoration buildBoxDecoration() => BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF003F66),
            Color(0xFF003F60),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
          )
        ],
      );
}
