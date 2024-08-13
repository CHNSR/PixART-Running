import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:testbar4/database/Fire_Activity.dart';
import 'package:testbar4/manage/manage_icon/icon_path.dart';
import 'package:testbar4/screen/layer2/activity/componente/activityCP.dart';

class P1Home extends StatefulWidget {
  const P1Home({super.key});

  @override
  State<P1Home> createState() => _P1HomeState();
}

class _P1HomeState extends State<P1Home> {
  final IconPath iconPath = IconPath();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFEEA),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 100,
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/150'),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 1200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFfef3c7),
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Row(
                          children: [
                            const Expanded(
                              child: Text("Activity",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w400)),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/p13");
                              },
                              child: Image.asset(
                                iconPath.appBarIcon("moreInfo_outline"),
                                height: 60,
                                width: 60,
                              ),
                            ),
                          ],
                        ),
                        subtitle: const Divider(
                          height: 4,
                          color: Colors.black,
                        ),
                      ),
                      // Space for ACcard data

                      const Expanded(
                        child: CardAc(
                          numOfCard: 3,
                        ),
                      ),

                      /*
                      Container(
                        height: 200,
                        width: 200,
                        color: Colors.white,
                        child: ActivityMap(activities: [activity]),
                      )
                      */
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                //container for chart
                Container(
                  height: 500,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFfef3c7),
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Row(
                          children: [
                            const Expanded(
                              child: Text("Chart",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w400)),
                            ),
                            GestureDetector(
                              onTap: () {
                                //Navigator.pushNamed(context, "/p13");
                              },
                              child: Image.asset(
                                iconPath.appBarIcon("moreInfo_outline"),
                                height: 60,
                                width: 60,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Divider(
                          height: 4,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
