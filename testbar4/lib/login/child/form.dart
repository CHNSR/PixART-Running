import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:testbar4/login/child/ThirdpatySigin.dart';
import '../../manage/manage_icon/icon_path.dart';
import '../../services/auth_service/auth_service.dart';
import '../../services/firebase_service/Fire_User.dart';
import '../components/register_compponents.dart';
//import 'package:testbar4/services/firebase_service/AuthService.dart';

class AddDataForThirdpaty extends StatefulWidget {
  const AddDataForThirdpaty({super.key});

  @override
  State<AddDataForThirdpaty> createState() => _AddDataForThirdpatyState();
}

class _AddDataForThirdpatyState extends State<AddDataForThirdpaty> {
  IconPath iconPath = IconPath();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final birthdayController = TextEditingController();
  final weeklyGoalController = TextEditingController();
  
  final GAuthService _authService = GAuthService();
  User? _user;
  final ThirdPartySignIn _thirdPartySignIn = ThirdPartySignIn();
  

  @override
  void initState() {
    super.initState();
    _signInWithFacebook(); // เรียกใช้ Facebook Sign-In เมื่อหน้าจอถูกโหลด
  }

  Future<void> _signInWithFacebook() async {
    User? user = await _thirdPartySignIn.loginWithFacebook();
    if (user != null) {
      setState(() {
        _user = user;
        emailController.text = user.email ?? ''; // กรอกอีเมลอัตโนมัติ
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign in with Facebook')),
      );
    }
  }

  // Function to handle Google sign-in
  Future<void> _signInWithGoogle() async {
    User? user = await _authService.signInWithGoogle();
    if (user != null) {
      setState(() {
        _user = user;
        emailController.text = user.email ?? ''; // กรอกอีเมลอัตโนมัติ
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign in with Google')),
      );
    }
  }

  Future<void> _updateUserInfo() async {
    String name = usernameController.text;
    String password = passwordController.text;
    double weight = double.tryParse(weightController.text) ?? 0; // กำหนดค่าดีฟอลต์เป็น 0
    double height = double.tryParse(heightController.text) ?? 0; // กำหนดค่าดีฟอลต์เป็น 0
    DateTime birthday = DateTime.tryParse(birthdayController.text) ?? DateTime.now(); // กำหนดค่าดีฟอลต์เป็นวันนี้
    int weeklyGoal = int.tryParse(weeklyGoalController.text) ?? 0; // กำหนดค่าดีฟอลต์เป็น 0

    await PixARTUser.updateUserData(
      name: name,
      weight: weight,
      height: height,
      birthday: birthday,
      weeklyGoal: weeklyGoal,
      password: password,
    );
    Navigator.pushNamed(context, '/main');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Transform.rotate(
            angle: 3.14,
            child: Image.asset(iconPath.appBarIcon("arrowR_outline")),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFFFFEEA),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 80),
              Image.asset(iconPath.appBarIcon('register_outline'), height: 200, width: 200),
              const SizedBox(height: 40),
              const Text('Register to PixART Running Tracking', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey)),
              const SizedBox(height: 25),
              NPSTextField(controller: usernameController, hintText: 'Username', obscure: false),
              const SizedBox(height: 15),
              NPSTextField(controller: emailController, hintText: 'Email', obscure: false),
              const SizedBox(height: 15),
              NPSTextField(controller: passwordController, hintText: 'Password', obscure: true),
              const SizedBox(height: 15),
              HAndWTextField(controller: heightController, hintText: 'Height (cm)'),
              const SizedBox(height: 15),
              HAndWTextField(controller: weightController, hintText: 'Weight (kg)'),
              const SizedBox(height: 15),
              BirthdayTextField(controller: birthdayController, hintText: 'Enter your birthday (yyyy-mm-dd)'),
              const SizedBox(height: 15),
              WeeklyGoalTextField(controller: weeklyGoalController, hintText: 'Enter your weekly goal (1-7 times/week)'),
              const SizedBox(height: 15),
              ElevatedButton(onPressed: _updateUserInfo, child: const Text('Update User Info')),
              const SizedBox(height: 45),
            ],
          ),
        ),
      ),
    );
  }
}