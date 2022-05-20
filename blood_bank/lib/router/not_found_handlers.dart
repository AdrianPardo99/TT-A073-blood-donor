import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';

import 'package:blood_bank/providers/side_menu_provider.dart';
import 'package:blood_bank/ui/views/not_found_view.dart';

class NotFoundHandlers {
  static Handler noPageFound = Handler(handlerFunc: (context, parameters) {
    Provider.of<SideMenuProvider>(context!, listen: false)
        .setCurrentPageUrl("/404");
    return NotFoundView();
  });
}
