// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class SuperLikeAnimation extends StatefulWidget {
  const SuperLikeAnimation({
    super.key,
    required this.username,
  });

  final String username;

  @override
  State<SuperLikeAnimation> createState() => _SuperLikeAnimationState();
}

class _SuperLikeAnimationState extends State<SuperLikeAnimation>
    with TickerProviderStateMixin {
  late AnimationController _sizeController;
  late Animation<double> _sizeAnimation;

  // late AnimationController _positionController;
  // late Animation<Alignment> _positionAnimation;

  late AnimationController _colorController;
  late Animation<double> _backgroundTransition;
  late Animation<double> _textTransition;

  late AnimationController _imageController;
  late Animation<double> _imageSizeAnimation;

  bool _sizeAnimationCompleted = false;
  bool _colorAnimationCompleted = false;

  final List<Color> gradientColors = [
    const Color(0xFFD83694),
    const Color(0xFF0039C7)
  ];

  @override
  void initState() {
    super.initState();

    // Position animation controller
    // _positionController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 400),
    // );

    // _positionAnimation = AlignmentTween(
    //   begin: Alignment.bottomRight,
    //   end: Alignment.center,
    // ).animate(
    //   CurvedAnimation(parent: _positionController, curve: Curves.easeOut),
    // );

    _sizeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _sizeAnimation = Tween<double>(begin: 70, end: 185).animate(
      CurvedAnimation(parent: _sizeController, curve: Curves.easeInOut),
    );

    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _backgroundTransition = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _colorController, curve: Curves.linear),
    );

    _textTransition = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _colorController, curve: Curves.linear),
    );

    _imageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 300),
    );

    _imageSizeAnimation = Tween<double>(begin: 0, end: 50).animate(
      CurvedAnimation(parent: _imageController, curve: Curves.easeOutBack),
    );

    // Start position animation first
    _sizeController.forward();
    // _positionController.forward().then((_) {

    // });

    _sizeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _sizeAnimationCompleted = true;
        });
        _colorController.forward();
      }
    });

    _colorController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _colorAnimationCompleted = true;
        });

        _imageController.repeat(reverse: true);
        Future.delayed(const Duration(milliseconds: 1600), () {
          _imageController.stop();
          _imageController.reverse();
        });

        Future.delayed(const Duration(milliseconds: 1800), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _sizeController.dispose();
    _colorController.dispose();
    _imageController.dispose();
    //   _positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _sizeAnimation,
        _colorController,
        _imageController,
        //  _positionController
      ]),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            if (_colorAnimationCompleted)
              Positioned(
                top: -35,
                right: -30,
                bottom: 150,
                child: SizedBox(
                  height: _imageSizeAnimation.value,
                  width: _imageSizeAnimation.value,
                  child: Image.asset("assets/heart2.png"),
                ),
              ),
            Container(
              height: _sizeAnimation.value,
              width: 185,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: _sizeAnimationCompleted
                    ? LinearGradient(colors: [
                        Color.lerp(Colors.white, gradientColors[0],
                            _backgroundTransition.value)!,
                        Color.lerp(Colors.white, gradientColors[1],
                            _backgroundTransition.value)!,
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight)
                    : null,
                color: _sizeAnimationCompleted ? null : Colors.white,
              ),
              child: Center(
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: _sizeAnimationCompleted
                          ? [Colors.white, Colors.white]
                          : gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: Text(
                    'S',
                    style: TextStyle(
                      fontSize: _sizeAnimation.value / 1.5,
                      fontWeight: FontWeight.w900,
                      color: _sizeAnimationCompleted
                          ? Color.lerp(gradientColors[1], Colors.white,
                              _textTransition.value)
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            if (_colorAnimationCompleted)
              Positioned(
                top: 20,
                left: -60,
                child: Transform.rotate(
                  angle: -0.8,
                  child: SizedBox(
                    height: _imageSizeAnimation.value,
                    width: _imageSizeAnimation.value,
                    child: Image.asset("assets/heart2.png"),
                  ),
                ),
              ),
            Positioned(
              bottom: -50,
              child: Text('You Super Liked ${widget.username}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            )
          ],
        );
      },
    );
  }
}
