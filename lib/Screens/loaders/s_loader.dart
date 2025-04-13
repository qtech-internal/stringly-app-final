// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedWaveLetter extends StatefulWidget {
  final String text;
  const AnimatedWaveLetter({
    Key? key,
    required this.text,
  }) : super(key: key);
  @override
  _AnimatedWaveLetterState createState() => _AnimatedWaveLetterState();
}

class _AnimatedWaveLetterState extends State<AnimatedWaveLetter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(); // No reverse, just looping

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return ClipPath(
                clipper: WaveRevealClipper(_animation.value),
                child: child,
              );
            },
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [
                    Color(0xffD83694),
                    Color(0xff0039C7),
                    Color(0xff0039C7)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcIn,
              child: Text(
                'S',
                style: GoogleFonts.poppins(
                  fontSize: 120, // Large, bold text
                  fontWeight: FontWeight.bold, // Maximum Boldness
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          widget.text,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Color(0xff26288B), fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class WaveRevealClipper extends CustomClipper<Path> {
  final double revealPercentage;

  WaveRevealClipper(this.revealPercentage);

  @override
  Path getClip(Size size) {
    Path path = Path();
    double waveHeight = 20.0; // Wave height for effect

    double revealHeight = size.height * revealPercentage;
    path.moveTo(0, size.height);

    for (double i = 0; i <= size.width; i += 10) {
      double waveY = revealHeight - waveHeight * sin((i / size.width) * 2 * pi);
      path.lineTo(i, waveY);
    }

    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
