import 'package:blood_bank/router/router.dart';
import 'package:blood_bank/services/local_storage.dart';
import 'package:blood_bank/services/navigation_service.dart';
import 'package:flutter/material.dart';

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthProvider extends ChangeNotifier {
  String? _token;
  AuthStatus authStatus = AuthStatus.checking;

  AuthProvider() {
    this.isAuthenticated();
  }

  login(String email, password) {
    /* Todo. Peticion a backend */
    _token = "sadasdoasdasdoasdjk.jasdasjkdhjkwdhjkasdjsad.sadasdasdas";
    LocalStorage.prefs.setString("token", this._token ?? "");
    LocalStorage.prefs.getString("token");
    print("Almacena JWT");
    // Navigate to dashboard
    authStatus = AuthStatus.authenticated;

    notifyListeners();
    NavigationService.replaceTo(Flurorouter.dbRoute);
  }

  Future<bool> isAuthenticated() async {
    final token = LocalStorage.prefs.get("token");
    if (token == null) {
      authStatus = AuthStatus.notAuthenticated;
      notifyListeners();
      return false;
    }
    /* Petition HTTP para backend para comprobar JWT */
    await Future.delayed(Duration(milliseconds: 1000));
    authStatus = AuthStatus.authenticated;
    notifyListeners();
    return true;
  }
}
