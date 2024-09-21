import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:testbar4/database/Fire_Activity.dart';
import 'package:testbar4/manage/manage_icon/icon_path.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:testbar4/model/provider_userData.dart';

import '../selectShoes/selectShoes.dart';

class Navigation extends StatefulWidget {
  Navigation({super.key, required this.route});

  final List<Map<String, dynamic>> route;

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  BitmapDescriptor? endMarkerIcon;
  BitmapDescriptor? startMarkerIcon;
  BitmapDescriptor? currentMarkerIcon;
  IconPath iconPath = IconPath();
  bool _canStartRun = false;
  final Completer<GoogleMapController> _controller = Completer();
  Position? _currentPosition;
  double _distance = 0, _speed = 0, _avgSpeed = 0;
  bool _isNavigation = false;
  bool _isRunning = false;
  LatLng? _lastPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  StreamSubscription<Position>? _positionStreamSubscription;
  int _speedCounter = 0;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final List<LatLng> _trackingRoute = [];
   bool _isShoeSelected =false;
   String? _selectedShoe;

  @override
  void dispose() {
    _stopTracking();
    _stopWatchTimer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    //_checkProximityToStart();
    _loadCustomMarkers();
    
    // Move camera to cover route on initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _moveCameraToCoverRoute();
    });
  }

  //load marker
  Future<void> _loadCustomMarkers() async {
     final BitmapDescriptor startIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(30, 30)),
      iconPath.appBarIcon('pin_red'),
    );

    final BitmapDescriptor endIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(30, 30)),
      iconPath.appBarIcon('pin_green'),
    );

    final BitmapDescriptor currentIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(30, 30)),
      iconPath.appBarIcon('pin_black'),
    );
    
    

    setState(() {
      startMarkerIcon = startIcon;
      endMarkerIcon = endIcon;
      currentMarkerIcon = currentIcon;
    });
  }

    // Check if the user is close to the start point
  void _checkProximityToStart() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    // Define the radius of the circular area (in meters)
    const double radiusInMeters = 50.0;

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

        // Check if the current location is within the circular area
        _canStartRun = distanceToStart <= radiusInMeters;
        print('[Navigation]Distance to start: $distanceToStart meters');
        print("[Navigation] Canrun state: $_canStartRun");
      });
    });
    

  }

  void _moveCameraToCoverRoute() async {
  final GoogleMapController controller = await _controller.future;
  
  // Create LatLngBounds to cover all the points of the route
  LatLngBounds bounds;
  if (widget.route.isNotEmpty) {
    List<LatLng> routePoints = widget.route.map((location) {
      return LatLng(location['latitude'], location['longitude']);
    }).toList();

    // Include current position if available
    if (_currentPosition != null) {
      routePoints.add(LatLng(_currentPosition!.latitude, _currentPosition!.longitude));
    }

    bounds = _createBoundsFromLatLngList(routePoints);
    
    // Animate camera to cover the route with padding
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }
}

LatLngBounds _createBoundsFromLatLngList(List<LatLng> points) {
  double southWestLat = points.first.latitude;
  double southWestLng = points.first.longitude;
  double northEastLat = points.first.latitude;
  double northEastLng = points.first.longitude;

  for (LatLng point in points) {
    if (point.latitude < southWestLat) southWestLat = point.latitude;
    if (point.longitude < southWestLng) southWestLng = point.longitude;
    if (point.latitude > northEastLat) northEastLat = point.latitude;
    if (point.longitude > northEastLng) northEastLng = point.longitude;
  }

  return LatLngBounds(
    southwest: LatLng(southWestLat, southWestLng),
    northeast: LatLng(northEastLat, northEastLng),
  );
}

  // ฟังก์ชันเพื่อดึงตำแหน่งปัจจุบันและอัปเดตกล้องกับ marker
Future<void> _getCurrentPosition() async {
  try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentPosition = position;
      LatLng currentLatLng = LatLng(position.latitude, position.longitude);
      _updateCurrentLocationMarker(currentLatLng);
      
      _moveCameraToRouteAndUser(currentLatLng);
    });
  } catch (e) {
    print('Error getting current position: $e');
  }
}

// อัปเดตกล้องให้ครอบคลุมทั้งเส้นทางและตำแหน่งผู้ใช้
void _moveCameraToRouteAndUser(LatLng userLatLng) {
  if (widget.route.isEmpty) return;

  List<LatLng> latLngBoundsPoints = widget.route.map((location) {
    return LatLng(location['latitude'], location['longitude']);
  }).toList();

  latLngBoundsPoints.add(userLatLng); // รวมตำแหน่งผู้ใช้

  LatLngBounds bounds = _getLatLngBounds(latLngBoundsPoints);

  _controller.future.then((GoogleMapController controller) {
    controller.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 100), // ครอบคลุมเส้นทางและตำแหน่งผู้ใช้
    );
  });
}

