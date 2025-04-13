import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: MainScreen()));
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Show the reward achieved overlay when button is pressed
            showDialog(
              context: context,
              builder: (context) => const RewardAchievedOverlay2(),
            );
          },
          child: const Text('Show Reward Overlay'),
        ),
      ),
    );
  }
}


class RewardAchievedOverlay2 extends StatefulWidget {
  const RewardAchievedOverlay2({Key? key}) : super(key: key);

  @override
  State<RewardAchievedOverlay2> createState() => _RewardAchievedOverlay2State();
}

class _RewardAchievedOverlay2State extends State<RewardAchievedOverlay2> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      backgroundColor: Colors.white, // Background color of the dialog
      child: Container(
        width: 400, // Width of the dialog
        height: 450, // Adjust height as needed
        padding: const EdgeInsets.all(16), // Padding around the content
        child: Column(
          mainAxisSize: MainAxisSize.min, // Minimize the height of the column
          children: [SizedBox(height: 60,),
            Image.asset(
              'assets/coin2.png', // Image to be displayed
              height: 100, // Adjust height of the image as needed
              width: 100, // Adjust width of the image as needed
            ),
            const SizedBox(height: 8), // Small space between image and text
            const Text(
              'You earned 20 points', // Text to be displayed
              style: TextStyle(
                fontSize: 24, // Font size for the warning text
                fontWeight: FontWeight.bold, // Make the text bold
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20), // Small space below the text
            const Text(
              'Nice job expading your meaningful connections',
              textAlign: TextAlign.center, // Center align the text
              style: TextStyle(
                fontSize: 16, // Font size for the placeholder text
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 80), // Space below the placeholder text

            // Learn how to earn tokens button
            Container(
              width: 300, // Width of the button
              child: ElevatedButton(
                onPressed: () {
                  // Action for learn how to earn tokens button
                  Navigator.of(context).pop(); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Background color of the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Adjust the radius for less rounding
                  ),
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
    );
  }
}
