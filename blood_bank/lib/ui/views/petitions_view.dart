import 'package:flutter/material.dart';

import 'package:blood_bank/ui/cards/white_card.dart';
import 'package:blood_bank/ui/labels/custom_labels.dart';
import 'package:mdi/mdi.dart';

class PetitionsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [
            Text(
              "Peticiones de transferencia recibidas",
              style: CustomLabels.h1,
            ),
            SizedBox(height: 10),
            WhiteCard(
              title: "Lista de peticions",
              child: Text("Hola mundo"),
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.horizontal,
              children: [
                WhiteCard(
                  width: 170,
                  title: 'Cancelar',
                  child: Center(
                    child: Icon(Mdi.cancel),
                  ),
                ),
                WhiteCard(
                  width: 170,
                  title: 'Siguiente status',
                  child: Center(
                    child: Icon(Mdi.commentArrowRightOutline),
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
