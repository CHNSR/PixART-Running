import 'package:flutter/material.dart';
import 'package:testbar4/main.dart';
import 'export.dart';

class Routes {
  // Route Names
  static const String initial = '/';
  static const String main = '/main';
  static const String p1 = '/p1'; // Home
  static const String p2 = '/p2'; // Location
  static const String p3 = '/p3'; // Run
  static const String p4 = '/p4'; // Plan/ForgetPass (from main.dart logic)
  static const String p5 = '/p5'; // Profile
  static const String p6 = '/p1_intro';
  static const String p7 = '/p2_login';
  static const String p8 = '/p3_register';
  static const String p9 = '/p4_forgetpass';
  static const String p10 = '/edit_profile';
  static const String p11 = '/shoes';
  static const String p12 = '/add_shoes';
  static const String p13 = '/activity';
  static const String p15 = '/edit_location';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return MaterialPageRoute(builder: (_) => const AuthCheck());
      case main:
        return MaterialPageRoute(builder: (_) => Navbar());
      case p1:
        return MaterialPageRoute(builder: (_) => P1Home());
      case p2:
        return MaterialPageRoute(builder: (_) => P2Location());
      case p3:
        return MaterialPageRoute(builder: (_) => P3Run());
      case p4:
        return MaterialPageRoute(builder: (_) => P4Forgetpass());
      case p5:
        return MaterialPageRoute(builder: (_) => P5Profile());
      case p6:
        return MaterialPageRoute(builder: (_) => P1Intro());
      case p7:
        return MaterialPageRoute(builder: (_) => P2Login());
      case p8:
        return MaterialPageRoute(builder: (_) => P3Register());
      case p9:
        return MaterialPageRoute(builder: (_) => P4Forgetpass());
      case p10:
        return MaterialPageRoute(builder: (_) => EditeProfile());
      case p11:
        return MaterialPageRoute(builder: (_) => Shoes());
      case p12:
        return MaterialPageRoute(builder: (_) => Addshoes());
      case p13:
        return MaterialPageRoute(builder: (_) => ActivityPage());
      case p15:
        return MaterialPageRoute(builder: (_) => EditlocationPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
