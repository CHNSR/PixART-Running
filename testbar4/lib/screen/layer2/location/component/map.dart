import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowMap extends StatefulWidget {
  const ShowMap({super.key});

  @override
  State<ShowMap> createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMap> {
  final Completer<GoogleMapController> _controller = Completer();
  List<LatLng> _route = [];

  @override
  void initState() {
    super.initState();
    _fetchRoute();
  }

  Future<void> _fetchRoute() async {
    try {
      // Assuming you have the document ID of the route you want to display
      // Replace 'YOUR_DOCUMENT_ID' with the actual document ID or retrieve it dynamically
      final documentId = 'YOUR_DOCUMENT_ID';

      final docSnapshot = await FirebaseFirestore.instance
          .collection('Location')
          .doc(documentId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        final routeData = data?['route'] as List<dynamic>?;

        if (routeData != null) {
          setState(() {
            _route = routeData.map((point) {
              final lat = point['lat'] as double;
              final lng = point['lng'] as double;
              return LatLng(lat, lng);
            }).toList();
          });
        }
      }
    } catch (e) {
      print('Failed to fetch route: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _route.isNotEmpty ? _route.first : LatLng(0, 0),
        zoom: 10,
      ),
      polylines: {
        Polyline(
          polylineId: PolylineId('route'),
          points: _route,
          color: Colors.blue,
          width: 5,
        ),
      },
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}
