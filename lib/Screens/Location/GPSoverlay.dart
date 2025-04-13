import 'package:flutter/material.dart';

import 'LocationSettings.dart';

class GPSOverlay extends StatelessWidget {
  const GPSOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.white,
      child: Container(height: 400,
        width: 500,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 80,),
              Image.asset(
                'assets/blacktick.png',
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 10),
              const Text(
                'GPS Access Allowed',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Access to GPS was successful!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 60),
              Container(
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    // Pass the GPS enabled state back to LocationSettings
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Adjust this value for less rounding
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
    );
  }
}
