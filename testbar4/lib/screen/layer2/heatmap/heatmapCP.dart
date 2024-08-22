import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:testbar4/database/Fire_Activity.dart';

class HeatmapCP extends StatefulWidget {
  HeatmapCP({super.key});

  @override
  State<HeatmapCP> createState() => _HeatmapCPState();
}

class _HeatmapCPState extends State<HeatmapCP> {
  Map<DateTime, int> datasets = {};

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
    return HeatMapCalendar(
      datasets: datasets,
      colorMode: ColorMode.opacity,
      colorsets: const {
        1: Colors.red,
        3: Colors.orange,
        5: Colors.yellow,
        7: Colors.green,
        9: Colors.blue,
        11: Colors.indigo,
        13: Colors.purple,
      },
      size: 40,
      onClick: (value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(value.toString())));
      },
    );
  }
}
