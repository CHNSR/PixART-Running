import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testbar4/manage/manage_icon/icon_path.dart';
import 'package:testbar4/screen/layer2/shose/components/addshoescomP.dart';
import 'package:testbar4/screen/layer2/shose/components/shoescomP.dart';
import 'package:testbar4/database/Fire_Shoes.dart';

class Shoes extends StatelessWidget {
  Shoes({super.key});
  IconPath iconPath = IconPath();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, "/main"),
          icon: Transform.rotate(
            angle: 3.14, // 180 องศาในเรเดียน (π เรเดียน)
            child: Image.asset(iconPath.appBarIcon("arrowR_outline")),
          ),
        ),
        actions: [
          Text("Add Shoes"),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/p12");
            },
            icon: Image.asset(iconPath.appBarIcon("add_outline")),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFFFFEEA),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),

              // โลโก้ภาพการวิ่ง
              Image.asset(
                iconPath.appBarIcon("running_img"),
                height: 200,
                width: 200,
              ),

              const SizedBox(height: 40),

              Text(
                "My Shoes",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey),
              ),
              // คอนเทนเนอร์สำหรับ StreamBuilder ของรองเท้า
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.deepOrange[200]),
                    height: 800,
                    width: double.maxFinite,
                    child: StreamBuilder<List<DocumentSnapshot>>(
                      stream: PixARTShoes.streamShoes(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No shoes found'));
                        }

                        final documents = snapshot.data!;

                        return ListView.builder(
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            final doc = documents[index];
                            final data = doc.data() as Map<String, dynamic>;
                            final documentID = doc.id; // ดึง ID เอกสาร

                            return Card(
                              margin: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(15),
                                      title:
                                          Text(data['shoesName'] ?? 'Unknown'),
                                      subtitle: Text(
                                          'Range: ${data['shoesRange'] ?? 'Unknown'}\nStart Use: ${data['startUse'] ?? 'Unknown'}'),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _deleteShoes(context, documentID);
                                    },
                                    icon: Image.asset(
                                        width: 30,
                                        height: 30,
                                        iconPath.appBarIcon("delete_outline")),
                                    iconSize: 40,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    )),
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteShoes(BuildContext context, String documentID) async {
    final result = await PixARTShoes.deleteShoes(documentID);

    final snackBar = SnackBar(
      content: Text(result),
      backgroundColor: result.startsWith('Failed') ? Colors.red : Colors.green,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
