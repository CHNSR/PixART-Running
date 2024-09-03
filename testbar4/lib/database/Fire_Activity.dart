import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:testbar4/model/provider_userData.dart';

// Firestore & Auth
final firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;

class Activity {
  /*
  static String? runnerID;

  // Initialize runnerID using context
  static void initialize(BuildContext context) async {
    if (runnerID != null) {
      print("[Debug] Runner ID is already initialized.");
       // Return early if runnerID is already initialized
    }else{
      print("[Debug] initialize called");
      runnerID = context.read<UserDataPV>().userData?['id'];
      print("[Debug] Initialized runnerID: $runnerID");
    }

    

    // ทำการรอคอยหากมีการทำงานแบบอะซิงโครนัสอื่นที่ต้องทำที่นี่
  }
*/
  static String? runnerID;
  // Initialize runnerID using FirebaseAuth
  static void initialize() async {
    if (runnerID != null) {
      print("[Debug] Runner ID is already initialized.");
      return; // Return early if runnerID is already initialized
    } else {
      print("[Debug] initialize called");
      runnerID = auth.currentUser?.uid; // Fetch the user ID from FirebaseAuth
      print("[Debug] Initialized runnerID: $runnerID");
    }

    // ทำการรอคอยหากมีการทำงานแบบอะซิงโครนัสอื่นที่ต้องทำที่นี่
  }


  // Add activity data
  static Future<void> addActivity({
    required double distance,
    required DateTime finishdate,
    required double avgPace,
    required List<Map<String, dynamic>> routeData,
    required int time, // Change Timer to Duration
  }) async {
    if (auth.currentUser == null) {
      print("[Fire Activity][addActivity]------Error: No user logged in.");
      return;
    }

    try {
      await firestore.collection("Activity").add({
        "runnerID": runnerID ,
        "distance": distance,
        "date": Timestamp.fromDate(finishdate),
        "AVGpace": avgPace,
        "route": routeData,
        "time": time, // Store as milliseconds
      });
      print("[Fire Activity][addActivity]------saved data to fire");
    } catch (e) {
      print("[Fire Activity][addActivity]------Error to add activity [code error]: $e");
    }
  }

