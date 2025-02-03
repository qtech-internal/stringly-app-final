import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/user_profile_params_model.dart';
import '../Reward Settings/RewardAcheivedOverlay2.dart';
import '../Reward Settings/RewardsPage.dart';
import '../UserInfo5.dart';
import 'LikeScreenVariationMatched.dart';
import 'detailedNetworking.dart';
import 'detaileddating.dart';

class SwipingScreen extends StatefulWidget {
  @override
  _SwipingScreenState createState() => _SwipingScreenState();
}

class _SwipingScreenState extends State<SwipingScreen> with SingleTickerProviderStateMixin {
  var userProfile = userProfileParamsModel();
  final List<Map<String, String>> images = [
    {
      'path': 'assets/img.png',
      'name': 'Jane Cooper, 25',
      'location': 'Lives in Portland, Illinois',
      'distance': '11 miles away',
      'info': 'Lorem ipsum dolor sit amet, consectetur adipiscing eli.Quisque eu lacinia justo, ut  ',
    },
    {
      'path': 'assets/img_1.png',
      'name': 'John Doe, 30',
      'location': 'Lives in New York, NY',
      'distance': '5 miles away',
      'info': 'Lorem ipsum dolor sit amet, consectetur adipiscing eli.Quisque eu lacinia justo, ut  ',
    },
    {
      'path': 'assets/img_2.png',
      'name': 'Alice Smith, 28',
      'location': 'Lives in Seattle, WA',
      'distance': '8 miles away',
      'info': 'Lorem ipsum dolor sit amet, consectetur adipiscing eli.Quisque eu lacinia justo, ut  ',
    },
  ];

  int currentIndex = 0;
  Offset cardOffset = Offset.zero;
  double cardRotation = 0.0;
  bool isToggled = false;
  bool isFirstSwipe = true;
  bool showOverlay = false; // Overlay visibility control

