import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Firebase instances
final firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
final user = auth.currentUser;

class Location {
  // Save route
  static Future<void> addRoute({
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
      await firestore.collection("Location").doc(userId).set({
        'route': routeData,
        'distance': distance,
        'name': name,
        'visited': visit,
        'private': status,
      });
      print("[Fire_Location][addRoute] Saved private location");
    } catch (e) {
      print('[Fire_Location][addRoute] Failed to add route: $e');
    }
  }

  // Fetch data
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

  // Add visit
  static Future<void> addVisit(String documentID) async {
    try {
      final docRef = firestore.collection('Location').doc(documentID);

      // Transaction to ensure that the visit count is updated correctly
      await firestore.runTransaction((transaction) async {
        final docSnapshot = await transaction.get(docRef);

        if (!docSnapshot.exists) {
          throw Exception("Document does not exist");
        }

        final currentVisit = docSnapshot.data()?['visited'] ?? 0;
        transaction.update(docRef, {'visited': currentVisit + 1});
      });
    } catch (e) {
      print('Failed to add visit: $e');
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
  //add Private route
}
