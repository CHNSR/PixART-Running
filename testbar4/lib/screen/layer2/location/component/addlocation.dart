/*
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testbar4/database/Fire_Activity.dart';
import 'package:testbar4/screen/layer2/activity/componente/activityCP.dart';

class AddLocationPage extends StatefulWidget {
  const AddLocationPage({super.key});

  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  DateTime? _startDate, _endDate;
  Future<List<Map<String, dynamic>>>? _fetchedData; // Future to store fetched data

  // Function to format date as dd-MM-yyyy
  String _formatDate(DateTime? date) {
    if (date == null) return 'Select Date'; // Placeholder if date is null
    return DateFormat('dd-MM-yyyy').format(date);
  }

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
        _fetchedData = _fetchData(); // Fetch new data when date changes
      });
    }
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    return await Activity.fetchActivityDateTime(
      numOfFetch: 'all',
      startDate: _startDate,
      endDate: _endDate,
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchedData = _fetchData(); // Initial data fetch
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Location"),
      ),
      body: Stack(
        children: [
          // Date search container positioned after the AppBar
          Positioned(
            top: 10,
            left: 16,
            right: 16,
            child: Container(
              height: 80,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () async {
                      await _pickDate(context, true);
                    },
                    child: Text(_startDate == null
                        ? 'Select Start Date'
                        : _formatDate(_startDate)),
                  ),
                  TextButton(
                    onPressed: () async {
                      await _pickDate(context, false);
                    },
                    child: Text(_endDate == null
                        ? 'Select End Date'
                        : _formatDate(_endDate)),
                  ),
                ],
              ),
            ),
          ),
          // Positioned ListView below the date search container
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            bottom: 0,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchedData, // Use the cached future data
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching data'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data found'));
                }

                final data = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.black),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          // Custom card to display data
                          CardAc(
                            numOfCard: 'all',
                            methodFetch: "fetchActivityDateTime",
                            startDate: _startDate,
                            endDate: _endDate,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testbar4/database/Fire_Activity.dart';
import 'package:testbar4/screen/layer2/activity/componente/activityCP.dart';

class AddLocationPage extends StatefulWidget {
  const AddLocationPage({super.key});

  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  DateTime? _startDate, _endDate;
  Future<List<Map<String, dynamic>>>? _fetchedData; // Future to store fetched data

  // Function to format date as dd-MM-yyyy
  String _formatDate(DateTime? date) {
    if (date == null) return 'Select Date'; // Placeholder if date is null
    return DateFormat('dd-MM-yyyy').format(date);
  }

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
        _fetchedData = _fetchData(); // Fetch new data when date changes
      });
    }
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    return await Activity.fetchActivityDateTime(
      numOfFetch: 'all',
      startDate: _startDate,
      endDate: _endDate,
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchedData = _fetchData(); // Initial data fetch
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Location"),
      ),
      body: Stack(
        children: [
          // Date search container positioned after the AppBar
          Positioned(
            top: 10,
            left: 16,
            right: 16,
            child: Container(
              height: 80,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () async {
                      await _pickDate(context, true);
                    },
                    child: Text(_startDate == null
                        ? 'Select Start Date'
                        : _formatDate(_startDate)),
                  ),
                  TextButton(
                    onPressed: () async {
                      await _pickDate(context, false);
                    },
                    child: Text(_endDate == null
                        ? 'Select End Date'
                        : _formatDate(_endDate)),
                  ),
                ],
              ),
            ),
          ),
          // Positioned ListView below the date search container
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            bottom: 0,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchedData, // Use the cached future data
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching data'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data found'));
                }

                final data = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.black),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          // Use a single CardAc widget instead of inside a loop
                          CardAc(
                            numOfCard: 'all',
                            methodFetch: "fetchActivityDateTime",
                            startDate: _startDate,
                            endDate: _endDate,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
