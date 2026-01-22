import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../manage/userprofile/user_path.dart';
import 'package:testbar4/routes/export.dart';

class Profilepick extends StatefulWidget {
  const Profilepick({super.key});

  @override
  State<Profilepick> createState() => _ProfilepickState();
}

class _ProfilepickState extends State<Profilepick> {
  final UserProfile userProfile = UserProfile();

  // กำหนดให้ `_profilePictures` เป็นรายการของคีย์แทน path ของรูปภาพ
  late List<String> _profileKeys;

  // เก็บคีย์ของรูปที่เลือก
  String _selectedProfileKey = '';

  @override
  void initState() {
    super.initState();

    // ดึงคีย์ของรูปภาพทั้งหมดจาก userProfilePath
    _profileKeys = userProfile.userProfilePath.keys.toList();

    // กำหนดค่าเริ่มต้นให้ _selectedProfileKey ถ้ามีรูปในรายการ
    if (_profileKeys.isNotEmpty) {
      _selectedProfileKey = _profileKeys[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Profile Picture"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text("Selected Profile Picture"),
                const SizedBox(height: 16),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(
                    userProfile.userProfileImg(_selectedProfileKey),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: _profileKeys.length,
              itemBuilder: (context, index) {
                String key = _profileKeys[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedProfileKey = key;
                    });
                  },
                  child: CircleAvatar(
                    backgroundImage: AssetImage(
                      userProfile.userProfileImg(key),
                    ),
                    radius: 50,
                    child: _selectedProfileKey == key
                        ? Icon(Icons.check_circle,
                            color: const Color.fromARGB(255, 255, 131, 122),
                            size: 30)
                        : null,
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // อัปเดตรูปโปรไฟล์ใน Firestore โดยใช้คีย์ของรูปภาพที่เลือก
              await PixARTUser.updateProfilePic(
                context: context,
                profilePic: userProfile.userProfileImg(_selectedProfileKey),
              );
              // รีเฟรชข้อมูลผู้ใช้
              Provider.of<UserDataPV>(context, listen: false).refreshUserData();
              Navigator.pop(context, _selectedProfileKey);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
