import 'package:flutter/material.dart';
import 'package:stringly/Screens/AccountSettings/privacy_policy_page.dart';

import 'FAQ.dart';
import 'Repor.dart';


class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black, // Black app bar
        title: const Row(
          children: [
            Icon(Icons.help_outline, color: Colors.white), // Help icon
            SizedBox(width: 8),
            Text(
              'Help and Support',
              style: TextStyle(color: Colors.white), // Title text
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey[200], // Greyish background for the body
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white, // White container for contents
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TextButton row for FAQ, Terms and Privacy Policy, and Report an issue
                  Column(
                    children: [
                      TextButtonRow(
                        imagePath: 'assets/FAQ.png', // Custom image for FAQ
                        text: 'FAQ',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => FAQScreen()));
                        },
                      ),
                      const SizedBox(height: 15),
                      TextButtonRow(
                        imagePath: 'assets/policy.png', // Custom image for Terms and Privacy Policy
                        text: 'Terms and Privacy Policy',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PrivacyPolicyPage()));
                        },
                      ),
                      const SizedBox(height: 15),
                      TextButtonRow(
                        imagePath: 'assets/report.png', // Custom image for Report an Issue
                        text: 'Report an Issue',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReportIssueScreen()));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom row widget for text buttons with images and right arrow
class TextButtonRow extends StatelessWidget {
  final String imagePath;
  final String text;
  final VoidCallback onTap;

  const TextButtonRow({
    Key? key,
    required this.imagePath,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontWeight: FontWeight.w400,fontSize: 14),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 12), // Text color
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(width: 20,
                child: Image.asset(
                  fit: BoxFit.contain,
                  imagePath,
                  width: 20, // Adjust width as needed
                  height: 20, // Adjust height as needed
                ),
              ), // Custom image before text
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(fontSize: 16), // Adjust text size as needed
              ),
            ],
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 15), // Right arrow
        ],
      ),
    );
  }
}