  // Fetch activity data
  static Future<List<Map<String, dynamic>>> fetchActivity({
    required dynamic numOfFetch,
  }) async {
    if (runnerID == null) {
      throw Exception("Runner ID not initialized.");
    }

    try {
      QuerySnapshot snapshot;

      // Check if numOfFetch is 'all' or a number
      if (numOfFetch == 'all') {
        snapshot = await firestore
            .collection("Activity")
            .where('runnerID', isEqualTo: runnerID)
            .orderBy('date', descending: true)
            .get();
      } else {
        snapshot = await firestore
            .collection("Activity")
            .where('runnerID', isEqualTo: runnerID)
            .orderBy('date', descending: true)
            .limit(numOfFetch)
            .get();
      }

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        // Convert Timestamp to DateTime
        if (data['date'] is Timestamp) {
          data['date'] = (data['date'] as Timestamp).toDate();
        }

        return data;
      }).toList();
    } catch (e) {
      throw Exception("Error fetching activity: $e");
    }
  }

  // Fetch best time
  static Future<Map<String, dynamic>?> fetchBestTime(int distance) async {
    if (runnerID == null) {
      throw Exception("Runner ID not initialized.");
    }

    final double minDistance = distance.toDouble();
    final double maxDistance = minDistance * 1.1;

    print("[Debug] Fetching best time for distance: $distance");
    print("[Debug] Runner ID: $runnerID, Min Distance: $minDistance, Max Distance: $maxDistance");

    try {
      final snapshot = await firestore
          .collection("Activity")
          .where('runnerID', isEqualTo: runnerID)
          .where('distance', isGreaterThanOrEqualTo: minDistance)
          .where('distance', isLessThanOrEqualTo: maxDistance)
          .orderBy('time', descending: true)
          .limit(1)
          .get();

      print("[Debug][${distance}] Snapshot retrieved: ${snapshot.docs.length} documents");

      if (snapshot.docs.isEmpty) {
        return null;
      }

      final doc = snapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;

      final result = {
        'besttime': data['time'],
        'date': DateFormat('yyyy-MM-dd HH:mm:ss').format((data['date'] as Timestamp).toDate()),
        'AVGpace': (data['AVGpace'] as double).toStringAsFixed(2),
      };

      print("[Fire-Activity][fetchBestTime] --------> { distance :$distance }: $result");
      return result;
    } catch (e) {
      print("[Fire_Activity][fetchBestTime]----Error---> : $e");
      return null;
    }
  }

  // Fetch longest distance
  static Future<Map<String, dynamic>?> fetchLongestDistance() async {
    if (runnerID == null) {
      throw Exception("Runner ID not initialized.");
    }

    try {
      final snapshot = await firestore
          .collection("Activity")
          .where('runnerID', isEqualTo: runnerID)
          .orderBy('distance', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      final doc = snapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;

      final distanceInMeters = data['distance'] as double;
      final distanceInKm = distanceInMeters / 1000.0;
      final formattedDistance = distanceInKm.toStringAsFixed(2);

      final result = {
        'date': DateFormat('yyyy-MM-dd HH:mm:ss').format((data['date'] as Timestamp).toDate()),
        'distance': formattedDistance,
      };

      print("[Fire-Activity][fetchLongestDistance] --------> : $result");
      return result;
    } catch (e) {
      print("[Fire_Activity][fetchLongestDistance]----Error---> : $e");
      return null;
    }
  }

  // Fetch best pace
  static Future<Map<String, dynamic>?> fetchBestPace() async {
    if (runnerID == null) {
      throw Exception("Runner ID not initialized.");
    }

    try {
      final snapshot = await firestore
          .collection("Activity")
          .where('runnerID', isEqualTo: runnerID)
          .where('distance', isGreaterThan: 1.0)
          .orderBy('AVGpace')
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      final doc = snapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;

      final result = {
        'date': DateFormat('yyyy-MM-dd HH:mm:ss').format((data['date'] as Timestamp).toDate()),
        'AVGpace': (data['AVGpace'] as double).toStringAsFixed(2),
      };

      print("[Fire-Activity][fetchBestPace] --------> : $result");
      return result;
    } catch (e) {
      print("[Fire_Activity][fetchBestPace]----Error---> : $e");
      return null;
    }
  }

  // Fetch longest duration
  static Future<Map<String, dynamic>?> fetchLongestDuration() async {
    if (runnerID == null) {
      throw Exception("Runner ID not initialized.");
    }

    try {
      final snapshot = await firestore
          .collection("Activity")
          .where('runnerID', isEqualTo: runnerID)
          .orderBy('time', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      final doc = snapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;

      final durationMillis = data['time'] as int;
      final duration = Duration(milliseconds: durationMillis);
      final formattedTime = "${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";

      final result = {
        'date': DateFormat('yyyy-MM-dd HH:mm:ss').format((data['date'] as Timestamp).toDate()),
        'time': formattedTime,
      };

      print("[Fire-Activity][fetchLongestDuration] --------> : $result");
      return result;
    } catch (e) {
      print("[Fire-Activity][fetchLongestDuration]----Error---> : $e");
      return null;
    }
  }

  // Fetch total distance
  static Future<double> fetchTotalDistance() async {
    if (runnerID == null) {
      throw Exception("Runner ID not initialized.");
    }

    double totalDistance = 0.0;

    try {
      final snapshot = await firestore
          .collection("Activity")
          .where('runnerID', isEqualTo: runnerID)
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        totalDistance += data['distance'] as double;
      }

      print("[Fire-Activity][fetchTotalDistance] --------> Total Distance: $totalDistance");
      return totalDistance;
    } catch (e) {
      print("[Fire_Activity][fetchTotalDistance]----Error---> : $e");
      return 0.0;
    }
  }

  // Fetch total hours
  static Future<String> fetchTotalHours() async {
    if (runnerID == null) {
      throw Exception("Runner ID not initialized.");
    }

    int totalTimeMillis = 0;

    try {
      final snapshot = await firestore
          .collection("Activity")
          .where('runnerID', isEqualTo: runnerID)
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        totalTimeMillis += data['time'] as int;
      }

      final totalTime = Duration(milliseconds: totalTimeMillis);
      final hours = totalTime.inHours.toString().padLeft(2, '0');
      final minutes = totalTime.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds = totalTime.inSeconds.remainder(60).toString().padLeft(2, '0');
      final formattedTime = "$hours:$minutes:$seconds";

      print("[Fire-Activity][fetchTotalHours] --------> Total Time: $formattedTime");
      return formattedTime;
    } catch (e) {
      print("[Fire-Activity][fetchTotalHours]----Error---> : $e");
      return "00:00:00";
    }
  }

  // Fetch total hours
  static Future<String> fetchTotalHouse() async {
  //final runnerID = user?.uid;
    int totalTimeMillis = 0;

    try {
      final snapshot = await firestore
          .collection("Activity")
          .where('runnerID', isEqualTo: runnerID)
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        totalTimeMillis += data['time'] as int;
      }

      final totalTime = Duration(milliseconds: totalTimeMillis);
      
      // Convert to HH:MM:SS format
      final hours = totalTime.inHours.toString().padLeft(2, '0');
      final minutes = totalTime.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds = totalTime.inSeconds.remainder(60).toString().padLeft(2, '0');
      
      final formattedTime = "$hours:$minutes:$seconds";
      
      print("[Fire-Activity][fetchTotalTimeFormatted] --------> Total Time: $formattedTime");
      
      return formattedTime;
    } catch (e) {
      print("[Fire_Activity][fetchTotalTimeFormatted]----Error---> : $e");
      return "00:00:00";
    }
  }

  // Fetch total average pace
  static Future<double> fetchTotalAveragePace() async {
    if (runnerID == null) {
      throw Exception("Runner ID not initialized.");
    }

    double totalPaceSum = 0.0;
    int activityCount = 0;

    try {
      final snapshot = await firestore
          .collection("Activity")
          .where('runnerID', isEqualTo: runnerID)
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        totalPaceSum += data['AVGpace'] as double;
        activityCount++;
      }

      final totalAvgPace = activityCount > 0 ? totalPaceSum / activityCount : 0.0;
      print("[Fire-Activity][fetchTotalAveragePace] --------> Total AVGpace: $totalAvgPace");
      return totalAvgPace;
    } catch (e) {
      print("[Fire-Activity][fetchTotalAveragePace]----Error---> : $e");
      return 0.0;
    }
  }
}
