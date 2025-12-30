import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:testbar4/services/Fire_Location.dart';
import 'package:testbar4/screens/layer2/location/component/card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class P2Location extends StatelessWidget {
  P2Location({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfffffe),
      body: Stack(children: [
        FutureBuilder<List<QueryDocumentSnapshot>>(
          future: Locations.fetchLocations(),
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
                //final data = doc.data() as Map<String, dynamic>;
                final documentID = doc.id;

                return Column(
                  children: [
                    CardLocation(
                      documentId:
                          documentID, // Pass the document ID to CardLocation
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                );
              },
            );
          },
        ),
        //add location
        Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/p15');
              },
              child: const Icon(Icons.settings),
              backgroundColor: Color(0xFFeaddcf),
            ))
      ]),
    );
  }
}
