import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../services/firebase_service/Fire_Activity.dart';
import '../../../model/provider_userData.dart';

class WeeklyGoalGauges extends StatefulWidget {
  const WeeklyGoalGauges({super.key});

  @override
  State<WeeklyGoalGauges> createState() => _WeeklyGoalGaugesState();
}

class _WeeklyGoalGaugesState extends State<WeeklyGoalGauges> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataPV>(builder: (context, userDataProvider, child) {
      final userData = userDataProvider.userData;
      print("[P5]-------------------------${userData}------------------");

      // แปลงค่า weeklyGoal ให้เป็น double
      final weeklyGoal = (userData?['weekly_goal'] as num).toDouble();
      final runnerID = userData?['id'];

      // ใช้ FutureBuilder เพื่อจัดการกับ Future ที่เกิดจาก fetchNumOfWeeklyActivity
      return FutureBuilder<int?>(
        future: Activity.fetchNumOfWeeklyActivity(runnerID), // ดึงค่าจำนวนครั้งที่วิ่งในสัปดาห์นี้
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // แสดง loading ขณะที่รอข้อมูล
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }

          // ใช้ค่า currentValue ที่ได้จาก Future
          final currentValue = snapshot.data!.toDouble();

          // ตรวจสอบให้แน่ใจว่าค่า currentValue อยู่ในช่วงที่กำหนด
          final needleValue = currentValue.clamp(0.0, weeklyGoal);

          return Center(
            child: Container(
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: weeklyGoal,
                    ranges: <GaugeRange>[
                      GaugeRange(
                        startValue: 0,
                        endValue: weeklyGoal / 3,
                        color: Colors.green,
                      ),
                      GaugeRange(
                        startValue: weeklyGoal / 3,
                        endValue: (weeklyGoal * 2) / 3,
                        color: Colors.orange,
                      ),
                      GaugeRange(
                        startValue: (weeklyGoal * 2) / 3,
                        endValue: weeklyGoal,
                        color: Colors.red,
                      ),
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(value: needleValue), // ใช้ค่า currentValue แทน
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Container(
                          child: Text(
                            '$needleValue times',
                            style: GoogleFonts.pixelifySans(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF4f4134),
                            ),
                          ),
                        ),
                        angle: 90,
                        positionFactor: 0.7,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
