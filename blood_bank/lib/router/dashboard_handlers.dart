import 'package:blood_bank/ui/views/login_view.dart';
import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';

import 'package:blood_bank/providers/auth_provider.dart';
import 'package:blood_bank/ui/views/dashboard_view.dart';

class DashboardHandlers {
  static Handler dashboard = Handler(
    handlerFunc: (context, parameters) {
      final authProvider = Provider.of<AuthProvider>(context!);
      if (authProvider.authStatus == AuthStatus.authenticated) {
        return DashboardView();
      }
      return LoginView();
    },
  );
}
