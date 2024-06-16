import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final double coverHeight = 280;
  final double profileHeight = 144;

  @override
  Widget build(BuildContext context) {
    final top = coverHeight - profileHeight / 2;
    final bottom = profileHeight / 2;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              buildCoverImg(),
              Positioned(
                top: top,
                child: buildProfileimg(),
              ),
            ],
          ),
          buildProfileContent(),
          const SizedBox(
            height: 10,
          ),
          bestrec(),
        ],
      ),
    );
  }

  Widget buildProfileimg() => Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color.fromARGB(255, 133, 133, 133),
              width: 4.0,
            )),
        child: CircleAvatar(
          radius: profileHeight / 2,
          backgroundImage: const AssetImage("assests/img/icon_persion-man.png"),
          backgroundColor: const Color.fromARGB(255, 255, 114, 114),
        ),
      );

  Widget buildCoverImg() => Container(
        color: const Color.fromARGB(255, 223, 223, 223),
        child: Image.asset(
          "assests/img/runner.png",
          width: double.infinity,
          height: coverHeight,
          fit: BoxFit.cover,
        ),
      );

  Widget buildProfileContent() => Column(
        children: [
          SizedBox(height: profileHeight / 2),
          Text(
            'Username',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'AVG pace => 6.50',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width *
                0.9, // กำหนดความกว้าง 80% ของขอบจอ
            height: 200, // กำหนดความสูง
            padding: EdgeInsets.all(16.0), // เพิ่ม padding ภายในกล่อง
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 142, 77),
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ), // พื้นหลังสีส้ม
              borderRadius:
                  BorderRadius.circular(8.0), // ขอบกล่องโค้งมน (optional)
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My progress',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(height: 8),
                Padding(
                  padding:
                      EdgeInsets.only(left: 16.0), // เพิ่มย่อหน้าให้กับข้อความ
                  child: Column(
                    children: [
                      Text(
                        'Total distance',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      Text(
                        "1545 Km",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Finish Location",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    "15",
                    style: TextStyle(fontSize: 26, color: Colors.white),
                  ),
                )

                // เพิ่มข้อมูลที่ต้องการเพิ่มเติมในนี้
              ],
            ),
          ),
        ],
      );

  Widget bestrec() => Column(
        children: [
          Container(
            height: 400,
            width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 142, 77),
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ), // พื้นหลังสีส้ม
              borderRadius:
                  BorderRadius.circular(8.0), // ขอบกล่องโค้งมน (optional)
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    "Best reccord",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
