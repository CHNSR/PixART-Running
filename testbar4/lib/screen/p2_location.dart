import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testbar4/database/Fire_Location.dart';
import 'package:testbar4/screen/layer2/location/component/card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class P2Location extends StatelessWidget {
  P2Location({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFEEA),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: Location.fetchLocations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: LoadingAnimationWidget.discreteCircle(
                    color: Colors.green, size: 50));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No locations found'));
          }

          final documents = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final doc = documents[index];
              final data = doc.data() as Map<String, dynamic>;
              final documentID = doc.id;

              return CardLocation(
                documentId: documentID, // Pass the document ID to CardLocation
              );
            },
          );
        },
      ),
    );
  }
}
