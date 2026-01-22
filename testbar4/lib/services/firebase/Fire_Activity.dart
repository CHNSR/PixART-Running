import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
//import 'package:provider/provider.dart';
//import 'package:testbar4/model/provider_userData.dart';

// Firestore & Auth
final firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;

class Activity {
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
        "runnerID": runnerID,
        "distance": distance,
        "date": Timestamp.fromDate(finishdate),
        "AVGpace": avgPace,
        "route": routeData,
        "time": time, // Store as milliseconds
      });
      print("[Fire Activity][addActivity]------saved data to fire");
    } catch (e) {
      print(
          "[Fire Activity][addActivity]------Error to add activity [code error]: $e");
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

  // Fetch activity data with DateTime range
  static Future<List<Map<String, dynamic>>> fetchActivityDateTime({
    required dynamic numOfFetch,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (runnerID == null) {
      throw Exception("Runner ID not initialized.");
    }

    try {
      Query query = firestore
          .collection("Activity")
          .where('runnerID', isEqualTo: runnerID);

      // If both startDate and endDate are provided, apply date filtering
      if (startDate != null && endDate != null) {
        query = query
            .where('date', isGreaterThanOrEqualTo: startDate)
            .where('date', isLessThanOrEqualTo: endDate);
      }

      // Order by date in descending order
      query = query.orderBy('date', descending: true);

      // Apply limit if numOfFetch is not 'all'
      if (numOfFetch != 'all') {
        query = query.limit(numOfFetch);
      }

      // Execute the query and fetch the snapshot
      QuerySnapshot snapshot = await query.get();

      // Map the snapshot data
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
    print(
        "[Debug] Runner ID: $runnerID, Min Distance: $minDistance, Max Distance: $maxDistance");

    try {
      final snapshot = await firestore
          .collection("Activity")
          .where('runnerID', isEqualTo: runnerID)
          .where('distance', isGreaterThanOrEqualTo: minDistance)
          .where('distance', isLessThanOrEqualTo: maxDistance)
          .orderBy('time', descending: true)
          .limit(1)
          .get();

      print(
          "[Debug][${distance}] Snapshot retrieved: ${snapshot.docs.length} documents");

      if (snapshot.docs.isEmpty) {
        return null;
      }

      final doc = snapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;

      final result = {
        'besttime': data['time'],
        'date': DateFormat('yyyy-MM-dd HH:mm:ss')
            .format((data['date'] as Timestamp).toDate()),
        'AVGpace': (data['AVGpace'] as double).toStringAsFixed(2),
      };

      print(
          "[Fire-Activity][fetchBestTime] --------> { distance :$distance }: $result");
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
        'date': DateFormat('yyyy-MM-dd HH:mm:ss')
            .format((data['date'] as Timestamp).toDate()),
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
          .where('AVGpace', isGreaterThan: 1.00) // เพิ่มเงื่อนไข pace > 1.00
          .orderBy('AVGpace')
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      final doc = snapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;

      final result = {
        'date': DateFormat('yyyy-MM-dd HH:mm:ss')
            .format((data['date'] as Timestamp).toDate()),
        'AVGpace': (data['AVGpace'] as double).toStringAsFixed(2),
      };
      print("[Fire-Activity][fetchBestPace] Check data --------> : $data");
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
      final formattedTime =
          "${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";

      final result = {
        'date': DateFormat('yyyy-MM-dd HH:mm:ss')
            .format((data['date'] as Timestamp).toDate()),
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

      print(
          "[Fire-Activity][fetchTotalDistance] --------> Total Distance: $totalDistance");
      return totalDistance;
    } catch (e) {
      print("[Fire_Activity][fetchTotalDistance]----Error---> : $e");
      return 0.0;
    }
  }

  // Fetch total distance within a date range
  static Future<double> fetchTotalDistanceSE(
      DateTime startDate, DateTime endDate) async {
    if (runnerID == null) {
      throw Exception("Runner ID not initialized.");
    }

    double totalDistance = 0.0;

    try {
      final snapshot = await firestore
          .collection("Activity")
          .where('runnerID', isEqualTo: runnerID)
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        totalDistance += data['distance'] as double;
      }

      print(
          "[Fire-Activity][fetchTotalDistanceSE][ Start date: $startDate ,End date: $endDate] --------> Total Distance: $totalDistance");
      return totalDistance;
    } catch (e) {
      print("[Fire_Activity][fetchTotalDistanceSE]----Error---> : $e");
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
      final minutes =
          totalTime.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds =
          totalTime.inSeconds.remainder(60).toString().padLeft(2, '0');
      final formattedTime = "$hours:$minutes:$seconds";

      print(
          "[Fire-Activity][fetchTotalHours] --------> Total Time: $formattedTime");
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
      final minutes =
          totalTime.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds =
          totalTime.inSeconds.remainder(60).toString().padLeft(2, '0');

      final formattedTime = "$hours:$minutes:$seconds";

      print(
          "[Fire-Activity][fetchTotalTimeFormatted] --------> Total Time: $formattedTime");

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

      final totalAvgPace =
          activityCount > 0 ? totalPaceSum / activityCount : 0.0;
      print(
          "[Fire-Activity][fetchTotalAveragePace] --------> Total AVGpace: $totalAvgPace");
      return totalAvgPace;
    } catch (e) {
      print("[Fire-Activity][fetchTotalAveragePace]----Error---> : $e");
      return 0.0;
    }
  }

  //fetch by date
  static Future<List<Map<String, dynamic>>> fetchActivityByDate(
      DateTime date) async {
    if (auth.currentUser == null) {
      print(
          "[Fire Activity][fetchActivityByDate]------Error: No user logged in.");
      return [];
    }

    try {
      // Normalize the date to start of the day
      DateTime startOfDay = DateTime(date.year, date.month, date.day);
      DateTime endOfDay = startOfDay.add(const Duration(days: 1));

      QuerySnapshot querySnapshot = await firestore
          .collection("Activity")
          .where("runnerID", isEqualTo: runnerID)
          .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where("date", isLessThan: Timestamp.fromDate(endOfDay))
          .get();

      List<Map<String, dynamic>> activityList = [];

      for (var doc in querySnapshot.docs) {
        activityList.add(doc.data() as Map<String, dynamic>);
      }

      print(
          "[Fire Activity][fetchActivityByDate]------Fetched activities: $activityList");
      return activityList;
    } catch (e) {
      print(
          "[Fire Activity][fetchActivityByDate]------Error fetching activity by date: $e");
      return [];
    }
  }

  // Fetch the number of weekly activities without fetching data
  static Future<int?> fetchNumOfWeeklyActivity(String runnerID) async {
    if (auth.currentUser == null) {
      print(
          "[Fire Activity][fetchNumOfWeeklyActivity]------Error: No user logged in.");
      return 0; // Return 0 since no user is logged in
    }

    try {
      // Get today's date
      DateTime now = DateTime.now();

      // Calculate the start (Sunday) and end (Saturday) of the current week
      DateTime sunday = now
          .subtract(Duration(days: now.weekday)); // Start of the week (Sunday)
      DateTime saturday =
          sunday.add(Duration(days: 6)); // End of the week (Saturday)

      print("Weekly range: $sunday - $saturday");

      // Query the 'Activity' collection for activities within this week
      AggregateQuerySnapshot querySnapshot = await firestore
          .collection("Activity")
          .where("runnerID", isEqualTo: runnerID)
          .where("date", isGreaterThanOrEqualTo: sunday)
          .where("date", isLessThanOrEqualTo: saturday)
          .count()
          .get();

      // Return the number of activities fetched
      int? activityCount = querySnapshot.count;
      print(
          "[Fire Activity][fetchNumOfWeeklyActivity]------Number of activities this week: $activityCount");

      return activityCount;
    } catch (e) {
      print(
          "[Fire Activity][fetchNumOfWeeklyActivity]------Error fetching weekly activities: $e");
      return 0;
    }
  }
}
