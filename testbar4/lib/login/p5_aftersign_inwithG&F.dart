import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdditionalInfoScreen extends StatefulWidget {
  final User user;

  const AdditionalInfoScreen({Key? key, required this.user}) : super(key: key);

  @override
  _AdditionalInfoScreenState createState() => _AdditionalInfoScreenState();
}

class _AdditionalInfoScreenState extends State<AdditionalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weeklyGoalController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _saveUserDataToFirestore() async {
    if (_formKey.currentState!.validate()) {
      // ข้อมูลที่ผู้ใช้ป้อนมีความถูกต้อง
      try {
        final userData = {
          "id": widget.user.uid,
          "name": widget.user.displayName ?? '',
          "username": widget.user.email ?? '',
          "role": "user",
          "weight": double.parse(_weightController.text),
          "height": double.parse(_heightController.text),
          "weekly_goal": int.parse(_weeklyGoalController.text),
          "birthday": Timestamp.fromDate(_selectedDate ?? DateTime.now()),
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user.uid)
            .set(userData);

        // นำทางไปยังหน้าหลักหลังจากบันทึกข้อมูลเสร็จแล้ว
        Navigator.pushReplacementNamed(context, '/');
      } catch (e) {
        print('Error saving user data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save user data. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Complete Your Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your height';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _weeklyGoalController,
                decoration: InputDecoration(labelText: 'Weekly Goal'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weekly goal';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text(_selectedDate == null
                    ? 'Select your birthday'
                    : 'Birthday: ${_selectedDate!.toLocal()}'.split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null && pickedDate != _selectedDate) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUserDataToFirestore,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
