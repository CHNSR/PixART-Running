import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:testbar4/manage/manage_icon/icon_path.dart';


class ShowMap2 extends StatefulWidget {
  final List<Map<String, dynamic>> route;

  const ShowMap2({super.key, required this.route});

  @override
  State<ShowMap2> createState() => _ShowMap2State();
}

class _ShowMap2State extends State<ShowMap2> {
  final Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor? startMarkerIcon;
  BitmapDescriptor? endMarkerIcon;
  IconPath iconPath = IconPath();

  @override
  void initState() {
    super.initState();
    _loadCustomMarkers();
  }

  Future<void> _loadCustomMarkers() async {
     final BitmapDescriptor startIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(30, 30)),
      iconPath.appBarIcon('pin_black'),
    );

    final BitmapDescriptor endIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(30, 30)),
      iconPath.appBarIcon('pin_black'),
    );
    

    setState(() {
      startMarkerIcon = startIcon;
      endMarkerIcon = endIcon;
    });
  }

  // Calculate LatLngBounds based on the route
  LatLngBounds _calculateBounds(List<LatLng> latLngRoute) {
    double minLat = latLngRoute.first.latitude;
    double maxLat = latLngRoute.first.latitude;
    double minLng = latLngRoute.first.longitude;
    double maxLng = latLngRoute.first.longitude;

    for (LatLng point in latLngRoute) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<LatLng> latLngRoute = widget.route.map((location) {
      final lat = location['latitude'] as double;
      final lng = location['longitude'] as double;
      return LatLng(lat, lng);
    }).toList();

    final Set<Marker> markers = {
      if (latLngRoute.isNotEmpty && startMarkerIcon != null)
        Marker(
          markerId: const MarkerId('start'),
          position: latLngRoute.first,
          icon: startMarkerIcon!,
          infoWindow: const InfoWindow(title: 'Start'),
        ),
      if (latLngRoute.isNotEmpty && endMarkerIcon != null)
        Marker(
          markerId: const MarkerId('end'),
          position: latLngRoute.last,
          icon: endMarkerIcon!,
          infoWindow: const InfoWindow(title: 'End'),
        ),
    };

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: latLngRoute.isNotEmpty
            ? latLngRoute.first
            : const LatLng(16.743225, 100.195124),
        zoom: 14,
      ),
      polylines: {
        Polyline(
          polylineId: const PolylineId('route'),
          points: latLngRoute,
          color: Colors.red,
          width: 5,
        ),
      },
      markers: markers,
      onMapCreated: (GoogleMapController controller) async {
        _controller.complete(controller);
        if (latLngRoute.isNotEmpty) {
          final bounds = _calculateBounds(latLngRoute);
          await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50)); // Padding added for better view
        }
      },
    );
  }
}
