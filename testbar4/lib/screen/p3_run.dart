import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:testbar4/routes/export.dart';

class P3Run extends StatefulWidget {
  const P3Run({super.key});

  @override
  State<P3Run> createState() => _RunPageState();
}

class _RunPageState extends State<P3Run> {
  final Activity activity = Activity();
  // for store the value about tracking
  final Set<Polyline> polyline = {};
  IconPath iconPath = IconPath();
  List<LatLng> route = [];

  double _avgSpeed = 0;
  LatLng _center = const LatLng(0, 0);
  late String _displayTime;
  double _dist = 0;
  bool _isMapReady = false; // Set initial to false
  bool _isRunning = false;
  late int _lastTime;
  Location _location = Location();
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  double _speed = 0;
  int _speedCounter = 0;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  late int _time;
  bool _isShoeSelected = false;
  String? _selectedShoe;
  BitmapDescriptor? _markerIcon;

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose(); // Need to call dispose function.
  }

  @override
  void initState() {
    super.initState();
    _loadCustomMarkers();
    _getUserLocation();
  }

  Future<void> _loadCustomMarkers() async {
    final BitmapDescriptor startIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(35, 35)),
      iconPath.appBarIcon('pin_red_pixel'),
    );

    setState(() {
      _markerIcon = startIcon;
    });
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
          icon: _markerIcon!,
        ),
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _startTracking() {
    setState(() {
      _isRunning = true;
    });
    _stopWatchTimer.onStartTimer();
    _location.changeSettings(interval: 500);
    _location.onLocationChanged.listen((event) {
      if (!_isRunning) return;

      double? latitude = event.latitude;
      double? longitude = event.longitude;

      if (latitude != null && longitude != null) {
        LatLng loc = LatLng(latitude, longitude);

        _mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: loc, zoom: 15)));

        setState(() {
          _markers.clear();
          _markers.add(
            Marker(
              markerId: const MarkerId('currentLocation'),
              position: loc,
              infoWindow: const InfoWindow(title: 'Current Location'),
              icon: _markerIcon!,
            ),
          );

          if (route.isNotEmpty) {
            double appendDist = Geolocator.distanceBetween(
              route.last.latitude,
              route.last.longitude,
              loc.latitude,
              loc.longitude,
            );
            _dist += appendDist;

            int timeDuration = (_time - _lastTime);
            if (timeDuration != 0) {
              _speed = (appendDist / (timeDuration / 1000)) * 3.6;
              if (_speed != 0) {
                _avgSpeed += _speed;
                _speedCounter++;
              }
            }
          }

          _lastTime = _time;
          route.add(loc);

          polyline.clear();
          polyline.add(
            Polyline(
              polylineId: const PolylineId('currentRoute'),
              points: route,
              width: 5,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
              color: Colors.deepOrange,
            ),
          );
        });
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
    // แปลงรายการเส้นทางเป็นรายการตำแหน่งทางภูมิศาสตร์
    List<Map<String, dynamic>> routeData = route.map((loc) {
      return {
        'latitude': loc.latitude,
        'longitude': loc.longitude,
      };
    }).toList();

    // รับเวลาในมิลลิวินาทีจาก StopWatchTimer
    final durationInMilliseconds = _stopWatchTimer.rawTime.value;
    print('[P3][check data]Duration in milliseconds: $durationInMilliseconds');

    // บันทึกข้อมูลลงใน Firebase
    await Activity.addActivity(
      distance: _dist,
      finishdate: DateTime.now(),
      avgPace: _speedCounter == 0 ? 0 : _avgSpeed / _speedCounter,
      routeData: routeData,
      time: durationInMilliseconds,
    );

    print("[P3] ตรวจสอบการเรียกฟังก์ชัน _savedata ไปที่ Firebase");

    // อัปเดตระยะทางสำหรับรองเท้าที่เลือก
    if (_selectedShoe != null) {
      try {
        // รับ document ID สำหรับรองเท้าที่เลือก
        String documentID = await _getShoeDocumentID(_selectedShoe!);
        double newDistance = _dist / 1000; // แปลงระยะทางเป็นกิโลเมตร

        // อัปเดตระยะทางใน Firestore
        await updateDistance(documentID: documentID, newDistance: newDistance);

        print('อัปเดตระยะทางเรียบร้อยแล้ว');
      } catch (e) {
        print('ไม่สามารถอัปเดตระยะทางได้: $e');
      }
    }
  }

  Future<String> _getShoeDocumentID(String shoeName) async {
    try {
      // ดึง document ID ตามชื่อรองเท้า
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Shoes')
          .where('shoesName', isEqualTo: shoeName)
          .where('runnerID',
              isEqualTo: context
                  .read<UserDataPV>()
                  .userData?['id']) // ตรวจสอบว่าเป็นของผู้ใช้ปัจจุบัน
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
                height: 85,
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 4),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: BoxDecoration(
                    color: Color(0xFFf9f4ef),
                    border: Border.all(width: 1.8, color: Color(0xFF020826))),
                child: Column(
                  children: [
                    Row(
                      children: [
                        if (_isRunning) ...[
                          // ปุ่ม "Stop"
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                _stopTracking();
                                print("[P3]---------Tap save data---------");
                                // save data to Firestore
                                _saveRunData();
                                Navigator.pushNamed(context, '/main');
                              },
                              child: Image.asset(
                                IconPath().appBarIcon('finish_outline'),
                                width: 40,
                                height: 40,
                              ),
                            ),
                          ),
                          const Spacer(),
                          //container for time
                          Container(
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "SPEED (KM/H)",
                                      style: GoogleFonts.pixelifySans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF0f0e17),
                                      ),
                                    ),
                                    Text(
                                      _speed.toStringAsFixed(2),
                                      style: GoogleFonts.pixelifySans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF0f0e17),
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "TIME",
                                      style: GoogleFonts.pixelifySans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF0f0e17),
                                      ),
                                    ),
                                    StreamBuilder<int>(
                                      stream: _stopWatchTimer.rawTime,
                                      initialData: 0,
                                      builder: (context, snap) {
                                        if (snap.hasData) {
                                          _time = snap.data!;
                                          _displayTime = StopWatchTimer
                                                  .getDisplayTimeHours(_time) +
                                              ":" +
                                              StopWatchTimer
                                                  .getDisplayTimeMinute(_time) +
                                              ":" +
                                              StopWatchTimer
                                                  .getDisplayTimeSecond(_time);
                                          return Text(
                                            _displayTime,
                                            style: GoogleFonts.pixelifySans(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF0f0e17),
                                            ),
                                          );
                                        } else {
                                          return Text(
                                            '00:00:00',
                                            style: GoogleFonts.pixelifySans(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF0f0e17),
                                            ),
                                          );
                                        }
                                      },
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "DISTANCE (KM)",
                                      style: GoogleFonts.pixelifySans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF0f0e17),
                                      ),
                                    ),
                                    Text(
                                      (_dist / 1000).toStringAsFixed(2),
                                      style: GoogleFonts.pixelifySans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF0f0e17),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          const Spacer(),

                          // ปุ่ม "End"
                          GestureDetector(
                            onTap: () {},
                            child: Column(
                              children: [
                                Image.asset(
                                  _isShoeSelected
                                      ? IconPath().appBarIcon(
                                          'shoesSelection_outline') // ไอคอนใหม่เมื่อเลือกรองเท้า
                                      : IconPath()
                                          .appBarIcon('shoesSelection_select'),
                                  width: 40,
                                  height: 40,
                                ),
                                if (_selectedShoe !=
                                    null) // แสดงชื่อรองเท้าที่เลือกใต้ไอคอน
                                  Text(
                                    _selectedShoe!,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300),
                                  ),
                              ],
                            ),
                          ),
                        ] else ...[
                          // ปุ่ม "LetsGo"
                          GestureDetector(
                            onTap: () {
                              _startTracking();
                            },
                            child: Image.asset(
                              IconPath().appBarIcon('letsGo_outline'),
                              width: 60,
                              height: 60,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "SPEED (KM/H)",
                                      style: GoogleFonts.pixelifySans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF0f0e17),
                                      ),
                                    ),
                                    Text(
                                      _speed.toStringAsFixed(2),
                                      style: GoogleFonts.pixelifySans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF0f0e17),
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "TIME",
                                      style: GoogleFonts.pixelifySans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF0f0e17),
                                      ),
                                    ),
                                    StreamBuilder<int>(
                                      stream: _stopWatchTimer.rawTime,
                                      initialData: 0,
                                      builder: (context, snap) {
                                        if (snap.hasData) {
                                          _time = snap.data!;
                                          _displayTime = StopWatchTimer
                                                  .getDisplayTimeHours(_time) +
                                              ":" +
                                              StopWatchTimer
                                                  .getDisplayTimeMinute(_time) +
                                              ":" +
                                              StopWatchTimer
                                                  .getDisplayTimeSecond(_time);
                                          return Text(
                                            _displayTime,
                                            style: GoogleFonts.pixelifySans(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF0f0e17),
                                            ),
                                          );
                                        } else {
                                          return Text(
                                            '00:00:00',
                                            style: GoogleFonts.pixelifySans(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF0f0e17),
                                            ),
                                          );
                                        }
                                      },
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "DISTANCE (KM)",
                                      style: GoogleFonts.pixelifySans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF0f0e17),
                                      ),
                                    ),
                                    Text(
                                      (_dist / 1000).toStringAsFixed(2),
                                      style: GoogleFonts.pixelifySans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF0f0e17),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          const Spacer(),

                          // ปุ่ม "Square"
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return SelectShoes(
                                    onSelect: (selectedShoes) {
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
                                        ? IconPath().appBarIcon(
                                            'shoesSelection_outline') // ไอคอนใหม่เมื่อเลือกรองเท้า
                                        : IconPath().appBarIcon(
                                            'shoesSelection_select'),
                                    width: 40,
                                    height: 40,
                                  ),
                                  if (_selectedShoe !=
                                      null) // แสดงชื่อรองเท้าที่เลือกใต้ไอคอน
                                    Text(
                                      _selectedShoe!,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
