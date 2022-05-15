import 'package:blood_bank/ui/buttons/link_text.dart';
import 'package:flutter/material.dart';

class LinkBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: Colors.black,
      height: (size.width > 1000) ? size.height * 0.05 : null,
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          LinkText(
            text: "Acerca de",
            onPressed: () => print("Hola"),
          ),
          LinkText(text: "Contacto"),
          LinkText(text: "Ayuda"),
          LinkText(text: "Privacidad"),
          LinkText(text: "Soporte técnico"),
        ],
      ),
    );
  }
}
