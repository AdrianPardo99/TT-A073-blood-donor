import 'package:blood_bank/services/notification_service.dart';
import 'package:flutter/material.dart';

import 'package:blood_bank/api/unit_blood_api.dart';
import 'package:blood_bank/models/http/auth_response.dart';
import 'package:blood_bank/router/router.dart';
import 'package:blood_bank/services/local_storage.dart';
import 'package:blood_bank/services/navigation_service.dart';

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthProvider extends ChangeNotifier {
  AuthStatus authStatus = AuthStatus.checking;
  User? user;

  AuthProvider() {
    isAuthenticated();
  }

  login(String email, password) {
    /* Todo. Peticion a backend */
    final data = {
      "email": email,
      "password": password,
    };
    UnitBloodApi.httpPost("/auth/login/", data).then(
      (json) {
        final authResponse = AuthResponse.fromMap(json);
        user = authResponse.user;
        authStatus = AuthStatus.authenticated;
        LocalStorage.prefs.setString("token", authResponse.token);
        LocalStorage.prefs.setInt("center_id", authResponse.user.center.id);
        UnitBloodApi.configureDio();
        notifyListeners();
        NavigationService.replaceTo(Flurorouter.dbRoute);
      },
    ).catchError(
      (e) {
        //
        NotificationService.showSnackbarError("Credenciales incorrectas");
      },
    );
  }

  logout() {
    LocalStorage.prefs.remove("token");
    LocalStorage.prefs.remove("center_id");
    authStatus = AuthStatus.notAuthenticated;
    notifyListeners();
  }

  Future<bool> isAuthenticated() async {
    final token = LocalStorage.prefs.get("token");
    if (token == null) {
      authStatus = AuthStatus.notAuthenticated;
      notifyListeners();
      return false;
    }
    /* Petition HTTP para backend para comprobar JWT */
    bool flag = false;
    final data = {
      "token": LocalStorage.prefs.getString("token"),
    };
    await UnitBloodApi.httpPost("/auth/verify/", data).then((json) {
      final authResponse = AuthResponse.fromMap(json);
      user = authResponse.user;
      authStatus = AuthStatus.authenticated;
      flag = true;
    }).catchError((e) {
      flag = false;
    });
    notifyListeners();
    return flag;
  }
}
