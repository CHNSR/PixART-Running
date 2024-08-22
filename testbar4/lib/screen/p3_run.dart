import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:testbar4/database/Fire_Activity.dart';
//import 'package:testbar2/model/entry.dart';

class P3Run extends StatefulWidget {
  const P3Run({super.key});

  @override
  State<P3Run> createState() => _RunPageState();
}

class _RunPageState extends State<P3Run> {
  // for store the value about tracking
  final Set<Polyline> polyline = {};
  final Set<Marker> _markers = {};
  final Activity activity = Activity();

  Location _location = Location();
  late GoogleMapController _mapController;
  LatLng _center = const LatLng(0, 0);
  List<LatLng> route = [];

  double _dist = 0;
  late String _displayTime;
  late int _time;
  late int _lastTime;
  double _speed = 0;
  double _avgSpeed = 0;
  int _speedCounter = 0;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  bool _isRunning = false;
  bool _isMapReady = false; // Set initial to false

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try requesting permissions again
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
      print('debug Lat & Long : ${_center}');
      _isMapReady = true; // Set map as ready
      _mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: _center, zoom: 15)));

      _markers.add(
        Marker(
          markerId: MarkerId('currentLocation'),
          position: _center,
          infoWindow: InfoWindow(title: 'Current Location'),
        ),
      );
    });
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose(); // Need to call dispose function.
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _startTracking() {
    setState(() {
      _isRunning = true;
    });
    _stopWatchTimer.onStartTimer();

    _location.onLocationChanged.listen((event) {
      if (!_isRunning) return; // ถ้าไม่ได้กำลังจับเวลาอยู่ ให้ออกไปก่อน

      double? latitude = event.latitude;
      double? longitude = event.longitude;

      // ตรวจสอบว่าค่า latitude และ longitude ไม่เป็น null
      if (latitude != null && longitude != null) {
        LatLng loc = LatLng(latitude, longitude);
        _mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: loc, zoom: 15)));

        setState(() {
          // อัพเดต marker
          _markers.clear();
          _markers.add(
            Marker(
              markerId: MarkerId('currentLocation'),
              position: loc,
              infoWindow: InfoWindow(title: 'Current Location'),
            ),
          );

          if (route.isNotEmpty) {
            double appendDist = Geolocator.distanceBetween(route.last.latitude,
                route.last.longitude, loc.latitude, loc.longitude);
            _dist = _dist + appendDist;
            int timeDuration = (_time - _lastTime);

            if (timeDuration != 0) {
              _speed = (appendDist / (timeDuration / 1000)) * 3.6;
              if (_speed != 0) {
                _avgSpeed = _avgSpeed + _speed;
                _speedCounter++;
              }
            }
          }
          _lastTime = _time;
          route.add(loc);

          polyline.add(Polyline(
              polylineId: PolylineId(event.toString()),
              visible: true,
              points: route,
              width: 5,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
              color: Colors.deepOrange));
        });
      } else {
        // จัดการกรณีที่ latitude หรือ longitude เป็น null
        print("Error: latitude or longitude is null.");
      }
    });
  }

  void _stopTracking() {
    setState(() {
      _isRunning = false;
    });
    _stopWatchTimer.onStopTimer();
    // Optionally, you can add code here to save the tracking data
  }

  //save route and store in firebase
  void _saveRunData() async {
    //convert route list to geo list
    List<Map<String, dynamic>> routeData = route.map((loc) {
      return {
        'latitude': loc.latitude,
        'longitude': loc.longitude,
      };
    }).toList();

    // Get time in milliseconds from StopWatchTimer
    final durationInMilliseconds = _stopWatchTimer.rawTime.value;

    //store data in firebase
    Activity.addActivity(
      distance: _dist,
      finishdate: DateTime.now(),
      avgPace: _speedCounter == 0 ? 0 : _avgSpeed / _speedCounter,
      routeData: routeData,
      time: durationInMilliseconds,
    );

    print("[P3] Check call func _savedata to fire ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Container for creating the map
          Container(
            width: double.infinity,
            height: double.infinity,
            child: GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: _center, zoom: 15.0),
              markers: _markers,
              polylines: polyline,
              zoomControlsEnabled: false,
              onMapCreated: _onMapCreated,
              myLocationButtonEnabled: true,
            ),
          ),
          if (_isMapReady)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 160,
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 4),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text("SPEED (KM/H)",
                                style: GoogleFonts.montserrat(
                                    fontSize: 10, fontWeight: FontWeight.w300)),
                            Text(_speed.toStringAsFixed(2),
                                style: GoogleFonts.montserrat(
                                    fontSize: 30, fontWeight: FontWeight.w300))
                          ],
                        ),
                        Column(
                          children: [
                            Text("TIME",
                                style: GoogleFonts.montserrat(
                                    fontSize: 10, fontWeight: FontWeight.w300)),
                            StreamBuilder<int>(
                              stream: _stopWatchTimer.rawTime,
                              initialData: 0,
                              builder: (context, snap) {
                                _time = snap.data!;
                                _displayTime = StopWatchTimer
                                        .getDisplayTimeHours(_time) +
                                    ":" +
                                    StopWatchTimer.getDisplayTimeMinute(_time) +
                                    ":" +
                                    StopWatchTimer.getDisplayTimeSecond(_time);
                                return Text(_displayTime,
                                    style: GoogleFonts.montserrat(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w300));
                              },
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text("DISTANCE (KM)",
                                style: GoogleFonts.montserrat(
                                    fontSize: 10, fontWeight: FontWeight.w300)),
                            Text((_dist / 1000).toStringAsFixed(2),
                                style: GoogleFonts.montserrat(
                                    fontSize: 30, fontWeight: FontWeight.w300))
                          ],
                        )
                      ],
                    ),

                    // Divider is a line
                    Divider(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () async {
                            if (_isRunning) {
                              _stopTracking();
                            } else {
                              _startTracking();
                            }
                          },
                          icon: Icon(
                            _isRunning ? Icons.stop : Icons.play_arrow,
                            size: 50,
                          ),
                        ),
                        if (!_isRunning)
                          IconButton(
                            onPressed: () {
                              print("[P3]---------Tap save data---------");
                              //save date to firestore
                              _saveRunData();
                              Navigator.pushNamed(context, '/main');
                            },
                            icon: const Icon(
                              Icons.home,
                              size: 50,
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
