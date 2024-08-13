import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testbar4/database/Fire_User.dart';
import 'package:testbar4/manage/manage_icon/icon_path.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:testbar4/model/provider_userData.dart';

class P5Profile extends StatelessWidget {
  P5Profile({super.key});
  IconPath iconPath = IconPath();

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
                        Expanded(
                            child: Card(
                          elevation: 4,
                          margin: const EdgeInsets.fromLTRB(6, 3, 6, 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(Icons.social_distance),
                                title: Text(
                                  'LONGEST DISTANCE',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(24, 0, 0, 3),
                                    child: const Text(
                                      "15.19 km",
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    ),
                                  )),
                                  Expanded(
                                      child: Container(
                                          alignment: Alignment.bottomRight,
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 6, 3),
                                          child: Text("jul 17,2022 20:49"))),
                                ],
                              )
                            ],
                          ),
                        )),
                        Expanded(
                            child: Card(
                          elevation: 4,
                          margin: const EdgeInsets.fromLTRB(6, 3, 6, 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(Icons.social_distance),
                                title: Text(
                                  'LONGEST DISTANCE',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(24, 0, 0, 3),
                                    child: const Text(
                                      "15.19 km",
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    ),
                                  )),
                                  Expanded(
                                      child: Container(
                                          alignment: Alignment.bottomRight,
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 6, 3),
                                          child: Text("jul 17,2022 20:49"))),
                                ],
                              )
                            ],
                          ),
                        )),
                        Expanded(
                            child: Card(
                          elevation: 4,
                          margin: const EdgeInsets.fromLTRB(6, 3, 6, 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(Icons.social_distance),
                                title: Text(
                                  'LONGEST DISTANCE',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(24, 0, 0, 3),
                                    child: const Text(
                                      "15.19 km",
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    ),
                                  )),
                                  Expanded(
                                      child: Container(
                                          alignment: Alignment.bottomRight,
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 6, 3),
                                          child: Text("jul 17,2022 20:49"))),
                                ],
                              )
                            ],
                          ),
                        )),
                      ],
                    )),
                  ),
                ),
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
                              "Fastest time",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            )),
                        const SizedBox(
                          height: 2,
                        ),

                        cardWidget(
                          icon: Icons.star,
                          title: 'BEST 400M',
                          subtitle: '2022 Sep 15  08:30',
                          trailing: '2.12 MIN/KM',
                          trailingColor: Colors.red,
                        ),
                        //call card func
                        cardWidget(
                          icon: Icons.directions_run,
                          title: 'BEST 1K',
                          subtitle: '2022 Sep 15  08:30',
                          trailing: '4.50 MIN/KM',
                          trailingColor: Colors.green,
                        ),
                        cardWidget(
                          icon: Icons.directions_run,
                          title: 'BEST 2K',
                          subtitle: '2022 Sep 15  08:30',
                          trailing: '4.50 MIN/KM',
                          trailingColor: Colors.green,
                        ),
                        cardWidget(
                          icon: Icons.directions_run,
                          title: 'BEST 5K',
                          subtitle: '2022 Sep 15  08:30',
                          trailing: '4.50 MIN/KM',
                          trailingColor: Colors.green,
                        ),
                        cardWidget(
                          icon: Icons.directions_run,
                          title: 'BEST 10K',
                          subtitle: '2022 Sep 15  08:30',
                          trailing: '4.50 MIN/KM',
                          trailingColor: Colors.green,
                        ),
                        cardWidget(
                          icon: Icons.directions_run,
                          title: 'BEST 21K',
                          subtitle: '2022 Sep 15  08:30',
                          trailing: '4.50 MIN/KM',
                          trailingColor: Colors.green,
                        ),
                        cardWidget(
                          icon: Icons.directions_run,
                          title: 'BEST 42K',
                          subtitle: '2022 Sep 15  08:30',
                          trailing: '4.50 MIN/KM',
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
    required String subtitle,
    required String trailing,
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
              child: ListTile(
                title: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  subtitle,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 6, 0),
            child: Text(
              trailing,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: trailingColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
