import 'package:blood_bank/router/dashboard_handlers.dart';
import 'package:fluro/fluro.dart';

import 'package:blood_bank/router/admin_handlers.dart';
import 'package:blood_bank/router/not_found_handlers.dart';

class Flurorouter {
  static final FluroRouter router = new FluroRouter();

  /* Root */
  static String rootRoute = "/";
  /* Auth route */
  static String loginRoute = "/auth/login";
  /* Db routes */
  static String dbRoute = "/dashboard";

  /* Auth routes */

  static void configureRoutes() {
    router.define(loginRoute, handler: AdminHandlers.login);

    router.define(dbRoute, handler: DashboardHandlers.dashboard);

    /* 404 */
    router.notFoundHandler = NotFoundHandlers.noPageFound;
  }
}
