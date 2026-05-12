import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tylunch/view/CONNEXION%20AND%20ACCOUNT/registration.dart';
import 'package:tylunch/view/cart.dart';
import 'package:tylunch/view/home.dart';
import 'package:tylunch/view/landing.dart';
import 'package:tylunch/view/CONNEXION%20AND%20ACCOUNT/login.dart';
import 'package:tylunch/splashscreen.dart';
import 'view/CONNEXION AND ACCOUNT/auth.dart';

class TyLunchApp extends StatelessWidget {
  const TyLunchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          MonthYearPickerLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('fr', 'FR'),
          Locale('en', 'US')
        ],
        title: 'Ty-Lunch',
        theme: ThemeData(
          fontFamily: 'CraftRounded',
        ),
        home: const SplashScreenPage(),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case "/landing_page":
              return PageTransition(
                  child: LandingPage(),
                  type: PageTransitionType.leftToRightWithFade);

            case "/cart_page":
              return PageTransition(
                  child: const CartPage(),
                  type: PageTransitionType.leftToRightWithFade);

            case "/login_page":
              return PageTransition(
                  child: const LoginPage(),
                  type: PageTransitionType.leftToRightWithFade);

            case "/registration_page":
              return PageTransition(
                  child: const RegistrationPage(),
                  type: PageTransitionType.leftToRightWithFade);

            case "/auth_page":
              return PageTransition(
                  child: const AuthPage(),
                  type: PageTransitionType.leftToRightWithFade);

            default:
              return PageTransition(
                  child: const HomePage(), type: PageTransitionType.fade);
          }
        });
  }
}
