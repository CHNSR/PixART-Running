import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Set Firestore & Auth
final firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
final user = auth.currentUser;

class Challenge {
  //fetch challenge
  static Future<List<Map<String,dynamic>>> fetchChallenge() async{
    try{
      QuerySnapshot snapshot = await firestore
            .collection("Challenge")
            .get();
      return snapshot.docs.map((docs) {
        final data = docs.data() as Map<String,dynamic>;
        print('[Fire-Challenge][fetchcallenge] data: $data');
        return data;
      }).toList();
    }catch (e){
      throw Exception("[Fire-Challenge][fetchChallenge] Error fetching : $e");
    }
  }
  // add challenge for admin
  static Future<void> addChallenge({
    required String name,
    required double distance,
    required DateTime startDate,
    required DateTime endDate,
    required String expend, // Example field, adjust as needed
  }) async {
    try {
      // Create a new document with an auto-generated ID in the 'Challenge' collection
      await firestore.collection("Challenge").add({
        'name': name,
        'distance': distance,
        'start_date': Timestamp.fromDate(startDate),
        'end_date': Timestamp.fromDate(endDate),
        'expend': expend, // Example field, adjust as needed
      });
      print('[Fire-Challenge][addChallenge] Challenge added successfully');
    } catch (e) {
      throw Exception("[Fire-Challenge][addChallenge] Error adding challenge: $e");
    }
  }
}
