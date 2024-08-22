import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testbar4/database/Fire_Activity.dart';
import 'package:testbar4/database/Fire_User.dart';
import 'package:testbar4/manage/manage_icon/icon_path.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:testbar4/model/provider_userData.dart';

class P5Profile extends StatelessWidget {
  P5Profile({super.key});
  IconPath iconPath = IconPath();

  static fetchAndDisplayDuration(String key) async {
    final durationData = await Activity.fetchLongestDuration();
    print('[P5][fetchAndDisplayDuration] ----> : $durationData');
    if (durationData != null) {
      if (key == 'date') {
        return durationData['date'];
      } else if (key == 'time') {
        return durationData['time'];
      }
    } else {
      return 'null';
    }
  }

  //fetch best Distance
  static fetchAndDisplayDistance(String key) async {
    final durationData = await Activity.fetchLongestDistance();
    print('[P5][fetchAndDisplayDistance] ----> : $durationData');
    if (durationData != null) {
      if (key == 'date') {
        return durationData['date'];
      } else if (key == 'distance') {
        return durationData['distance'];
      }
    } else {
      return 'null';
    }
  }

  //fetch bestPace
  static fetchAndDisplayBestPace(String key) async {
    final durationData = await Activity.fetchBestPace();
    print('[P5][fetchAndDisplayBestPace] ----> : $durationData');
    if (durationData != null) {
      if (key == 'date') {
        return durationData['date'];
      } else if (key == 'AVGpace') {
        return durationData['AVGpace'];
      }
    } else {
      return 'null';
    }
  }

