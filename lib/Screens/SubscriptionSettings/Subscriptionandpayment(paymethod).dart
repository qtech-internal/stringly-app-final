import 'package:flutter/material.dart';

class SubscriptionPaymentScreenmethod extends StatelessWidget {
  const SubscriptionPaymentScreenmethod ({super.key});

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
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Choose your Payment Option',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16),
            PaymentOptionCard(
              label: 'Card Payment',
              icon: Icons.credit_card,
            ),
            SizedBox(height: 12),
            PaymentOptionCard(
              label: 'Internet Banking',
              icon: Icons.account_balance,
            ),
            SizedBox(height: 12),
            PaymentOptionCard(
              label: 'UPI Payment',
              icon: Icons.payment,
              customIcon: 'assets/Upi.logo.png', // Replace with UPI logo asset path
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentOptionCard extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? customIcon;

  const PaymentOptionCard({
    super.key,
    required this.label,
    this.icon,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SizedBox(
        height: 80,
        child: ListTile(
          trailing: customIcon != null
              ? Image.asset(
            customIcon!,
            width: 50,
            height: 50,
          )
              : Icon(icon, size: 30),
          title: Text(label),
          onTap: () {
            // Handle payment option tap
          },
        ),
      ),
    );
  }
}