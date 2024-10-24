import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;

class PixARTUser {
  // Function to register a new user
  static Future<void> registerUser({
    
    required String email,
    required String password,
    required String name,
    required double weight,
    required double height,
    required DateTime birthday,
    required int goal,
    required  bool creatuserID,
    String? userId,
  }) async {
    try {
      if (creatuserID == true) {
        // Create user in Firebase Authentication
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
       userId = userCredential.user!.uid;
      }
      

      // Add user data to Firestore
      await firestore.collection("RunnerProfile").doc(userId).set({
        "id": userId, // Ensure 'id' field is included for future queries
        "name": name,
        "weight": weight,
        "height": height,
        "birthday": birthday,
        "weekly_goal": goal,
        "username": email,
      });
      
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
    } catch (e) {
      print(e);
    }
  }
 

  // Function to fetch a document by userID field
  static Future<DocumentSnapshot?> getUserDocumentByUserID(
      String userID) async {
    try {
      final querySnapshot = await firestore
          .collection('RunnerProfile')
          .where('id', isEqualTo: userID) // Use 'id' field for querying
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first; // Return the first document found
      }
    } catch (e) {
      print('Error fetching user document: $e');
    }
    return null;
  }

  // Function to fetch user data
  static Future<Map<String, dynamic>?> fetchUserData() async {
    final userID = auth.currentUser?.uid;

    if (userID == null) {
      print('No current user logged in.');
      return null;
    }

    final doc = await getUserDocumentByUserID(userID);

    if (doc != null) {
      final data = doc.data() as Map<String, dynamic>;
      print('User data: $data');
      return data;
    } else {
      print('No document found for userID $userID');
      return null;
    }
  }

  // Function to update user data
  static Future<void> updateUserData({
    String? email,
    String? password,
    String? name,
    double? weight,
    double? height,
    DateTime? birthday,
    int? weeklyGoal,
  }) async {
    final user = auth.currentUser;

    if (user == null) {
      print('No user is currently signed in.');
      return;
    }

    final userId = user.uid;

    try {
      // Update Firebase Authentication fields if provided
      if (password != null && password.isNotEmpty) {
        await user.updatePassword(password);
      }

      if (email != null && email.isNotEmpty) {
        await user.updateEmail(email);
      }

      // Query the document to get its ID
      final doc = await getUserDocumentByUserID(userId);

      if (doc == null) {
        print('No document found for userID $userId');
        return;
      }

      final docId = doc.id;

      // Prepare the update data
      final updateData = {
        if (name != null) "name": name,
        if (weight != null) "weight": weight,
        if (height != null) "height": height,
        if (birthday != null) "birthday": birthday, // Uncomment if needed
        if (weeklyGoal != null) "weekly_goal": weeklyGoal,
        if (email != null) "username": email,
      };

      if (updateData.isNotEmpty) {
        // Update the document with the new data
        await firestore
            .collection('RunnerProfile')
            .doc(docId)
            .update(updateData);
        print('User profile updated successfully.');
      }
    } catch (e) {
      print('Failed to update user profile: $e');
    }
  }
  //is Admin
   static Future<bool> isAdmin() async {
    try {
      // Fetch user data from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        return data['role'] == 'admin'; // Check if the role field is 'admin'
      }
    } catch (e) {
      print('Error checking admin status: $e');
    }
    return false;
  }
}
