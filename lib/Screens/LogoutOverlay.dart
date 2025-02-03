import 'package:flutter/material.dart';

import '../main.dart';
import 'WelcomePage.dart';

class LogOutOverlay extends StatelessWidget {
  const LogOutOverlay({Key? key}) : super(key: key);

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
                'assets/blacktick.png', // Image to be displayed
                height: 100, // Adjust height of the image as needed
                width: 100, // Adjust width of the image as needed
              ),
              const SizedBox(height: 8), // Small space between image and text
              const Text(
                'Logout Confirmation', // Updated title for logout
                style: TextStyle(
                  fontSize: 20, // Font size for the warning text
                  fontWeight: FontWeight.bold, // Make the text bold
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8), // Small space below the text
              const Text(
                'Are you sure you want to logout?',
                textAlign: TextAlign.center, // Center align the text
                style: TextStyle(
                  fontSize: 16, // Font size for the placeholder text
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16), // Space below the placeholder text
              // Logout button
              SizedBox(
                width: 300, // Width of the button
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Welcomepage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Background color of the button
                  ),
                  child: const Text(
                    'Logout', // Button text
                    style: TextStyle(color: Colors.white), // Text color
                  ),
                ),
              ),
              const SizedBox(height: 8), // Space below the button
              // Cancel button
              SizedBox(
                width: 300, // Width of the button
                child: ElevatedButton(
                  onPressed: () {
                    // Action for cancel button
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, // Background color for cancel button
                  ),
                  child: const Text(
                    'Cancel', // Button text
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
