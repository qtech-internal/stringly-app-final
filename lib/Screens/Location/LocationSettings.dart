import 'package:flutter/material.dart';
import '../../StorageServices/get_storage_service.dart';
import '../SettingScreen.dart';
import 'GPSoverlay.dart';

class LocationSettings extends StatefulWidget {
  final bool gpsEnabled;

  LocationSettings({this.gpsEnabled = false});

  @override
  _LocationSettingsState createState() => _LocationSettingsState();
}

class _LocationSettingsState extends State<LocationSettings> {
  bool _gpsEnabled = false; // Local state to control the toggle

  @override
  void initState() {
    super.initState();
    // Initialize the GPS state from storage or default to false
    _gpsEnabled = StorageService.read('gpsEnableService') ?? widget.gpsEnabled;
  }

  // Function to toggle GPS setting
  void _toggleGpsSetting(bool value) {
    setState(() {
      _gpsEnabled = value; // Update local state
      // Save to storage
      StorageService.write('gpsEnableService', value);
    });
  }

  bool _isToggled = false;

  void _toggleSwitch() {
    if (!_isToggled) {
      _showGpsPermissionDialog();
    } else {
      setState(() {
        _isToggled = !_isToggled;
      });
    }
  }

  // Function to show the GPS permission dialog
  void _showGpsPermissionDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Color(0xFFE4E4E4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Do you want to allow GPS access?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                        // No change in the state if user presses Cancel
                        setState(() {
                          _isToggled = false; // Set GPS to false if cancelled
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE4E4E4),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style:
                            TextStyle(color: Color(0xFFE4626F), fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () {
                    // Update GPS state when the user clicks "Allow"
                    setState(() {
                      _isToggled = true; // Turn on GPS
                    });
                    Navigator.of(context).pop(); // Close the dialog
                    _showGpsOverlay(); // Show the GPS overlay
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Allow',
                    style: TextStyle(color: Color(0xFF5355D0), fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to show the GPS overlay dialog
  void _showGpsOverlay() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GPSOverlay(); // Show the GPS overlay
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
              icon: const Icon(Icons.arrow_back),
            ),
            const Icon(Icons.location_on_outlined, color: Colors.white),
            const SizedBox(width: 8),
            const Text('Location Setting',
                style: TextStyle(color: Colors.white)),
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
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'GPS Access',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Toggle to allow access to GPS',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff4E4949),
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
                        alignment: _isToggled
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
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
          const Divider(
            color: Color(0xfff1eeee),
            height: 0.1,
          )
          // Additional content can be added here
        ],
      ),

      // Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           const Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               SizedBox(height: 10),
      //               Text(
      //                 'GPS Access',
      //                 style: TextStyle(
      //                   fontSize: 18,
      //                   fontWeight: FontWeight.bold,
      //                 ),
      //               ),
      //               SizedBox(height: 8),
      //               Text(
      //                 'Toggle for enabling GPS access',
      //                 style: TextStyle(
      //                   fontSize: 14,
      //                   color: Colors.grey,
      //                 ),
      //               ),
      //             ],
      //           ),
      //           Switch(
      //             value: _gpsEnabled, // Show the current value of _gpsEnabled
      //             onChanged: (bool value) {
      //               if (value) {
      //                 _showGpsPermissionDialog(); // Show the permission dialog
      //               } else {
      //                 setState(() {
      //                   _gpsEnabled = value; // If the toggle is off, just update locally
      //                 });
      //               }
      //             },
      //             activeColor: Colors.white,
      //             activeTrackColor: Colors.black,
      //             inactiveThumbColor: Colors.white,
      //             inactiveTrackColor: Color(0xFFD2D5DA),
      //           ),
      //         ],
      //       ),
      //       SizedBox(height: 15),
      //       const Divider(
      //         color: Colors.grey,
      //         thickness: 1.0,
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
