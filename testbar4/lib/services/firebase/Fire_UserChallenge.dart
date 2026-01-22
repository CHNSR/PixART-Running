import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testbar4/services/firebase/Fire_Activity.dart';

// Set Firestore & Auth
final firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
final user = auth.currentUser;

class UserChallenge {
  //add UserChallenge
  static Future<void> startChallenge(String userId, String challengeId,
      Timestamp startDate, Timestamp endDate) async {
    await firestore.collection('UserChallenges').add({
      'runnerID': userId,
      'challengeId': challengeId,
      'status': 'in progress',
      'startDate': startDate,
      'endDate': endDate,
    });
  }

  //Checking challenge
  static Future<void> checkChallengeCompletion(
      String userId, String challengeId) async {
    // รับรายละเอียดของความท้าทาย
    DocumentSnapshot challengeDoc =
        await firestore.collection('Challenges').doc(challengeId).get();
    DateTime startDate = challengeDoc['start_date'].toDate();
    DateTime endDate = challengeDoc['end_date'].toDate();
    double requiredDistance = challengeDoc['distance'];

    // นับระยะทางทั้งหมดของกิจกรรมผู้ใช้ที่เกิดขึ้นในช่วงเวลาของความท้าทาย

    double totalDistance =
        await Activity.fetchTotalDistanceSE(startDate, endDate);
    // อัปเดตสถานะของความท้าทาย
    if (totalDistance >= requiredDistance) {
      await FirebaseFirestore.instance
          .collection('UserChallenges')
          .where('runnerID', isEqualTo: userId)
          .where('challengeId', isEqualTo: challengeId)
          .limit(1)
          .get()
          .then((snapshot) {
        snapshot.docs.first.reference.update({'status': 'passed'});
      });
    }
  }

//fetch user challenge Userchallenge

  static Future<List<Map<String, dynamic>>> fetchUserChallenge({
    required String runnerID,
  }) async {
    try {
      // Fetch data from Firestore where runnerID matches the given runnerID
      QuerySnapshot snapshot = await firestore
          .collection("UserChallenges")
          .where('runnerID', isEqualTo: runnerID)
          .get();

      // Map the documents to a list of Map<String, dynamic>
      return snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      // Throw an exception if an error occurs
      throw Exception("Error fetching UserChallenge: $e");
    }
  }
  //Ma
}