  //logout func
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    print('Logout successful');
    Navigator.pushNamed(context, '/p7');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataPV>(builder: (context, userDataProvider, child) {
      final userData = userDataProvider.userData;
      print("[P5]-------------------------${userData}------------------");
      final name = userData?['name'] ?? 'error';
      return Scaffold(
        backgroundColor: const Color(0xFFFFFEEA),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Profile',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150'), // URL รูปโปรไฟล์
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 30),
                Divider(),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: Image.asset(
                            iconPath.appBarIcon('setting_outline'),
                            height: 40,
                            width: 40,
                          ),
                          title: Text('Edite Profile'),
                          subtitle: Text(
                              FirebaseAuth.instance.currentUser?.email ??
                                  "unknow"),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right_outlined),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, '/p10'); // Replace with your route name
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                //logout
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/p11");
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            leading: Image.asset(
                              iconPath.appBarIcon('shoes_outline'),
                              width: 40,
                              height: 40,
                            ),
                            title: Text('My Shoes'),
                            //subtitle: Text('chanonsukrod@gmail.com'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () => _logout(context),
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            leading: Image.asset(
                              iconPath.appBarIcon('logout_outline'),
                              width: 40,
                              height: 40,
                            ),
                            title: Text('Logout'),
                            //subtitle: Text('chanonsukrod@gmail.com'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                        color: Colors.deepOrange[100],
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.run_circle_outlined),
                          title: Text(
                            'My progress',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            '418 KM',
                            style: TextStyle(fontSize: 45),
                          ),
                          subtitle: Text('Total Km'),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                color: Colors.red,
                                height: 200,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.yellow,
                                height: 200,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.green,
                                height: 200,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                //best reccord

                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                        color: Colors.deepOrange[100],
                        borderRadius: BorderRadius.circular(5)),
                    child: Expanded(
                        child: Column(
                      children: [
                        Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.topLeft,
                            child: const Text(
                              "Best reccord",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            )),
                        const SizedBox(
                          height: 2,
                        ),
                        //Longest distance
                        BestRecCard(
                            iconPath: 'coin_outline',
                            title: 'LONGEST DISTANCE',
                            result: fetchAndDisplayDistance('distance'),
                            unit: 'Pace',
                            datetime: fetchAndDisplayDistance('date'),
                            trailingColor: Colors.green),

                        //best pace
                        BestRecCard(
                            iconPath: 'coin_outline',
                            title: 'BEST PACE',
                            result: fetchAndDisplayBestPace('AVGpace'),
                            unit: 'Pace',
                            datetime: fetchAndDisplayBestPace('date'),
                            trailingColor: Colors.green),

                        //Longest dulation

                        BestRecCard(
                            iconPath: "coin_outline",
                            title: "BEST DULATION",
                            result: fetchAndDisplayDuration('time'),
                            unit: "Hour",
                            datetime: "test",
                            trailingColor: Colors.green)
                      ],
                    )),
                  ),
                ),

                //Fastest times
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    width: 400,
                    height: 650,
                    decoration: BoxDecoration(
                        color: Colors.deepOrange[100],
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      children: [
                        Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.topLeft,
                            child: const Text(
                              "Fastest times",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            )),
                        const SizedBox(
                          height: 2,
                        ),

                        cardWidget(
                          icon: Icons.star,
                          title: 'BEST 400M',
                          distanceM: 400,
                          trailingColor: Colors.red,
                        ),
                        //call card func
                        cardWidget(
                          icon: Icons.directions_run,
                          title: 'BEST 1K',
                          distanceM: 1000,
                          trailingColor: Colors.green,
                        ),
                        cardWidget(
                          icon: Icons.directions_run,
                          title: 'BEST 2K',
                          distanceM: 2000,
                          trailingColor: Colors.green,
                        ),
                        cardWidget(
                          icon: Icons.directions_run,
                          title: 'BEST 5K',
                          distanceM: 5000,
                          trailingColor: Colors.green,
                        ),
                        cardWidget(
                          icon: Icons.directions_run,
                          title: 'BEST 10K',
                          distanceM: 10000,
                          trailingColor: Colors.green,
                        ),
                        cardWidget(
                          icon: Icons.directions_run,
                          title: 'BEST 21K',
                          distanceM: 21000,
                          trailingColor: Colors.green,
                        ),
                        cardWidget(
                          icon: Icons.directions_run,
                          title: 'BEST 42K',
                          distanceM: 42000,
                          trailingColor: Colors.green,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget cardWidget({
    required IconData icon,
    required String title,
    required int distanceM,
    required Color trailingColor,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.fromLTRB(6, 3, 6, 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.fromLTRB(6, 0, 0, 0),
            child: Icon(
              icon,
              size: 40,
            ),
          ),
          Expanded(
            child: Container(
              child: FutureBuilder<Map<String, dynamic>?>(
                future: Activity.fetchBestTime(distanceM),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle:
                          const Text('Loading...', // แสดงข้อความขณะรอข้อมูล
                              style: TextStyle(fontSize: 15)),
                    );
                  } else if (snapshot.hasError) {
                    return ListTile(
                      title: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: const Text('Error loading data',
                          style: TextStyle(fontSize: 15)),
                    );
                  } else if (snapshot.hasData && snapshot.data != null) {
                    final data = snapshot.data!;
                    return ListTile(
                      title: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        data['date']
                            .toString(), // แสดงวันที่ที่ได้จาก fetchBestTime
                        style: const TextStyle(fontSize: 15),
                      ),
                    );
                  } else {
                    return ListTile(
                      title: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: const Text('No data available',
                          style: TextStyle(fontSize: 15)),
                    );
                  }
                },
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 6, 0),
            child: FutureBuilder<Map<String, dynamic>?>(
              future: Activity.fetchBestTime(distanceM),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text(
                    '...',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: trailingColor,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    'Error',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: trailingColor,
                    ),
                  );
                } else if (snapshot.hasData && snapshot.data != null) {
                  final data = snapshot.data!;
                  return Text(
                    data['AVGpace']
                        .toString(), // แสดงค่า AVGpace ที่ได้จาก fetchBestTime
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: trailingColor,
                    ),
                  );
                } else {
                  return Text(
                    'No data',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: trailingColor,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  //bestRecCard func
  Widget BestRecCard({
    required String iconPath,
    required String title,
    required dynamic result,
    required String unit,
    required dynamic datetime,
    required Color trailingColor,
  }) {
    return Expanded(
        child: Card(
      elevation: 4,
      margin: const EdgeInsets.fromLTRB(6, 3, 6, 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Image.asset(
              IconPath().appBarIcon(iconPath),
              width: 40,
              height: 40,
            ),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: Container(
                padding: const EdgeInsets.fromLTRB(24, 0, 0, 3),
                child: Text(
                  "$result $unit",
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              )),
              Expanded(
                  child: Container(
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.fromLTRB(0, 0, 6, 3),
                      child: Text('$datetime'))),
            ],
          )
        ],
      ),
    ));
  }
}

