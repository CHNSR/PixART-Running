import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart'; // For generating unique IDs

final firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
final user = auth.currentUser;

class PixARTShoes {
  // Add shoes with auto-generated document ID
  static Future<void> addShoes({
    required String shoesName,
    required double shoesRange,
    required String startUse,
  }) async {
    try {
      if (user == null) {
        print("Error: No user in auth");
        return;
      }
      final runnerID = user?.uid;
      final shoesID = Uuid().v4(); // Generate a unique ID for the shoes

      await firestore.collection("Shoes").add({
        "shoesID": shoesID,
        "runnerID": runnerID,
        "startUse": startUse,
        "shoesName": shoesName,
        "shoesRange": shoesRange,
      });
    } catch (e) {
      print('Failed to add shoes: $e');
    }
  }

  // Fetch shoes specific to the current user
  static Future<List<DocumentSnapshot>> fetchShoes() async {
    if (user == null) {
      throw Exception('User not logged in');
    }
    final userID = user?.uid;

    final snapshot = await firestore
        .collection('Shoes')
        .where('runnerID', isEqualTo: userID)
        .get();

    return snapshot.docs;
  }

  // Stream shoes
  static Stream<List<DocumentSnapshot>> streamShoes() {
    if (user == null) {
      throw Exception('User not logged in');
    }
    final userID = user?.uid;

    return firestore
        .collection('Shoes')
        .where('runnerID', isEqualTo: userID)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  // Update distance
  static Future<void> updateDistance({
    required String shoesID,
    required double newDistance,
  }) async {
    try {
      final querySnapshot = await firestore
          .collection('Shoes')
          .where('shoesID', isEqualTo: shoesID)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await firestore.collection('Shoes').doc(querySnapshot.docs.first.id).update({
          'distance': newDistance,
        });
      } else {
        throw Exception('Shoe not found');
      }
    } catch (e) {
      print('Failed to update distance: $e');
    }
  }

  // Delete shoes
  static Future<String> deleteShoes(String shoesID) async {
    try {
      final querySnapshot = await firestore
          .collection('Shoes')
          .where('shoesID', isEqualTo: shoesID)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await firestore.collection('Shoes').doc(querySnapshot.docs.first.id).delete();
        return "Shoes deleted successfully!";
      } else {
        throw Exception('Shoe not found');
      }
    } catch (e) {
      return 'Failed to delete shoes: $e';
    }
  }
}
