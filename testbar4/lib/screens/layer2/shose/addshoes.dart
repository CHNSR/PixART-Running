import 'package:flutter/material.dart';
import 'package:testbar4/routes/export.dart';

class Addshoes extends StatefulWidget {
  Addshoes({super.key});

  @override
  State<Addshoes> createState() => _AddshoesState();
}

class _AddshoesState extends State<Addshoes> {
  IconPath iconPath = IconPath();

  final shoesNameController = TextEditingController();
  final dateController = TextEditingController();
  final distanceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Transform.rotate(
            angle: 3.14, // 180 degrees in radians (π radians)
            child: Image.asset(iconPath.appBarIcon("arrowR_outline")),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFFFFEEA),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            const SizedBox(height: 40),

            //logo running pic
            Image.asset(
              iconPath.appBarIcon("running_img"),
              height: 200,
              width: 200,
            ),

            const SizedBox(height: 40),

            Text(
              "Add Shoes",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey),
            ),

            const SizedBox(
              height: 25,
            ),

            //input txt Name of shoes
            AddTxtField(
              controller: shoesNameController,
              hintText: "Name of shoes",
            ),

            /*
            Padding(
              padding: const EdgeInsets.fromLTRB(33, 25, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "If you add old shoes you must check box.",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            //input start date
            
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Checkbokfordate()],
                ),
              ),
            ),
            */
            const SizedBox(
              height: 20,
            ),
            //input date if the old shoes
            BirthdayTextField(
              controller: dateController,
              hintText: "Enter you start date of shoes",
            ),

            const SizedBox(
              height: 20,
            ),
            //Range of shoes input
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: AddRangeOfShoes(
                controller: distanceController,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            //add button
            AddShoesButton(
                NameOfShoesController: shoesNameController,
                DateOfShoesController: dateController,
                DistanceOfShoesController: distanceController)
          ],
        )),
      ),
    );
  }
}
