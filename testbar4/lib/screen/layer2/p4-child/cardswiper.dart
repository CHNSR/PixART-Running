import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:testbar4/database/Fire_Challenge.dart';

class CardswiperCP extends StatefulWidget {
  const CardswiperCP({super.key});

  @override
  State<CardswiperCP> createState() => _CardswiperCPState();
}

class _CardswiperCPState extends State<CardswiperCP> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("Challenge").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No challenges found.'));
        } else {
          // Create cards from the fetched challenges
          List<Container> cards = snapshot.data!.docs.map((doc) {
            final challenge = doc.data() as Map<String, dynamic>;
            return Container(
              height: 200,
              width: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 2, color: Colors.black),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Top container with 80% height
                  Expanded(
                    flex: 8, // This is 80% of the total height (8 out of 10)
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        challenge['name'] ?? 'No name', // Display the challenge name
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Footer container with 20% height
                  Expanded(
                    flex: 2, // This is 20% of the total height (2 out of 10)
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Expend: ${challenge['expend']} ',
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList();

          return SizedBox(
            height: 200, // Ensure there is enough height for the CardSwiper
            child: CardSwiper(
              cardBuilder: (context, index, percentThresholdX, percentThresholdY) => cards[index],
              cardsCount: cards.length,
            ),
          );
        }
      },
    );
  }
}
