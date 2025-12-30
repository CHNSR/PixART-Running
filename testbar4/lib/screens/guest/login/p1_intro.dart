import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:testbar4/routes/icon_path.dart';

class P1Intro extends StatefulWidget {
  P1Intro({super.key});

  @override
  State<P1Intro> createState() => _P1IntroState();
}

class _P1IntroState extends State<P1Intro> {
  final IconPath iconPath = IconPath();

  // Page intro method
  PageViewModel getPage(
      String title, String textBody, String footer, String img) {
    return PageViewModel(
      image: Container(
          width: 180,
          height: 180,
          child: Image.asset(
            iconPath.appBarIcon(img),
          )),
      title: title,
      body: textBody,
      footer: Center(child: Text(footer)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
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
          getPage("PixART Running", "Take your stlye if you want", 'footer',
              'facebook_outline'),
          getPage("Second", "Introduction Screen", 'footer', 'google_outline'),
        ],
        globalBackgroundColor: Colors.white,
      ),
    );
  }
}
