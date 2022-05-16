import 'package:blood_bank/ui/layouts/dashboard/dashboard_layout.dart';
import 'package:blood_bank/ui/layouts/splash/splash_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:blood_bank/router/router.dart';
import 'package:blood_bank/providers/auth_provider.dart';
import 'package:blood_bank/ui/layouts/auth/auth_layout.dart';
import 'package:blood_bank/services/local_storage.dart';
import 'package:blood_bank/services/navigation_service.dart';

void main() async {
  await LocalStorage.configurePrefs();
  Flurorouter.configureRoutes();
  runApp(AppState());
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => AuthProvider(),
        )
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blood bank application - dashboard',
      initialRoute: Flurorouter.loginRoute,
      onGenerateRoute: Flurorouter.router.generator,
      navigatorKey: NavigationService.navigatorKey,
      builder: (_, child) {
        final authProvider = Provider.of<AuthProvider>(context);
        if (authProvider.authStatus == AuthStatus.checking) {
          return SplashLayout();
        }
        if (authProvider.authStatus == AuthStatus.authenticated) {
          return DashboardLayout(child: child!);
        }
        return AuthLayout(
          child: child!,
        );
      },
      theme: ThemeData.light().copyWith(
        scrollbarTheme: ScrollbarThemeData().copyWith(
          thumbColor: MaterialStateProperty.all(
            Colors.white.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
