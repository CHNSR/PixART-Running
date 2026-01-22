import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

final firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;

class Visit {
  final CollectionReference visitCollection = firestore.collection('Visits');

  // Method to add a visit by location ID and runner ID
  Future<void> addVisit(BuildContext context, String locationId) async {
    try {
      String runnerId = auth.currentUser!.uid;
      String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      await visitCollection.add({
        'locationId': locationId,
        'runnerId': runnerId,
        'date': formattedDate,
      });
      print('Visit added successfully');

      // Show success SnackBar
      _showSnackBar(context, 'Visit added successfully', Colors.green);
    } catch (e) {
      print('Failed to add visit: $e');
      // Show error SnackBar
      _showSnackBar(context, 'Failed to add visit: $e', Colors.red);
    }
  }

  // Method to delete a visit by runner ID
  Future<void> deleteVisitByRunnerId(BuildContext context, String runnerId) async {
    try {
      QuerySnapshot snapshot = await visitCollection.where('runnerId', isEqualTo: runnerId).get();

      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
      print('Visits deleted successfully');

      // Show success SnackBar
      _showSnackBar(context, 'Visits deleted successfully', Colors.green);
    } catch (e) {
      print('Failed to delete visits: $e');
      // Show error SnackBar
      _showSnackBar(context, 'Failed to delete visits: $e', Colors.red);
    }
  }

  // Fetch the number of visits for a specific location ID
  Future<int> fetchVisitCount(String locationId) async {
    try {
      QuerySnapshot snapshot = await visitCollection.where('locationId', isEqualTo: locationId).get();
      return snapshot.size;
    } catch (e) {
      print('Failed to fetch visit count: $e');
      return 0;
    }
  }

  // Helper method to show SnackBar
  void _showSnackBar(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: const Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
