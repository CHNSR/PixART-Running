import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testbar4/services/firebase_service/Fire_User.dart';
import 'package:testbar4/model/provider_userData.dart';

class EditeProfileButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController usernameController;
  final TextEditingController weightController;
  final TextEditingController heightController;
  final TextEditingController birthdayController;
  final TextEditingController weeklyGoalController;

  const EditeProfileButton({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.usernameController,
    required this.weightController,
    required this.heightController,
    required this.birthdayController,
    required this.weeklyGoalController, 
  });

  Future<void> _update(BuildContext context) async {
    final userProvider = Provider.of<UserDataPV>(context, listen: false);

    final email = emailController.text.isNotEmpty
        ? emailController.text
        : userProvider.userData?['username'] ?? '';
    final password = passwordController.text;
    final name = usernameController.text.isNotEmpty
        ? usernameController.text
        : userProvider.userData?['name'] ?? '';
    final weight = weightController.text.isNotEmpty
        ? double.tryParse(weightController.text)
        : userProvider.userData?['weight'];
    final height = heightController.text.isNotEmpty
        ? double.tryParse(heightController.text)
        : userProvider.userData?['height'];
    
    final birthday = birthdayController.text.isNotEmpty
        ? DateTime.tryParse(birthdayController.text)
        : userProvider.userData?['birthday'];
        
    final weeklyGoal = weeklyGoalController.text.isNotEmpty
        ? int.tryParse(weeklyGoalController.text)
        : userProvider.userData?['weekly_goal'];

    // Validate email format
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('The email address is badly formatted.')),
      );
      return;
    }

    // Validate other fields
    if (password.isEmpty &&
        (email.isEmpty ||
            name.isEmpty ||
            weight == null ||
            height == null ||
            birthday == null ||
            weeklyGoal == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields with valid data.')),
      );
      return;
    }

    try {
      // Update user data in Firebase
      await PixARTUser.updateUserData(
        email: email,
        password: password.isNotEmpty ? password : null,
        name: name,
        weight: weight!,
        height: height!,
        birthday: birthday!,
        weeklyGoal: weeklyGoal!,
      );
      
      // Notify the provider to refresh user data
      await userProvider.refreshUserData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully.')),
      );
      } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _update(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Color(0xFFc3f0ca),
          borderRadius: BorderRadius.circular(5),
          border:Border.all(width: 1,color: Colors.black)
        ),
        child: const Center(
          child: Text("Update Data",
              style: TextStyle(color: Colors.black, fontSize: 16)),
        ),
      ),
    );
  }
}
