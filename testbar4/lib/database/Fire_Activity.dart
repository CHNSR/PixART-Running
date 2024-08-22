import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

// Firestore & Auth
final firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
final user = auth.currentUser;

class Activity {
  //to store route list
  late List<dynamic> routedataformfire;

  //to store activity data
  late Map<String, dynamic> runingdata;

  static int durationToMilliseconds(Duration duration) {
    return duration.inMilliseconds;
  }

  // Add activity data
  static Future<void> addActivity({
    required double distance,
    required DateTime finishdate,
    required double avgPace,
    required List<Map<String, dynamic>> routeData,
    required int time, // Change Timer to Duration
  }) async {
    if (user == null) {
      print("[Fire Activity][addActivity]------Error: No user logged in.");
    }

    final runnerID = user!.uid;

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
      // No error
    } catch (e) {
      print(
          "[Fire Activity][addActivity]------Error to add activity [code error]: $e");
    }
  }

  // Fetch activity data
  // Fetch activity data
  static Future<List<Map<String, dynamic>>> fetchActivity(
      {required dynamic numOfFetch}) async {
    final runnerID = user?.uid;

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

  //fetch each fastes time

  static Future<Map<String, dynamic>?> fetchBestTime(int distance) async {
    final runnerID = user?.uid;
    final double minDistance = distance.toDouble(); // ระยะทางขั้นต่ำที่ต้องการ
    final double maxDistance = minDistance * 1.1; // ระยะทางสูงสุดที่ไม่เกิน 10%

    try {
      final snapshot = await firestore
          .collection("Activity")
          .where('runnerID', isEqualTo: runnerID)
          .where('distance',
              isGreaterThanOrEqualTo:
                  minDistance.toString()) // ระยะทาง >= minDistance
          .where('distance',
              isLessThanOrEqualTo:
                  maxDistance.toString()) // ระยะทาง <= maxDistance
          .orderBy('time', descending: true) // เรียงจากเวลาที่เร็วที่สุด
          .limit(1) // จำกัดให้ดึงมาแค่เวลาเร็วที่สุดเท่านั้น
          .get();

      if (snapshot.docs.isEmpty) {
        return null; // ถ้าไม่มีข้อมูล
      }

      final doc = snapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;

      final result = {
        'besttime': data['time'], // เวลาที่ดีที่สุด
        'date': DateFormat('yyyy-MM-dd HH:mm:ss').format(
            (data['date'] as Timestamp).toDate()), // แปลงและจัดรูปแบบ DateTime
        'AVGpace': (data['AVGpace'] as double)
            .toStringAsFixed(2), // แปลงเป็น String และกำหนดจุดทศนิยม 2 ตำแหน่ง
      };

      print(
          "[Fire-Activity][fetchBestTime] --------> { distance :$distance }: $result");
      return result; // ส่งคืนข้อมูลเป็น Map<String, dynamic>
    } catch (e) {
      print("[Fire_Activity][fetchBestTime]----Error---> : $e");
      return null;
    }
  }

  //fetch Longest distance|ex.result{date: 2024-08-21 07:01:16,distance: 15.19}
  static Future<Map<String, dynamic>?> fetchLongestDistance() async {
    final runnerID = user?.uid;

    try {
      final snapshot = await firestore
          .collection("Activity")
          .where('runnerID', isEqualTo: runnerID)
          .orderBy('distance', descending: true) // เรียงจากระยะทางที่ไกลที่สุด
          .limit(1) // จำกัดให้ดึงมาแค่ระยะทางที่ไกลที่สุดเท่านั้น
          .get();

      if (snapshot.docs.isEmpty) {
        return null; // ถ้าไม่มีข้อมูล
      }

      final doc = snapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;

      final result = {
        'date': DateFormat('yyyy-MM-dd HH:mm:ss').format(
            (data['date'] as Timestamp).toDate()), // แปลงและจัดรูปแบบ DateTime
        'distance': data['distance'], // ระยะทางที่ไกลที่สุด
      };

      print("[Fire-Activity][fetchLongestDistance] --------> : $result");
      return result; // ส่งคืนข้อมูลเป็น Map<String, dynamic>
    } catch (e) {
      print("[Fire_Activity][fetchLongestDistance]----Error---> : $e");
      return null;
    }
  }

  //fetch best pace use data more than 1 km |ex.result{date: 2024-08-21 07:01:16,AVGpace: 4.19}
  static Future<Map<String, dynamic>?> fetchBestPace() async {
    final runnerID = user?.uid;

    try {
      final snapshot = await firestore
          .collection("Activity")
          .where('runnerID', isEqualTo: runnerID)
          .where('distance', isGreaterThan: '1.0') // เฉพาะระยะทางมากกว่า 1 กม.
          .orderBy('AVGpace') // เรียงจาก pace ที่ดีที่สุด (น้อยที่สุด)
          .limit(1) // จำกัดให้ดึงมาแค่ pace ที่ดีที่สุดเท่านั้น
          .get();

      if (snapshot.docs.isEmpty) {
        return null; // ถ้าไม่มีข้อมูล
      }

      final doc = snapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;

      final result = {
        'date': DateFormat('yyyy-MM-dd HH:mm:ss').format(
            (data['date'] as Timestamp).toDate()), // แปลงและจัดรูปแบบ DateTime
        'AVGpace':
            (data['AVGpace'] as double).toStringAsFixed(2), // pace ที่ดีที่สุด
      };

      print("[Fire-Activity][fetchBestPace] --------> : $result");
      return result; // ส่งคืนข้อมูลเป็น Map<String, dynamic>
    } catch (e) {
      print("[Fire_Activity][fetchBestPace]----Error---> : $e");
      return null;
    }
  }

//fetchlongest duration
  static Future<Map<String, dynamic>?> fetchLongestDuration() async {
    final runnerID = user?.uid; // Ensure user is defined and has an ID

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("Activity")
          .where('runnerID', isEqualTo: runnerID)
          .orderBy('time',
              descending:
                  true) // Sort by duration, descending to get the longest
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null; // No data available
      }

      final doc = snapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;

      // Convert duration from milliseconds to [HH:MM:SS]
      final durationMillis =
          data['time'] as int; // Assuming 'time' is in milliseconds
      final duration = Duration(milliseconds: durationMillis);
      final formattedTime =
          "${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";

      final result = {
        'date': DateFormat('yyyy-MM-dd HH:mm:ss')
            .format((data['date'] as Timestamp).toDate()), // Format date
        'time': formattedTime, // Format duration to [HH:MM:SS]
      };

      print("[Fire-Activity][fetchLongestDuration] --------> : $result");
      return result; // Return formatted result
    } catch (e) {
      print("[Fire-Activity][fetchLongestDuration]----Error---> : $e");
      return null;
    }
  }
}
