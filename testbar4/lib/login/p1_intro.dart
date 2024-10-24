import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:testbar4/manage/manage_icon/icon_path.dart';
import 'package:lottie/lottie.dart';

class P1Intro extends StatefulWidget {
  P1Intro({super.key});

  @override
  State<P1Intro> createState() => _P1IntroState();
}

class _P1IntroState extends State<P1Intro> {
  final IconPath iconPath = IconPath();

  // Page intro method
  PageViewModel getPage(String title, String textBody, String footer, String path) {
    return PageViewModel(
      decoration: PageDecoration(
        pageColor: Color(0xFFf9f4ef)
        
      ),
      image: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          color: Color(0xFFf9f4ef),
        ),
        child: Center( // Center the image vertically and horizontally
          child: Lottie.asset(path),
        ),
      ),
      title: title,
      body: textBody,
      footer: Center(child: Text(footer)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                color: Color(0xFFf9f4ef)
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: IntroductionScreen(
                done: const Text(
                  'Done',
                  style: TextStyle(color: Colors.black),
                ),
                onDone: () {
                  Navigator.pushNamed(context, '/p7');
                },
                skip: const Text(
                  'Skip',
                  style: TextStyle(color: Colors.black),
                ),
                showSkipButton: true,
                next: const Icon(Icons.arrow_forward, color: Colors.black),
                pages: [
                  getPage("PixART Running", "Running Tracking application \n wram your step andrun with", 'PixArt Running', 'assets/image/animation/Animation01.json'),
                  getPage("Friendly for newbie runner", "Easy to run and \n fun with", 'PixArt Running', 'assets/image/animation/Animation02.json'),
                  getPage("Navigation for you", "Run with my route or your route \n fun with", 'PixArt Running', 'assets/image/animation/Location_intro.json'),
                ],
                globalBackgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
