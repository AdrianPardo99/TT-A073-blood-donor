import 'package:blood_bank/router/router.dart';
import 'package:provider/provider.dart';
import 'package:fluro/fluro.dart';

import 'package:blood_bank/providers/auth_provider.dart';
import 'package:blood_bank/providers/side_menu_provider.dart';
import 'package:blood_bank/ui/views/dashboard_view.dart';
import 'package:blood_bank/ui/views/login_view.dart';
import 'package:blood_bank/ui/views/petitions_view.dart';
import 'package:blood_bank/ui/views/transfers_view.dart';
import 'package:blood_bank/ui/views/units_view.dart';

class DashboardHandlers {
  static Handler dashboard = Handler(
    handlerFunc: (context, parameters) {
      final authProvider = Provider.of<AuthProvider>(context!);
      if (authProvider.authStatus == AuthStatus.authenticated) {
        Provider.of<SideMenuProvider>(context, listen: false)
            .setCurrentPageUrl(Flurorouter.dbRoute);
        return DashboardView();
      }
      return LoginView();
    },
  );

  static Handler units = Handler(
    handlerFunc: (context, parameters) {
      final authProvider = Provider.of<AuthProvider>(context!);
      if (authProvider.authStatus == AuthStatus.authenticated) {
        Provider.of<SideMenuProvider>(context, listen: false)
            .setCurrentPageUrl(Flurorouter.unitsRoute);
        return UnitsView();
      }
      return LoginView();
    },
  );

  static Handler transfers = Handler(
    handlerFunc: (context, parameters) {
      final authProvider = Provider.of<AuthProvider>(context!);
      if (authProvider.authStatus == AuthStatus.authenticated) {
        Provider.of<SideMenuProvider>(context, listen: false)
            .setCurrentPageUrl(Flurorouter.transfersRoute);
        return TransfersView();
      }
      return LoginView();
    },
  );
  static Handler petitions = Handler(
    handlerFunc: (context, parameters) {
      final authProvider = Provider.of<AuthProvider>(context!);
      if (authProvider.authStatus == AuthStatus.authenticated) {
        Provider.of<SideMenuProvider>(context, listen: false)
            .setCurrentPageUrl(Flurorouter.petitionsRoute);
        return PetitionsView();
      }
      return LoginView();
    },
  );
}
