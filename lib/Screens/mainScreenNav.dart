import 'package:flutter/material.dart';
import 'package:stringly/webSocketRegisterLogin/websocket_register.dart';
import '../constants/globals.dart';
import 'share/BottomNavBar.dart';
import 'Chat/MessageScreen.dart';
import 'MainSection/PremiumVariation2.dart';
import 'MainSection/Premiumvariation1.dart';
import 'MainSection/SwipeCardsPremium.dart';
import 'profile.dart';

class Mainscreennav extends StatefulWidget {
  final int initialIndex;
  Mainscreennav({super.key, this.initialIndex = 0});

  @override
  _MainscreennavState createState() => _MainscreennavState();
}

class _MainscreennavState extends State<Mainscreennav> {
  void changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic> && args.containsKey('initialIndex')) {
        setState(() {
          _selectedIndex = args['initialIndex'];
        });
      } else {
        _selectedIndex = widget.initialIndex;
      }
    }); // Set initial index from constructor
  }

  int _selectedIndex = 0;

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return SwipingScreenPremium();
      case 1:
        if (!GlobalConstant.isPremiumUser) {
          // Check if the user is a premium user
          return const PremiumVariation1();
        } else {
          return const PremiumVariation2();
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
