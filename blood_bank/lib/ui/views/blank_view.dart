import 'package:flutter/material.dart';

import 'package:blood_bank/ui/cards/white_card.dart';
import 'package:blood_bank/ui/labels/custom_labels.dart';

class BlankView extends StatelessWidget {
  const BlankView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [
            Text(
              "Blank view",
              style: CustomLabels.h1,
            ),
            SizedBox(height: 10),
            WhiteCard(
              title: "Blank view",
              child: Text("Hola mundo"),
            ),
          ],
        ),
      ),
    );
  }
}
