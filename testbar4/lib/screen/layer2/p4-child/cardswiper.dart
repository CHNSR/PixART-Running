import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class CardswiperCP extends StatefulWidget {
  final Function(Map<String, dynamic>) onChallengeSelected;
  final Map<String, String> challengeStatuses;

  const CardswiperCP({super.key, required this.onChallengeSelected, required this.challengeStatuses});

  @override
  State<CardswiperCP> createState() => CardswiperCPState();
}

class CardswiperCPState extends State<CardswiperCP> {
  int selectedIndex = 0; // เริ่มต้นไม่มีการ์ดถูกเลือก
  late CardSwiperController swiperController;
  int pickChallenge = -1;

  @override
  void initState() {
    super.initState();
    swiperController = CardSwiperController();
  }

  // Function to convert a hex string back to a Color
  Color hexToColor(String hexString) {
    return Color(int.parse(hexString.replaceFirst('#', '0x')));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // กรองข้อมูลตาม end_date ที่ยังไม่หมดอายุ
      stream: FirebaseFirestore.instance
          .collection("Challenge")
          .where('end_date', isGreaterThanOrEqualTo: Timestamp.now())
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No challenges found.'));
        } else {
          List<Map<String, dynamic>> challenges = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final challengeId = doc.id;
            return {...data, 'challengeId': challengeId};
          }).toList();

          return SizedBox(
            height: 200,
            child: challenges.length == 1
                ? _buildChallengeCard(challenges[0], widget.challengeStatuses[challenges[0]['challengeId']] ?? 'Unknown', true)
                : CardSwiper(
                    controller: swiperController,
                    initialIndex: selectedIndex >= 0 ? selectedIndex : 0,
                    cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                      final challenge = challenges[index];
                      final challengeId = challenge['challengeId'];
                      final status = widget.challengeStatuses[challengeId] ?? 'Unknown';

                      return GestureDetector(
                        onDoubleTap: () {
                          final challenge = challenges[index];
                          final status = widget.challengeStatuses[challenge['challengeId']] ?? 'Unknown';

                          // เช็คสถานะการ์ด ถ้าอยู่ในสถานะ in progress
                          if (status == 'in progress') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('You are already in progress with this challenge!'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            setState(() {
                              if (pickChallenge == index) {
                                pickChallenge = -1; // ยกเลิกการเลือกถ้ากดซ้ำการ์ดที่เลือกแล้ว
                              } else {
                                pickChallenge = index; // select new card
                                selectedIndex = index; // update selectIndex
                              }
                            });
                            widget.onChallengeSelected(challenge);
                          }
                        },
                        child: _buildChallengeCard(challenge, status, index == pickChallenge),
                      );
                    },
                    cardsCount: challenges.length,
                  ),
          );

        }
      },
    );
  }


  Widget _buildChallengeCard(Map<String, dynamic> challenge, String status, bool isSelected) {
    Color statusColor;

    switch (status) {
      case 'Unknown':
        statusColor = Colors.yellow;
        break;
      case 'in progress':
        statusColor = Colors.blue;
        break;
      case 'passed':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.red;
    }

    return Container(
      height: 250,
      width: 200,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: challenge['color'] != null ? hexToColor(challenge['color']) : Colors.blue,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 2, color: Colors.black),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 8,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    challenge['name'] ?? 'No name',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Expend: ${challenge['expend']}',
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Text(
                        'Distance: ${challenge['distance']} meters',
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Text(
                        'Start Date: ${challenge['start_date'].toDate()}',
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      Text(
                        'End Date: ${challenge['end_date'].toDate()}',
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      Text(
                        'Status: $status',
                        style: TextStyle(fontSize: 14, color: statusColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (isSelected)
            Positioned(
              top: 10,
              right: 10,
              child: Icon(Icons.check_circle, color: Colors.green, size: 30),
            ),
        ],
      ),
    );
  }
}