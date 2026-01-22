import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testbar4/routes/export.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final IconPath iconPath = IconPath();

  Future<void> _resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Password reset email sent!')),
      );
      _emailController.clear();
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred. Please try again.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(errorMessage)),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFf9f4ef),
            border:
                Border(bottom: BorderSide(width: 3, color: Color(0xFF0f0e17))),
          ),
        ),
        title: Text(
          'Forgot Password',
          style: GoogleFonts.pixelifySans(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0f0e17),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        color: const Color(0xFFf9f4ef), // กำหนดสีพื้นหลังของ body
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: Image.asset(iconPath.appBarIcon('reset_outline')),
            ),
            SizedBox(
              height: 80,
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                    Colors.black), // สีพื้นหลังปุ่มสีดำ
                foregroundColor: WidgetStateProperty.all<Color>(
                    Colors.white), // สีตัวหนังสือสีขาว
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8.0), // ขอบมลระดับ 8.0 (ปรับได้)
                  ),
                ),
                padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 24.0), // เพิ่ม padding ให้ปุ่มดูเต็ม
                ),
              ),
              onPressed: _resetPassword,
              child: const Text('Send Reset Email'),
            )
          ],
        ),
      ),
    );
  }
}
