import 'package:flutter/material.dart';

import 'RewardAcheivedOverlay2.dart';

class RewardPointsScreen extends StatefulWidget {
  @override
  State<RewardPointsScreen> createState() => _RewardPointsScreenState();
}

class _RewardPointsScreenState extends State<RewardPointsScreen> {
  double _progressValue = 1 / 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: const Row(
          children: [
            Image(
              image: AssetImage('assets/icon.png'),
              height: 19,
            ),
            SizedBox(width: 8),
            Text('Reward Points Management',
                style: TextStyle(color: Colors.white, fontSize: 19)),
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  gradient: LinearGradient(
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
              const SizedBox(height: 30),

              const Text(
                'Earn tokens through referrals',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
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

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 4.0), // Adjust this value to move the icon down
            child: Image.asset(
              'assets/giftbulletine.png', // Replace with your bullet point image
              height: 12,
              width: 24,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
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
