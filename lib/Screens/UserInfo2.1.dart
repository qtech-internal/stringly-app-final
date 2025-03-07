import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stringly/Screens/UserInfo3.dart';
import 'package:stringly/Screens/videoRecScreen.dart';

class Overlay25 extends StatelessWidget {
  const Overlay25({super.key});

  Future<bool> _requestPermissions() async {
    final permissions = [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
    ];

    Map<Permission, PermissionStatus> statuses = await permissions.request();

    if (statuses.values.every((status) => status.isGranted)) {
      return true;
    }

    if (statuses.values.any((status) => status.isPermanentlyDenied)) {
      openAppSettings();
    }
    return false;
  }

  void _handlePermissionsAndNavigate(BuildContext context) async {
    if (await _requestPermissions()) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => VideoRecordingScreen(),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please allow all permissions to continue."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor:
          Colors.transparent, // Set to transparent for gradient border
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD83694), Color(0xFF0039C7)],
            end: Alignment.topRight,
            begin: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding:
            const EdgeInsets.all(3), // Padding for gradient border thickness
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Inner container color
            borderRadius: BorderRadius.circular(12),
          ),
          height: 309,
          width: 275,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => UserInfo3()));
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 5, left: 16, right: 16, bottom: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Proof of Humanity',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Optional verification to confirm you’re real and build trust.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 50),
                      Container(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            _handlePermissionsAndNavigate(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProofOfHumanityDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD83694), Color(0xFF0039C7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(3),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          height: 400,
          width: 500,
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Proof of Humanity',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'You have not submitted your Proof of Humanity. Please do so now.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 60),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () async {
                      _handlePermissionsAndNavigate(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
