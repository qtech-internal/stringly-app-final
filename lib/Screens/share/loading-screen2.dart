import 'package:flutter/material.dart';

class ProfileCardAnimation extends StatefulWidget {
  @override
  _ProfileCardAnimationState createState() => _ProfileCardAnimationState();
}

class _ProfileCardAnimationState extends State<ProfileCardAnimation> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _iconRotationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _iconRotationAnimation;

  @override
  void initState() {
    super.initState();

    // Slide and scale animations for the profile card
    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(1.5, 0), // Slides to the right off-screen
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8, // Slightly scales down
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    // Rotation animation for the icon
    _iconRotationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _iconRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _iconRotationController, curve: Curves.linear));
  }

  @override
  void dispose() {
    _slideController.dispose();
    _iconRotationController.dispose();
    super.dispose();
  }

  void _onButtonTap() {
    _slideController.forward();
    _iconRotationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Stack(
          children: [
            SlideTransition(
              position: _slideAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 300,
                  height: 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage("https://via.placeholder.com/300x500"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Kristin Watson, 24",
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                          Text(
                            "Lives in Portland, Illinois\n15 miles away",
                            style: TextStyle(fontSize: 16, color: Colors.white70),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 40,
              child: GestureDetector(
                onTap: _onButtonTap,
                child: RotationTransition(
                  turns: _iconRotationAnimation,
                  child: Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
