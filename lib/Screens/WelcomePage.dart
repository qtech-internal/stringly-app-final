// import 'dart:developer';
// import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:agent_dart/agent_dart.dart';
// import 'package:flutter_icp_auth/flutter_icp_auth.dart';
// import 'package:flutter_icp_auth/internal/auth_idl.dart';
//
// import '../integration.dart';
// import '../mainScreenNav.dart';
// import 'UserInfo1.dart';
//
//
// class Welcomepage extends StatefulWidget {
//   const Welcomepage({super.key});
//
//   @override
//   State<Welcomepage> createState() => _WelcomepageState();
// }
//
// class _WelcomepageState extends State<Welcomepage> {
//   bool _isSignIn = true; // State variable to track the text
//   String _principalId = "Log in to see your principal"; // Default principal ID
//   bool isLoggedIn = false;
//
//   // ---------------------------------------------------
//   // Must declare these in your application
//   // ---------------------------------------------------
//   bool isLocal =
//   true; // To confirm if you running your project locally or using main-net. Change it to true if running locally
//   Service idlService =
//       FieldsMethod.idl; // Idl service (Location: lib/integration.dart)
//   String backendCanisterId =
//       'bkyz2-fmaaa-aaaaa-qaaaq-cai'; // Replace it with your backend canisterId
//   String middlePageCanisterId =
//       'br5f7-7uaaa-aaaaa-qaaca-cai'; // Replace it with your middlePage canisterId
//
//   // ---------------------------------------------------------------
//   // Add this in the app to check the login state when the app is opened
//   // ---------------------------------------------------------------
//
//   @override
//   void initState() {
//     super.initState();
//     AuthLogIn.checkLoginStatus(isLocal, backendCanisterId).then((loggedIn) {
//       setState(() {
//         isLoggedIn = loggedIn;
//         if (loggedIn) {
//           _principalId = AuthLogIn.getPrincipal;
//         }
//       });
//       if (!loggedIn) {
//         UrlListener.handleInitialUri(_manualLogin, () {});
//         UrlListener.initListener(_manualLogin);
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     UrlListener.cancelListener();
//     super.dispose();
//   }
//
//   Future<void> _manualLogin(Uri uri) async {
//     List<dynamic> result = await AuthLogIn.fetchAgent(
//         uri.queryParameters, isLocal, backendCanisterId, idlService as Service);
//     if (result.isNotEmpty) {
//       setState(() {
//         isLoggedIn = uri.queryParameters['status'] == "true" ? true : false;
//         _principalId = result[0];
//       });
//     } else {
//       setState(() {
//         isLoggedIn = false;
//         _principalId = "Log in to see your principal";
//       });
//     }
//   }
//
//   void _toggleText() {
//     setState(() {
//       _isSignIn = !_isSignIn; // Toggle the text state
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(height: 50,),
//           // Display Principal ID
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               'Principal ID: $_principalId',
//               style: TextStyle(
//                 fontFamily: 'SFProDisplay',
//                 fontSize: 14,
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           SizedBox(height: 190,),
//           const Center(
//           //   child: Image(
//           //     image: AssetImage(
//           //       'assets/COLOURED LOGO 1.png',
//           //     ),
//           //   ),
//           ),
//           SizedBox(height: 5,),
//           Text(
//             'String your vibe.',
//             style: TextStyle(
//               fontFamily: 'SFProDisplay',
//               fontSize: 14,
//               color: Color(0xFF000000),
//             ),
//           ),
//           SizedBox(height: 72,),
//
//           // Button for ICP Sign In
//           SizedBox(
//             width: 276,
//             height: 50,
//             child: ElevatedButton(
//               onPressed: () async {
//                 if (!isLoggedIn) {
//                   await AuthLogIn.authenticate(isLocal,
//                       middlePageCanisterId, "examplecallback", "example");
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                 backgroundColor: Colors.black,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     _isSignIn ? 'Sign Up with Internet Identity' : 'Sign In with Internet Identity  ', // Change text based on state
//                     style: TextStyle(
//                       fontFamily: 'SFProDisplay',
//                       fontSize: 13,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 30),
//
//           // Button for NFID Sign In
//           SizedBox(
//             width: 276,
//             height: 50,
//             child: ElevatedButton(
//               onPressed: () {
//               },
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                 backgroundColor: Colors.black,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     _isSignIn ? 'Sign up with Email' : 'Sign in with Email', // Change text based on state
//                     style: TextStyle(
//                       fontFamily: 'SFProDisplay',
//                       fontSize: 13,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 30),
//
//           // Text Button to toggle between "Sign In" and "Sign Up"
//           Text.rich(
//             TextSpan(
//               text: _isSignIn ? 'Already have an account? ' : 'Don’t have an account? ', // Change text based on state
//               style: TextStyle(
//                 fontFamily: 'SFProDisplay',
//                 fontSize: 12,
//                 color: Colors.black,
//               ),
//               children: <TextSpan>[
//                 TextSpan(
//                   text: _isSignIn ? 'Sign In' : 'Sign Up', // Change text based on state
//                   style: TextStyle(
//                     fontFamily: 'SFProDisplay',
//                     fontWeight: FontWeight.bold,
//                     fontSize: 12,
//                     color: Colors.black,
//                   ),
//                   recognizer: TapGestureRecognizer()..onTap = _toggleText, // Handle tap
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }