import 'package:blood_bank/utils/create_material_color.dart';
import 'package:flutter/material.dart';

class BackgroundAuth extends StatelessWidget {
  const BackgroundAuth({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Container(
        decoration: _BuildBoxDecoration(),
        // child: Container(
        //   constraints: BoxConstraints(maxWidth: 400),
        //   child: Center(
        //     child: Icon(
        //       Icons.bloodtype,
        //       color: Colors.redAccent,
        //       size: (size.width * 1.25) / 3,
        //     ),
        //   ),
        // ),
      ),
    );
  }

  BoxDecoration _BuildBoxDecoration() {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage("login.jpg"),
        fit: BoxFit.cover,
      ),
    );
  }
}
