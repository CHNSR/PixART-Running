import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testbar4/login/components/register_compponents.dart';
import 'package:testbar4/manage/manage_icon/icon_path.dart';
import 'package:provider/provider.dart';
import 'package:testbar4/model/provider_userData.dart';
import 'package:testbar4/screen/layer2/p5-child/CPediteprofile.dart';
import 'package:intl/intl.dart';

class EditeProfile extends StatelessWidget {
  EditeProfile({super.key});
  IconPath iconPath = IconPath();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final birthdayController = TextEditingController();
  final weeklyGoalController = TextEditingController();

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    print('Logout successful');
    Navigator.pushNamed(context, '/p7');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataPV>(builder: (context, userDataProvider, child) {
      final userData = userDataProvider.userData;
      // Old data
      final userName = userData?['name'] ?? '';
      final email = userData?['username'] ?? '';
      final height = userData?['height']?.toString() ?? '';
      final weight = userData?['weight']?.toString() ?? '';
      final birthday = ((userData?['birthday']as Timestamp).toDate()).toString() ??  '';
      final weeklyGoal = userData?['weekly_goal']?.toString() ?? '';

      return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              
              color: Color(0xFFf9f4ef),
              border: Border(bottom: BorderSide(width: 3,color: Color(0xFF0f0e17)))
            ),
          ),
          title: Text(
            "PixART Running",
            style: GoogleFonts.pixelifySans(
                fontSize: 30, fontWeight: FontWeight.w500),
          ),
          backgroundColor: Colors.transparent, 
         
        ),
        backgroundColor: const Color(0xFFf9f4ef),
        body: SingleChildScrollView(
            child: Center(
          child: Column(
            children: [
              const SizedBox(height: 80),

              // Logo
              Image.asset(
                iconPath.appBarIcon("document_outline"),
                height: 200,
                width: 200,
              ),

              const SizedBox(height: 30),

              // Text register
              const Text(
                'Edit Profile',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),

              const SizedBox(height: 25),

              // Username field
              NPSTextField(
                controller: usernameController,
                hintText: userName,
                obscure: false,
              ),

              const SizedBox(height: 15),

              // Email field
              NPSTextField(
                controller: emailController,
                hintText: email,
                obscure: false,
              ),

              const SizedBox(height: 15),

              // Password field (Optional)
              NPSTextField(
                controller: passwordController,
                hintText: 'Password',
                obscure: true,
              ),

              const SizedBox(height: 15),

              // Height field
              HAndWTextField(
                controller: heightController,
                hintText: height,
              ),

              const SizedBox(height: 15),

              // Weight field
              HAndWTextField(
                controller: weightController,
                hintText: weight,
              ),

              const SizedBox(height: 15),
              
              // Birthday field
              BirthdayTextField(
                controller: birthdayController,
                hintText: birthday,
              ),

              const SizedBox(height: 15),
              
              // Weekly goal field
              WeeklyGoalTextField(
                controller: weeklyGoalController,
                hintText: weeklyGoal,
              ),

              const SizedBox(height: 25),

              // Update button
              EditeProfileButton(
                emailController: emailController,
                passwordController: passwordController,
                usernameController: usernameController,
                weightController: weightController,
                heightController: heightController,
                birthdayController: birthdayController,
                weeklyGoalController: weeklyGoalController,
              ),

              const SizedBox(height: 45)
            ],
          ),
        )),
      );
    });
  }
}
