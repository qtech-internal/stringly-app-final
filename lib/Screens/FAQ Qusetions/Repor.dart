import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import '../../Reuseable Widget/gradienttextfield.dart';
import '../mainScreenNav.dart';

class ReportIssueScreen extends StatefulWidget {
  @override
  _ReportIssueScreenState createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  SingleValueDropDownController _controller = SingleValueDropDownController(); // Controller for the dropdown
  String? IssueValue;

  List<String> IssueItems = [
    'Lorem ipsum',
    'Lorem ipsum',
    'Lorem ipsum',
    'Lorem ipsum',
  ];

  bool isFocused = false; // Track if the dropdown is focused

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black, // Black app bar
        title: const Row(
          children: [
            Image(
              image: AssetImage('assets/report2.png'),
              width: 32,
              height: 32,
            ),
            SizedBox(width: 8),
            Text(
              'Report an Issue',
              style: TextStyle(color: Colors.white), // Title text
            ),
          ],
        ),
      ),
      body: SingleChildScrollView( // Make the body scrollable
        child: Column(
          children: [
            SizedBox(height: 40),
            // Logo image
            Center(
              child: Image.asset(
                'assets/COLOURED LOGO 1.png',
                height: 40,
              ),
            ),
            const SizedBox(height: 16),
            // Text below the logo
            const Center(
              child: Text(
                'How can we help you?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 50),
            // Dropdown TextField
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: GradientdropdownTextField(
                        hintText: 'Select',
                        items: IssueItems,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              isFocused = true;
                            });
                          }
                        },
                        label: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'What Issues are you facing?',
                                  style: TextStyle(
                                      color: Colors.black ,
                                      backgroundColor: Colors.white, fontSize: 14
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                    ),
                  ),
                ],
              ),
            ),

            // GestureDetector(
            //   onTap: () {
            //     setState(() {
            //       isFocused = true; // Set focus to true when tapped
            //     });
            //   },
            //   child: Container(
            //     margin: const EdgeInsets.symmetric(horizontal: 16),
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(10),
            //       border: Border.all(
            //         color: isFocused ? Colors.blue : Colors.grey, // Change border color based on focus
            //       ),
            //       gradient: const LinearGradient(
            //         colors: [Color(0xFFD83694), Color(0xFF0039C7)],
            //         begin: Alignment.topLeft,
            //         end: Alignment.bottomRight,
            //       ),
            //     ),
            //     child: DropDownTextField(
            //       controller: _controller,
            //       clearOption: true,
            //       dropDownItemCount: 6,
            //       dropDownList: IssueItems.map((item) {
            //         return DropDownValueModel(name: item, value: item);
            //       }).toList(),
            //       onChanged: (value) {
            //         setState(() {
            //           IssueItems = value.value; // Update the selected value
            //           isFocused = false; // Remove focus after selection
            //         });
            //       },
            //       textFieldDecoration: InputDecoration(
            //         hintText: 'What Issues are you facing?',
            //         border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(10),
            //           borderSide: BorderSide.none,
            //         ),
            //         contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            //         filled: true,
            //         fillColor: Colors.white, // Background color for the dropdown
            //         suffixIcon: const Text('*', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 300), // Add space before the button
            // Black rectangular button at the bottom
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  _showReportedSuccessfullyDialog(context); // Show the success dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                ),
                child: const Text(
                  'Submit Report',
                  style: TextStyle(
                    color: Colors.white, // Text color
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReportedSuccessfullyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          backgroundColor: Colors.white, // Background color of the dialog
          child: Container(
            height:380,
            width: 450, // Width of the dialog
            padding: const EdgeInsets.all(16), // Padding around the content
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Minimize the height of the column
                    children: [
                      SizedBox(height: 30),
                      Image.asset(
                        'assets/tick.png', // Image to be displayed
                        height: 100, // Adjust height of the image as needed
                        width: 100, // Adjust width of the image as needed
                      ),
                      const SizedBox(height: 8), // Small space between image and text
                      const Text(
                        'Report Submitted Successfully',
                        textAlign: TextAlign.center,// Text to be displayed
                        style: TextStyle(
                          fontSize: 16, // Font size for the warning text
                          fontWeight: FontWeight.bold, // Make the text bold
                          color: Colors.black,
                        ),
                      ), // Small space below the text
                      const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'Thank you for helping us keep Stringly safe and enjoyable for everyone. Our team will review your report within 24-72 hours. If further information is needed, we’ll reach out to you.',
                          textAlign: TextAlign.center, // Center align the text
                          style: TextStyle(
                            fontSize: 14, // Font size for the placeholder text
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30), // Space below the placeholder text
                    ],
                  ),
                ),
                Positioned(
                  top: -14, // Position from the top
                  right: -14, // Position from the right
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.grey), // Gray cross icon
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
