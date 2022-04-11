import 'package:flutter/material.dart';
import 'package:smart_home_app/screens/splash_screen.dart';
import 'package:smart_home_app/screens/intro_screen.dart';
import 'package:smart_home_app/screens/login_screen.dart';
import 'package:smart_home_app/screens/reset_screen.dart';
import 'constants.dart' as constants;

class SmartHome extends StatelessWidget {
  const SmartHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SmartHome',
        theme: ThemeData(
            primarySwatch: const MaterialColor(0xFF981e97, constants.primary),
            backgroundColor: Colors.white,
            canvasColor: Colors.white),
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => const SplashScreen(),
          '/login': (BuildContext context) => const LoginScreen(),
          '/reset': (BuildContext context) => const ResetScreen(),
          '/intro': (BuildContext context) => const IntroScreen(),
        });
  }
}
