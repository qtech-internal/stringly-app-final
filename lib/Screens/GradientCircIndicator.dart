import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:io';
import 'share/newcustomimagepicker.dart';

class GradientCircularProgressPainter extends CustomPainter {
  final double progress;
  final List<Color> colors;

  GradientCircularProgressPainter({required this.progress, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);

    final gradient = LinearGradient(
      colors: [
        colors[0],
        Color.lerp(colors[0], colors[1], 0.5)!,
        colors[1],
      ],
      stops: [0.0, 0.5, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final backgroundPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, backgroundPaint);

    canvas.drawArc(
      Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2),
      -pi / 2,
      2 * pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ProfileWithProgressIndicator extends StatefulWidget {
  final double progress;

  ProfileWithProgressIndicator({required this.progress});

  @override
  State<ProfileWithProgressIndicator> createState() =>
      _ProfileWithProgressIndicatorState();
}

class _ProfileWithProgressIndicatorState
    extends State<ProfileWithProgressIndicator> {
  File? _profileImage;
  bool _isEditing = false;

  Future<void> _pickImage() async {
    final selectedPaths = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CustomImagePicker()),
    );

    if (selectedPaths != null && selectedPaths.isNotEmpty) {
      setState(() {
        _profileImage = File(selectedPaths[0]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double radius = 75; // Radius of the outer progress circle
    final double angle = 2 * pi * widget.progress - pi / 2; // Corrected angle for progress tracking

    // Calculate X and Y positions for the progress indicator circle (avoid clipping)
    final double indicatorX = (radius * cos(angle) + radius); // X offset based on progress
    final double indicatorY = (radius * sin(angle) + radius); // Y offset based on progress

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer container that holds the progress circle and profile image
          SizedBox(
            width: 160, // Increase the size of the container to prevent clipping
            height: 160, // Increase the size of the container to prevent clipping
            child: CustomPaint(
              painter: GradientCircularProgressPainter(
                progress: widget.progress,
                colors: [Color(0xFFD83694), Color(0xFF0039C7)],
              ),
            ),
          ),
          // Inner Circle with Profile Image
          Container(
            width: 130, // Size of the inner profile image container
            height: 130, // Size of the inner profile image container
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
              child: ClipOval(
                child: _profileImage != null
                    ? Image.file(
                  _profileImage!,
                  width: 127, // Size of the profile image
                  height: 127, // Size of the profile image
                  fit: BoxFit.cover,
                )
                    : const Image(
                  image: AssetImage('assets/img_1.png'),
                  width: 127, // Size of the profile image
                  height: 127, // Size of the profile image
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          if (_isEditing)
            Positioned(
              bottom: 10,
              right: 10,
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          // Progress Percentage Indicator Circle at Arc Endpoint
          Positioned(
            left: indicatorX - 20, // Adjust X to ensure visibility, reduce clipping
            top: indicatorY - 20, // Adjust Y to ensure visibility, reduce clipping
            child: Container(
              width: 40, // Percentage circle size
              height: 40, // Percentage circle size
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.pink,
              ),
              child: Center(
                child: Text(
                  '${(widget.progress * 100).round()}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12, // Font size inside the circle
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
