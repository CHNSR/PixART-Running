import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:testbar4/routes/export.dart';

class AddCardAc extends StatefulWidget {
  const AddCardAc(
      {super.key,
      required this.numOfCard,
      this.startDate,
      this.endDate,
      required this.methodFetch,
      required this.mapstatus});

  final dynamic numOfCard;
  final DateTime? startDate, endDate;
  final String methodFetch;
  final bool mapstatus;

  @override
  State<AddCardAc> createState() => _CardAcForPublicState();
}

class _CardAcForPublicState extends State<AddCardAc> {
  IconPath iconPath = IconPath();
  Future<List<Map<String, dynamic>>>? _activitiesFuture;

  // Add a TextEditingController for the name input
  final TextEditingController _nameController = TextEditingController();

  String convertMetresToKilometres(double metres) {
    return (metres / 1000).toStringAsFixed(3);
  }

  String convertKmPerHourToPace(double kmPerHour) {
    return (60 / kmPerHour).toStringAsFixed(3);
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final secs = (duration.inSeconds % 60).toString().padLeft(2, '0');

    return '$hours:$minutes:$secs';
  }

  @override
  void initState() {
    super.initState();
    //call initialize to get user id form provider and use it to fetch data
    Activity.initialize();
    if (widget.methodFetch == "fetchActivity") {
      _activitiesFuture = Activity.fetchActivity(numOfFetch: widget.numOfCard)
          as Future<List<Map<String, dynamic>>>?;
    } else if (widget.methodFetch == "fetchActivityDateTime") {
      _activitiesFuture = Activity.fetchActivityDateTime(
          numOfFetch: widget.numOfCard,
          startDate: widget.startDate,
          endDate: widget.endDate) as Future<List<Map<String, dynamic>>>?;
    } else {
      _activitiesFuture = null;
    }
    print(
        "[CardAC][check method] (${widget.methodFetch}) value :$_activitiesFuture");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataPV>(builder: (context, userDataProvider, child) {
      final userData = userDataProvider.userData;
      final userId = userData?['id'] ?? 'error';
      return FutureBuilder<List<Map<String, dynamic>>>(
        future: _activitiesFuture,
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: Colors.green,
                size: 50,
              ),
            );
          }

          // Handle error state
          if (snapshot.hasError) {
            return Center(child: Text('Error loading activities.'));
          }

          // Handle case where there is no data
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No activity data available.'));
          }

          // If data is available, process and display the activities
          final activities = snapshot.data!;
          return Column(
            children: activities.map((activity) {
              final route = activity['route'] as List<dynamic>;
              final distanceInMetres = activity['distance'] as double;
              final distanceInKilometres =
                  convertMetresToKilometres(distanceInMetres);
              final pace = (activity['AVGpace'] as double).toStringAsFixed(2);
              final timeInMilliseconds = activity['time'] as int;
              final timeInSeconds = (timeInMilliseconds / 1000).round();
              final time = _formatDuration(timeInSeconds);
              final date =
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(activity['date']);

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: const BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      child: ActivityMap(
                          activities: [activity]), // Pass single activity data
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Date: $date",
                              style: const TextStyle(fontSize: 18)),
                          Text("Distance: ${distanceInKilometres} km",
                              style: const TextStyle(fontSize: 18)),
                          Text("Time: ${time} sec",
                              style: const TextStyle(fontSize: 18)),
                          Text("Average Pace: ${pace} min/km",
                              style: const TextStyle(fontSize: 18)),
                          const SizedBox(height: 5),
                          // Add TextField for entering name
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Enter name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Add route to ${widget.mapstatus == true ? 'public' : 'private'} location -->",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 174, 0, 255),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Locations.addRoute(
                                      context: context,
                                      routeData: route,
                                      distance: distanceInMetres,
                                      name: _nameController
                                          .text, // Use the input name
                                      status: widget.mapstatus,
                                      userId: userId);
                                },
                                icon: Image.asset(
                                  iconPath.appBarIcon("add_outline"),
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose(); // Dispose of the controller
    super.dispose();
  }
}
