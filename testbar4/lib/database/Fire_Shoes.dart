import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
final user = auth.currentUser;

class PixARTShoes {
  // Add shoes with auto-generated document ID
  static Future<void> addShoes({
    required String shoesName,
    required String shoesRange,
    required String startUse,
  }) async {
    try {
      if (user == null) {
        print("Error: No user in auth");
        return;
      }
      final runnerID = user?.uid;

      await firestore.collection("Shoes").add({
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

  //stream shoes
  // สตรีมของรองเท้าที่เป็นของผู้ใช้ปัจจุบัน
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
    required String documentID,
    required double newDistance,
  }) async {
    try {
      await firestore.collection('Shoes').doc(documentID).update({
        'distance': newDistance,
      });
    } catch (e) {
      print('Failed to update distance: $e');
    }
  }

  // Delete shoes
  static Future<String> deleteShoes(String documentID) async {
    try {
      await firestore.collection('Shoes').doc(documentID).delete();

      return "Shoes deleted successfully!";
    } catch (e) {
      return 'Failed to delete shoes: $e';
    }
  }
}
