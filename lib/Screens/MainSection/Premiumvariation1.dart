import 'dart:ui';
import 'package:flutter/material.dart';

import '../Reward Settings/RewardsPage.dart';
import 'RewardAcheivedOverlay.dart';

class PremiumVariation1 extends StatefulWidget {
  const PremiumVariation1({Key? key}) : super(key: key);

  @override
  _PremiumVariation1State createState() => _PremiumVariation1State();
}

class _PremiumVariation1State extends State<PremiumVariation1> {
  bool isPremium = false; // Flag to track if the user has upgraded to premium
  String profileText = '33 Liked Your Profile'; // Initial profile text

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        title: const Text('Who liked you', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                profileText, // Use the state variable for text
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  // Match Cards
                  MatchCard(
                    image: 'assets/img.png',
                    isPremium: isPremium,
                    sideColor: Color(0xFFC6C6EF),
                    overlayIcon: 'assets/link2.png',
                  ),
                  MatchCard(
                    image: 'assets/img_1.png',
                    isPremium: isPremium,
                    sideColor: Color(0xFFDC73B6),
                    overlayIcon: 'assets/heart.png',
                  ),
                  MatchCard(
                    image: 'assets/img_2.png',
                    isPremium: isPremium,
                    sideColor: Color(0xFFC6C6EF),
                    overlayIcon: 'assets/link2.png',
                  ),
                  MatchCard(
                    image: 'assets/img_3.png',
                    isPremium: isPremium,
                    sideColor: Color(0xFFDC73B6),
                    overlayIcon: 'assets/heart.png',
                  ),
                  MatchCard(
                    image: 'assets/img_4.png',
                    isPremium: isPremium,
                    sideColor: Color(0xFFC6C6EF),
                    overlayIcon: 'assets/link2.png',
                  ),
                ],
              ),
            ),
            // Update to Premium Button, only visible if not premium
            if (!isPremium) // Show the button only if the user is not premium
              SizedBox(
                height: 50,
                width: 300, // Set the width to 300 pixels
                child: ElevatedButton(
                  onPressed: () {
                    // Show the overlay dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return RewardAchievedOverlay();
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                  ),
                  child: const Text(
                    'Upgrade to Premium',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class MatchCard extends StatelessWidget {
  final String image;
  final bool isPremium;
  final Color sideColor;
  final String overlayIcon; // New parameter for overlay icon

  const MatchCard({
    Key? key,
    required this.image,
    required this.isPremium,
    required this.sideColor,
    required this.overlayIcon, // Receive the overlay icon as a parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: sideColor), // Use the provided side color
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        height: 100,
        child: ListTile(

          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Image with fit
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                // Blur effect if not premium
                if (!isPremium)
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                // Lock image overlay if not premium
                if (!isPremium)
                  const Icon(Icons.lock_outline, color: Colors.white),

                // Add the icon image in the corner (outside the blur area)
                if (!isPremium)
                  Positioned(
                    bottom: 2,
                    right: -3,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white, // Add background color to make it stand out
                      ),
                      padding: const EdgeInsets.all(2), // Add padding inside the container
                      child: Image.asset(
                        overlayIcon, // Use the passed icon image
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          title: const Text(
            'Someone liked you! Unlock premium to see who.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text('Located within 10 miles'),
        ),
      ),
    );
  }
}
