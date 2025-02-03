import 'package:flutter/material.dart';

import 'RewardAcheivedOverlay2.dart';
import 'Rewardspage last.dart';

class RewardPointsSettings extends StatefulWidget {
  @override
  State<RewardPointsSettings> createState() => _RewardPointsSettingsState();
}

class _RewardPointsSettingsState extends State<RewardPointsSettings> {
  double _progressValue = 1 / 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 24,
          ),
        ),
        title: const Row(
          children: [
            Image(
              image: AssetImage('assets/icon.png'),
              height: 17,
            ),
            SizedBox(width: 8),
            Text('Reward Points Management',
                style: TextStyle(color: Colors.white, fontSize: 17)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reward Points Section
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RewardsPage2()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFD83694), // First color for the gradient
                        Color(0xFF0039C7), // Second color for the gradient
                      ],
                    ),
                  ),
                  padding: EdgeInsets.all(
                      2.0), // Add some padding for the border effect
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reward Points',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              '20',
                              style: TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Image.asset(
                          'assets/coin2.png', // Replace with your image
                          width: 80,
                          height: 80,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              // Daily Challenge Section
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daily Challenge',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisSize:
                        MainAxisSize.min, // Set the mainAxisSize to min
                    children: [
                      Icon(Icons.access_time, color: Colors.black),
                      SizedBox(width: 3), // Set a 3px gap
                      Text(
                        '10 hours',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  setState(() {
                    setState(() {
                      // Increment the progress on tap, but cap it at 1.0
                      if (_progressValue < 1.0) {
                        _progressValue += 1 / 3;
                      }
                    });
                  });
                },
                child: _buildChallengeCard(
                  'Make meaningful Connection',
                  'assets/heart.png', // Replace with your heart icon asset
                  Color(0xFFFAFAFA),
                  Color(0xFFD454A6),
                  '${(_progressValue * 3).toInt()}/3',
                  Color(0xFFF8E3F0),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => RewardAchievedOverlay2(),
                  );
                },
                child: _buildChallengeCard(
                  'Expand professional network',
                  'assets/link2.png', // Replace with your network icon asset
                  Color(0xFFFAFAFA),
                  Color(0xFF7071D8),
                  '1/5',
                  Color(0xFFE2E3F7),
                ),
              ),
              const SizedBox(height: 24),
              // Earn More Reward Points Section
              const Text(
                'Earn Tokens Through Referrals',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildBulletPoint('Maintain a streak to earn more points'),
              _buildBulletPoint(
                  'Redeem points for profile boosts, premium access, or special virtual gifts'),
              _buildBulletPoint(
                  'View your points earned from daily challenges and app activities'),
              _buildBulletPoint(
                  'Upgrade to premium and earn double points for every action'),
              const SizedBox(height: 24),
              const PointsSection(
                borderColor: Color(0xFFF1C7E2),
                title: 'Dating',
                activities: [
                  {
                    'title': 'Profile Completion',
                    'points': 30,
                  },
                  {
                    'title': 'Daily Check-ins',
                    'points': 5,
                    'additional-data': 'per day'
                  },
                  {
                    'title': 'First Match Bonus',
                    'points': 80,
                  },
                  {
                    'title': 'First Message Bonus',
                    'points': 20,
                  },
                  {
                    'title': 'Feedback or Bug Report Bon',
                    'points': 75,
                  },
                  {
                    'title': 'Successful Match Bonus',
                    'points': 25,
                    'additional-data': 'per match'
                  },
                  {
                    'title': 'Referral Program',
                    'points': 100,
                    'additional-data': 'per successful referral'
                  },
                  {
                    'title': 'Swipe Rewards',
                    'points': '+1',
                    'additional-data': 'per right swipe'
                  },
                ],
              ),
              const SizedBox(height: 24),
              const PointsSection(
                borderColor: Color(0xFFC6C6EF),
                title: 'Networking',
                activities: [
                  {
                    'title': 'Profile Completion',
                    'points': 30,
                  },
                  {
                    'title': 'Daily Check-ins',
                    'points': 5,
                    'additional-data': 'per day'
                  },
                  {
                    'title': 'First Match Bonus',
                    'points': 80,
                  },
                  {
                    'title': 'First Message Bonus',
                    'points': 20,
                  },
                  {
                    'title': 'Feedback or Bug Report Bon',
                    'points': 75,
                  },
                  {
                    'title': 'Successful Match Bonus',
                    'points': 25,
                    'additional-data': 'per match'
                  },
                  {
                    'title': 'Referral Program',
                    'points': 100,
                    'additional-data': 'per successful referral'
                  },
                  {
                    'title': 'Swipe Rewards',
                    'points': '+1',
                    'additional-data': 'per right swipe'
                  },
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeCard(String title, String asset, Color backgroundColor,
      Color progressColor, String progressText, Color borderColor) {
    // Calculate the progress value based on the text
    double progressValue = double.parse(progressText.split('/')[0]) /
        double.parse(progressText.split('/')[1]);

    // Adjust the progress value based on color
    if (progressColor == const Color(0xFFD454A6)) {
      // For pink, make sure it's filled more than half (e.g., 0.6)
      progressValue = 0.6; // You can adjust this value as needed
    } else if (progressColor == const Color(0xFF7071D8)) {
      // For blue, set it to fill only 1/5 (0.2)
      progressValue = 0.4; // This represents 1/5
    }

    return Container(
      height: 120,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0), // Set circular radius to 30
        color: backgroundColor,
        border: Border.all(
            color: borderColor, width: 2.0), // Add border color and width
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30, // Set the radius to 30
            backgroundColor: Colors.grey, // Background color for the avatar
            child: ClipOval(
              child: Image.asset(
                asset,
                width: 60, // You can adjust the width to fit the avatar size
                height: 60, // You can adjust the height to fit the avatar size
                fit: BoxFit.cover, // Ensure the image covers the avatar
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 13),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 30, // Set the height to increase the thickness
                      child: LinearProgressIndicator(
                        value: progressValue, // Use the adjusted progress value
                        color: progressColor,
                        backgroundColor: Colors.white,
                        borderRadius: BorderRadius.circular(
                            30.0), // Set circular radius to 30
                      ),
                    ),
                    Text(
                      progressText,
                      style: TextStyle(
                        color: (progressColor == const Color(0xFFD454A6))
                            ? Colors.white // Use white for pink
                            : Colors.black, // Use black for blue
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 15,
            child: Image.asset(
              'assets/giftbulletine.png', // Replace with your bullet point image
              height: 12,
              width: 11,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class PointsSection extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> activities;
  final Color borderColor; // Border color parameter

  const PointsSection({
    Key? key,
    required this.title,
    required this.activities,
    this.borderColor = Colors.grey, // Default border color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine icon color based on border color
    Color iconColor;
    if (borderColor == const Color(0xFFC6C6EF)) {
      iconColor =
          const Color(0xFF7071D8); // Set icon color for this border color
    } else if (borderColor == const Color(0xFFF1C7E2)) {
      iconColor =
          const Color(0xFFD454A6); // Set icon color for this border color
    } else {
      iconColor =
          Colors.black; // Default icon color if border color doesn't match
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: borderColor), // Use the border color
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Column(
            children: activities.map((activity) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(activity['title']),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${activity['points']}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                                width: 4), // Space between points and coin icon
                            Image.asset(
                              'assets/coin.png', // Add small coin image
                              height: 16, // Adjust size as needed
                              width: 16,
                            ),
                          ],
                        ),
                        if (activity.containsKey('additional-data'))
                          Text(
                            '${activity['additional-data']}',
                            style: const TextStyle(fontSize: 10),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
