import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowMap2 extends StatelessWidget {
  final List<Map<String, dynamic>>
      route; // Ensure route is List<Map<String, dynamic>>
  ShowMap2({super.key, required this.route});

  final Completer<GoogleMapController> _controller = Completer();
  @override
  Widget build(BuildContext context) {
    // Convert the route list into a list of LatLng objects
    final List<LatLng> latLngRoute = route.map((location) {
      final lat = location['latitude'] as double;
      final lng = location['longitude'] as double;
      return LatLng(lat, lng);
    }).toList();

    // Create markers for start and end points
    final Set<Marker> markers = {
      if (latLngRoute.isNotEmpty)
        Marker(
          markerId: MarkerId('start'),
          position: latLngRoute.first,
          infoWindow: InfoWindow(title: 'Start'),
        ),
      if (latLngRoute.isNotEmpty)
        Marker(
          markerId: MarkerId('end'),
          position: latLngRoute.last,
          infoWindow: InfoWindow(title: 'End'),
        ),
    };

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: latLngRoute.isNotEmpty
            ? latLngRoute.first
            : LatLng(16.743225, 100.195124),
        zoom: 14,
      ),
      polylines: {
        Polyline(
          polylineId: PolylineId('route'),
          points: latLngRoute,
          color: Colors.red,
          width: 5,
        ),
      },
      markers: markers,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}
