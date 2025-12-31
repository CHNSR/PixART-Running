import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:testbar4/services/firebase_service/Fire_Location.dart';
import 'package:testbar4/model/provider_userData.dart';
import 'package:testbar4/screen/layer2/location/component/card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
class P2Location extends StatelessWidget {
  P2Location({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataPV>(builder: (context, userDataProvider, child) {
      final userData = userDataProvider.userData;
      final userId = userData?['id'] ?? 'none user id';
      return  Scaffold(
          backgroundColor: const Color(0xFFfffffe),
          body: Stack(
            children: [
              ListView(
                children: [
                  // Container for Public Route
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder<List<QueryDocumentSnapshot>>(
                      future: Locations.fetchPublicLocations(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: LoadingAnimationWidget.discreteCircle(
                              color: Colors.green, 
                              size: 50,
                            ),
                          );
                        }
                    
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                    
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No public locations found'));
                        }
                    
                        final publicDocuments = snapshot.data!;
                    
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(width: 3.0, color: Colors.black),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  "Public Route",
                                  style: GoogleFonts.pixelifySans(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF0f0e17),
                                  ),
                                ),
                                subtitle: const Divider(
                                  height: 4,
                                  color: Colors.black,
                                ),
                              ),
                              
                              // Build List of Public Location Cards
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: publicDocuments.length,
                                itemBuilder: (context, index) {
                                  final doc = publicDocuments[index];
                                  final data = doc.data() as Map<String, dynamic>;
                    
                                  return Column(
                                    children: [
                                      CardLocation(
                                        data: data, // Pass the document data
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Container for Private Route
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder<List<QueryDocumentSnapshot>>(
                      future: Locations.fetchPrivateLocations(userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: LoadingAnimationWidget.discreteCircle(
                              color: Colors.green, 
                              size: 50,
                            ),
                          );
                        }
                    
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                    
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No private locations found'));
                        }
                    
                        final privateDocuments = snapshot.data!;
                    
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(width: 3.0, color: Colors.black),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  "Private Route",
                                  style: GoogleFonts.pixelifySans(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF0f0e17),
                                  ),
                                ),
                                subtitle: const Divider(
                                  height: 4,
                                  color: Colors.black,
                                ),
                              ),
                              // Build List of Private Location Cards
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: privateDocuments.length,
                                itemBuilder: (context, index) {
                                  final doc = privateDocuments[index];
                                  final data = doc.data() as Map<String, dynamic>;
                    
                                  return Column(
                                    children: [
                                      CardLocation(
                                        data: data, // Pass the document data
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              // Floating action button for settings
              Positioned(
                bottom: 16.0,
                right: 16.0,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/p15');
                  },
                  child: const Icon(Icons.settings),
                  backgroundColor: const Color(0xFFeaddcf),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
