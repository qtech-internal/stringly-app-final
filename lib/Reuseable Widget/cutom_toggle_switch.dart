import 'package:flutter/material.dart';

class CustomToggleSwitch extends StatelessWidget {
  final bool isToggled;
  final ValueChanged<bool> onToggle;

  const CustomToggleSwitch({
    Key? key,
    required this.isToggled,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onToggle(!isToggled),
      child: Container(
        width: 80,
        height: 30,
        decoration: BoxDecoration(
          color: isToggled ? const Color(0xff3639C7) : const Color(0xffCD3596),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              left: isToggled ? 56 : 8,
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
