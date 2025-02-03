import 'package:flutter/material.dart';

class SubscriptionandPayment5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Image.asset('assets/creditcard.png', width: 25),

            const SizedBox(width: 8), // Add space between the image and the title
            const Text(
              'Subscription & Payment',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
      body:const Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cancel Membership',
              style: TextStyle(
                fontSize: 19.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Subscriptions are non-refundable and cannot be cancelled once purchased. We kindly encourage you to choose your plan thoughtfully, as we won’t be able to process refunds or cancellations after the transaction is complete.',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black45,  // Grey subtext
              ),
            ),
          ],
        ),
      ),
    );
  }
}

