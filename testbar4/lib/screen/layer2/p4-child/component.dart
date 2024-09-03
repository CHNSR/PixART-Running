import 'package:flutter/material.dart';
import 'package:testbar4/screen/layer2/p4-child/addcontanceSC.dart';



class StartChallenge extends StatelessWidget {
  const StartChallenge({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Center(
          child: Text(
            'Start Challenge',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      
      ),
      
    );
  }
}

class AddChallengePage extends StatelessWidget {
  const AddChallengePage({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
         Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddChallengeSc()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 9, 255, 0),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 2,color: Colors.black)
        ),
        child: const Center(
          child: Text(
            'Add challenge(Admin)',
            style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 16),
          ),
        ),
      
      ),
      
    );
  }
}
