import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testbar4/screen/p1_home.dart';
import 'package:testbar4/screen/p2_location.dart';
import 'package:testbar4/screen/p3_run.dart';
import 'package:testbar4/screen/p4_plan.dart';
import 'package:testbar4/screen/p5_profile.dart';
import 'manage/manage_icon/icon_path.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int currentPageIndex = 0;
  // var for map nav bar with class
  final IconPath iconPath = IconPath();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0), // ขนาดของ AppBar
        child: AppBar(
          automaticallyImplyLeading: false, // ปิดปุ่มกลับ
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              /*
              gradient: LinearGradient(
                colors: [Color(0xFF1a2e05), Color(0xFF3f6212)], // ใส่สีของ Gradient
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              */
              color: Color(0xFFf9f4ef),
              border: Border(bottom: BorderSide(width: 3,color: Color(0xFF0f0e17)))
            ),
          ),
          title: Text(
            "PixART Running",
            style: GoogleFonts.pixelifySans(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0f0e17),
            ),
          ),
          backgroundColor: Colors.transparent, // ตั้งค่าพื้นหลังของ AppBar เป็นโปร่งใส
        ),
      ),

      //Nav bar
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          /*
          gradient: LinearGradient(
           colors: [ Color(0xFF365314),Color(0xFF3f6212)], // ใส่สีของ Gradient
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
          ),
          */
          color: Color(0xFFf9f4ef),
          //borderRadius: BorderRadius.circular(10),
          border: Border(top: BorderSide(color: Color(0xFF0f0e17),width: 3)),
          
        ),
        child: NavigationBar(
          //backgroundColor: const Color(0xFFbef264),
          indicatorColor: const Color(0xFFebeaf4),
          backgroundColor: Colors.transparent,
          indicatorShape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: <NavigationDestination>[
            NavigationDestination(
              selectedIcon: Image.asset(
                iconPath.appBarIcon("home_outline"),
                width: 36,
                height: 36,
              ),
              icon: Image.asset(
                iconPath.appBarIcon("home_outline"),
                width: 40,
                height: 40,
              ),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Image.asset(
                iconPath.appBarIcon("location_outline"),
                width: 36,
                height: 36,
              ),
              icon: Image.asset(
                iconPath.appBarIcon("location_outline"),
                width: 40,
                height: 40,
              ),
              label: 'Location',
            ),
            NavigationDestination(
              selectedIcon: Image.asset(
                iconPath.appBarIcon("run_outline"),
                width: 40,
                height: 40,
              ),
              icon: Image.asset(
                iconPath.appBarIcon("run_outline"),
                width: 45,
                height: 45,
              ),
              label: 'Run',
            ),
            NavigationDestination(
              selectedIcon: Image.asset(
                iconPath.appBarIcon("plan_outline"),
                width: 36,
                height: 36,
              ),
              icon: Image.asset(
                iconPath.appBarIcon("plan_outline"),
                width: 40,
                height: 40,
              ),
              label: 'Challenge',
            ),
            NavigationDestination(
              selectedIcon: Image.asset(
                iconPath.appBarIcon("profile_outline"),
                width: 36,
                height: 36,
              ),
              icon: Image.asset(
                iconPath.appBarIcon("profile_outline"),
                width: 40,
                height: 40,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: <Widget>[
          P1Home(),
          P2Location(),
          P3Run(),
          P4Plan(),
          P5Profile(),
        ],
      ),
    );
  }
}
