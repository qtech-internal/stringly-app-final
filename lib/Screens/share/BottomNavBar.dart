import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavBar extends StatefulWidget {
  final Function(int) onTabSelected;
  final int selectedIndex;

  const BottomNavBar({
    Key? key,
    required this.onTabSelected,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  void _onItemTapped(int index) {
    widget.onTabSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        currentIndex: widget.selectedIndex,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        elevation: 0,
        selectedItemColor: Colors.black,
        unselectedItemColor: const Color(0xFFB0B0B0),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          _buildNavItem('assets/newNavBarIcon/filled s.svg', 0),
          _buildNavItem('assets/newNavBarIcon/filled heartr1.svg', 1),
          _buildNavItem('assets/newNavBarIcon/filled chat1.svg', 2),
          _buildNavItem('assets/newNavBarIcon/user profile.svg', 3),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(String assetPath, int index) {
    bool isSelected = widget.selectedIndex == index;

    return BottomNavigationBarItem(
      icon: SizedBox(
        height: 32,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            index == 0
                ? ShaderMask(
                    shaderCallback: (bounds) {
                      if (isSelected && index == 0) {
                        return const LinearGradient(
                          colors: [Color(0xFFD83694), Color(0xFF0039C7)],
                        ).createShader(bounds);
                      } else if (isSelected) {
                        return const LinearGradient(
                          colors: [Colors.black, Colors.black],
                        ).createShader(bounds);
                      } else {
                        return const LinearGradient(
                          colors: [Color(0xFFB0B0B0), Color(0xFFB0B0B0)],
                        ).createShader(bounds);
                      }
                    },
                    child: SvgPicture.asset(
                      assetPath,
                      color: isSelected && index != 0
                          ? Colors.black
                          : Colors.grey[100],
                    ),
                  )
                : index == 2
                    ? SvgPicture.asset(
                        assetPath,
                        color: isSelected && index != 0
                            ? null
                            : const Color(0xFFB0B0B0),
                      )
                    : SvgPicture.asset(
                        assetPath,
                        color: isSelected && index != 0
                            ? Colors.black
                            : const Color(0xFFB0B0B0),
                      ),
            const SizedBox(height: 2),
            if (isSelected)
              Container(
                height: 3,
                width: 15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD83694), Color(0xFF0039C7)],
                  ),
                ),
              ),
          ],
        ),
      ),
      label: '',
    );
  }
}
