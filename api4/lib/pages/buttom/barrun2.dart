import 'package:flutter/material.dart';
import '../home.dart';
import '../location.dart';
import '../maps.dart';
import '../profile.dart';
import '../settings.dart';

class Barrun extends StatefulWidget {
  const Barrun({super.key});

  @override
  State<Barrun> createState() => _BarrunState();
}

class _BarrunState extends State<Barrun> {
  int _selectedIndex = 0; //for bar

  final List<Widget> _pades = [
    HomeContent(),
    LocationPage(),
    MapPage(),
    ProfilePage(),
    SettingsPage()
  ];

  void _onItemTappedNavigatorBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return barRun(context);
  }

  Scaffold barRun(BuildContext context) {
    return Scaffold(
      floatingActionButton: _selectedIndex == 0
          ? Container(
              height: 65.0,
              width: 65.0,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/maps');
                },
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 6.0,
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTappedNavigatorBar,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(
                  icon: Icon(Icons.location_city), label: 'Location'),
              NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
              NavigationDestination(
                  icon: Icon(Icons.settings_rounded), label: 'Settings'),
            ],
            animationDuration: const Duration(milliseconds: 1000),
          )),
    );
  }
}
