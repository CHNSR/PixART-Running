import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testbar4/services/firebase_service/Fire_User.dart';

class NPSTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscure;

  const NPSTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscure,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black26),
          ),
          fillColor: const Color.fromARGB(255, 249, 250, 212),
          filled: true,
          hintText: hintText,
        ),
        obscureText: obscure,
      ),
    );
  }
}

// for birthday (year, month, date)
class BirthdayTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  const BirthdayTextField(
      {super.key, required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black26),
          ),
          fillColor: const Color.fromARGB(255, 249, 250, 212),
          filled: true,
          hintText: hintText,
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            controller.text =
                "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
          }
        },
      ),
    );
  }
}

// for height and weight
class HAndWTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const HAndWTextField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black26),
          ),
          fillColor: const Color.fromARGB(255, 249, 250, 212),
          filled: true,
          hintText: hintText,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}

// for weekly goal (1-7 times/week)
class WeeklyGoalTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const WeeklyGoalTextField(
      {super.key, required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black26),
          ),
          fillColor: const Color.fromARGB(255, 249, 250, 212),
          filled: true,
          hintText: hintText,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}


class RegisterButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController usernameController;
  final TextEditingController weightController;
  final TextEditingController heightController;
  final TextEditingController birthdayController;
  final TextEditingController weeklyGoalController;

  const RegisterButton({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.usernameController,
    required this.weightController,
    required this.heightController,
    required this.birthdayController,
    required this.weeklyGoalController,
  });

  Future<void> _register(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;
    final name = usernameController.text;
    final weight = weightController.text;
    final height = heightController.text;
    final birthday = birthdayController.text;
    final weeklyGoal = weeklyGoalController.text;

    // Validate email format
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('The email address is badly formatted.')),
      );
      return;
    }

    // Validate other fields if needed
    if (password.isEmpty ||
        name.isEmpty ||
        weight.isEmpty ||
        height.isEmpty ||
        birthday.isEmpty ||
        weeklyGoal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields.')),
      );
      return;
    }

    try {
      
      PixARTUser.registerUser(
        email: email, 
        password: password, 
        name: name, 
        weight: double.parse(weight),
        height: double.parse(height), 
        birthday: DateTime.parse(birthday), 
        goal: int.parse(weeklyGoal), 
        creatuserID: true
        );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful')),
      );
      
      // Navigate to login page after successful registration
      Navigator.pushReplacementNamed(context, '/p7');
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else {
        message = 'An error occurred. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _register(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Center(
          child: Text(
            'Register',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
