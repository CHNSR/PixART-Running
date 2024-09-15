import 'package:flutter/material.dart';
import 'package:testbar4/screen/layer2/p4-child/addcontanceSC.dart';

class StartChallenge extends StatelessWidget {
  final VoidCallback onStart;
  final Map<String, dynamic>? selectedChallenge; // เพิ่มตัวแปรสำหรับ challenge ที่เลือก

  const StartChallenge({super.key, required this.onStart, this.selectedChallenge});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showChallengeDetailsDialog(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Center(
          child: Text(
            'Start Challenge',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

  void _showChallengeDetailsDialog(BuildContext context) {
    if (selectedChallenge == null) {
      return;
    }

    final status = selectedChallenge!['status']; // Retrieve the challenge status

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Challenge Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${selectedChallenge!['name'] ?? 'No name'}'),
              Text('Distance: ${selectedChallenge!['distance']} meters'),
              Text('Start Date: ${selectedChallenge!['start_date'].toDate()}'),
              Text('End Date: ${selectedChallenge!['end_date'].toDate()}'),
              Text('Expend: ${selectedChallenge!['expend']}'),
            ],
          ),
          actions: [
            if (status != 'in progress') // Show the button only if status is not 'in progress'
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  onStart(); // Call the onStart callback to start the challenge
                },
                child: Text('Start'),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}



class AddChallengePage extends StatelessWidget {
  const AddChallengePage({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
         Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddChallengeSc()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Color(0xFFeaddcf),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 2,color: Colors.black)
        ),
        child: const Center(
          child: Text(
            'Add challenge(Admin)',
            style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 16),
          ),
        ),
      
      ),
      
    );
  }
}
