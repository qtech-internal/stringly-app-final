// import 'package:flutter/material.dart';
//
// class LoadingScreen extends StatefulWidget {
//   @override
//   _LoadingScreenState createState() => _LoadingScreenState();
// }
//
// class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
//   AnimationController? _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 3),  // Adjust the duration for a slower/faster fill
//       vsync: this,
//     )..repeat(reverse: false);  // Repeat if you want it continuous
//   }
//
//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: AnimatedBuilder(
//           animation: _controller!,
//           builder: (context, child) {
//             return ShaderMask(
//               shaderCallback: (Rect bounds) {
//                 return LinearGradient(
//                   colors: const[
//                     Color(0xFFD83694), // Gradient color #D83694
//                     Color(0xFF0039C7), // Gradient color #0039C7
//                   ],
//                   stops: [_controller!.value, _controller!.value],
//                   begin: Alignment.bottomCenter,  // Filling from the bottom
//                   end: Alignment.topCenter,
//                 ).createShader(bounds);
//               },
//               blendMode: BlendMode.srcATop,
//               child: Image.asset(
//                 'assets/Group.png',  // Ensure your image is in the correct path
//                 width: 200,
//                 height: 200,
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
