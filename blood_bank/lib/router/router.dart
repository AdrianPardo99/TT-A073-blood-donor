import 'package:blood_bank/router/dashboard_handlers.dart';
import 'package:fluro/fluro.dart';

import 'package:blood_bank/router/admin_handlers.dart';
import 'package:blood_bank/router/not_found_handlers.dart';

class Flurorouter {
  static final FluroRouter router = new FluroRouter();

  /* Root */
  static String rootRoute = "/";
  /* Auth route */
  static String loginRoute = "/auth/login/";
  /* Db routes */
  static String dbRoute = "/dashboard/capabilities/";
  static String unitsRoute = "/dashboard/units/";
  static String transfersRoute = "/dashboard/transfers/";
  static String petitionsRoute = "/dashboard/petitions/";

  /* Auth routes */

  static void configureRoutes() {
    router.define(loginRoute, handler: AdminHandlers.login);

    router.define(dbRoute, handler: DashboardHandlers.dashboard);
    router.define(unitsRoute, handler: DashboardHandlers.units);
    router.define(transfersRoute, handler: DashboardHandlers.transfers);
    router.define(petitionsRoute, handler: DashboardHandlers.petitions);
    /* 404 */
    router.notFoundHandler = NotFoundHandlers.noPageFound;
  }
}
