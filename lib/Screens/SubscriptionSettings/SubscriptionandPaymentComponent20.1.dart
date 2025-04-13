import 'package:flutter/material.dart';
import 'package:stringly/Screens/SubscriptionSettings/redeem_page.dart';

import 'Subscription3.dart';
import 'SubscriptionandPaymentplans.dart';
import 'SubscriptionandPaymentplansgetstarted2.dart';

class SubscriptionScreen extends StatefulWidget {
  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String _selectedTab = 'Pro';
  final Map<String, List<Map<String, dynamic>>> _plans = {
    'Pro': [
      {
        'name': 'Monthly',
        'price': '\$30',
        'originalPrice': null,
        'discount': null,
        'features': [
          '500 Swipes',
          'Unlimited Extends',
          'Unlimited Backtrack',
          'Unlimited Rematch',
          '10 Super Swipes a week',
          '20 Compliments a week',
          'Boost a week',
          'See who liked you',
          'Access to for you',
          'Travel Mode',
          'Incognito Mode',
          'Location to anywhere',
          'Advanced Filters',
          'Enhanced Recommendations',
          'More likes in for you',
        ],
        'bestValue': false,
      },
      {
        'name': '3 Months Plan',
        'price': '\$63',
        'originalPrice': '\$70',
        'discount': '10%',
        'features': [
          '500 Swipes',
          'Unlimited Extends',
          'Unlimited Backtrack',
          'Unlimited Rematch',
          '10 Super Swipes a week',
          '20 Compliments a week',
          'Boost a week',
          'See who liked you',
          'Access to for you',
          'Travel Mode',
          'Incognito Mode',
          'Location to anywhere',
          'Advanced Filters',
          'Enhanced Recommendations',
          'More likes in for you',
        ],
        'bestValue': false,
      },
      {
        'name': 'Yearly',
        'price': '\$184',
        'originalPrice': '\$230',
        'discount': '20%',
        'features': [
          '500 Swipes',
          'Unlimited Extends',
          'Unlimited Backtrack',
          'Unlimited Rematch',
          '10 Super Swipes a week',
          '20 Compliments a week',
          'Boost a week',
          'See who liked you',
          'Access to for you',
          'Travel Mode',
          'Incognito Mode',
          'Location to anywhere',
          'Advanced Filters',
          'Enhanced Recommendations',
          'More likes in for you',
        ],
        'bestValue': true,
      },
    ],
    'Plus': [
      {
        'name': 'Monthly',
        'price': '\$12',
        'originalPrice': null,
        'discount': null,
        'features': [
          '500 Swipes',
          'Unlimited Extends',
          'Unlimited Backtrack',
          'Unlimited Rematch',
          '10 Super Swipes a week',
          '20 Compliments a week',
          'Boost a week',
        ],
        'bestValue': false,
      },
      {
        'name': '3 Months Plan',
        'price': '\$32',
        'originalPrice': '\$36',
        'discount': '10%',
        'features': [
          '500 Swipes',
          'Unlimited Extends',
          'Unlimited Backtrack',
          'Unlimited Rematch',
          '10 Super Swipes a week',
          '20 Compliments a week',
          'Boost a week',
        ],
        'bestValue': false,
      },
      {
        'name': 'Yearly',
        'price': '\$74',
        'originalPrice': '\$92',
        'discount': '20%',
        'features': [
          '500 Swipes',
          'Unlimited Extends',
          'Unlimited Backtrack',
          'Unlimited Rematch',
          '10 Super Swipes a week',
          '20 Compliments a week',
          'Boost a week',
        ],
        'bestValue': true,
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> currentPlans = _plans[_selectedTab]!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Image.asset('assets/creditcard.png', width: 25),
            const SizedBox(width: 8),
            const Text(
              'Subscription & Payment',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Choose your plan',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const RedeemPage())),
                  child: const Row(
                    children: [
                      Image(
                        height: 20,
                        image: AssetImage('assets/reward.png'),
                      ),
                      Text(
                        'Redeem Coins',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _tabButton(context, 'Pro'),
                _tabButton(context, 'Plus'),
              ],
            ),
            const SizedBox(height: 20),
            // Dynamically generate PlanCards based on selected tier
            ...currentPlans.map((plan) => Column(
                  children: [
                    PlanCard(
                      planType: _selectedTab,
                      planName: plan['name'],
                      price: plan['price'],
                      strikeThroughPrice: plan['originalPrice'],
                      discount: plan['discount'],
                      features: plan['features'],
                      bestValue: plan['bestValue'],
                      context: context,
                    ),
                    SizedBox(height: 20),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(BuildContext context, String label) {
    bool isSelected = _selectedTab == label;

    return Column(
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              _selectedTab = label;
            });
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            label,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        if (isSelected)
          Container(
            height: 4,
            width: 50,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFD83694), Color(0xFF0039C7)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
      ],
    );
  }
}

class PlanCard extends StatelessWidget {
  final String planName;
  final String price;
  final String? strikeThroughPrice;
  final String? discount;
  final List<String> features;
  final bool bestValue;
  final BuildContext context;
  final String planType; // Add this parameter

  PlanCard({
    required this.planName,
    required this.price,
    this.strikeThroughPrice,
    this.discount,
    required this.features,
    this.bestValue = false,
    required this.context,
    required this.planType, // Initialize this parameter
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (planType == 'Pro') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Subscriptionandpaymentplans(
                planDetails: {
                  'planType': planType,
                  'planName': planName,
                  'price': price,
                  'originalPrice': strikeThroughPrice,
                  'discount': discount,
                  'features': features,
                  'bestValue': bestValue,
                },
              ), // Replace with your Pro plan screen
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Subscriptionandpaymentplansgetstarted2(
                planDetails: {
                  'planType': planType,
                  'planName': planName,
                  'price': price,
                  'originalPrice': strikeThroughPrice,
                  'discount': discount,
                  'features': features,
                  'bestValue': bestValue,
                },
              ), // Replace with your Plus plan screen
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  planName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                if (bestValue) _bestValueTag(),
              ],
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  price,
                  style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
                ),
                if (strikeThroughPrice != null)
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      strikeThroughPrice!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                        decorationThickness: 2,
                        decorationColor: Colors.grey,
                      ),
                    ),
                  ),
                if (discount != null)
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      '($discount Off)',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),
            _getStartedButton(),
            SizedBox(height: 20),
            const Text(
              'Features',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _featuresList(),
            Text(
                planType == 'Pro'
                    ? 'view 11+ more features...'
                    : "view 3+ more features...",
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _bestValueTag() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD83694), Color(0xFF0039C7)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text('Best Value', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _getStartedButton() {
    return Center(
      child: Container(
        width: double.infinity,
        height: 40,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => SubscriptionAndPayment3()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Center(
            child: Text(
              'Get Started',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _featuresList() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(4, (index) {
          final feature = features[index];
          return FeatureTile(
            icon: Icons.check_circle,
            text: feature,
          );
        }));
  }
}

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String text;

  FeatureTile({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black, size: 16),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}
