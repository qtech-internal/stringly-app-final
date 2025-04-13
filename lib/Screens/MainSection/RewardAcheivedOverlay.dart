import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../Reward Settings/RewardsPage.dart';

class RewardAchievedOverlay extends StatelessWidget {
  const RewardAchievedOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12), // Rounded corners for the dialog
      ),
      backgroundColor: Colors.white, // Background color of the dialog
      child: Stack(
        children: [
          Container(
            width: 450, // Width of the dialog
            height: 455, // Adjust height as needed
            padding: const EdgeInsets.all(16), // Padding around the content
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // Minimize the height of the column
              children: [
                const Text(
                  'Unlock Premium', // Text to be displayed
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.0, // Set line height to 1.0 to reduce space
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    const SizedBox(width: 50),
                    Container(
                      child: Image.asset(
                        'assets/coin.png', // Image to be displayed
                        height: 80, // Adjust height of the image as needed
                        width: 70,
                        fit: BoxFit.contain,
                        // Adjust width of the image as needed
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '24 Tokens', // Token text
                      style: TextStyle(
                        fontWeight: FontWeight.bold, // Make the text bold
                        fontSize: 20, // Font size for token text
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30), // Space below the row
                // List of features
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check, color: Colors.black, size: 16),
                    // Tick mark adjusted to 16
                    SizedBox(width: 8),
                    // Space between icon and text
                    Expanded(
                      child: Text(
                        'See who liked your profile without limits.',
                        style: TextStyle(
                          fontSize: 14, // Decreased font size to 14
                          color: Colors.black, // Ensure text color is black
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10), // Space between bullet points
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check, color: Colors.black, size: 16),
                    // Tick mark adjusted to 16
                    SizedBox(width: 8),
                    // Space between icon and text
                    Expanded(
                      child: Text(
                        'Unlimited swipes per day for increased matching opportunities.',
                        style: TextStyle(
                          fontSize: 14, // Decreased font size to 14
                          color: Colors.black, // Ensure text color is black
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10), // Space between bullet points
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check, color: Colors.black, size: 16),
                    // Tick mark adjusted to 16
                    SizedBox(width: 8),
                    // Space between icon and text
                    Expanded(
                      child: Text(
                        'Activate “Boost” to enhance your profile visibility for an hour each day.',
                        style: TextStyle(
                          fontSize: 14, // Decreased font size to 14
                          color: Colors.black, // Ensure text color is black
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10), // Space between bullet points
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check, color: Colors.black, size: 16),
                    // Tick mark adjusted to 16
                    SizedBox(width: 8),
                    // Space between icon and text
                    Expanded(
                      child: Text(
                        'Backtrack button to undo the swipe.',
                        style: TextStyle(
                          fontSize: 14, // Decreased font size to 14
                          color: Colors.black, // Ensure text color is black
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50), // Space below the placeholder text
                // Learn how to earn tokens button
                SizedBox(
                  width: 300, // Width of the button
                  child: ElevatedButton(
                    onPressed: () {
                      // Action for learn how to earn tokens button
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return RewardOverlay2();
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      // Background color of the button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Reduced border radius to 10
                      ),
                    ),
                    child: const Text(
                      'Upgrade to premium', // Button text
                      style: TextStyle(color: Colors.white), // Text color
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Close button (X) at the top right
          Positioned(
            right: 10,
            top: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Icon(
                Icons.close,
                color: Colors.black, // Color of the close icon
                size: 20, // Size of the close icon
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RewardOverlay2 extends StatelessWidget {
  const RewardOverlay2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      backgroundColor: Colors.white, // Background color of the dialog
      child: Stack(
        children: [
          Container(
            width: 400, // Width of the dialog
            height: 450, // Adjust height as needed
            padding: const EdgeInsets.all(16), // Padding around the content
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // Minimize the height of the column
              children: [
                const SizedBox(height: 80),
                Image.asset(
                  'assets/coin2.png', // Image to be displayed
                  height: 100, // Adjust height of the image as needed
                  width: 100,
                  fit: BoxFit.contain,
                  // Adjust width of the image as needed
                ),
                const SizedBox(height: 25),
                // Small space between image and text
                const Text(
                  'Not Enough tokens!', // Text to be displayed
                  style: TextStyle(
                    fontSize: 18, // Font size for the warning text
                    fontWeight: FontWeight.bold, // Make the text bold
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 25),
                // Small space below the text
                const Text(
                  'Lorem ipsum dolor sit amet, consectetur ',
                  // Placeholder text
                  textAlign: TextAlign.center, // Center align the text
                  style: TextStyle(
                    fontSize: 17, // Font size for the placeholder text
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 50),
                // Space below the placeholder text
                // Learn how to earn tokens button
                SizedBox(
                  width: 300, // Width of the button
                  child: ElevatedButton(
                    onPressed: () {
                      // Action for learn how to earn tokens button
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return RewardPointsSettings();
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      // Background color of the button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Reduced border radius to 10
                      ),
                    ),
                    child: const Text(
                      'Upgrade to premium', // Button text
                      style: TextStyle(color: Colors.white), // Text color
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Close button (X) at the top right
          Positioned(
            right: 10,
            top: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Icon(
                Icons.close,
                color: Colors.black, // Color of the close icon
                size: 24, // Size of the close icon
              ),
            ),
          ),
        ],
      ),
    );
  }
}
