import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testbar4/manage/manage_icon/icon_path.dart';
import 'package:testbar4/screen/layer2/location/component/map.dart';
import 'package:testbar4/screen/layer2/location/navigation.dart';

class CardLocation extends StatelessWidget {
  final String documentId;
  final IconPath iconpath = IconPath();

  CardLocation({super.key, required this.documentId});

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
      final distanceInMeters = data['distance'] ?? 0.0;
      final distanceInKilometers = (distanceInMeters / 1000).toStringAsFixed(2);
      final route = data['route'] as List<dynamic>?;
      final status = data["private"] == true ? "private" : "public";

// Rest of your code...

        // Cast to List<dynamic>

        if (route != null) {
          // Convert List<dynamic> to List<Map<String, dynamic>>
          final List<Map<String, dynamic>> routeList = route.map((item) {
            return item as Map<String, dynamic>;
          }).toList();

          print("[P2][Card] Check route before send to ShowMap(): $routeList");

          return Container(
            
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(width: 2.0,color: Colors.black),
              color: Colors.white,


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
                  SizedBox(
                    height: 200, // Define a fixed height
                    child: ShowMap2(
                      route: routeList, // Pass the converted list
                    ), // Assume this widget will render map based on fetched data
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            ListTile(
                                title: Text(name),
                                subtitle: Column(
                                  children: [
                                    const Divider(
                                      height: 2,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Distance: $distanceInKilometers km')),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Status: $status "))
                                  ],
                                )),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Navigation(
                                route: routeList,
                              ),
                            ),
                          );
                        },
                        icon: Image.asset(
                          width: 30,
                          height: 30,
                          iconpath.appBarIcon("navigation_outline"),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: Text('No route data found'));
        }
      },
    );
  }
}
