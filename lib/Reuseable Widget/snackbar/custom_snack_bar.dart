import 'package:flutter/material.dart';
import 'package:stringly/constants/globals.dart';

class CustomSnackbar {
  static final context = GlobalConstant.navigatorKey.currentContext!;

  // notice warning snackbar
  static noticeSnackbar({required String message, double paddingAll = 10, double horizontalMargin = 30}) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          margin: const EdgeInsets.only(bottom: 10),
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          content:
          Container(
            padding: EdgeInsets.all(paddingAll),
            margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.green,
            ),
            child: Center(
              child: Text(message, style: Theme.of(context).textTheme.labelLarge!.apply(color: Colors.white), textAlign: TextAlign.center,),
            ),
          ),
          backgroundColor: Colors.transparent,
        )
    );
  }

  // success snackbar

  static successSnackbar({required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          content:
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.blue
            ),
            child: Center(
              child: Text(message, style: Theme.of(context).textTheme.labelLarge!.apply(color: Colors.white), textAlign: TextAlign.center,),
            ),
          ),
          backgroundColor: Colors.transparent,
        )
    );
  }

  // warning snack bar

  static warningSnackbar({required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          content:
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xFFF57C00)
            ),
            child: Center(
              child: Text(message, style: Theme.of(context).textTheme.labelLarge!.apply(color: Colors.white), textAlign: TextAlign.center,),
            ),
          ),
          backgroundColor: Colors.transparent,
        )
    );
  }

  // error and failed snackbar
  static errorSnackbar({required String message, double paddingAll = 10, double horizontalMargin = 30}) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          content:
          Container(
            padding: EdgeInsets.all(paddingAll),
            margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.red
            ),
            child: Center(
              child: Text(message, style: Theme.of(context).textTheme.labelLarge!.apply(color: Colors.white), textAlign: TextAlign.center,),
            ),
          ),
          backgroundColor: Colors.transparent,
        )
    );
  }
}