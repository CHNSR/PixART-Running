import 'package:flutter/material.dart';
//mport 'pages/home.dart';
import 'pages/location.dart';
import 'pages/maps.dart';
import 'pages/settings.dart';
import 'pages/testlocationmark.dart';
import 'pages/profile.dart';
import 'pages/buttom/barrun2.dart';
import '../db/db.dart';
import '../model/entry.dart';
import '../widgets/entry_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text("First Running Tracking"),
            backgroundColor: Colors.deepOrange[200],
          ),
          body: Column(
            children: [
              const Expanded(
                flex: 9,
                child: HomeContent(),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 1,
                child: Container(
                  color: Colors.red,
                  child: Barrun(),
                ),
              )
            ],
          )),
      routes: {
        '/home': (context) => const HomeContent(),
        '/location': (context) => const LocationPage(),
        '/maps': (context) => MapPage(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
      }, //ProfilePage(), //HomePage(), //MapScreenMarker(),
    );
  }
}

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
