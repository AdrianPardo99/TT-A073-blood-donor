import 'package:blood_bank/ui/views/not_found_view.dart';
import 'package:fluro/fluro.dart';

class NotFoundHandlers {
  static Handler noPageFound = Handler(
    handlerFunc: (context, parameters) => NotFoundView(),
  );
}
