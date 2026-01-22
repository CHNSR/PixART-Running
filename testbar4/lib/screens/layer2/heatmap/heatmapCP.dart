import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:testbar4/routes/export.dart';

class HeatmapCP extends StatefulWidget {
  HeatmapCP({super.key});

  @override
  State<HeatmapCP> createState() => _HeatmapCPState();
}

class _HeatmapCPState extends State<HeatmapCP> {
  Map<DateTime, int> datasets = {};
  double totalDistance = 0.0; // ตัวแปรสำหรับเก็บระยะทางรวมของวันนั้น

  @override
  void initState() {
    super.initState();
    loadDateData();
  }

  Future<void> loadDateData() async {
    try {
      final data = await Activity.fetchActivity(numOfFetch: 'all');
      Map<DateTime, int> tempDatasets = {};

      for (var activity in data) {
        DateTime date = activity['date'];
        // Normalize the date to start of the day
        date = DateTime(date.year, date.month, date.day);
        if (tempDatasets.containsKey(date)) {
          tempDatasets[date] = tempDatasets[date]! + 1;
        } else {
          tempDatasets[date] = 1;
        }
      }

      setState(() {
        datasets = tempDatasets;
        print('[P1][Chart][ChartComPo] DATAsets :$datasets');
      });
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  Future<void> loadTotalDistanceForDate(DateTime date) async {
    try {
      final data = await Activity.fetchActivityByDate(
          date); // สมมติว่าคุณมีฟังก์ชันนี้เพื่อดึงข้อมูลเฉพาะวัน
      double distanceSumMeters = 0.0;

      for (var activity in data) {
        distanceSumMeters += activity[
            'distance']; // สมมติว่า field ระยะทางใน activity คือ 'distance'
      }

      double distanceSumKm = distanceSumMeters / 1000.0; // แปลงเป็นกิโลเมตร

      setState(() {
        totalDistance = distanceSumKm;
        print("[P1][HeatMap] distance on this day: $totalDistance km");
      });
    } catch (e) {
      print("Error loading total distance: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the first and last days of the current month
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    print(
        '[P1][Chart][ChartComPo]-----print start day in chart: $firstDayOfMonth');
    print(
        '[P1][Chart][ChartComPo]-----print end day in chart: $lastDayOfMonth');
    return Column(
      children: [
        HeatMapCalendar(
          datasets: datasets,
          colorMode: ColorMode.opacity,
          colorsets: const {
            1: Colors.red,
            2: Colors.orange,
            3: Colors.yellow,
            4: Colors.green,
            5: Colors.blue,
            6: Colors.indigo,
            7: Colors.purple,
          },
          size: 40,
          flexible: true,
          weekTextColor: Colors.black,
          onClick: (date) {
            loadTotalDistanceForDate(
                date); // เมื่อกดที่วันที่จะเรียกฟังก์ชันนี้เพื่อโหลดระยะทาง
          },
        ),
        const SizedBox(height: 20),
        Text(
          "Total km on this day: ${totalDistance.toStringAsFixed(2)} km", // แสดงระยะทางรวมของวันนั้น
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
