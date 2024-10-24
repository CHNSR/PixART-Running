import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:testbar4/services/firebase_service/Fire_User.dart';

class GAuthService {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  

  Future<User?> signInWithGoogle() async {
    print("use signInWithGoogle");
    try {
      // Call Google Sign-In
      final GoogleSignInAccount? gUser = await googleSignIn.signIn();
      
      // Check if the user has signed in
      if (gUser == null) {
        
        return null;
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Create credential
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Sign in with Firebase
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;
      
      // Create a user document in Firestore
      if (user != null) {
        // Create a user document in Firestore
        await PixARTUser.registerUser(
          email: user.email ?? gUser.email,
          password: 'temporary_password', // Password management can be handled later
          name: user.displayName ?? 'User', // Display name from Google
          weight: 0, // Default weight, ask the user later
          height: 0, // Default height, ask the user later
          birthday: DateTime(2000, 1, 1), // Default birthday, prompt later
          goal: 0, // Default goal
          creatuserID: false,
          userId: user.uid, // Use Firebase UID for unique user identification
        );
      }

      return userCredential.user; // Return user
    } catch (e) {
      print("Error signing in with Google: $e");
      return null; // Return null if an error occurs
    }
  }
}
