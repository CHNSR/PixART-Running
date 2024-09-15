import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:testbar4/database/Fire_Challenge.dart';
import 'package:testbar4/grobleCP/ColorPicker.dart';

class AddChallengeSc extends StatefulWidget {
  const AddChallengeSc({super.key});

  @override
  _AddChallengeScState createState() => _AddChallengeScState();
}

class _AddChallengeScState extends State<AddChallengeSc> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _expendController = TextEditingController();
  //final TextEditingController _cardColorController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  Color _cardColor = Colors.blue; // Default color

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

  Color _parseColor(String colorString) {
    // Convert hex string to Color
    final buffer = StringBuffer();
    if (colorString.length == 6 || colorString.length == 7) buffer.write('ff'); // Add opacity if needed
    buffer.write(colorString.replaceAll('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

 void _updateCardColor(Color newColor) {
  setState(() {
    _cardColor = newColor; // Update the card color with the selected color
  });
  print("[AddChallenge][_updateCardColor] :$_cardColor");
}



  Future<void> _submitChallenge() async {
    if (_startDate != null && _endDate != null) {
      try {
        await Challenge.addChallenge(
          name: _nameController.text,
          distance: double.parse(_distanceController.text),
          startDate: _startDate!,
          endDate: _endDate!,
          expend: _expendController.text,
          color: colorToHex(_cardColor),
          context: context,
        );
        print('Challenge added successfully');
      } catch (e) {
        print('Error adding challenge: $e');
      }
    } else {
      print('Please select start and end dates');
    }
  }

  Future<void> _showChallengePreview() async {
    print('[P4-child][addChallenge] check _showChallenge is start');
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          title: const Text("Preview Challenge"),
          titleTextStyle: GoogleFonts.pixelifySans(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0f0e17),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // กำหนด BorderRadius ให้มน
            side: BorderSide(
              color: Color(0xFF020826),
              width: 2,
            ),
          ),
          
          backgroundColor: Color(0xFFf9f4ef),
          content: SingleChildScrollView(
            child: 
                 SizedBox(
                  height: 300,
                   child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40, 8, 40, 20),
                        child: SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: _buildChallengeCard(
                            _nameController.text,
                            _expendController.text,
                            double.tryParse(_distanceController.text) ?? 0.0,
                            _startDate!,
                            _endDate!,
                            _cardColor,
                            Colors.white,
                          ),
                        ),
                      ),
                      Center(
                        child: Row(
                          children: [
                            
                            Expanded(
                              child: GestureDetector(
                              onTap: () {
                                _submitChallenge(); // Call submit challenge function
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child:  Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color(0xFFff8ba7),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 2,
                                    color: Color(0xFF020826),
                                  )
                                  
                                ),
                                child: Center(child: Text("Save"))
                                ),
                                                      ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: 
                                 GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  child:  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                    color: Color(0xFFc3f0ca),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 2,
                                      color: Color(0xFF020826)
                                    )
                                  ),
                                    child: Center(child: Text("Cancel"))
                                  ),
                                ),
                              ),
                            
                          ],
                          
                        ),
                      ),
                      
                    ],
                                   ),
                 ),
              
            
            
          ),
          
        );
      
    },
  );
}
    // Function to convert Color to a hex string
  String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0')}';
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf9f4ef),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Color(0xFFf9f4ef),
            border: Border(
              bottom: BorderSide(width: 3,color: Color(0xFF0f0e17))
            )
          ),
        ),
        title: Text(
                "Add Challenge",
                style: GoogleFonts.pixelifySans(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0f0e17),
                ),
              ),
         
        backgroundColor: Colors.transparent,

      ),
      body: ListView(
        children: [
          Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Color(0xFFf9f4ef),
            
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF020826),width: 1),
                    ),
                    fillColor: const Color(0xFFf9f4ef),
                    filled: true,
                    labelText: 'Name',
                    labelStyle: const TextStyle(
                      fontFamily: 'Jersey25',
                      fontSize: 16,
                      color: Color(0xFF020826)
                    ),
        
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _distanceController,
                  decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF020826),width: 1),
                    ),
                    fillColor: const Color(0xFFf9f4ef),
                    filled: true,
                    labelText: 'Distance',
                    labelStyle: const TextStyle(
                      fontFamily: 'Jersey25',
                      fontSize: 16,
                      color: Color(0xFF020826)
                    ),),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  
                  controller: _expendController,
                  decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF020826),width: 1),
                    ),
                    fillColor: const Color(0xFFf9f4ef),
                    filled: true,
                    labelText: 'Expend',
                    labelStyle: const TextStyle(
                      fontFamily: 'Jersey25',
                      fontSize: 16,
                      color: Color(0xFF020826)
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                  child: ColorPickerCP(
                    onColorChanged: (Color color) {
                    setState(() {
                      _cardColor = color; // อัปเดตสีของการ์ด
                    });
                    },
                          ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                          width: 1,
                          color: Colors.black
                          ),
                          color: Color(0xFFeaddcf)
                        ),
                        child: Center(
                          child: GestureDetector(
                            onTap: () => _pickDate(context, true),
                            child: FittedBox(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(_startDate == null
                                      ? 'Select Start Date'
                                      : DateFormat('yyyy-MM-dd').format(_startDate!)),
                              ),
                              
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                          width: 1,
                          color: Colors.black
                          ),
                          color: Color(0xFFeaddcf)
                        ),
                        child: Center(
                          child: GestureDetector(
                            onTap: () => _pickDate(context, false),
                            child: FittedBox(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(_endDate == null
                                    ? 'Select End Date'
                                    :  DateFormat('yyyy-MM-dd').format(_startDate!)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                          width: 1,
                          color: Colors.black
                          ),
                          color: Color(0xFF020826)
                        ),
                  child: Center(
                    child: GestureDetector(
                      onTap: _showChallengePreview,
                      child: const Text('Preview',style: TextStyle(color: Color(0xFFf9f4ef),fontSize: 18,fontWeight: FontWeight.w400),),
                    ),
                  ),
                ),
              ),
              
                
            ],
          ),
        ),
        ]
      ),
    );
  }
  
  Widget _buildChallengeCard(String name, String expend, double distance, DateTime startDate, DateTime endDate, Color mainCardColor, Color footCardcolor) {
  Color statusColor;
  String status = 'in progress';

  switch (status) {
    case 'Not register':
      statusColor = Colors.yellow;
      break;
    case 'in progress':
      statusColor = Colors.blue;
      break;
    case 'passed':
      statusColor = Colors.green;
      break;
    default:
      statusColor = Colors.red;
  }

  return Container(
    height: 125,
    width: 100,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: mainCardColor,
      borderRadius: BorderRadius.circular(5),
      border: Border.all(width: 2, color: Colors.black),
    ),
    child: Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 8,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis, // จำกัดให้ตัวหนังสือไม่ล้นออกจากกล่อง
                  maxLines: 1, // จำกัดจำนวนบรรทัด
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: footCardcolor,
                ),
                alignment: Alignment.center,
                child: FittedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Expend: $expend',
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Text(
                        'Distance: ${(distance/1000).toStringAsFixed(2)} meters',
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Text(
                        'Start Date: $startDate',
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      Text(
                        'End Date: $endDate',
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      Text(
                        'Status: $status',
                        style: TextStyle(fontSize: 14, color: statusColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        
      ],
    ),
  );
}

}
