import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:blood_bank/ui/buttons/custom_outlined.dart';
import 'package:email_validator/email_validator.dart';
import 'package:blood_bank/ui/inputs/custom_inputs.dart';
import 'package:blood_bank/providers/auth_provider.dart';
import 'package:blood_bank/providers/login_form_provider.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return ChangeNotifierProvider(
      create: (_) => LoginFromProvider(),
      child: Builder(
        builder: (context) {
          final loginFormProvider =
              Provider.of<LoginFromProvider>(context, listen: false);

          return Container(
            margin: EdgeInsets.only(top: 100),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 370,
                ),
                child: Form(
                  key: loginFormProvider.formKey,
                  child: Column(
                    children: [
                      /* Email */
                      TextFormField(
                        onFieldSubmitted: (_) =>
                            onFormSubmit(loginFormProvider, authProvider),
                        validator: (value) {
                          if (!EmailValidator.validate(value ?? "xxxx"))
                            return "Email no valido";
                          return null;
                        },
                        onChanged: (value) => loginFormProvider.email = value,
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
                        onFieldSubmitted: (_) =>
                            onFormSubmit(loginFormProvider, authProvider),
                        onChanged: (value) =>
                            loginFormProvider.password = value,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return "Ingrese su contraseña";
                          return null;
                        },
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
                        onPressed: () =>
                            onFormSubmit(loginFormProvider, authProvider),
                        text: "Ingresar",
                        color: Colors.red,
                        isFilled: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void onFormSubmit(
      LoginFromProvider loginFromProvider, AuthProvider authProvider) {
    final isValid = loginFromProvider.validateForm();
    if (isValid) {
      authProvider.login(
        loginFromProvider.email,
        loginFromProvider.password,
      );
    }
  }
}
