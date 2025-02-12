import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GlobalConstant {
  // static String backendCanisterId = "bkyz2-fmaaa-aaaaa-qaaaq-cai";
  // static String middlePageCanisterId = "be2us-64aaa-aaaaa-qaabq-cai";
  // static bool isLocal = true;
  static String backendCanisterId = dotenv.env['BACKEND_CANISTER_ID']!;
  static String middlePageCanisterId = dotenv.env['MIDDLEWARE_CANISTER_ID']!;
  static bool isLocal = false;

  static bool isLoggedIn = false;

  static String googleMapApiKey = dotenv.env['GOOGLE_MAP_KEY']!;

  static Map<String, dynamic>? chatCredentials;

  static bool isPremiumUser = false;

  // logged user principal and User id
  static String? principal;
  static String? userId;
  // to navigate to different screen
  static bool checkUserProfileCreateOrNot = false;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
