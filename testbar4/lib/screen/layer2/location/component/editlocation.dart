import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:testbar4/database/Fire_Location.dart';
import 'package:testbar4/screen/layer2/activity/componente/acCpEdit.dart';
import 'package:testbar4/screen/layer2/location/component/addlocation.dart';
import 'package:testbar4/screen/layer2/location/component/card.dart';
import 'package:provider/provider.dart';
import 'package:testbar4/model/provider_userData.dart';// Adjust the path accordingly


class EditlocationPage extends StatefulWidget {
  const EditlocationPage({super.key});

  @override
  State<EditlocationPage> createState() => _EditlocationPageState();
}

class _EditlocationPageState extends State<EditlocationPage> {
  

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataPV>(context); // Get the provider
    final runnerId = userDataProvider.userData?['id']; // Access the runnerId
    
    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 242, 239),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFf9f4ef),
            border: Border(bottom: BorderSide(width: 3, color: Color(0xFF0f0e17)))
          ),
        ),
        title: Text(
          "Edit Location",
          style: GoogleFonts.pixelifySans(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF0f0e17),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: Locations.fetchLocations(),  // ดึงข้อมูลตำแหน่ง
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: Colors.green, size: 50
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('ไม่พบข้อมูลตำแหน่ง'));
          }

          final documents = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final doc = documents[index].data() as Map<String, dynamic>;
              final documentID = documents[index].id; // Get the document ID

              return Column(
                children: [
                  CardForEdit(
                    docId: documentID,
                    runnerId: runnerId,
                    data: doc, // ส่งค่า data ของเอกสาร
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddLocationDialog(); // เรียกฟังก์ชันแสดงกล่องเพิ่มตำแหน่ง
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // แสดงกล่องสำหรับเพิ่มตำแหน่ง
  void _showAddLocationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final userDataPV = Provider.of<UserDataPV>(context, listen: false);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(
              color: Color(0xFF020826),
              width: 2,
            ),
          ),
          backgroundColor: const Color(0xFFf9f4ef),
          title: Text('Add Location',
            style: GoogleFonts.pixelifySans(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF0f0e17),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (userDataPV.isAdmin) // ถ้าเป็นแอดมินให้แสดงตัวเลือกเพิ่มตำแหน่งสาธารณะ
                ListTile(
                  title: Text('Public location',
                    style: GoogleFonts.pixelifySans(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF0f0e17),
                    ),
                  ),
                  onTap: () {
                    // เพิ่มตำแหน่งสาธารณะ
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddLocationPageMap(mapStatus: false,)
                      ),
                    );
                  },
                ),
              ListTile(
                title: Text('Private location',
                  style: GoogleFonts.pixelifySans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF0f0e17),
                  ),
                ),
                onTap: () {
                  // เพิ่มตำแหน่งส่วนตัว
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddLocationPageMap(mapStatus: true,)
                      ),
                    );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
