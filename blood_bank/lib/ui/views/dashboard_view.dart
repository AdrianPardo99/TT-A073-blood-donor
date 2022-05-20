import 'package:flutter/material.dart';

import 'package:blood_bank/ui/cards/white_card.dart';
import 'package:blood_bank/ui/labels/custom_labels.dart';

class DashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [
            Text(
              "Capacidad del centro",
              style: CustomLabels.h1,
            ),
            SizedBox(height: 10),
            WhiteCard(
              title: "Listado de capacidades",
              child: Text("Hola mundo"),
            ),
          ],
        ),
      ),
    );
  }
}
