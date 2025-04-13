// import 'package:flutter/material.dart';
//
// class Focusoverlay extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Dialog(
//         backgroundColor: Colors.white,
//         insetPadding: EdgeInsets.only(top: 61),  // Adds gap at the top
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // Optional rounded top corners
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 children: [
//                   CircleAvatar(
//                     backgroundColor: Color(0xFFFAFAFA),  // Circle background color
//                     radius: 20,  // Adjust the size of the circle
//                     child: IconButton(
//                       icon: Icon(Icons.close),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                       color: Colors.black,  // Set the color of the icon
//                     ),
//                   ),
//
//
//
//                   Padding(
//                     padding: const EdgeInsets.only(left: 60.0),
//                     child: Container(
//                       width: 150,  // Adjust the width as needed
//                       child: Divider(
//                         color: Colors.grey[300],
//                         thickness: 1,
//                       ),
//                     ),
//                   )
//
//                 ],
//               ),
//               // Close Button and Title
//               Row(
//                 children: [
//
//                   Expanded(
//                     child: Center(
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 40.0,left: 10,right: 10),
//                         child: Text(
//                           "What is your main professional focus?",
//                           style: TextStyle(
//                             fontSize: 17,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 48), // Spacer to balance the close button
//                 ],
//               ),
//               SizedBox(height: 16),
//
//               // Scrollable Options
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       _buildOptionButton("Technology & Software Development"),
//                       _buildOptionButton("Arts & Entertainment"),
//                       _buildOptionButton("Media & Journalism"),
//                       _buildOptionButton("Music & Performing Arts"),
//                       _buildOptionButton("Banking & Finance"),
//                       _buildOptionButton("Consulting"),
//                       _buildOptionButton("Marketing & Advertising"),
//                       _buildOptionButton("Healthcare & Medicine"),
//                       _buildOptionButton("Education & Research"),
//                       SizedBox(height: 20), // Extra space before Done button
//                       Container(
//                         width: 300,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.black,
//                             padding: EdgeInsets.symmetric(vertical: 14),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           child: Text(
//                             'Done',
//                             style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 16),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Done Button
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildOptionButton(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Container(
//         height: 60,
//         width: 350,
//         child: TextButton(
//           onPressed: () {
//             // Action when option is selected
//           },
//           style: TextButton.styleFrom(
//             foregroundColor: Colors.black,
//             backgroundColor: Colors.white,
//             padding: EdgeInsets.symmetric(vertical: 14),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//               side: BorderSide(color: Colors.grey[300]!),
//             ),
//           ),
//           child: Center(
//             child: Text(
//               title,
//               style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
