import 'package:flutter/material.dart';

import 'package:blood_bank/ui/cards/white_card.dart';
import 'package:blood_bank/ui/labels/custom_labels.dart';
import 'package:mdi/mdi.dart';

class TransfersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [
            Text(
              "Transferencias relizadas en el centro",
              style: CustomLabels.h1,
            ),
            SizedBox(height: 10),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.horizontal,
              children: [
                WhiteCard(
                  width: 170,
                  title: 'Crear transferencia',
                  child: Center(
                    child: Icon(Mdi.mapMarkerPlusOutline),
                  ),
                ),
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
