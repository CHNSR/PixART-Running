import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:testbar4/services/firebase_service/Fire_Shoes.dart';

class AddTxtField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const AddTxtField(
      {super.key, required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: const Color.fromARGB(255, 255, 0, 0)),
          ),
          fillColor: const Color.fromARGB(255, 249, 250, 212),
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }
}

class AddNumTxtField extends StatelessWidget {
  const AddNumTxtField({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// Checkbox widget
class Checkbokfordate extends StatefulWidget {
  const Checkbokfordate({super.key});

  @override
  State<Checkbokfordate> createState() => _CheckbokState();
}

class _CheckbokState extends State<Checkbokfordate> {
  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: isCheck,
      onChanged: (bool? value) {
        setState(() {
          isCheck = value!;
        });
      },
      activeColor: Colors.orange,
      checkColor: Colors.white,
      hoverColor: Colors.grey,
      focusColor: Colors.yellow,
      splashRadius: 20,
    );
  }
}

// Date picker widget

class BirthdayTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hinttext;

  const BirthdayTextField(
      {super.key, required this.controller, required this.hinttext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          fillColor: const Color.fromARGB(255, 249, 250, 212),
          filled: true,
          hintText: hinttext,
          hintStyle: const TextStyle(color: Colors.grey),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            controller.text =
                "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
          }
        },
      ),
    );
  }
}

//add range of shoes
class AddRangeOfShoes extends StatefulWidget {
  final TextEditingController controller;
  AddRangeOfShoes({super.key, required this.controller});

  @override
  State<AddRangeOfShoes> createState() => _AddRangeOfShoesState();
}

class _AddRangeOfShoesState extends State<AddRangeOfShoes> {
  double _currentValue = 0;

  @override
  void initState() {
    super.initState();
    // Initialize controller value
    widget.controller.text = _currentValue.toStringAsFixed(0);
  }

  void _updateController(double value) {
    // Update the controller with the current slider value
    widget.controller.text = value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 25,
            ),
            Text('Shoes distance : ${_currentValue.toStringAsFixed(0)}'),
          ],
        ),
        Slider(
          value: _currentValue,
          min: 0,
          max: 1300,
          divisions: 1300,
          label: _currentValue.toStringAsFixed(0),
          activeColor: Colors.black,
          inactiveColor: Colors.yellow,
          onChanged: (value) {
            setState(() {
              _currentValue = value;
              _updateController(
                  value); // Update controller when slider value changes
            });
          },
        ),
      ],
    );
  }
}

//add shoes button
class AddShoesButton extends StatelessWidget {
  final TextEditingController NameOfShoesController;
  final TextEditingController DateOfShoesController;
  final TextEditingController DistanceOfShoesController;
  final PixARTShoes pixARTShoes = PixARTShoes();

  AddShoesButton({
    super.key,
    required this.NameOfShoesController,
    required this.DateOfShoesController,
    required this.DistanceOfShoesController,
  });

  Future<void> _addShoes(BuildContext context) async {
    final nameShoes = NameOfShoesController.text;
    final distanceShoesString = DistanceOfShoesController.text;
    final dateShoes = DateOfShoesController.text;

    // Validation fields Empty?
    if (nameShoes.isEmpty || dateShoes.isEmpty || distanceShoesString.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please enter every field.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return; // Exit the function if validation fails
    }

    // Convert distanceShoesString to double
    double? distanceShoes;
    try {
      distanceShoes = double.parse(distanceShoesString);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Invalid distance format.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    try {
      // Add shoes in Firebase
      await PixARTShoes.addShoes(
        shoesName: nameShoes,
        shoesRange: distanceShoes,
        startUse: dateShoes,
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Shoes added successfully!",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      // Clear the text controllers
      NameOfShoesController.clear();
      DateOfShoesController.clear();
      DistanceOfShoesController.clear();

      // Navigator to manage shoes page
      Navigator.pushNamed(context, "/p11");
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to add shoes: $e",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _addShoes(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Center(
          child: Text(
            'Add Shoes',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
