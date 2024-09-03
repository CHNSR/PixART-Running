import 'package:flutter/material.dart';
import 'package:testbar4/manage/manage_icon/icon_path.dart';
import 'package:testbar4/screen/layer2/activity/componente/activityCP.dart';

class ActivityPage extends StatelessWidget {
  ActivityPage({super.key});
  IconPath iconPath = IconPath();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, "/main"),
          icon: Transform.rotate(
            angle: 3.14, // 180 degrees in radians (π radians)
            child: Image.asset(iconPath.appBarIcon("arrowR_outline")),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFFFFEEA),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 40,
              ),

              //logo
              Image.asset(
                iconPath.appBarIcon("running_img"),
                height: 200,
                width: 200,
              ),
              const SizedBox(height: 40),

              // Centered ListTile
              Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(
                        "My Activity",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey),
                      ),
                      subtitle: Text(
                        "all activity",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        // height: 1500,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFfef3c7),
                          border: Border.all(
                            color: Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: CardAc(numOfCard: 'all'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
