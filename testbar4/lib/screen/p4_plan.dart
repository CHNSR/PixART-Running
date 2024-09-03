import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testbar4/model/provider_userData.dart';
import 'package:testbar4/screen/layer2/p4-child/cardswiper.dart';
import 'package:testbar4/screen/layer2/p4-child/component.dart';

class P4Plan extends StatelessWidget {
  P4Plan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFEEA),
      body: ListView(
        children: [
          // Slider Card
          SizedBox(
            height: 600,
            child: CardswiperCP(),
          ),
          // Footer buttons - conditional rendering based on admin status
          Consumer<UserDataPV>(
            builder: (context, userDataPV, child) {
              if (userDataPV.isAdmin) {
                // If user is an admin, show "Add Challenge" and "Start Challenge" buttons
                return Column(
                  children: [
                    AddChallengePage(),
                    const SizedBox(height: 10,),  // Make sure this is a valid widget
                    StartChallenge(),   // Make sure this is a valid widget
                  ],
                );
              } else {
                // If user is not an admin, show only "Start Challenge" button
                return StartChallenge();  // Make sure this is a valid widget
              }
            },
          ),
          SizedBox(height: 20,)
        ],
      ),
    );
  }
}
