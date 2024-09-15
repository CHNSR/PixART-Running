import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class ColorPickerCP extends StatefulWidget {
  final Function(Color) onColorChanged; 
  const ColorPickerCP({super.key , required this.onColorChanged});

  @override
  State<ColorPickerCP> createState() => _ColorPickerCPState();
}

class _ColorPickerCPState extends State<ColorPickerCP> {
  // ตัวแปรสำหรับเก็บสีที่เลือก
  Color currentColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('Select card color ',
            style: TextStyle(fontFamily: 'Jersey25',
                          fontSize: 20,
                          color: Color(0xFF020826)),
          ),
          subtitle: Text(
            '${ColorTools.materialNameAndCode(currentColor)} ',
            style: TextStyle(fontFamily: 'Jersey25',
                          fontSize: 16,
                          color: Color(0xFF020826)),
          
          ),
          trailing: ColorIndicator(
            width: 44,
            height: 44,
            borderRadius: 5,
            color: currentColor,
            hasBorder: true,
            borderColor: Colors.grey,
          ),
        ),
        // ปุ่มเปิดตัวเลือกสี
        
          Row(
            children: [
              Expanded(child: SizedBox()),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 8, 8),
                child: GestureDetector(
                  onTap: () async {
                    final Color? selectedColor = await showDialog(
                      context: context,
                      builder: (context) {
                        return SingleChildScrollView(
                          child: AlertDialog(
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15), // กำหนด BorderRadius ให้มน
                            side: BorderSide(
                              color: Color(0xFF020826),
                              width: 2,
                            ),
                          ),
              
                            title: const Text('Select Color', 
                              style: TextStyle(fontFamily: 'Jersey25',
                              fontSize: 16,
                              color: Color(0xFF020826)),
                            ),
                            content: ColorPicker(
                              color: currentColor,
                              onColorChanged: (Color color) {
                                setState(() {
                                  currentColor = color;
                                });
                              },
                              width: 44,
                              height: 44,
                              borderRadius: 22,
                              heading: Text(
                                'Pick a color',
                                style: TextStyle(fontFamily: 'Jersey25',
                                fontSize: 16,
                                color: Color(0xFF020826)),
                              ),
                              subheading: Text(
                                'Select color shade',
                                style: TextStyle(fontFamily: 'Jersey25',
                                fontSize: 16,
                                color: Color(0xFF020826)),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                Navigator.of(context).pop(currentColor); // ปิด dialog
                                widget.onColorChanged(currentColor); // เรียก callback เพื่ออัปเดตสีที่ถูกเลือก
                              },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                
                    if (selectedColor != null) {
                      setState(() {
                        currentColor = selectedColor;
                      });
                    }
                  },
                  child: const Text('Pick a Color'),
                ),
              ),
            ],
          ),
        
      ],
    );
  }
}
