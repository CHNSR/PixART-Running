import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testbar4/routes/export.dart';
import 'package:testbar4/screens/guest/login/components/login_compponents.dart';

class P4Forgetpass extends StatefulWidget {
  const P4Forgetpass({super.key});

  @override
  State<P4Forgetpass> createState() => _P4ForgetpassState();
}

class _P4ForgetpassState extends State<P4Forgetpass> {
  final emailController = TextEditingController();
  final IconPath iconPath = IconPath();

  Future<void> sendResetEmail() async {
    try {
      if (emailController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your email')),
        );
        return;
      }

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Password reset email sent! check your inbox.')),
        );
        Navigator.pop(context); // Go back to login
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'An error occurred')),
        );
      }
    }
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
              // Lock icon or similar
              Image.asset(
                iconPath.appBarIcon(
                    "lock_outline"), // Reusing lock icon as placeholder or maybe standard icon
                // Or we could use another icon if available, but lock is safe for password reset
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 50),

              const Text(
                'Forgot Password?',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Don't worry! It happens. Please enter the email associated with your account.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              MyTextField(
                controller: emailController,
                hintText: 'Enter your email',
                obscure: false,
              ),

              const SizedBox(height: 30),

              // Send Button
              GestureDetector(
                onTap: sendResetEmail,
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
                      'Send Request',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
