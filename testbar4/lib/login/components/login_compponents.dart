import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:testbar4/database/Fire_Activity.dart';
import 'package:testbar4/login/p5_aftersign_inwithG.dart';
import 'package:testbar4/model/provider_userData.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscure;

  const MyTextField({
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

// for login button
class MyButton extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const MyButton({
    super.key,
    required this.usernameController,
    required this.passwordController,
  });

  Future<void> loginFunc(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );
      await Provider.of<UserDataPV>(context, listen: false).refreshUserData();
      print('Notification --->Login -- Login successfully');
      
      
      Activity.initialize();
      /*
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged in successfully')),
      );*/
      // Navigate to the next screen or perform other actions upon successful login
      Navigator.pushNamed(context, '/');
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else {
        message = 'An error occurred. Please try again.';
      }
      /*
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      */
      print('Notification --->Login -- Login failed |$message');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => loginFunc(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class SigninGoogle {
  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      // เริ่มกระบวนการลงชื่อเข้าใช้
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // รับรายละเอียดการรับรองความถูกต้องจากการร้องขอ
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // สร้างข้อมูลรับรองใหม่
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // เมื่อเข้าสู่ระบบแล้ว ให้คืน UserCredential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signed in as ${user.displayName}')),
        );

        // นำทางไปที่ AdditionalInfoScreen เพื่อเก็บข้อมูลที่ขาดหายไป
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdditionalInfoScreen(user: user),
          ),
        );
      }

      return user;
    } catch (e) {
      print('Sign in with Google failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Sign in with Google failed. Please try again.')),
      );
      return null;
    }
  }
}