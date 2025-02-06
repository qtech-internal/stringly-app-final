import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProfileCircleWidget extends StatelessWidget {
  final String? imageUrl;
  final double progress;
  final bool isVerified;
  final double size;

  const ProfileCircleWidget({
    super.key,
    this.imageUrl,
    this.progress = 0.0,
    this.isVerified = false,
    this.size = 0.25,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double dynamicSize = screenWidth * size;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Profile Image
        Container(
          width: dynamicSize - 10,
          height: dynamicSize - 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: imageUrl != null
                ? DecorationImage(
                    image: NetworkImage(imageUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
            color: imageUrl == null ? Colors.grey[300] : null,
          ),
        ),

        // Progress Circle
        CustomPaint(
          size: Size(dynamicSize, dynamicSize),
          painter: ProgressArcPainter(
            // progress: progress,
            gradient: LinearGradient(
              colors: [Colors.grey.shade300, Colors.grey.shade300],
              begin: Alignment.topRight,
              end: Alignment.topLeft,
            ),
          ),
        ),

        // Verified Badge
        if (isVerified)
          Positioned(
            bottom: dynamicSize * 0.04,
            right: dynamicSize * 0.02,
            child: Container(
              width: dynamicSize * 0.3,
              height: dynamicSize * 0.3,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.transparent,
              ),
              child: const Center(
                child:
                    Image(image: AssetImage('assets/verified_transparent.png')),
              ),
            ),
          ),
      ],
    );
  }
}

// class ProgressArcPainter extends CustomPainter {
//   final double progress;
//   final Gradient gradient;

//   ProgressArcPainter({
//     required this.progress,
//     required this.gradient,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = size.width / 2;

//     final rect = Rect.fromCircle(center: center, radius: radius);
//     final paint = Paint()
//       ..shader = gradient.createShader(rect)
//       ..strokeWidth = 5.0
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round;

//     canvas.drawArc(
//       rect,
//       -math.pi / 2,
//       2 * math.pi * progress,
//       false,
//       paint,
//     );

//     final angle = -math.pi / 2 + 2 * math.pi * progress;
//     final containerX = center.dx + radius * math.cos(angle);
//     final containerY = center.dy + radius * math.sin(angle);

//     const containerDiameter = 24.0;
//     final containerCenter = Offset(containerX, containerY);

//     final containerPaint = Paint()..color = Colors.pink;
//     canvas.drawCircle(containerCenter, containerDiameter / 2, containerPaint);

//     final textSpan = TextSpan(
//       text: '${(progress * 100).toInt()}%',
//       style: const TextStyle(
//         color: Colors.white,
//         fontSize: 8,
//         fontWeight: FontWeight.bold,
//       ),
//     );

//     final textPainter = TextPainter(
//       text: textSpan,
//       textAlign: TextAlign.center,
//       textDirection: TextDirection.ltr,
//     );

//     textPainter.layout();

//     final textX = containerCenter.dx - (textPainter.width / 2);
//     final textY = containerCenter.dy - (textPainter.height / 2);

//     textPainter.paint(canvas, Offset(textX, textY));
//   }

//   @override
//   bool shouldRepaint(ProgressArcPainter oldDelegate) {
//     return oldDelegate.progress != progress;
//   }
// }

class ProgressArcPainter extends CustomPainter {
  final Gradient gradient;

  ProgressArcPainter({
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw the full circle
    canvas.drawArc(
      rect,
      0, // Start angle (0 radians)
      2 * math.pi, // Sweep angle (full circle)
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(ProgressArcPainter oldDelegate) {
    // Always repaint when gradient changes
    return oldDelegate.gradient != gradient;
  }
}
