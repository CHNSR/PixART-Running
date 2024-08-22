import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:testbar4/database/Fire_Activity.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:testbar4/database/Fire_Location.dart';
import 'package:testbar4/manage/manage_icon/icon_path.dart';

class ActivityMap extends StatefulWidget {
  const ActivityMap({super.key, required this.activities});
  final List<Map<String, dynamic>> activities;

  @override
  State<ActivityMap> createState() => _ActivityMapState();
}

class _ActivityMapState extends State<ActivityMap> {
  late GoogleMapController _mapController;
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    //_createPolylines();
  }

  void _createPolylines() {
    if (_mapController != null) {
      _polylines.clear(); // Clear existing polylines

      for (var activity in widget.activities) {
        final route = activity['route'] as List<dynamic>;
        final date = activity['date'];
        final polylineId = date.toString();
        print("[p1]check data --->: $route");

        _polylines.add(Polyline(
          polylineId: PolylineId(polylineId),
          visible: true,
          points:
              route.map((e) => LatLng(e['latitude'], e['longitude'])).toList(),
          width: 5,
          color: Colors.red,
        ));
      }

      print(
          "[p1]check polylines: $_polylines"); // Check if polylines are correctly created

      if (widget.activities.isNotEmpty) {
        final firstActivity = widget.activities.first;
        final firstPoint = LatLng(
            (firstActivity['route'] as List<dynamic>).first['latitude'],
            (firstActivity['route'] as List<dynamic>).first['longitude']);
        _mapController
            .animateCamera(CameraUpdate.newLatLngZoom(firstPoint, 14));
        print(
            "P1-------------load route data successful $firstPoint--------------");
      }

      setState(() {}); // Ensure the map updates with the new polylines
    } else {
      print("[p1]Error: _mapController is not initialized.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (controller) {
        _mapController = controller;
        _createPolylines();
      },
      initialCameraPosition: CameraPosition(
        target: widget.activities.isNotEmpty
            ? LatLng(
                (widget.activities.first['route'] as List<dynamic>)
                    .first['latitude'],
                (widget.activities.first['route'] as List<dynamic>)
                    .first['longitude'])
            : const LatLng(16.74847032254596,
                100.19174765472641), // Default position if no activities
        zoom: 12,
      ),
      polylines: _polylines,
    );
  }
}

//class card to show data form activities
//can select number of card ex. show card 3 or show all card
class CardAc extends StatefulWidget {
  const CardAc({super.key, required this.numOfCard});

  final int numOfCard;

  @override
  State<CardAc> createState() => _CardAcState();
}

class _CardAcState extends State<CardAc> {
  IconPath iconPath = IconPath();
  Future<List<Map<String, dynamic>>>? _activitiesFuture;

  String convertMetresToKilometres(double metres) {
    return (metres / 1000).toStringAsFixed(3);
  }

  String convertKmPerHourToPace(double kmPerHour) {
    return (60 / kmPerHour).toStringAsFixed(3);
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final secs = (duration.inSeconds % 60).toString().padLeft(2, '0');

    return '$hours:$minutes:$secs';
  }

  @override
  void initState() {
    super.initState();
    _activitiesFuture = Activity.fetchActivity(numOfFetch: widget.numOfCard)
        as Future<List<Map<String, dynamic>>>?;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _activitiesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.twistingDots(
              leftDotColor: Color.fromARGB(255, 255, 144, 16),
              rightDotColor: Color.fromARGB(255, 128, 128, 128),
              size: 100,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No activity data available.'));
        } else {
          final activities = snapshot.data!;
          print('[P1][ActivityCP]-----$activities');

          return Column(
            children: activities.map((activity) {
              final route = activity['route'] as List<dynamic>;
              final distanceInMetres = activity['distance'] as double;
              final distanceInKilometres =
                  convertMetresToKilometres(distanceInMetres);

              final pace = (activity['AVGpace'] as double).toStringAsFixed(2);
              final timeInSeconds = activity['time'] as int;
              final time = _formatDuration(timeInSeconds);

              final date =
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(activity['date']);

              return Card(
                color: Color.fromARGB(255, 255, 247, 134),
                margin: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: const BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      child: ActivityMap(
                          activities: [activity]), // Pass single activity data
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date : $date",
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text(
                            "Distance: ${distanceInKilometres} km",
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text(
                            "Time: ${time} min",
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text(
                            "Average Pace: ${pace} min/km",
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Add route to private location -->',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 174, 0, 255),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Location.addRoute(
                                      routeData: route,
                                      distance: distanceInMetres,
                                      name: "",
                                      status: true);
                                },
                                icon: Image.asset(
                                  iconPath.appBarIcon("add_outline"),
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}

class AddLocationButton extends StatelessWidget {
  final String type;

  AddLocationButton({super.key, required this.type});
  IconPath iconPath = IconPath();

  @override
  Widget build(BuildContext context) {
    if (type == "private") {
      const imageName = "addLocationPR_outline";
      return IconButton(
          onPressed: () {},
          icon: Image.asset(
            iconPath.appBarIcon(imageName),
            width: 20,
            height: 20,
          ));
    } else {
      const imageName = "addLocationPL_outline";
      return IconButton(
          onPressed: () {},
          icon: Image.asset(
            iconPath.appBarIcon(imageName),
            width: 20,
            height: 20,
          ));
    }
  }
}
