import 'package:flutter/material.dart';

class GlobalConstant {
  // static String backendCanisterId = "bkyz2-fmaaa-aaaaa-qaaaq-cai";
  // static String middlePageCanisterId = "be2us-64aaa-aaaaa-qaabq-cai";
  // static bool isLocal = true;
  static String backendCanisterId = 'pnk7d-ryaaa-aaaag-atzxa-cai';
  static String middlePageCanisterId = 'ehmai-2qaaa-aaaag-att2a-cai';
  static bool isLocal = false;

  static bool isLoggedIn = false;

  static String googleMapApiKey = "AIzaSyBr2rLjHYyCQPf82mpqckqgFkfqRsEW8wo";

  static Map<String, dynamic>? chatCredentials;

  static bool isPremiumUser = false;

  // logged user principal and User id
  static String? principal;
  static String? userId;
  // to navigate to different screen
  static bool checkUserProfileCreateOrNot = false;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