/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testbar4/database/Fire_Activity.dart';
import 'package:testbar4/database/Fire_User.dart';
import 'package:testbar4/manage/manage_icon/icon_path.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:testbar4/model/provider_userData.dart';

class P5Profile extends StatelessWidget {
  P5Profile({super.key});
  IconPath iconPath = IconPath();
  Activity activity = Activity();

  static fetchAndDisplayDuration(String key) async {
    final durationData = await Activity.fetchLongestDuration();

    if (durationData != null) {
      if (key == 'date') {
        return durationData['date'].toString();
      } else if (key == 'time') {
        return durationData['time'].toString();
      }
    } else {
      return 'null';
    }
  }

  //fetch best Distance
  static fetchAndDisplayDistance(String key) async {
    final durationData = await Activity.fetchLongestDistance();

    if (durationData != null) {
      if (key == 'date') {
        return durationData['date'];
      } else if (key == 'distance') {
        return durationData['distance'];
      }
    } else {
      return 'null';
    }
  }

  //fetch bestPace
  static fetchAndDisplayBestPace(String key) async {
    final durationData = await Activity.fetchBestPace();

    if (durationData != null) {
      if (key == 'date') {
        return durationData['date'];
      } else if (key == 'AVGpace') {
        return durationData['AVGpace'];
      }
    } else {
      return 'null';
    }
  }

