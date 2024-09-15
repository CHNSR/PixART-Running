import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testbar4/database/Fire_Activity.dart';
import 'package:testbar4/database/Fire_User.dart';
import 'package:testbar4/manage/manage_icon/icon_path.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:testbar4/model/provider_userData.dart';

class P5Profile extends StatefulWidget {
  P5Profile({super.key});
 

  @override
  State<P5Profile> createState() => _P5ProfileState();
}

class _P5ProfileState extends State<P5Profile> {
  IconPath iconPath = IconPath();


  String? bestAVGpace;
  String? bestAVGpacedate;
  String? bestDuration;
  String? bestDurationdate;
  String? distance;
  String? distancedate;
  String? totaldistance = '0.0' ;
  String? totalAVGpace;
  String? totalHouse; 


  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    bestAVGpace = await fetchAndDisplayBestPace('AVGpace');
    bestAVGpacedate = await fetchAndDisplayBestPace('date');
    bestDuration = await fetchAndDisplayDuration('time');
    bestDurationdate = await fetchAndDisplayDuration('date');
    distance = await fetchAndDisplayDistance('distance');
    distancedate = await fetchAndDisplayDistance('date');
    totaldistance = await fetchandDisplayTotalKM();
    totalAVGpace = await fetchAndDisPlayTotalPace();
    totalHouse = await fetchandDisplayTotalHouse();


