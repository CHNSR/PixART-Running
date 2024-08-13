import 'package:flutter/material.dart';

class P4Plan extends StatelessWidget {
  const P4Plan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFEEA),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [Text("plan")],
          ),
        ),
      ),
    );
  }
}