  Color _getOverlayColor() {
    if (cardOffset.dx > 0) {
      return Colors.green.withOpacity(0.3); // Green for right swipe
    } else if (cardOffset.dx < 0) {
      return Colors.red.withOpacity(0.3); // Red for left swipe
    }
    return Colors.transparent; // No overlay for neutral state
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => exit(0),
            child: const Text('Exit'),
          ),
        ],
      ),
    ) ?? false;
  }

  void _bringBackPreviousCard() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
        cardOffset = Offset.zero;
        cardRotation = 0.0;
      }
    });
  }

  void _showMatchOverlay() {
    setState(() {
      showOverlay = true; // Show overlay
    });
    // Hide overlay after a few seconds
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        showOverlay = false; // Hide overlay
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 25),
                            child: Image.asset(
                              'assets/COLOURED LOGO 1.png',
                              height: 60,
                              width: 90,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 80),
                          Center(
                            child: CustomToggleSwitch(
                              isToggled: isToggled,
                              onToggle: (value) {
                                setState(() {
                                  isToggled = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 35),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => UserPreferenceScreen()),
                              );
                            },
                            child: Image.asset(
                              'assets/equalizer.png',
                              height: 25,
                              width: 25,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 15),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => RewardPointsSettings()),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/reward.png',
                                  height: 20,
                                  width: 20,
                                  fit: BoxFit.fill,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  '32',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: images.reversed.map((imageData) {
                          int index = images.indexOf(imageData);
                          if (index < currentIndex) return Container();
        
                          double scale = index - currentIndex == 1 ? 0.98 : 1.0;
                          double opacity = index - currentIndex == 1 ? 0.9 : 1.0;
                          double topOffset = (index - currentIndex == 1) ? -30.0 : 0.0;
        
                          return Positioned(
                            top: 50 + topOffset,
                            left: 20.0,
                            right: 20.0,
                            child: Opacity(
                              opacity: opacity,
                              child: Transform.scale(
                                scale: scale,
                                child: GestureDetector(
                                  onPanUpdate: index == currentIndex
                                      ? (details) {
                                    setState(() {
                                      cardOffset += details.delta;
                                      cardRotation = cardOffset.dx * 0.01;
                                    });
                                  }
                                      : null,
                                  onPanEnd: index == currentIndex
                                      ? (details) {
                                    if (cardOffset.dx > 100 || cardOffset.dx < -100) {
                                      setState(() {
                                        if (cardOffset.dx > 100) {
                                          print('Liked: ${imageData['name']}');
                                          if (currentIndex == 1) {
                                            // showDialog(
                                            //   context: context,
                                            //   builder: (BuildContext context) => PremiumVariation2Matched(usersInfo: {'user': 'uroeuroeuoeuroeuoeuoi', 'user': 'io'},),
                                            // );// Show overlay for 2nd card match
                                          }
                                        } else {
                                          print('Disliked: ${imageData['name']}');
                                        }
                                        currentIndex++;
                                        cardOffset = Offset.zero;
                                        cardRotation = 0.0;
                                        isFirstSwipe = false;
                                      });
                                    } else {
                                      setState(() {
                                        cardOffset = Offset.zero;
                                        cardRotation = 0.0;
                                      });
                                    }
                                  }
                                      : null,
                                  onTap: index == currentIndex
                                      ? () {
                                    if (isToggled) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => DetailedDating(data:  userProfile),
                                        ),
                                      );
                                    } else {

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => Detailednetworking(data:  userProfile,),
                                        ),
                                      );
                                    }
                                  }
                                      : null,
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.65,
                                    child: Transform.translate(
                                      offset: index == currentIndex ? cardOffset : Offset.zero,
                                      child: Transform.rotate(
                                        angle: index == currentIndex ? cardRotation : 0.0,
                                        child: Stack(
                                          children: [
                                            if (index == currentIndex && currentIndex != 0)
                                              Positioned(
                                                top: 10,
                                                right: 10,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    // Add your button action here
                                                  },
                                                  child: const Icon(Icons.refresh),
                                                ),
                                              ),
                                            Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              elevation: 4.0,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(20),
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    Image.asset(
                                                      imageData['path']!,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Positioned(
                                                      bottom: 20,
                                                      left: 20,
                                                      right: 20,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            imageData['name']!,
                                                            style: const TextStyle(
                                                              fontFamily: 'SFProDisplay',
                                                              fontSize: 30,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 5),
                                                          Text(
                                                            imageData['location']!,
                                                            style: const TextStyle(
                                                              fontFamily: 'SFProDisplay',
                                                              fontSize: 16,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                          Text(
                                                            imageData['distance']!,
                                                            style: const TextStyle(
                                                              fontFamily: 'SFProDisplay',
                                                              fontSize: 16,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 10),
                                                          Text(
                                                            imageData['info']!,
                                                            style: const TextStyle(
                                                              fontFamily: 'SFProDisplay',
                                                              fontSize: 16,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DetailedNetworking {
}





class CustomToggleSwitch extends StatelessWidget {
  final bool isToggled;
  final ValueChanged<bool> onToggle;

  const CustomToggleSwitch({
    Key? key,
    required this.isToggled,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onToggle(!isToggled),
      child: Container(
        width: 80,
        height: 40,
        decoration: BoxDecoration(
          color: isToggled ? Colors.pink[100] : Colors.blue[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Heart Icon - rises up from the bottom to its initial position
            AnimatedPositioned(
              duration: Duration(milliseconds: 400),
              left: 10,
              bottom: isToggled ? 10 : -20, // Moves up to the initial position
              child: AnimatedOpacity(
                opacity: isToggled ? 1 : 0,
                duration: Duration(milliseconds: 300),
                child: Image.asset(
                  'assets/Component 4.png',
                  width: 25,
                  height: 25,
                  color: Colors.red[400],
                ),
              ),
            ),
            // Link Icon - rises up from the bottom when toggled off
            AnimatedPositioned(
              duration: Duration(milliseconds: 400),
              right: 10,
              bottom: isToggled ? -20 : 10, // Moves down from the initial position
              child: AnimatedOpacity(
                opacity: isToggled ? 0 : 1,
                duration: Duration(milliseconds: 300),
                child: Image.asset(
                  'assets/go.png',
                  width: 25,
                  height: 25,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            // Thumb Animation
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              left: isToggled ? 43 : 3,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