    setState(() {}); // Notify the widget to rebuild with the new data
  }

  static Future<String?> fetchAndDisplayDuration(String key) async {
    final durationData = await Activity.fetchLongestDuration();
    print('[P5][fetchAndDisplayDuration] ----> : $durationData');
    if (durationData != null) {
      return durationData[key]?.toString() ?? 'null';
    }
    return 'null';
  }

  static Future<String?> fetchAndDisplayDistance(String key) async {
    final distanceData = await Activity.fetchLongestDistance();
    print('[P5][fetchAndDisplayDistance] ----> : $distanceData');
    if (distanceData != null) {
      return distanceData[key]?.toString() ?? 'null';
    }
    return 'null';
  }

  static Future<String?> fetchAndDisplayBestPace(String key) async {
    final paceData = await Activity.fetchBestPace();
    print('[P5][fetchAndDisplayBestPace] ----> : $paceData');
    if (paceData != null) {
      return paceData[key]?.toString() ?? 'null';
    }
    return 'null';
  }

  static Future<String> fetchAndDisPlayTotalPace() async{
    final data = await Activity.fetchTotalAveragePace();
    if(data != 0.0){
      return data.toStringAsFixed(2);
    }
    return 'None';
      
  }

 static Future<String> fetchandDisplayTotalKM() async {
  final data = await Activity.fetchTotalDistance();
  if (data != 0.0) {
    // แปลงจากเมตรเป็นกิโลเมตร
    final distanceInKM = data / 1000;
    return distanceInKM.toStringAsFixed(2);
  }
  return 'None';
}

  static Future<String> fetchandDisplayTotalHouse() async{
    final data = await Activity.fetchTotalHouse();
    if(data != "00:00:00"){
      return data;
    }
    return data;
  }

  void _logout(BuildContext context) async {
  // Sign out from Firebase Auth
  await FirebaseAuth.instance.signOut();

  // Reset the provider state by calling a method to clear user data
  Provider.of<UserDataPV>(context, listen: false).clearUserData();

    // Reset runnerID in the Activity class
  Activity.runnerID = null;
  
  print('Logout successful');

  // Navigate to the login screen
  Navigator.pushNamed(context, '/p7');
}


  @override
  Widget build(BuildContext context) {
    
    return Consumer<UserDataPV>(builder: (context, userDataProvider, child) {
      final userData = userDataProvider.userData;
      print("[P5]-------------------------${userData}------------------");
      final name = userData?['name'] ?? 'error';
      return Scaffold(
        backgroundColor: const Color(0xFFf9f4ef),
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
                const Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        'https://www.flaticon.com/free-icons/pixel'), // URL รูปโปรไฟล์
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
                const Divider(),
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
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: Image.asset(
                            iconPath.appBarIcon('shoes_outline'),
                            width: 40,
                            height: 40,
                          ),
                          title: const Text('My Shoes'),
                          //subtitle: Text('chanonsukrod@gmail.com'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () => _logout(context),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: Image.asset(
                            iconPath.appBarIcon('logout_outline'),
                            width: 40,
                            height: 40,
                          ),
                          title: const Text('Logout'),
                          //subtitle: Text('chanonsukrod@gmail.com'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    width: 400,
                    //height: 400,
                    decoration: BoxDecoration(
                      color: Color(0xFFeaddcf),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 2,
                        color: Colors.black
                      )  
                    ),
                        
                    child: Column(
                      children: [
                        const ListTile(
                          leading: Icon(Icons.run_circle_outlined),
                          title: Text(
                            'My progress',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            totaldistance!,
                            style: const TextStyle(fontSize: 45),
                          ),
                          subtitle: const Text('Total Km',style: TextStyle(fontSize: 30),),
                        ),
                        Container(margin: const EdgeInsets.all(8), child: const Divider(color: Colors.grey,)),
                        Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                title: Text(totalHouse!,style: const TextStyle(fontSize: 22),),
                                subtitle: const Text("Total Hour",style: TextStyle(fontSize: 20),),
                              )
                            ),
                            Expanded(
                              child: ListTile(
                                title: Text("data",style: TextStyle(fontSize: 25),),
                                subtitle: Text("data",style: TextStyle(fontSize: 20),),
                              )
                            ),
                            Expanded(
                              child: ListTile(
                                title: Text(totalAVGpace!,style: const TextStyle(fontSize: 25),),
                                subtitle: const Text('AVG pace',style: TextStyle(fontSize: 20),),
                              )
                            ),
                            
                          ],
                        ),
                        const SizedBox(height: 10,)
                      ],
                    ),
                  ),
                ),

                //best reccord
                const SizedBox(height: 20),
                Padding(
                padding: const EdgeInsets.all(2.0),
                child: SizedBox(
                  width: 400,
                  height: 450,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xFFeaddcf),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 2,
                        color: Colors.black
                      )  
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // จัดแนวลูก widget ไปที่จุดเริ่มต้น
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            "Best record",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        // ระยะทางที่ยาวที่สุด
                        Flexible(
                          child: bestRecCard(
                            iconPath: 'distance_outline',
                            title: 'LONGEST DISTANCE',
                            result: distance ?? '0.0', // ให้ค่าเริ่มต้น
                            unit: 'KM',
                            datetime: distancedate ?? 'Loading...', // ให้ค่าเริ่มต้น
                            trailingColor: Color(0xFF0c4a6e),
                          ),
                        ),
                        // ความเร็วที่ดีที่สุด
                        Flexible(
                          child: bestRecCard(
                            iconPath: 'fast_outline',
                            title: 'BEST PACE',
                            result: bestAVGpace ?? '0.0', // ให้ค่าเริ่มต้น
                            unit: 'Pace',
                            datetime: bestAVGpacedate ?? 'Loading...', // ให้ค่าเริ่มต้น
                            trailingColor: Color(0xFFf25042),
                          ),
                        ),
                        // ระยะเวลาที่ยาวที่สุด
                        Flexible(
                          child: bestRecCard(
                            iconPath: "clock_outline",
                            title: "BEST DURATION",
                            result: bestDuration ?? '0.0', // ให้ค่าเริ่มต้น
                            unit: "Hour",
                            datetime: bestDurationdate ?? 'Loading...', // ให้ค่าเริ่มต้น
                            trailingColor: Color(0xFF8c7851),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                      color: Color(0xFFeaddcf),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 2,
                        color: Colors.black
                      )  
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          imgName: 'best_outline',
                          title: 'BEST 400M',
                          distanceM: 400,
                          trailingColor: Color(0xFF0c4a6e),
                        ),
                        //call card func
                        cardWidget(
                          imgName: 'best_outline',
                          title: 'BEST 1K',
                          distanceM: 1000,
                          trailingColor: Color(0xFF0c4a6e),
                        ),
                        cardWidget(
                          imgName: 'best_outline',
                          title: 'BEST 2K',
                          distanceM: 2000,
                          trailingColor: Color(0xFF0c4a6e),
                        ),
                        cardWidget(
                          imgName: 'best_outline',
                          title: 'BEST 5K',
                          distanceM: 5000,
                          trailingColor: Color(0xFF0c4a6e),
                        ),
                        cardWidget(
                          imgName: 'best_outline',
                          title: 'BEST 10K',
                          distanceM: 10000,
                          trailingColor: Color(0xFF0c4a6e),
                        ),
                        cardWidget(
                          imgName: 'best_outline',
                          title: 'BEST 21K',
                          distanceM: 21000,
                          trailingColor: Color(0xFF0c4a6e),
                        ),
                        cardWidget(
                          imgName: 'best_outline',
                          title: 'BEST 42K',
                          distanceM: 42000,
                          trailingColor: Color(0xFF0c4a6e),
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
  required String imgName,
  required String title,
  required int distanceM,
  required Color trailingColor,
}) {
  // เรียกใช้ Future เพื่อดึงข้อมูลจาก fetchBestTime
  Future<Map<String, dynamic>?> futureData = Activity.fetchBestTime(distanceM);
  print("[P5][cardWidget] data in var futureData: $futureData");

  return FutureBuilder<Map<String, dynamic>?>(
    future: futureData,
    builder: (context, snapshot) {
      // ตัวแปรสำหรับเก็บข้อมูล date และ AVGpace
      String date = 'Loading...';
      String avgPace = '...';

      if (snapshot.connectionState == ConnectionState.waiting) {
        date = 'Loading...';
        avgPace = '...';
      } else if (snapshot.hasError) {
        date = 'Error loading data';
        avgPace = 'Error';
      } else if (snapshot.hasData && snapshot.data != null) {
        final data = snapshot.data!;
        date = data['date'].toString(); // ใช้ข้อมูลจาก fetchBestTime
        avgPace = data['AVGpace'].toString();
      } else {
        date = 'No data available';
        avgPace = 'No data';
      }

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
              child: Image.asset(iconPath.appBarIcon(imgName),width: 40,height: 40,)
            ),
            Expanded(
              child: ListTile(
                title: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  date,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 6, 0),
              child: Text(
                avgPace,
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
    },
  );
}

  //bestRecCard func
  Widget bestRecCard({
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
                  style:  TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: trailingColor
                    ),
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
