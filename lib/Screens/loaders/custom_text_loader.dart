import 'package:flutter/material.dart';
import '../../constants/globals.dart';

class CustomTextLoader {
  static final context = GlobalConstant.navigatorKey.currentContext!;

  static void openLoadingDialog({required String message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Material(
          child: Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GradualRevealLogo(),
                      const SizedBox(height: 20),
                      Text(
                        message,
                        style: TextStyle(color: Colors.blueAccent),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void stopLoading() {
    Navigator.of(context).pop();
  }
}

class GradualRevealLogo extends StatefulWidget {
  @override
  _GradualRevealLogoState createState() => _GradualRevealLogoState();
}

class _GradualRevealLogoState extends State<GradualRevealLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return ClipRect(
            clipper: GradualRevealClipper(_animation.value),
            child: child,
          );
        },
        child: Image.asset(
          'assets/logo_s.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class GradualRevealClipper extends CustomClipper<Rect> {
  final double revealPercentage;

  GradualRevealClipper(this.revealPercentage);

  @override
  Rect getClip(Size size) {
    final height = size.height * revealPercentage;
    return Rect.fromLTRB(0, size.height - height, size.width, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true; // Reclip on every frame
  }
}

