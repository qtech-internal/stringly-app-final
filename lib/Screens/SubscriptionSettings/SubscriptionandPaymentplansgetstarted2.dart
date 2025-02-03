import 'package:flutter/material.dart';

import 'Subscription3.dart';

class Subscriptionandpaymentplansgetstarted2 extends StatefulWidget {
  final Map<String, dynamic> planDetails;

  const Subscriptionandpaymentplansgetstarted2({
    Key? key,
    required this.planDetails
  }) : super(key: key);

  @override
  State<Subscriptionandpaymentplansgetstarted2> createState() =>
      _Subscriptionandpaymentplansgetstarted2State();
}

class _Subscriptionandpaymentplansgetstarted2State
    extends State<Subscriptionandpaymentplansgetstarted2> {
  late Map<String, dynamic> _planDetails;

  @override
  void initState() {
    super.initState();
    _planDetails = widget.planDetails;
  }

  Widget _getStartedButton() {
    return Center(
      child: Container(
        width: 350,
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
          child: Center(
            child: Text(
              'Continue',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Image.asset('assets/creditcard.png', width: 25),
            const SizedBox(width: 8),
            Text(
              '${_planDetails['planType']} Plan',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '${_planDetails['planType']} Plan',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600
                    ),
                  )
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '${_planDetails['planName']} - ${_planDetails['price']}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                        ),
                      )
                  ),
                  if (_planDetails['originalPrice'] != null)
                    Text(
                      'Save ${_planDetails['discount']}',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                      ),
                    )
                ],
              ),
              SizedBox(height: 35),
              _getStartedButton(),
              SizedBox(height: 35),
              PlanCard(
                planName: _planDetails['planName'],
                price: _planDetails['price'],
                features: _planDetails['features'],
                bestValue: _planDetails['bestValue'] ?? false,
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Keep the existing PlanCard and FeatureTile classes from the previous implementation

class PlanCard extends StatelessWidget {
  final String planName;
  final String price;
  final String? pricePerMonth;
  final List<String> features;
  final bool bestValue;
  final BuildContext context; // Add context parameter

  PlanCard({
    required this.planName,
    required this.price,
    this.pricePerMonth,
    required this.features,
    this.bestValue = false,
    required this.context, // Accept context in constructor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
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
              Baseline(
                baseline: 30, // Adjust this value to align with the main price
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  price,
                  style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
                ),
              ),
              if (pricePerMonth != null)
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Baseline(
                    baseline: 22, // Match the baseline of the main price
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      pricePerMonth!,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 20),
          const Text(
            'Features',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 20),
          _featuresList(),
        ],
      ),
    );
  }

  Widget _bestValueTag() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFD83694), Color(0xFF0039C7)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text('Best Value', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _featuresList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features
          .map(
              (feature) => FeatureTile(icon: Icons.check_circle, text: feature))
          .toList(),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String text;

  FeatureTile({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          SizedBox(width: 10),
          Expanded(
              child: Text(
            text,
            style: const TextStyle(color: Colors.grey),
          )), // Prevent text overflow
        ],
      ),
    );
  }
}
