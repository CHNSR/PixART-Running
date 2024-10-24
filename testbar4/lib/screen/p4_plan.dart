import 'package:flutter/material.dart';
//import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:testbar4/services/firebase_service/Fire_UserChallenge.dart';
import 'package:testbar4/model/provider_userData.dart';
import 'package:testbar4/screen/layer2/p4-child/cardswiper.dart';
import 'package:testbar4/screen/layer2/p4-child/component.dart';

class P4Plan extends StatefulWidget {
  P4Plan({super.key});

  @override
  _P4PlanState createState() => _P4PlanState();
}


class _P4PlanState extends State<P4Plan> {
  Map<String, String> challengeStatuses = {};
  final GlobalKey<CardswiperCPState> _cardswiperKey = GlobalKey<CardswiperCPState>();
  Map<String, dynamic>? _selectedChallenge;
  bool _hasLoadedChallenges = false; // Add flag to prevent multiple calls

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadChallengeStatuses() async {
    final userDataPV = Provider.of<UserDataPV>(context, listen: false);
    final userId = userDataPV.userData?['id'];
    if (userId == null) {
      print("[P4_Plan][loadChallengeStatuses] User ID is null, skipping fetch.");
      return;
    }
    try {
      final dataUserChallenges = await UserChallenge.fetchUserChallenge(
        runnerID: userId,
      );
      final statuses = <String, String>{};
      for (var challenge in dataUserChallenges) {
        statuses[challenge['challengeId']] = challenge['status'] ?? 'Unknown';
      }
      setState(() {
        challengeStatuses = statuses;
        print("[P4_Plan][loadChallengeStatuses] set status state: $challengeStatuses");
      });
    } catch (e) {
      print("[P4_Plan][loadChallengeStatuses] Error loading challenge statuses: $e");
    }
  }

  void _updateSelectedChallenge(Map<String, dynamic> challenge) {
    setState(() {
      _selectedChallenge = challenge;
      print("[P4_Plan][state in _selectedChallenge] : $_selectedChallenge");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf9f4ef),
      body: Consumer<UserDataPV>(
        builder: (context, userDataPV, child) {
          if (userDataPV.userData == null) {
            print("[P4_Plan] userdata in widget == null:${userDataPV.userData}");
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            print("[P4_Plan] userdata in widget != null:${userDataPV.userData}");

            // Only load challenges once when userData is available
            if (!_hasLoadedChallenges) {
              _hasLoadedChallenges = true; // Prevent re-fetching
              loadChallengeStatuses();
            }

            return ListView(
              children: [
                SizedBox(
                  height: 600,
                  child: CardswiperCP(
                    key: _cardswiperKey,
                    onChallengeSelected: _updateSelectedChallenge,
                    challengeStatuses: challengeStatuses,
                  ),
                ),
                Column(
                  children: [
                    if (userDataPV.isAdmin) AddChallengePage(),
                    const SizedBox(height: 10),
                    StartChallenge(
                      onStart: () {
                        if (_selectedChallenge != null) {
                          final userId = userDataPV.userData?['id'];
                          final challengeId = _selectedChallenge!['challengeId'];
                          final startDate = _selectedChallenge!['start_date'];
                          final endDate = _selectedChallenge!['end_date'];

                          if (challengeId != null) {
                            UserChallenge.startChallenge(
                              userId,
                              challengeId,
                              startDate,
                              endDate,
                            ).then((_) {
                              setState(() {
                                _selectedChallenge = null;
                                loadChallengeStatuses(); // Reload challenge statuses
                              });
                            });
                          }
                        } else {
                          print("No challenge selected.");
                        }
                      },
                      selectedChallenge: _selectedChallenge,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            );
          }
        },
      ),
    );
  }
}