import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../model/entry.dart';

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Set<Polyline> polyline = {};
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

  @override
  void initState() {
    super.initState();
    //_stopWatchTimer.onExecute.add(StopWatchExecute.start);

    _stopWatchTimer.onStartTimer(); // ใช้เมธอดเริ่มจับเวลา
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose(); // Need to call dispose function.
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    double appendDist;

    _location.onLocationChanged.listen((event) {
      double? latitude = event.latitude;
      double? longitude = event.longitude;

      // ตรวจสอบว่าค่า latitude และ longitude ไม่เป็น null
      if (latitude != null && longitude != null) {
        LatLng loc = LatLng(latitude, longitude);
        _mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: loc, zoom: 15)));

        if (route.isNotEmpty) {
          appendDist = Geolocator.distanceBetween(route.last.latitude,
              route.last.longitude, loc.latitude, loc.longitude);
          _dist = _dist + appendDist;
          int timeDuration = (_time - _lastTime);

          //if (_lastTime != null && timeDuration != 0) {  version old
          if (timeDuration != 0) {
            _speed = (appendDist / (timeDuration / 100)) * 3.6;
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

        setState(() {});
      } else {
        // จัดการกรณีที่ latitude หรือ longitude เป็น null
        print("Error: latitude or longitude is null.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
          child: GoogleMap(
        polylines: polyline,
        zoomControlsEnabled: false,
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(target: _center, zoom: 11),
      )),
      Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10, 0, 10, 40),
            height: 145,
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                            _displayTime =
                                StopWatchTimer.getDisplayTimeHours(_time) +
                                    ":" +
                                    StopWatchTimer.getDisplayTimeMinute(_time) +
                                    ":" +
                                    StopWatchTimer.getDisplayTimeSecond(_time);
                            return Text(_displayTime,
                                style: GoogleFonts.montserrat(
                                    fontSize: 30, fontWeight: FontWeight.w300));
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
                Divider(),
                IconButton(
                  icon: Image.asset(
                    "assests/img/icon_stop.png",
                    width: 50,
                    height: 50,
                  ),
                  padding: const EdgeInsets.all(0),
                  onPressed: () async {
                    Entry en = Entry(
                        date: DateFormat.yMMMMd('en_US').format(DateTime.now()),
                        duration: _displayTime,
                        speed:
                            _speedCounter == 0 ? 0 : _avgSpeed / _speedCounter,
                        distance: _dist);
                    Navigator.pop(context, en);
                  },
                )
              ],
            ),
          ))
    ]));
  }
}
