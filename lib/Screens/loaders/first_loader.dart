import 'package:flutter/material.dart';
import '../../constants/globals.dart';

class FirstLoader {
  static final context = GlobalConstant.navigatorKey.currentContext!;

  static void openLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Material(
          child: Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/loading_animation.gif'),
                        height: 100,
                        width: 100,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Waiting for the profile to be verified',
                        style: TextStyle(color: Color(0xff26288B), fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void stopLoading() {
    Navigator.of(context).pop();
  }
}


