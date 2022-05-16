import 'package:flutter/material.dart';

import 'package:blood_bank/providers/auth_provider.dart';

class LoginFromProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String email = '';
  String password = '';

  bool validateForm() {
    if (formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }
}
