import 'package:blood_bank/services/local_storage.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;

  login(String email, password) {
    /* Todo. Peticion a backend */
    _token = "sadasdoasdasdoasdjk.jasdasjkdhjkwdhjkasdjsad.sadasdasdas";
    LocalStorage.prefs.setString("token", this._token ?? "");
    LocalStorage.prefs.getString("token");
    print("Almacena JWT");
    // Navigate to dashboard
    notifyListeners();
  }
}
