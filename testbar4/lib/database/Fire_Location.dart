import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Firebase instances
final firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
final user = auth.currentUser;

class Locations {
  // Save route
  static Future<void> addRoute({
    required BuildContext context,
    required List routeData,
    required double distance,
    required String name,
    required bool status,
  }) async {
    if (user == null) {
      print("Error: No user logged in.");
      return;
    }

    final userId = user!.uid;
    const visit = 0;
    try {
      // Using .add() to generate a new document with an auto ID
      await firestore.collection("Location").add({
        'route': routeData,
        'distance': distance,
        'name': name,
        'visited': visit,
        'private': status,
        'userId': userId, // Add userId field to identify the owner of the location
      });
      print("[Fire_Location][addRoute] Saved private location");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully saved route [${status}]'),
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save route: $e'),
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  // Fetch locations
  static Future<List<QueryDocumentSnapshot>> fetchLocations() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('Location').get();
      print('Location form fire: $snapshot');
      return snapshot.docs;
    } catch (e) {
      print('Failed to fetch locations: $e');
      return [];
    }
  }

 

  //fetch route

  static Future<Map<String, dynamic>?> fetchRouteById(String documentID) async {
    try {
      // Fetch specific document by documentID
      final docSnapshot = await FirebaseFirestore.instance
          .collection('Location')
          .doc(documentID)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final route = data['route'];

        return {
          'docID': docSnapshot.id,
          'route': route,
        };
      } else {
        print('No such document exists with ID: $documentID');
        return null;
      }
    } catch (e) {
      print('Failed to fetch route for documentID: $documentID - Error: $e');
      return null;
    }
  }

  

  // Delete route by ID (public/private)
  static Future<void> deleteRoute(BuildContext context, String documentID) async {
    try {
      await firestore.collection('Location').doc(documentID).delete();
      // Show snackbar on successful deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully deleted route with ID: $documentID'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Show snackbar on failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete route: $e'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

}
