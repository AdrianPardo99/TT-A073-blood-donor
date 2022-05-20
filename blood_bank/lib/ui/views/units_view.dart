import 'dart:html';

import 'package:flutter/material.dart';

import 'package:blood_bank/ui/cards/white_card.dart';
import 'package:blood_bank/ui/labels/custom_labels.dart';
import 'package:mdi/mdi.dart';

class UnitsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [
            Text(
              "Unidades del centro",
              style: CustomLabels.h1,
            ),
            SizedBox(height: 10),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.horizontal,
              children: [
                WhiteCard(
                  width: 170,
                  title: 'Unidades de sangre',
                  child: Center(
                    child: Icon(Mdi.bloodBag),
                  ),
                ),
                WhiteCard(
                  width: 170,
                  title: 'Agregar unidad de sangre',
                  child: Center(
                    child: Icon(Mdi.waterPlusOutline),
                  ),
                ),
                WhiteCard(
                  width: 170,
                  title: 'Remover unidad de sangre',
                  child: Center(
                    child: Icon(Mdi.waterRemoveOutline),
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
