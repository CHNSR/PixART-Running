import 'package:flutter/material.dart';

import '../../../manage/userprofile/user_path.dart';

class Profilepick extends StatefulWidget {
  const Profilepick({super.key});

  @override
  State<Profilepick> createState() => _ProfilepickState();
}
class _ProfilepickState extends State<Profilepick> {
  // ใช้ UserProfile เพื่อดึง path ของรูปภาพโปรไฟล์
  final UserProfile userProfile = UserProfile();

  // รูปภาพโปรไฟล์ที่เรากำหนดให้ผู้ใช้เลือก
  late List<String> _profilePictures;

  // ตัวแปรเก็บรูปภาพที่ผู้ใช้เลือก
  String _selectedProfile = '';

  @override
  void initState() {
    super.initState();

    // ดึงเฉพาะ values จาก userProfilePath
    _profilePictures = userProfile.userProfilePath.values.toList();

    // ตรวจสอบว่ามีรูปในรายการหรือไม่
    if (_profilePictures.isNotEmpty) {
      _selectedProfile = _profilePictures[0];
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
          // แสดงรูปโปรไฟล์ที่เลือก
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text("Selected Profile Picture"),
                const SizedBox(height: 16),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _selectedProfile.isNotEmpty
                      ? AssetImage(_selectedProfile)
                      : null,
                ),
              ],
            ),
          ),
          const Divider(),
          // GridView สำหรับเลือกรูป
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // จำนวนคอลัมน์ใน Grid
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: _profilePictures.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedProfile = _profilePictures[index];
                    });
                  },
                  child: CircleAvatar(
                    backgroundImage: AssetImage(_profilePictures[index]),
                    radius: 50,
                    child: _selectedProfile == _profilePictures[index]
                        ? Icon(Icons.check_circle, color: Colors.green, size: 30)
                        : null,
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // ส่งรูปโปรไฟล์ที่เลือกกลับไปหน้าโปรไฟล์
              Navigator.pop(context, _selectedProfile);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
