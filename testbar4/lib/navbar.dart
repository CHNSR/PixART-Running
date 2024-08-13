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
      appBar: AppBar(
        title: Text(
          "PixART Running",
          style: GoogleFonts.pixelifySans(
              fontSize: 30, fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xFFF49D0C),
        automaticallyImplyLeading: false, // ปิดปุ่มกลับ
      ),

      //Nav bar
      bottomNavigationBar: SizedBox(
        height: 80,
        child: NavigationBar(
          backgroundColor: const Color(0xFFfde68a),
          indicatorColor: const Color.fromARGB(255, 255, 219, 59),
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
              label: 'Plan',
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
