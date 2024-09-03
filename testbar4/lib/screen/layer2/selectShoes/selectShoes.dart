import 'package:flutter/material.dart';
import 'package:testbar4/database/Fire_Shoes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectShoes extends StatefulWidget {
  final Function(String) onSelect;

  const SelectShoes({Key? key, required this.onSelect}) : super(key: key);

  @override
  State<SelectShoes> createState() => _SelectShoesState();
}

class _SelectShoesState extends State<SelectShoes> {
  String? selectedShoes;

  // Function to show the modal for selecting shoes
  void _showShoeSelector(BuildContext context, List<Map<String, dynamic>> shoesData) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Select Your Shoes',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black,),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: shoesData.length,
                  itemBuilder: (context, index) {
                    String shoeName = shoesData[index]['shoesName'] as String;
                    double shoeRangeInFire = shoesData[index]['shoesRange'] as double; // Assuming `shoesRange` is a double
                    double shoesRange = ((shoeRangeInFire * 100)/1300);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 2, color: const Color.fromARGB(255, 65, 65, 65)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: 
                                ListTile(
                                  title: Text(
                                    shoeName,
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                                  ),
                                  
                                  // Non-interactive Slider to display the shoe range
                                  subtitle: Row(
                                    children: [
                                      Expanded(
                                        child: SliderTheme(
                                          data: SliderThemeData(
                                            disabledActiveTrackColor: Colors.black, // สีของ track เมื่อ slider ถูกปิดการใช้งานและเป็น active
                                            disabledInactiveTrackColor: Colors.yellow, // สีของ track เมื่อ slider ถูกปิดการใช้งานและเป็น inactive
                                            disabledThumbColor: Colors.black,
                                          ),
                                          child: Slider(
                                            value: shoesRange,
                                            min: 0, // Adjust the min value based on your requirements
                                            max: 100, // Adjust the max value based on your requirements
                                            divisions: 100, // Optional: Adjust based on your range granularity
                                            onChanged: null, // Makes the slider non-interactive
                                          ),
                                        ),
                                      ),
                                      Text('${shoeRangeInFire.toString()} Km'),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selectedShoes = shoeName; // Update the selected shoe
                                    });
                                    Navigator.pop(context); // Close the popup
                                
                                    // Send the selected shoe back to the main widget
                                    widget.onSelect(selectedShoes!);
                                  },
                                ),
                             
                          ),
                          
                       
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: const Text('Select Shoes'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: PixARTShoes.fetchShoes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No shoes found.'));
          } else {
            List<Map<String, dynamic>> shoesData = snapshot.data!
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => _showShoeSelector(context, shoesData),
                            child: const Text('Select Shoes'),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            selectedShoes != null
                                ? 'Selected Shoe: $selectedShoes'
                                : 'Not selected shoes.',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
