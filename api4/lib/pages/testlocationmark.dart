import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreenMarker extends StatefulWidget {
  const MapScreenMarker({super.key});

  @override
  State<MapScreenMarker> createState() => _MapScreenMarkerState();
}

class _MapScreenMarkerState extends State<MapScreenMarker> {
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    addCustomIcon();
    super.initState();
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "img/pin-red.png")
        .then((icon) {
      setState(() {
        markerIcon = icon;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
          zoomControlsEnabled: false,
          myLocationEnabled: true,
          initialCameraPosition: const CameraPosition(
            target: LatLng(37.422131, -122.084801),
            zoom: 15.6746,
          ),
          markers: {
            Marker(
              markerId: MarkerId("demo"),
              position: LatLng(37.422131, -122.084801),
              draggable: true,
              icon: markerIcon,
            ),
          }),
    );
  }
}
