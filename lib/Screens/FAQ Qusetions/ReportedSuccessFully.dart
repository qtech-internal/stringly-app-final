import 'package:flutter/material.dart';

import '../mainScreenNav.dart';


class ReportedSuccessfully extends StatelessWidget {
  const ReportedSuccessfully({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      backgroundColor: Colors.white, // Background color of the dialog
      child: Container(
        width: 500, // Width of the dialog
        padding: const EdgeInsets.all(16), // Padding around the content
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Minimize the height of the column
            children: [
              Image.asset(
                'assets/tick.png', // Image to be displayed
                height: 100, // Adjust height of the image as needed
                width: 100, // Adjust width of the image as needed
              ),
              const SizedBox(height: 8), // Small space between image and text
              const Text(
                'Report Submitted Successfully', // Text to be displayed
                style: TextStyle(
                  fontSize: 20, // Font size for the warning text
                  fontWeight: FontWeight.bold, // Make the text bold
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8), // Small space below the text
              const Text(
                'Thank you for helping us keep Stringly safe and enjoyable for everyone. Our team will review your report within 24-72 hours. If further information is needed, we’ll reach out to you.',
                textAlign: TextAlign.center, // Center align the text
                style: TextStyle(
                  fontSize: 16, // Font size for the placeholder text
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16), // Space below the placeholder text
              // Continue button
              Container(
                width: 300, // Width of the button
                child: ElevatedButton(
                  onPressed: () {
                    // Action for the continue button
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Mainscreennav())); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Background color of the button
                  ),
                  child: const Text(
                    'Continue', // Button text
                    style: TextStyle(color: Colors.white), // Text color
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