  //logout func
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    print('Logout successful');
    Navigator.pushNamed(context, '/p7');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataPV>(builder: (context, userDataProvider, child) {
      final userData = userDataProvider.userData;
      final name = userData?['name'] ?? 'error';

      return Scaffold(
        backgroundColor: const Color(0xFFFFFEEA),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Profile',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150'), // URL รูปโปรไฟล์
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 30),
                Divider(),
                _buildProfileOption(
                  iconPath.appBarIcon('setting_outline'),
                  'Edit Profile',
                  FirebaseAuth.instance.currentUser?.email ?? "unknown",
                  () {
                    Navigator.pushNamed(context, '/p10');
                  },
                ),
                const SizedBox(height: 10),
                _buildProfileOption(
                  iconPath.appBarIcon('shoes_outline'),
                  'My Shoes',
                  null,
                  () {
                    Navigator.pushNamed(context, "/p11");
                  },
                ),
                const SizedBox(height: 10),
                _buildProfileOption(
                  iconPath.appBarIcon('logout_outline'),
                  'Logout',
                  null,
                  () => _logout(context),
                ),
                const SizedBox(height: 20),
                _buildProgressSection(),
                const SizedBox(height: 20),
                _buildRecordSection(),
                const SizedBox(height: 20),
                _buildFastestTimesSection(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildProfileOption(
      String iconPath, String title, String? subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Row(
          children: [
            Expanded(
              child: ListTile(
                leading: Image.asset(
                  iconPath,
                  width: 40,
                  height: 40,
                ),
                title: Text(title),
                subtitle: subtitle != null ? Text(subtitle) : null,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right_outlined),
              onPressed: onTap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(
            color: Colors.deepOrange[100],
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.run_circle_outlined),
              title: Text(
                'My progress',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              title: Text(
                '418 KM',
                style: TextStyle(fontSize: 45),
              ),
              subtitle: Text('Total Km'),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.red,
                    height: 200,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.yellow,
                    height: 200,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.green,
                    height: 200,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRecordSection() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(
            color: Colors.deepOrange[100],
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.topLeft,
              child: const Text(
                "Best record",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 2),
            // Longest Distance
            BestRecCard(
              iconPath: "coin_outline",
              title: "LONGEST DISTANCE",
              result: fetchAndDisplayDistance('distance'), // Fetch the result
              unit: "km",
              datetime: fetchAndDisplayDistance(
                  'date'), // You can replace this with actual datetime
              trailingColor: Colors.green,
            ),
            /*
            // Best Pace
            BestRecCard(
              iconPath: "coin_outline",
              title: "BEST PACE",
              result:
                  "test error", //fetchAndDisplayBestPace('AVGpace'), // Fetch the result
              unit: "min/km",
              datetime: "test error",
              /*fetchAndDisplayBestPace(
                  'date'),*/ // You can replace this with actual datetime
              trailingColor: Colors.green,
            ),
            // Longest Duration
            BestRecCard(
              iconPath: "coin_outline",
              title: "LONGEST DURATION",
              result:
                  "test error", //fetchAndDisplayDuration('time'), // Fetch the result
              unit: "hrs",
              datetime: "test error",
              /* fetchAndDisplayDuration(
                  'date'),*/ // You can replace this with actual datetime
              trailingColor: Colors.green,
            ),
            */
          ],
        ),
      ),
    );
  }

  Widget _buildFastestTimesSection() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: 400,
        height: 650,
        decoration: BoxDecoration(
            color: Colors.deepOrange[100],
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.topLeft,
              child: const Text(
                "Fastest times",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 2),
            cardWidget(
              icon: Icons.star,
              title: 'BEST 400M',
              distanceM: 400,
              trailingColor: Colors.red,
            ),
            cardWidget(
              icon: Icons.directions_run,
              title: 'BEST 1K',
              distanceM: 1000,
              trailingColor: Colors.green,
            ),
            cardWidget(
              icon: Icons.directions_run,
              title: 'BEST 2K',
              distanceM: 2000,
              trailingColor: Colors.green,
            ),
            cardWidget(
              icon: Icons.directions_run,
              title: 'BEST 5K',
              distanceM: 5000,
              trailingColor: Colors.green,
            ),
            cardWidget(
              icon: Icons.directions_run,
              title: 'BEST 10K',
              distanceM: 10000,
              trailingColor: Colors.green,
            ),
            cardWidget(
              icon: Icons.directions_run,
              title: 'BEST 21K',
              distanceM: 21000,
              trailingColor: Colors.green,
            ),
            cardWidget(
              icon: Icons.directions_run,
              title: 'BEST 42K',
              distanceM: 42000,
              trailingColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  //cardWidget stays the same
  Widget cardWidget({
    required IconData icon,
    required String title,
    required int distanceM,
    required Color trailingColor,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.fromLTRB(6, 3, 6, 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(icon, size: 30),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Icon(
          Icons.star,
          color: trailingColor,
        ),
      ),
    );
  }

  //bestRecCard func
  Widget BestRecCard({
    required String iconPath,
    required String title,
    required dynamic result,
    required String unit,
    required dynamic datetime,
    required Color trailingColor,
  }) {
    return Expanded(
        child: Card(
      elevation: 4,
      margin: const EdgeInsets.fromLTRB(6, 3, 6, 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Image.asset(
              IconPath().appBarIcon(iconPath),
              width: 40,
              height: 40,
            ),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: Container(
                padding: const EdgeInsets.fromLTRB(24, 0, 0, 3),
                child: Text(
                  "$result $unit",
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              )),
              Expanded(
                  child: Container(
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.fromLTRB(0, 0, 6, 3),
                      child: Text(datetime))),
            ],
          )
        ],
      ),
    ));
  }
}
*/
