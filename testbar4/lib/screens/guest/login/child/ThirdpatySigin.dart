import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart' as google_sign_in;
import 'package:testbar4/routes/export.dart';
/*
class //ThirdPartySignIn {
  final google_sign_in.GoogleSignIn _googleSignIn = google_sign_in.GoogleSignIn.instance; // สร้าง instance ของ GoogleSignIn
  Future<User?> loginWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        // ดึงข้อมูลผู้ใช้
        final userData = await FacebookAuth.instance.getUserData();
        print('Facebook login successful: $userData');

        // สร้าง Firebase user จากข้อมูลที่ดึงมา
        final credential =
            FacebookAuthProvider.credential(result.accessToken!.tokenString);
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        User? user = userCredential.user;

        String userId = user!.uid; // ดึง userId จาก Firebase Auth

        // ลงทะเบียนผู้ใช้ใน Firestore
        PixARTUser.registerUser(
          email: userData['email'],
          name: userData['name'] ?? '', // ใช้ข้อมูลชื่อจาก Facebook
          weight: 0, // คุณสามารถกำหนดค่าที่นี่ได้
          height: 0, // คุณสามารถกำหนดค่าที่นี่ได้
          birthday: DateTime.now(), // ใช้ข้อมูลวันเกิดที่ถูกต้องถ้ามี
          goal: 3, // คุณสามารถกำหนดค่าที่นี่ได้
          password: '',
          // userId: userId, // ใช้ userId ที่ดึงจาก Firebase Auth
          // creatuserID: false,
        );

        return user; // ส่งกลับ Firebase User
      } else {
        print('Facebook login failed: ${result.message}');
        return null; // หรือสามารถ throw exception ได้
      }
    } catch (e) {
      print('Error during Facebook login: $e');
      return null; // หรือสามารถ throw exception ได้
    }
  }

  //signin with google
  Future<User?> loginWithGoogle() async {
    try {
      final google_sign_in.GoogleSignInAccount? googleUser =
          await _googleSignIn.authenticate(); // เปิด Google Sign-In
      if (googleUser == null) return null; // ถ้าไม่เลือกผู้ใช้

      final google_sign_in.GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // สร้าง credential สำหรับ Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      String userId = user!.uid;

      // ลงทะเบียนผู้ใช้ใน Firestore
      PixARTUser.registerUser(
        email: googleUser.email,
        name: googleUser.displayName ?? '',
        weight: 0,
        height: 0,
        birthday: DateTime.now(),
        goal: 3,
        password: '',
        // userId: userId,
        // creatuserID: false,
      );

      return user; // ส่งกลับ Firebase User
    } catch (e) {
      print('Error during Google login: $e');
      return null;
    }
  }
}
*/
