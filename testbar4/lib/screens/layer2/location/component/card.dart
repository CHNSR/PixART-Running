import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testbar4/routes/export.dart';

class CardLocation extends StatelessWidget {
  final Map<String, dynamic> data;
  final String documentId;
  final IconPath iconpath = IconPath();

  CardLocation({super.key, required this.data, required this.documentId});

  @override
  Widget build(BuildContext context) {
    // Retrieve data
    final name = data['name'] ?? 'Unknown';
    final distanceInMeters = data['distance'] ?? 0.0;
    final distanceInKilometers = (distanceInMeters / 1000).toStringAsFixed(2);
    final route = data['route'] as List<dynamic>?;
    final status = data['private'] == true ? 'Private' : 'Public';
    final visit = data['visit'] ?? 0;

    // Cast route data if available
    if (route != null) {
      final List<Map<String, dynamic>> routeList = route.map((item) {
        return item as Map<String, dynamic>;
      }).toList();

      print("[P2][Card] Route data before passing to ShowMap(): $routeList");

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(width: 1.0, color: Colors.black),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                height: 200, // Define a fixed height
                child: ShowMap2(
                  route: routeList, // Pass the converted list to ShowMap2
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Distance: $distanceInKilometers km'),
                        Text('Status: $status'),
                        Text('Visit: ${visit} times'),
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
                      iconpath.appBarIcon('navigation_outline'),
                    ),
                  ),
                  const SizedBox(width: 10),
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
  }
}

//card for edit it can delete change name
class CardForEdit extends StatelessWidget {
  final String docId;
  final String runnerId;
  final IconPath iconpath = IconPath();
  final Map<String, dynamic> data;

  CardForEdit(
      {super.key,
      required this.data,
      required this.runnerId,
      required this.docId});

  @override
  Widget build(BuildContext context) {
    // ใช้ข้อมูลที่ส่งมาแทนการดึงข้อมูลใหม่
    final name = data['name'] ?? 'Unknown';
    final distanceInMeters = data['distance'] ?? 0.0;
    final distanceInKilometers = (distanceInMeters / 1000).toStringAsFixed(2);
    final route = data['route'] as List<dynamic>?;
    final status = data["private"] == true ? "private" : "public";
    final visit = data['visit'] ?? 0;
    final userDataPV = Provider.of<UserDataPV>(context, listen: false);

    if (route != null) {
      final List<Map<String, dynamic>> routeList = route.map((item) {
        return item as Map<String, dynamic>;
      }).toList();

      print("[P2][Card] Check route before send to ShowMap(): $routeList");

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(width: 2.0, color: Colors.black),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8.0),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0),
                  border: Border.all(width: 1.0, color: Colors.black),
                ),
                child: ShowMap2(
                  route: routeList, // Pass the converted list
                ),
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
                              const SizedBox(height: 3),
                              Align(
                                alignment: Alignment.centerLeft,
                                child:
                                    Text('Distance: $distanceInKilometers km'),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Status: $status "),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Visit: ${visit} times"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // If status is private, show the delete button
                  if (status == "private" ||
                      (status == "public" && userDataPV.isAdmin))
                    IconButton(
                      onPressed: () {
                        // delete location
                        Locations.deleteRoute(context, docId);

                        // delete visite
                        Visit().deleteVisitByRunnerId(context, runnerId);
                      },
                      icon: Image.asset(
                        width: 30,
                        height: 30,
                        iconpath.appBarIcon("delete_outline"),
                      ),
                    ),
                  const SizedBox(width: 10),
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
  }
}
