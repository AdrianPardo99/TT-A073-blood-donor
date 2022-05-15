import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.contain,
            child: Icon(
              Icons.bloodtype_rounded,
              size: 80,
              color: Colors.redAccent,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FittedBox(
            fit: BoxFit.contain,
            child: Text(
              "Aplicación - Banco de Sangre",
              style: GoogleFonts.montserratAlternates(
                fontSize: 60,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
