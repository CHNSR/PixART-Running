import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testbar4/database/Fire_Shoes.dart';
import 'package:testbar4/manage/manage_icon/icon_path.dart';

class ShoesList extends StatelessWidget {
  ShoesList({super.key});
  IconPath iconPath = IconPath();
  final PixARTShoes pixARTShoes = PixARTShoes();

  Future<void> _deleteShoes(BuildContext context, String documentID) async {
    final result = await PixARTShoes.deleteShoes(documentID);

    final snackBar = SnackBar(
      content: Text(result),
      backgroundColor: result.startsWith('Failed') ? Colors.red : Colors.green,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: PixARTShoes.fetchShoes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
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
            final documentID = doc.id; // Get the document ID

            return Card(
              margin: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(15),
                      title: Text(data['shoesName'] ?? 'Unknown'),
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
    );
  }
}
