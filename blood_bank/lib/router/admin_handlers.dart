import 'package:fluro/fluro.dart';

import 'package:blood_bank/ui/views/login_view.dart';

class AdminHandlers {
  static Handler login = new Handler(
    handlerFunc: (context, parameters) {
      return LoginView();
    },
  );
}
