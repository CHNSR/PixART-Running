import 'package:flutter/material.dart';
import 'package:testbar4/database/Fire_Challenge.dart';

class AddChallengeSc extends StatefulWidget {
  const AddChallengeSc({super.key});

  @override
  _AddChallengeScState createState() => _AddChallengeScState();
}

class _AddChallengeScState extends State<AddChallengeSc> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _expendController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

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
      });
    }
  }

  Future<void> _submitChallenge() async {
    if (_startDate != null && _endDate != null) {
      try {
        await Challenge.addChallenge(
          name: _nameController.text,
          distance: double.parse(_distanceController.text),
          startDate: _startDate!,
          endDate: _endDate!,
          expend: _expendController.text, // Assuming expend is a String
        );
        print('Challenge added successfully');
      } catch (e) {
        print('Error adding challenge: $e');
      }
    } else {
      print('Please select start and end dates');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Challenge')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _distanceController,
              decoration: const InputDecoration(labelText: 'Distance'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _expendController,
              decoration: const InputDecoration(labelText: 'Expend'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => _pickDate(context, true),
                  child: Text(_startDate == null
                      ? 'Select Start Date'
                      : _startDate.toString()),
                ),
                TextButton(
                  onPressed: () => _pickDate(context, false),
                  child: Text(_endDate == null
                      ? 'Select End Date'
                      : _endDate.toString()),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _submitChallenge,
              child: const Text('Add Challenge'),
            ),
          ],
        ),
      ),
    );
  }
}
