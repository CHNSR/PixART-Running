import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:testbar4/database/Fire_Activity.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
    for (var activity in widget.activities) {
      final route = activity['route'] as List<dynamic>;
      final date = activity['date'];
      final polylineId = date.toString();

      _polylines.add(Polyline(
        polylineId: PolylineId(polylineId),
        visible: true,
        points:
            route.map((e) => LatLng(e['latitude'], e['longitude'])).toList(),
        width: 5,
        color: Colors.blue,
      ));
    }

    if (widget.activities.isNotEmpty) {
      final firstActivity = widget.activities.first;
      final firstPoint = LatLng(
          (firstActivity['route'] as List<dynamic>).first['latitude'],
          (firstActivity['route'] as List<dynamic>).first['longitude']);
      _mapController.animateCamera(CameraUpdate.newLatLngZoom(firstPoint, 14));
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
                100.19174765472641), // Default position(naresuan university) if no activities
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
  Future<List<Map<String, dynamic>>>? _activitiesFuture;

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
              //loadinganimation
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

          return Column(
            children: activities.map((activity) {
              final route = activity['route'] as List<dynamic>;

              return Card(
                margin: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: const BorderSide(
                      color: Colors.grey,
                      width: 1,
                    )),
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
                            "Date : ${activity['date'] ?? 'N/A'}",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            "Distance: ${activity['distance'] ?? 'N/A'} km",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            "Average Pace: ${activity['AVGpace'] ?? 'N/A'} min/km",
                            style: TextStyle(fontSize: 18),
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
