import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:testbar4/database/Fire_Activity.dart';
import 'package:testbar4/manage/manage_icon/icon_path.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

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
  bool _canStartRun = false;
  bool _isRunning = false;
  double _distance = 0, _speed = 0, _avgSpeed = 0;
  int _speedCounter = 0;
  LatLng? _lastPosition;
  StreamSubscription<Position>? _positionStreamSubscription;
  IconPath iconPath = IconPath();
  BitmapDescriptor? _startMarkerIcon;

  @override
  void initState() {
    super.initState();
    _checkProximityToStart();
    _loadCustomMarker();
  }
  // Load custom marker image
  void _loadCustomMarker() async {
  _startMarkerIcon = await getCustomMarkerIcon(iconPath.appBarIcon("pin_red"), 50); // 50px size
  setState(() {});
}


  Future<BitmapDescriptor> getCustomMarkerIcon(String imagePath, int targetWidth) async {
  final ByteData data = await rootBundle.load(imagePath);
  final Uint8List markerImageBytes = data.buffer.asUint8List();
  
  // Resize the image
  final List<int>? resizedImage = await FlutterImageCompress.compressWithList(
    markerImageBytes,
    minWidth: targetWidth,
    minHeight: targetWidth,
    quality: 100,
  );

  return BitmapDescriptor.fromBytes(Uint8List.fromList(resizedImage!));
}

  // Check if the user is close to the start point
  void _checkProximityToStart() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      setState(() {
        _currentPosition = position;
        final startLatLng = LatLng(widget.route.first['latitude'], widget.route.first['longitude']);
        final distanceToStart = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          startLatLng.latitude,
          startLatLng.longitude,
        );

        // Set a threshold to determine proximity to the start point (e.g., 10 meters)
        if (distanceToStart <= 10) {
          _canStartRun = true;
        } else {
          _canStartRun = false;
        }
      });
    });
  }

  void _startTracking() {
    if (_canStartRun) {
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

          // Calculate distance and speed
          if (_lastPosition != null) {
            final distance = Geolocator.distanceBetween(
              _lastPosition!.latitude,
              _lastPosition!.longitude,
              currentLatLng.latitude,
              currentLatLng.longitude,
            );
            _distance += distance;

            final timeElapsed =
                _stopWatchTimer.rawTime.value / 1000.0; // Time in seconds
            _speed = distance / timeElapsed; // Speed = Distance / Time

            _avgSpeed = ((_avgSpeed * _speedCounter) + _speed) /
                (_speedCounter + 1); // Average speed
            _speedCounter++;
          }

          _lastPosition = currentLatLng;

          // Check if user reached the endpoint
          _checkIfReachedEndpoint(currentLatLng);
        });
      });

      _stopWatchTimer.onStartTimer();
    } else {
      // Show message that user must be close to start point
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You must be at the start point to begin!")),
      );
    }
  }

  void _stopTracking() {
    _positionStreamSubscription?.cancel();
    _stopWatchTimer.onStopTimer();
    setState(() {
      _isNavigation = false;
    });
  }

  // Check if user has reached the endpoint
  void _checkIfReachedEndpoint(LatLng currentLatLng) {
    final endLatLng = LatLng(widget.route.last['latitude'], widget.route.last['longitude']);
    final distanceToEnd = Geolocator.distanceBetween(
      currentLatLng.latitude,
      currentLatLng.longitude,
      endLatLng.latitude,
      endLatLng.longitude,
    );

    // If the user is within 10 meters of the endpoint, stop tracking and save data
    if (distanceToEnd <= 10) {
      _stopTracking();
      _saveRunData();
    }
  }

  void _updatePolyline() {
    setState(() {
      _polylines.add(Polyline(
        polylineId: const PolylineId('tracking_route'),
        points: _trackingRoute,
        color: Colors.yellow,
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

  void _saveRunData() async {
    // Convert route list to geo list
    List<Map<String, dynamic>> routeData = _trackingRoute.map((loc) {
      return {
        'latitude': loc.latitude,
        'longitude': loc.longitude,
      };
    }).toList();

    // Get time in milliseconds from StopWatchTimer
    final durationInMilliseconds = _stopWatchTimer.rawTime.value;

    // Store data in Firebase
    Activity.addActivity(
      distance: _distance,
      finishdate: DateTime.now(),
      avgPace: _speedCounter == 0 ? 0 : _avgSpeed / _speedCounter,
      routeData: routeData,
      time: durationInMilliseconds,
    );

    print("[P3] Check call func _saveRunData to Firestore ");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Run data saved successfully!")),
    );
  }

  @override
  void dispose() {
    _stopTracking();
    _stopWatchTimer.dispose();
    super.dispose();
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
          "Navigation Route",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500,color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: startLatLng,
              zoom: 14,
            ),
            polylines: _polylines.union({
              Polyline(
                polylineId: const PolylineId('route'),
                points: latLngRoute,
                color: Colors.black,
                width: 5,
              ),
            }),
            markers: _markers.union({
              Marker(
                markerId: const MarkerId('start'),
                position: startLatLng,
                infoWindow: const InfoWindow(title: 'Start'),
                icon: _startMarkerIcon ?? BitmapDescriptor.defaultMarker,
              ),
              if (latLngRoute.isNotEmpty)
                Marker(
                  markerId: const MarkerId('end'),
                  position: latLngRoute.last,
                  infoWindow: const InfoWindow(title: 'End'),
                  icon: _startMarkerIcon ?? BitmapDescriptor.defaultMarker,
                ),
                
            }),
            // Add circles for start and end points
            circles: {
              Circle(
              circleId: const CircleId('startCircle'),
              center: startLatLng,
              radius: 50, // radius in meters
              strokeColor: Colors.black,
              strokeWidth: 3,
              fillColor: Colors.blue.withOpacity(0.2),
            ),
            if (latLngRoute.isNotEmpty)
              Circle(
                circleId: const CircleId('endCircle'),
                center: latLngRoute.last,
                radius: 50, // radius in meters
                strokeColor: Colors.black,
                strokeWidth: 3,
                fillColor: Colors.yellow.withOpacity(0.2),
              ),
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          /*
          Positioned(
            bottom: 30,
            left: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,  // Aligns children to the left
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
                    icon: Image.asset(iconPath.appBarIcon('play-button_outline'), width: 45, height: 45,),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    _stopTracking();
                    _saveRunData();
                    Navigator.pop(context);
                  },
                    icon:  Image.asset(iconPath.appBarIcon('the-end_outline'), width: 45, height: 45,),
                ),
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<int>(
                      stream: _stopWatchTimer.rawTime,
                      initialData: 0,
                      builder: (context, snapshot) {
                        final value = snapshot.data!;
                        final displayTime = StopWatchTimer.getDisplayTime(value);
                        return Text('Time: $displayTime',style: TextStyle(fontSize: 15),);
                      },
                    ),
                    Text('Distance: ${_distance.toStringAsFixed(2)} m',style: TextStyle(fontSize: 15),),
                    Text('Speed: ${_speed.toStringAsFixed(2)} m/s',style: TextStyle(fontSize: 15),),
                  ],
                ),
              ],
            ),
          ),
          */
          Positioned(
          bottom: 30,
          left: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_isRunning)
                IconButton(
                  onPressed: () {
                    if (_canStartRun) {
                      setState(() {
                        _isRunning = true;
                      });
                      _startTracking();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(content: Text("You must be at the start point to begin!"),
                        backgroundColor: Colors.redAccent[400],
                        ),
                      );
                    }
                  },
                  icon: Image.asset(
                    iconPath.appBarIcon('play-button_outline'), 
                    width: 45, 
                    height: 45,
                  ),
                )
              else
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        _stopTracking();
                        setState(() {
                          _isRunning = false;
                        });
                      },
                      icon: Image.asset(
                        iconPath.appBarIcon('pause_outline'), 
                        width: 45, 
                        height: 45,
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        _stopTracking();
                        _saveRunData();
                        Navigator.pop(context);
                      },
                      icon: Image.asset(
                        iconPath.appBarIcon('the-end_outline'), 
                        width: 45, 
                        height: 45,
                      ),
                    ),
                  ],
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<int>(
                    stream: _stopWatchTimer.rawTime,
                    initialData: 0,
                    builder: (context, snapshot) {
                      final value = snapshot.data!;
                      final displayTime = StopWatchTimer.getDisplayTime(value);
                      return Text('Time: $displayTime', style: const TextStyle(fontSize: 15),);
                    },
                  ),
                  Text('Distance: ${_distance.toStringAsFixed(2)} m', style: const TextStyle(fontSize: 15),),
                  Text('Speed: ${_speed.toStringAsFixed(2)} m/s', style: const TextStyle(fontSize: 15),),
                ],
              ),
            ],
          ),
        )


        ],
      ),
    );
  }
}
