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
    required int distance,
    required String name,
  }) async {
    final visit = 0;
    try {
      await firestore.collection("Location").add({
        'route': routeData,
        'distance': distance,
        'name': name,
        'visited': visit,
      });
    } catch (e) {
      print('Failed to add route: $e');
    }
  }

  // Fetch data
  // Fetch locations
  static Future<List<QueryDocumentSnapshot>> fetchLocations() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('Location').get();
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
}
