import 'package:flutter/material.dart';

import '../Chat/ChatBox.dart';
import '../Chat/MessageScreen.dart';

class PremiumVariation2Matched extends StatefulWidget {
  PremiumVariation2Matched({super.key, required this.usersInfo});

  Map<String, String> usersInfo;
  @override
  State<PremiumVariation2Matched> createState() => _PremiumVariation2MatchedState();
}

class _PremiumVariation2MatchedState extends State<PremiumVariation2Matched> {
  bool _isOverlayVisible = false; // Track overlay visibility

  void _showOverlay() {
    setState(() {
      _isOverlayVisible = true; // Show overlay
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.black.withOpacity(0.5),
      child: Stack(
        children: [
          // Transparent black background
          // if (_isOverlayVisible)
          //   Positioned.fill(
          //     child: Container(
          //       color: Colors.black.withOpacity(0.3), // Low opacity background
          //     ),
          //   ),

          Center(
            child: Container(
              height: 500, // Set container height to 500
              width: MediaQuery.of(context).size.width - 40, // Optional: set width
              decoration: BoxDecoration(
                color: Colors.black, // Background color of the inner container
                borderRadius: BorderRadius.circular(12), // Match dialog corners
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Adding a transparent overlay behind the inner container
                  // if (_isOverlayVisible)
                  //   Positioned.fill(
                  //     child: Container(
                  //       color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
                  //     ),
                  //   ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 31),
                      const Text(
                        'It\'s a Match!',
                        style: TextStyle(
                          fontFamily: 'SFProDisplay', // Specify the font family here
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 130,
                                height: 130,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [Colors.blue, Colors.purple],
                                  ),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                         widget.usersInfo['loggedUserImage']!,
                                        width: 110,
                                        height: 110,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 15),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 130,
                                height: 130,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [Colors.blue, Colors.purple],
                                  ),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                        widget.usersInfo['currentUserProfileImage']!,
                                        width: 110,
                                        height: 110,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 112),
                      ElevatedButton(
                        onPressed: () {
                          Map<String, dynamic> userInfo = {
                            'userProfileImage': widget.usersInfo['currentUserProfileImage']!,
                            'name': widget.usersInfo['profileUserName']!,
                            'chat_id': 'chat-${widget.usersInfo['loggedUserId']}-${widget.usersInfo['ProfileUserId']}'
                          };
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChatBox(userInfo: userInfo)));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: const Size(200, 50),
                          side: const BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Send a message',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: const Size(200, 50),
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
