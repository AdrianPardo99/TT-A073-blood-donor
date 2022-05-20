import 'package:flutter/material.dart';

class NavbarAvatar extends StatelessWidget {
  const NavbarAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        child: Image.network(
          "https://is2-ssl.mzstatic.com/image/thumb/Purple122/v4/84/de/1d/84de1d6e-0e98-b2ab-d2a7-2d93d79b36f1/AppIcon-1x_U007emarketing-0-7-0-85-220.png/1024x1024bb.png",
          width: 30,
          height: 30,
        ),
      ),
    );
  }
}
