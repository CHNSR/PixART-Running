import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:testbar4/database/Fire_Activity.dart';

class Navigation extends StatefulWidget {
  final List<Map<String, dynamic>> route;

  Navigation({super.key, required this.route});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final Completer<GoogleMapController> _controller = Completer();
  Position? _currentPosition;
  final List<LatLng> _trackingRoute = [];
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  bool _isNavigation = false;
  double _distance = 0, _speed = 0, _avgSpeed = 0;
  int _speedCounter = 0;
  LatLng? _lastPosition;
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
  }

  void _startTracking() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      setState(() {
        _currentPosition = position;
        final currentLatLng = LatLng(position.latitude, position.longitude);
        _trackingRoute.add(currentLatLng);
        _updatePolyline();
        _updateCurrentLocationMarker(currentLatLng);
        _isNavigation = true;

        // คำนวณระยะทางและความเร็ว
        if (_lastPosition != null) {
          final distance = Geolocator.distanceBetween(
            _lastPosition!.latitude,
            _lastPosition!.longitude,
            currentLatLng.latitude,
            currentLatLng.longitude,
          );
          _distance += distance;

          final timeElapsed =
              _stopWatchTimer.rawTime.value / 1000.0; // เวลาเป็นวินาที
          _speed = distance / timeElapsed; // ความเร็ว = ระยะทาง / เวลา

          _avgSpeed = ((_avgSpeed * _speedCounter) + _speed) /
              (_speedCounter + 1); // ความเร็วเฉลี่ย
          _speedCounter++;
        }

        _lastPosition = currentLatLng;
      });
    });

    _stopWatchTimer.onStartTimer();
  }

  void _stopTracking() {
    _positionStreamSubscription?.cancel();
    _stopWatchTimer.onStopTimer();
    setState(() {
      _isNavigation = false;
    });
  }

  void _updatePolyline() {
    setState(() {
      _polylines.add(Polyline(
        polylineId: const PolylineId('tracking_route'),
        points: _trackingRoute,
        color: Colors.green,
        width: 5,
      ));
    });
  }

  void _updateCurrentLocationMarker(LatLng currentLatLng) {
    setState(() {
      _markers.removeWhere(
          (marker) => marker.markerId == const MarkerId('current_location'));
      _markers.add(Marker(
        markerId: const MarkerId('current_location'),
        position: currentLatLng,
        infoWindow: const InfoWindow(title: 'You are here'),
      ));
    });
  }

  @override
  void dispose() {
    _stopTracking(); // หยุดการติดตามตำแหน่งเมื่อ widget ถูกลบ
    _stopWatchTimer.dispose();
    super.dispose();
  }

  //save Activity and +1 to location at field visit
  void _saveRunData() async {
    //convert route list to geo list
    List<Map<String, dynamic>> routeData = _trackingRoute.map((loc) {
      return {
        'latitude': loc.latitude,
        'longitude': loc.longitude,
      };
    }).toList();

    // Get time in milliseconds from StopWatchTimer
    final durationInMilliseconds = _stopWatchTimer.rawTime.value;

    //store data in firebase
    Activity.addActivity(
      distance: _distance,
      finishdate: DateTime.now(),
      avgPace: _speedCounter == 0 ? 0 : _avgSpeed / _speedCounter,
      routeData: routeData,
      time: durationInMilliseconds,
    );

    print("[P3] Check call func _savedata to fire ");
  }

  @override
  Widget build(BuildContext context) {
    final List<LatLng> latLngRoute = widget.route.map((location) {
      final lat = location['latitude'] as double;
      final lng = location['longitude'] as double;
      return LatLng(lat, lng);
    }).toList();

    final startLatLng = latLngRoute.isNotEmpty
        ? latLngRoute.first
        : const LatLng(16.743225, 100.195124);

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "เส้นทางนำทาง",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
          ),
          backgroundColor: Colors.deepOrange[400],
        ),
        body: Stack(children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: startLatLng,
              zoom: 14,
            ),
            polylines: _polylines.union({
              Polyline(
                polylineId: const PolylineId('route'),
                points: latLngRoute,
                color: Colors.red,
                width: 5,
              ),
            }),
            markers: _markers.union({
              Marker(
                markerId: const MarkerId('start'),
                position: startLatLng,
                infoWindow: const InfoWindow(title: 'เริ่มต้น'),
              ),
              if (latLngRoute.isNotEmpty)
                Marker(
                  markerId: const MarkerId('end'),
                  position: latLngRoute.last,
                  infoWindow: const InfoWindow(title: 'สิ้นสุด'),
                ),
            }),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (_isNavigation) {
                      _stopTracking();
                      Future.delayed(const Duration(seconds: 5), () {
                        Navigator.pushNamed(context, "/main");
                      });
                    } else {
                      _startTracking();
                    }
                  },
                  icon: Icon(
                    _isNavigation ? Icons.stop : Icons.play_arrow,
                    size: 50,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<int>(
                      stream: _stopWatchTimer.rawTime,
                      initialData: 0,
                      builder: (context, snapshot) {
                        final value = snapshot.data!;
                        final displayTime =
                            StopWatchTimer.getDisplayTime(value);
                        return Text('เวลาที่ผ่านไป: $displayTime');
                      },
                    ),
                    Text('ระยะทาง: ${_distance.toStringAsFixed(2)} เมตร'),
                    Text('ความเร็ว: ${_speed.toStringAsFixed(2)} เมตร/วินาที'),
                  ],
                ),
              ],
            ),
          ),
        ]));
  }
}
