import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testbar4/screen/layer2/location/component/map.dart';

class CardLocation extends StatelessWidget {
  final String documentId;

  const CardLocation({super.key, required this.documentId});

  Future<Map<String, dynamic>?> _fetchLocationData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('Location')
          .doc(documentId)
          .get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print('Failed to fetch location data: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _fetchLocationData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data found'));
        }

        final data = snapshot.data!;
        final name = data['name'] ?? 'Unknown';
        final distance = data['distance']?.toString() ?? 'Unknown';

        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8.0),
                const SizedBox(
                  height: 200, // Define a fixed height
                  child:
                      ShowMap(), // Assume this widget will render map based on fetched data
                ),
                const SizedBox(height: 8.0),
                ListTile(
                  title: Text(name),
                  subtitle: Text('Distance: $distance km'),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
