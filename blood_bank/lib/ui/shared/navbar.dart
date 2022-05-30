import 'package:blood_bank/providers/side_menu_provider.dart';
import 'package:flutter/material.dart';

import 'package:blood_bank/ui/shared/widgets/search_tex.dart';
import 'widgets/notifications_indicator.dart';
import 'package:blood_bank/ui/shared/widgets/navbar_avatar.dart';

class Navbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: 50,
      decoration: builBoxDecoration(),
      child: Row(
        children: [
          // TODO icono de hamburguesa
          if (size.width <= 700)
            IconButton(
                onPressed: () => SideMenuProvider.openMenu(),
                icon: Icon(Icons.menu_outlined)),
          SizedBox(
            width: 5,
          ),

          /* Search input */
          // if (size.width >= 390)
          //   ConstrainedBox(
          //     constraints: BoxConstraints(maxWidth: 250),
          //     child: SearchText(),
          //   ),
          Spacer(),
          NotificationsIndicator(),
          SizedBox(
            width: 10,
          ),
          NavbarAvatar(),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  BoxDecoration builBoxDecoration() => BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
          ),
        ],
      );
}
