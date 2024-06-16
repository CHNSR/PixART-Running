/*
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../db/db.dart';
import '../model/entry.dart';
import '../pages/maps.dart';
import '../widgets/entry_card.dart';
import '../pages/location.dart';
import '../pages/profile.dart';
import '../pages/settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // for changing screen

  final GlobalKey<_HomeContentState> _homeContentKey =
      GlobalKey<_HomeContentState>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = <Widget>[
      HomeContent(key: _homeContentKey), // Pass GlobalKey to HomeContent
      const LocationPage(),

      const ProfilePage(),
      const SettingsPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("First Running Tracking"),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapPage()),
                ).then((value) {
                  if (value != null) {
                    _homeContentKey.currentState?._addEntries(value as Entry);
                  }
                });
              },
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(
                icon: Icon(Icons.location_city), label: 'Location'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
            NavigationDestination(
                icon: Icon(Icons.settings_rounded), label: 'Settings'),
          ],
          animationDuration: const Duration(milliseconds: 1000),
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late List<Entry> _data = [];
  List<EntryCard> _cards = [];

  @override
  void initState() {
    super.initState();
    DB.init().then((value) => _fetchEntries());
  }

  void _fetchEntries() async {
    _cards = [];
    List<Map<String, dynamic>> _results = await DB.query(Entry.table);
    _data = _results.map((item) => Entry.fromMap(item)).toList();
    _data.forEach((element) => _cards.add(EntryCard(entry: element)));
    setState(() {});
  }

  void _addEntries(Entry? en) async {
    if (en != null) {
      await DB.insert(Entry.table, en);
      _fetchEntries();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _cards,
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../db/db.dart';
import '../model/entry.dart';
import '../widgets/entry_card.dart';
import '../pages/location.dart';
import '../pages/profile.dart';
import '../pages/settings.dart';
import 'buttom/barrun2.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => HomeContentState();
}

class HomeContentState extends State<HomeContent> {
  late List<Entry> _data = [];
  List<EntryCard> _cards = [];

  @override
  void initState() {
    super.initState();
    DB.init().then((value) => _fetchEntries());
  }

  void _fetchEntries() async {
    _cards = [];
    List<Map<String, dynamic>> _results = await DB.query(Entry.table);
    _data = _results.map((item) => Entry.fromMap(item)).toList();
    _data.forEach((element) => _cards.add(EntryCard(entry: element)));
    setState(() {});
  }

  void addEntries(Entry? en) async {
    if (en != null) {
      await DB.insert(Entry.table, en);
      _fetchEntries();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _cards,
    );
  }
}