// ฟังก์ชันเพื่อคำนวณ LatLngBounds
LatLngBounds _getLatLngBounds(List<LatLng> points) {
  double? minLat, maxLat, minLng, maxLng;

  for (LatLng point in points) {
    if (minLat == null || point.latitude < minLat) minLat = point.latitude;
    if (maxLat == null || point.latitude > maxLat) maxLat = point.latitude;
    if (minLng == null || point.longitude < minLng) minLng = point.longitude;
    if (maxLng == null || point.longitude > maxLng) maxLng = point.longitude;
  }

  return LatLngBounds(
    southwest: LatLng(minLat!, minLng!),
    northeast: LatLng(maxLat!, maxLng!),
  );
}

  void _startTracking() {
    //click run func call _checkProximityToStart() to check user can run and change state 
    //_checkProximityToStart();
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

            // Move camera to cover the new position and the route
            _moveCameraToCoverRoute();

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

    // If the user is within 10 meters of the endpoint, stop tracking and save data and change state of button 
    if (distanceToEnd <= 10) {
      _stopTracking();
      _saveRunData();
      setState(() {
      _isRunning = false;
      });
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
        icon: currentMarkerIcon ?? BitmapDescriptor.defaultMarker,
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

  Future<String> _getShoeDocumentID(String shoeName) async {
    try {
      // ดึง document ID ตามชื่อรองเท้า
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Shoes')
          .where('shoesName', isEqualTo: shoeName)
          .where('runnerID', isEqualTo: context.read<UserDataPV>().userData?['id']) // ตรวจสอบว่าเป็นของผู้ใช้ปัจจุบัน
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id; // คืนค่า document ID แรก
      } else {
        throw Exception('ไม่พบรองเท้า');
      }
    } catch (e) {
      throw Exception('ไม่สามารถดึง document ID ของรองเท้าได้: $e');
    }
  }
  static Future<void> updateDistance({
    required String documentID,
    required double newDistance,
  }) async {
    try {
      await firestore.collection('Shoes').doc(documentID).update({
        'shoesRange': newDistance,
      });
    } catch (e) {
      print('ไม่สามารถอัปเดตระยะทางได้: $e');
    }
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
        flexibleSpace: Container(
            decoration: const BoxDecoration(
              
              color: Color(0xFFf9f4ef),
              border: Border(bottom: BorderSide(width: 3,color: Color(0xFF0f0e17)))
            ),
          ),
          title: Text(
            "Navigation",
            style: GoogleFonts.pixelifySans(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0f0e17),
            ),
          ),
          backgroundColor: Colors.transparent,      ),
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
                icon: startMarkerIcon ?? BitmapDescriptor.defaultMarker,
              ),
              if (latLngRoute.isNotEmpty)
                Marker(
                  markerId: const MarkerId('end'),
                  position: latLngRoute.last,
                  infoWindow: const InfoWindow(title: 'End'),
                  icon: endMarkerIcon ?? BitmapDescriptor.defaultMarker,
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
          
          Positioned(
          bottom: 30,
          left: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ปุ่ม "Square"
              GestureDetector(
                onTap: () {
                showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return SelectShoes(
                                    onSelect: (selectedShoes){
                                      setState(() {
                                        _selectedShoe = selectedShoes;
                                        _isShoeSelected = true;
                                      });
                                     Navigator.pop(context);
                                    },
                                  );
                                    
                                },
                              );
                            },
                            child: Center(
                              child: Column(
                                children: [
                                  Image.asset(
                                    _isShoeSelected
                                        ? IconPath().appBarIcon('shoesSelection_outline') // ไอคอนใหม่เมื่อเลือกรองเท้า
                                        : IconPath().appBarIcon('shoesSelection_select'),
                                    width: 40,
                                    height: 40,
                                  ),
                                  if (_selectedShoe != null) // แสดงชื่อรองเท้าที่เลือกใต้ไอคอน
                                    Text(
                                      _selectedShoe!,
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                                    ),
                                ],
                              ),
                            ),
                          ),
              if (!_isRunning)
                IconButton(
                  onPressed: () {
                    // เรียกใช้การเช็คตำแหน่งก่อนที่จะเปลี่ยนสถานะ
                    _checkProximityToStart();

                    // รอให้ `_checkProximityToStart` อัปเดตสถานะ `_canStartRun`
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (_canStartRun) {
                        setState(() {
                          _isRunning = true;
                        });
                        _startTracking();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("You must be at the start point to begin!"),
                            backgroundColor: Colors.redAccent[400],
                          ),
                        );
                      }
                    });
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
