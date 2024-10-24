import 'package:flutter/material.dart';
import 'package:testbar4/manage/manage_icon/icon_path.dart';
import 'package:testbar4/screen/layer2/activity/componente/activityCP.dart';
import 'package:testbar4/screen/layer2/gauges/gauges.dart';
import 'package:testbar4/screen/layer2/heatmap/heatmapCP.dart';

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
      backgroundColor: const Color(0xFFfffffe),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 100,
                  backgroundColor: Color(0xFFeaddcf),
                  child: WeeklyGoalGauges(),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFeaddcf),
                    border: Border.all(
                      color: Colors.black,
                      width: 3,
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
                      const CardAc(
                        numOfCard: 3,
                        methodFetch:"fetchActivity",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  height: 500,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFeaddcf),
                    border: Border.all(
                      color: Colors.black,
                      width: 3,
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
                        subtitle: const Divider(
                          height: 4,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      
                      Container(
                          margin: const EdgeInsets.all(8.0),
                          child:  HeatmapCP(),
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
