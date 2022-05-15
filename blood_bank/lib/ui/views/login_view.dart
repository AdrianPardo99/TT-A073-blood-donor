import 'package:blood_bank/ui/buttons/custom_outlined.dart';
import 'package:blood_bank/ui/buttons/link_text.dart';
import 'package:blood_bank/ui/inputs/custom_inputs.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 100),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 370,
          ),
          child: Form(
            child: Column(
              children: [
                /* Email */
                TextFormField(
                  //validator: ,
                  style: TextStyle(color: Colors.white),
                  decoration: CustomInputs.loginInputDecoration(
                      hint: "Ingresa tu email.",
                      label: "Email",
                      icon: Icons.email_outlined),
                ),
                SizedBox(
                  height: 20,
                ),
                /* Password */
                TextFormField(
                  //validator: ,
                  style: TextStyle(color: Colors.white),
                  obscureText: true,
                  decoration: CustomInputs.loginInputDecoration(
                      hint: "*******",
                      label: "Contraseña",
                      icon: Icons.lock_outline_rounded),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomOutlinedButton(
                  onPressed: () {},
                  text: "Ingresar",
                  color: Colors.redAccent,
                  isFilled: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
