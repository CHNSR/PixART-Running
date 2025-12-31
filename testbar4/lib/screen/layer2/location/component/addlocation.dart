import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:testbar4/services/firebase_service/Fire_Activity.dart';
import '../../activity/componente/acCpEdit.dart';

class AddLocationPageMap extends StatelessWidget {
  const AddLocationPageMap({super.key, required this.mapStatus});

  final bool mapStatus; // Accept the mapStatus parameter
  
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
      // Handle date selection
      if (isStart) {
        // Store the start date
        // (You can pass this back to a parent widget if needed)
      } else {
        // Store the end date
        // (You can pass this back to a parent widget if needed)
      }
    }
  }

  Future<List<Map<String, dynamic>>> _fetchData(DateTime? startDate, DateTime? endDate) async {
    return await Activity.fetchActivityDateTime(
      numOfFetch: 'all',
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime? startDate, endDate; // Local variables for date selection
    Future<List<Map<String, dynamic>>>? fetchedData = _fetchData(startDate, endDate); // Initial fetch
    print("[Add Location]-mapstatus: $mapStatus");
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 242, 239),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFf9f4ef),
            border: Border(bottom: BorderSide(width: 3, color: Color(0xFF0f0e17))),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add Location",
              style: GoogleFonts.pixelifySans(
                fontSize: 24, // Adjusted size to fit better in the AppBar
                fontWeight: FontWeight.w500,
                color: const Color(0xFF0f0e17),
              ),
            ),
            Text(
              "Status map: ${mapStatus == true ? 'private' : 'public'}",
              style: TextStyle(
                fontSize: 14, // Reduced font size for subtitle
                color: const Color(0xFF0f0e17),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
      ),

      body: Stack(
        children: [
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
                    child: Text(startDate == null
                        ? 'Select Start Date'
                        : _formatDate(startDate)),
                  ),
                  TextButton(
                    onPressed: () async {
                      await _pickDate(context, false);
                    },
                    child: Text(endDate == null
                        ? 'Select End Date'
                        : _formatDate(endDate)),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            bottom: 0,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchedData,
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
                          if (mapStatus == false) 
                            AddCardAc(
                              numOfCard: 'all',
                              methodFetch: "fetchActivityDateTime",
                              mapstatus: false,
                              startDate: startDate,
                              endDate: endDate,
                            )
                          else if (mapStatus == true)
                            AddCardAc(
                              numOfCard: 'all', 
                              methodFetch: "fetchActivityDateTime", 
                              mapstatus: true,
                              startDate: startDate,
                              endDate: endDate,
                              )
                          else
                            Text("Error input Mapstatus you must input 'true' or 'false' ")
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
