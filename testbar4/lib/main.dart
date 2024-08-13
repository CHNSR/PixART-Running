import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:testbar4/login/p1_intro.dart';
import 'package:testbar4/login/p2_login.dart';
import 'package:testbar4/login/p3_register.dart';
import 'package:testbar4/login/p4_forgetpass.dart';
import 'package:testbar4/model/provider_userData.dart';
import 'package:testbar4/navbar.dart';
import 'package:testbar4/screen/layer2/activity/activity.dart';
import 'package:testbar4/screen/layer2/shose/addshoes.dart';
import 'package:testbar4/screen/layer2/shose/shoes.dart';
import 'package:testbar4/screen/p1_home.dart';
import 'package:testbar4/screen/p2_location.dart';
import 'package:testbar4/screen/p3_run.dart';
import 'package:testbar4/screen/p5-child/edite_profile.dart';
import 'package:testbar4/screen/p5_profile.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserDataPV())],
      child: const Nav(),
    ),
  );
}

class Nav extends StatelessWidget {
  const Nav({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthCheck(),
      //trun off debug tag
      debugShowCheckedModeBanner: false,
      initialRoute: '/',

      routes: {
        '/main': (context) => Navbar(),
        '/p1': (context) => P1Home(),
        '/p2': (context) => P2Location(),
        '/p3': (context) => P3Run(),
        '/p4': (context) => P4Forgetpass(),
        '/p5': (context) => P5Profile(),
        '/p6': (context) => P1Intro(),
        '/p7': (context) => P2Login(),
        '/p8': (context) => P3Register(),
        '/p9': (context) => P4Forgetpass(),
        '/p10': (context) => EditeProfile(),
        '/p11': (context) => Shoes(),
        '/p12': (context) => Addshoes(),
        '/p13': (context) => ActivityPage(),
      },
    );
  }
}

// this class will check user login?
class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    // ตรวจสอบสถานะการเข้าสู่ระบบของผู้ใช้
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child:
                  CircularProgressIndicator()); // รอการตรวจสอบสถานะการเข้าสู่ระบบ
        } else if (snapshot.hasData) {
          return Navbar(); // if user is logged in
        } else {
          return P1Intro(); // if user is not logged in
        }
      },
    );
  }
}
