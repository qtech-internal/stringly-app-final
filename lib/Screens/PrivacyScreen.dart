import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stringly/StorageServices/get_storage_service.dart';
import 'package:stringly/constants/globals.dart';

class PrivacyScreen extends StatefulWidget {
  @override
  _PrivacyScreenState createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _isProfileVisible = false;

  @override
  void initState() {
    super.initState();
    // Read the stored value and update the local state
    _isProfileVisible = StorageService.read('profileVisibility') ?? false;
  }

  void _toggleProfileVisibility(bool value) {
    setState(() {
      _isProfileVisible = value; // Update local state
      StorageService.write('profileVisibility', value); // Save to storage
    });
  }

  bool _isToggled = false;

  void _toggleSwitch() {
    setState(() {
      _isToggled = !_isToggled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Container(
              child: Image.asset(
                'assets/priv.png',
                width: 24,
                height: 24,
              fit: BoxFit.contain,),
            ),
            const SizedBox(width: 8),
            const Text(
              'Privacy',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30,),
                    Text(
                      'Profile Visibility',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Toggle for Incognito mode',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: _toggleSwitch,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 60,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _isToggled ? Colors.black : Color(0xFFD2D5DA),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Align(
                        alignment: _isToggled ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Switch(
                //   value: _isProfileVisible,
                //   onChanged: _toggleProfileVisibility,
                //   activeColor: Colors.white,           // Thumb color when on
                //   activeTrackColor: Colors.black,       // Solid black track when on
                //   inactiveThumbColor: Colors.white,     // Thumb color when off
                //   inactiveTrackColor: Color(0xFFD2D5DA),
                //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,// Solid grey track when off
                // ),
              ],
            ),
          ),
          const Divider(color: Color(0xfff1eeee), height: 0.1,)
          // Additional content can be added here
        ],
      ),
    );
  }
}
