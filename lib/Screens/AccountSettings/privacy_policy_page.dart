import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Privacy Policy",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Last Updated: ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text('[06-12-2024]', style: TextStyle(fontWeight: FontWeight.bold),)
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "1. Who We Are",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.grey),
                      children: [
                        TextSpan(
                          text: "Stringly is dedicated to creating meaningful and authentic connections through innovative technology. This Privacy Policy applies to all services provided through our mobile app and any associated websites or services.",
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "2. Information We Collect",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Personal Information:', style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        TextSpan(
                         text:  ' Name, email address, phone number, gender, date of birth, and preferences.' , style: TextStyle(color: Colors.grey)
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.black),
                      children: [
                        TextSpan(
                            text: 'Profile Data: ', style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        TextSpan(
                            text:  'Photos, bio, and verification data.' , style: TextStyle(color: Colors.grey)
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.black),
                      children: [
                        TextSpan(
                            text: 'Location Information: ', style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        TextSpan(
                            text:  'Geolocation data with your consent.' , style: TextStyle(color: Colors.grey)
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.black),
                      children: [
                        TextSpan(
                            text: 'Activity Information: ', style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        TextSpan(
                            text:  'Swipes, matches, messages, and interactions.' , style: TextStyle(color: Colors.grey)
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.black),
                      children: [
                        TextSpan(
                            text: 'Device Information: ', style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        TextSpan(
                            text:  'Device model, OS, IP address, and usage logs.' , style: TextStyle(color: Colors.grey)
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "3. How We Use Your Information",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Matching users based on preferences, location, and interests.", style: TextStyle(
                            fontSize: 16, height: 1.5, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Authenticating and verifying profiles to ensure trustworthy interactions.", style: TextStyle(
                            fontSize: 16, height: 1.5, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Customizing user experiences.", style: TextStyle(
                            fontSize: 16, height: 1.5, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Detecting and preventing fraud and unauthorized activity.", style: TextStyle(
                            fontSize: 16, height: 1.5, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Processing payments securely.", style: TextStyle(
                            fontSize: 16, height: 1.5, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Enhancing features and performance through analytics.",style: TextStyle(
                            fontSize: 16, height: 1.5, color: Colors.grey),
                        ),
                      ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "4. Sharing Your Information",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "With trusted partners for payment processing, analytics, and support.", style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "To comply with legal obligations.", style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "In case of a merger or acquisition.", style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "5. Your Privacy Choices",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Update or edit your data in-app.", style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Request account deletion via app settings.", style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Manage permissions in your device settings.", style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "6. Data Retention",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "We retain your data as long as your account is active. Once deleted, data is removed within 30 days, except for legal compliance.", style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "7. Cookies and Tracking Technologies",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "We use cookies to enhance your experience.", style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "You can manage cookie preferences through your browser or device settings.", style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "8. Security",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                      "We implement encryption and secure protocols to protect your data. While no system is foolproof, we maintain high-security standards.", style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "9. Children’s Privacy",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Stringly is intended for users aged 18 and older. We do not knowingly collect information from individuals under 18.", style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "10. International Data Transfers",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "If you’re using Stringly outside of [Insert Country], your data may be transferred to and processed in countries where we operate. We comply with applicable data protection laws for these transfers.", style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "11. Contact Us",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'If you have questions or concerns about this Privacy Policy or your data, please contact us at: ', style: TextStyle(color: Colors.grey)
                        ),
                        TextSpan(
                           text: "Email: support@stringly.com", style: TextStyle(fontWeight: FontWeight.bold)
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                  fontSize: 16, height: 1.5, color: Colors.black),
              children: _parseContent(content),
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _parseContent(String content) {
    final List<TextSpan> spans = [];
    final parts = content.split(RegExp(r'(\*\*.*?\*\*)'));

    for (var part in parts) {
      if (part.startsWith('**') && part.endsWith('**')) {
        spans.add(TextSpan(
          text: part.replaceAll('**', ''),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ));
      } else {
        spans.add(TextSpan(text: part));
      }
    }
    return spans;
  }
}
