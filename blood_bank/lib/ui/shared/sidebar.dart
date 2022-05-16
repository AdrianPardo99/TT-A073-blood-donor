import 'package:flutter/material.dart';

import 'package:blood_bank/ui/shared/widgets/logo.dart';
import 'package:blood_bank/ui/shared/widgets/text_separator.dart';
import 'package:blood_bank/ui/shared/widgets/menu_item.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
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
            text: "Capacidad",
            icon: Icons.equalizer_outlined,
            onPressed: () => print("Capacidad"),
          ),
          CustomMenuItem(
            text: "Unidades",
            icon: Icons.local_hospital_outlined,
            onPressed: () => print("Unidades"),
          ),
          SizedBox(
            height: 50,
          ),
          TextSeparator(text: "Operaciones"),
          CustomMenuItem(
            text: "Transferencias",
            icon: Icons.send_outlined,
            onPressed: () => print("Transferencias"),
          ),
          CustomMenuItem(
            text: "Peticiones",
            icon: Icons.call_received_outlined,
            onPressed: () => print("Peticiones"),
          ),
          SizedBox(
            height: 50,
          ),
          CustomMenuItem(
            text: "Cerrar sesión",
            icon: Icons.logout_outlined,
            onPressed: () => print("Cerrar sesión"),
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
