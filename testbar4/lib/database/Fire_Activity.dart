import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Firestore & Auth
final firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
final user = auth.currentUser;

class Activity {
  //to store route list
  late List<dynamic> routedataformfire;

  //to store activity data
  late Map<String, dynamic> runingdata;

  // Add activity data
  static Future<String?> addActivity({
    required String distance,
    required DateTime date,
    required double avgPace,
    required List<Map<String, dynamic>> routeData,
  }) async {
    if (user == null) {
      return "Error: No user logged in.";
    }

    final runnerID = user!.uid;

    try {
      await firestore.collection("Activity").add({
        "runnerID": runnerID,
        "distance": distance,
        "date": Timestamp.fromDate(date),
        "AVGpace": avgPace,
        "route": routeData,
      });
      return null; // No error
    } catch (e) {
      return "Error to add activity [code error]: $e";
    }
  }

  // Fetch activity data
  // Fetch activity data
  static Future<List<Map<String, dynamic>>> fetchActivity(
      {required numOfFetch}) async {
    final runnerID = user?.uid;

    try {
      final snapshot = await firestore
          .collection("Activity")
          .where('runnerID', isEqualTo: runnerID)
          .orderBy('date', descending: true)
          .limit(numOfFetch)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        //convert timestamp in firecloud to datetime
        if (data['date'] is Timestamp) {
          data['date'] = (data['date'] as Timestamp).toDate();
        }

        return data;
      }).toList();
    } catch (e) {
      throw Exception("Error fetching activity: $e");
    }
  }

  /*
  // Get route from Firestore
  static Future<List<dynamic>?> getRoute({required int numOfRoute}) async {
    try {
      final snapshot = await fetchActivity(numOfFetch: numOfRoute);
      if (snapshot.docs.isNotEmpty) {
        final routeData = snapshot.docs.first.data()['route'];
        print("routeData : $routeData");
        return routeData as List<dynamic>?;
      }
      return null;
    } catch (e) {
      print("Error getting route: $e");
      return null;
    }
  }

  // Get all activity data except for route
  static Future<Map<String, dynamic>?> getData({required int numofdata}) async {
    try {
      final snapshot = await fetchActivity(numOfFetch: numofdata);
      if (snapshot.docs.isNotEmpty) {
        //final data = snapshot.docs.first.data();
        //data.remove('route'); // Remove route data
        //return data;
      }
      return null;
    } catch (e) {
      print("Error getting activity data: $e");
      return null;
    }
  }
  */
}
