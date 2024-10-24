import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../manage/manage_icon/icon_path.dart';
import '../../services/auth_service/auth_service.dart';
import '../../services/firebase_service/Fire_User.dart';
import '../components/register_compponents.dart';
//import 'package:testbar4/services/firebase_service/AuthService.dart';

class RegisterwithGoogle extends StatefulWidget {
  const RegisterwithGoogle({super.key});

  @override
  State<RegisterwithGoogle> createState() => _RegisterwithGoogleState();
}
class _RegisterwithGoogleState extends State<RegisterwithGoogle> {
  IconPath iconPath = IconPath();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final birthdayController = TextEditingController();
  final weeklyGoalController = TextEditingController();

  // AuthService instance
  final GAuthService _authService = GAuthService();
  User? _user;

  @override
  void initState() {
    super.initState();
    // เรียกใช้ Google Sign-In เมื่อหน้าจอถูกโหลด
    _signInWithGoogle();
    print("init state");
  }

  // Function to handle Google sign-in
  Future<void> _signInWithGoogle() async {
    User? user = await _authService.signInWithGoogle();
    print("user in _signInWithGoogle $user");
    if (user != null) {
      setState(() {
        _user = user;
        emailController.text = user.email ?? ''; // กรอกอีเมลอัตโนมัติ
      });
    } else {
      // แสดง error ถ้าล็อกอินล้มเหลว
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign in with Google')),
      );
    }
  }

  Future<void> _updateUserInfo() async {
    // รับข้อมูลจากฟิลด์ต่างๆ
    String name = usernameController.text;
    String password = passwordController.text;
    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text);
    DateTime birthday = DateTime.parse(birthdayController.text);
    int weeklyGoal = int.parse(weeklyGoalController.text);

    // อัปเดตข้อมูลใน Firestore
    await PixARTUser.updateUserData(
      name: name,
      weight: weight,
      height: height,
      birthday: birthday,
      weeklyGoal: weeklyGoal,
      password: password,
    );
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
            angle: 3.14, // 180 degrees in radians (π radians)
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
              // Logo
              Image.asset(
                iconPath.appBarIcon('register_outline'),
                height: 200,
                width: 200,
              ),
              const SizedBox(height: 40),
              // Text register
              const Text(
                'Register to PixART Running Tracking',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 25),
              // Username field
              NPSTextField(
                controller: usernameController,
                hintText: 'Username',
                obscure: false,
              ),
              const SizedBox(height: 15),
              // Email field (จาก Google)
              NPSTextField(
                controller: emailController,
                hintText: 'Email',
                obscure: false,
              ),
              const SizedBox(height: 15),
              // Password field
              NPSTextField(
                controller: passwordController,
                hintText: 'Password',
                obscure: true,
              ),
              const SizedBox(height: 15),
              // Height field
              HAndWTextField(
                controller: heightController,
                hintText: 'Height (cm)',
              ),
              const SizedBox(height: 15),
              // Weight field
              HAndWTextField(
                controller: weightController,
                hintText: 'Weight (kg)',
              ),
              const SizedBox(height: 15),
              // Birthday field
              BirthdayTextField(
                controller: birthdayController,
                hintText: 'Enter your birthday (yyyy-mm-dd)',
              ),
              const SizedBox(height: 15),
              // Weekly goal field
              WeeklyGoalTextField(
                controller: weeklyGoalController,
                hintText: 'Enter your weekly goal (1-7 times/week)',
              ),
              const SizedBox(height: 15),
              // Register button
              ElevatedButton(
                onPressed: _updateUserInfo,
                child: const Text('Update User Info'),
              ),
              const SizedBox(height: 45),
            ],
          ),
        ),
      ),
    );
  }
}
