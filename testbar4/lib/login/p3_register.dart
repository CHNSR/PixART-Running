import 'package:flutter/material.dart';
import 'package:testbar4/manage/manage_icon/icon_path.dart';
import 'package:testbar4/login/components/register_compponents.dart';

class P3Register extends StatelessWidget {
  P3Register({super.key});
  IconPath iconPath = IconPath();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final birthdayController = TextEditingController();
  final weeklyGoalController = TextEditingController();

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

              //logo
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
                    color: Colors.grey),
              ),

              const SizedBox(height: 25),

              // Username field
              NPSTextField(
                controller: usernameController,
                hintText: 'Username',
                obscure: false,
              ),

              const SizedBox(height: 15),

              //email
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
                hintText: 'Enter your weekly goal(1-7 times/week)',
              ),

              const SizedBox(height: 15),

              // Login
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/p7'),
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // Register button
              RegisterButton(
                usernameController: usernameController,
                emailController: emailController,
                passwordController: passwordController,
                weightController: weightController,
                heightController: heightController,
                birthdayController: birthdayController,
                weeklyGoalController: weeklyGoalController,
              ),

              const SizedBox(height: 45),
            ],
          ),
        ),
      ),
    );
  }
}
