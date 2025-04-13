import 'package:flutter/material.dart';

class AvailablePlansScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Your Monthly Payment', style: TextStyle(color: Colors.grey),),
            const SizedBox(height: 12),
            Container(
              height: 120,
              padding: const EdgeInsets.all(2), // Padding for thick gradient border
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Colors.pinkAccent, Colors.blueAccent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            SizedBox(height: 15), // Adjust top margin
                            Text(
                              'Yearly Plan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text('Your next billing date is October 16, 2024', style: TextStyle(color: Colors.grey),),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      right: 0, // Align to the right side
                      top: 15,  // Align at the same vertical level as 'Yearly Plan'
                      child: const Text(
                        '\$17.99',
                        style: TextStyle(
                          fontSize: 18, // Match font size with 'Yearly Plan'
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )

              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Payment History',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  buildPaymentHistoryItem('9/16/2024', '\$17.99'),
                  buildPaymentHistoryItem('8/16/2024', '\$17.99'),
                  buildPaymentHistoryItem('7/16/2024', '\$17.99'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentHistoryItem(String date, String amount) {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text('Lorem ipsum: dolor ist', style: TextStyle(color: Colors.grey),),
              const SizedBox(height: 6),

              const Text('Lorem ipsum: dolor ist', style: TextStyle(color: Colors.grey),),
            ],
          ),
          Text(
            amount,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
