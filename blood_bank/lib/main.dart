import 'package:blood_bank/providers/transfers_provider.dart';
import 'package:blood_bank/ui/shared/custom_scroll.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:blood_bank/router/router.dart';
import 'package:blood_bank/services/notification_service.dart';
import 'package:blood_bank/services/local_storage.dart';
import 'package:blood_bank/services/navigation_service.dart';
import 'package:blood_bank/ui/layouts/dashboard/dashboard_layout.dart';
import 'package:blood_bank/ui/layouts/splash/splash_layout.dart';
import 'package:blood_bank/ui/layouts/auth/auth_layout.dart';
import 'package:blood_bank/api/unit_blood_api.dart';
import 'package:blood_bank/providers/side_menu_provider.dart';
import 'package:blood_bank/providers/auth_provider.dart';
import 'package:blood_bank/providers/capabilities_providers.dart';
import 'package:blood_bank/providers/units_providers.dart';

void main() async {
  await LocalStorage.configurePrefs();
  UnitBloodApi.configureDio();
  Flurorouter.configureRoutes();
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(lazy: false, create: (_) => AuthProvider()),
        ChangeNotifierProvider(lazy: false, create: (_) => SideMenuProvider()),
        ChangeNotifierProvider(create: (_) => CapabilitiesProvider()),
        ChangeNotifierProvider(create: (_) => UnitsProvider()),
        ChangeNotifierProvider(create: (_) => TransfersProvider()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: CustomScroll(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [const Locale('es')],
      debugShowCheckedModeBanner: false,
      title: 'Blood bank application',
      initialRoute: Flurorouter.loginRoute,
      onGenerateRoute: Flurorouter.router.generator,
      navigatorKey: NavigationService.navigatorKey,
      scaffoldMessengerKey: NotificationService.msgKey,
      builder: (_, child) {
        final authProvider = Provider.of<AuthProvider>(context);
        if (authProvider.authStatus == AuthStatus.checking) {
          return const SplashLayout();
        }
        if (authProvider.authStatus == AuthStatus.authenticated) {
          return DashboardLayout(child: child!);
        }
        return AuthLayout(
          child: child!,
        );
      },
      theme: ThemeData.light().copyWith(
        scrollbarTheme: const ScrollbarThemeData().copyWith(
          thumbColor: MaterialStateProperty.all(
            Colors.white.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
