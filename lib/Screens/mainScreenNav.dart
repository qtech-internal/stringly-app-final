import 'package:flutter/material.dart';
import 'package:stringly/webSocketRegisterLogin/websocket_register.dart';

import 'share/BottomNavBar.dart';
import 'Chat/MessageScreen.dart';
import 'MainSection/PremiumVariation2.dart';
import 'MainSection/Premiumvariation1.dart';
import 'MainSection/SwipeCardsPremium.dart';
import 'profile.dart';

class Mainscreennav extends StatefulWidget {
  @override
  _MainscreennavState createState() => _MainscreennavState();
}

class _MainscreennavState extends State<Mainscreennav> {
  int _selectedIndex = 0;
  bool isPremiumUser  = false;

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return SwipingScreenPremium();
      case 1:
      // Check if the user is a premium user
        if (isPremiumUser ) {
          return PremiumVariation2();
        } else {
          return PremiumVariation1(); // Redirect to PremiumVariation1 if not premium
        }
      case 2:
        return MessagesScreen();
      case 3:
        return ProfileScreen();
      default:
        return SwipingScreenPremium();
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _getScreen(_selectedIndex), // Load only the selected screen
        bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex,
          onTabSelected: _onTabSelected,
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0; // Navigate back to the first tab
      });
      return false; // Prevent exiting the app
    }
    return true; // Exit the app if on the first tab
  }
}
