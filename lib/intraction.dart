import 'package:flutter/foundation.dart';
import 'package:flutter_icp_auth/authentication/login.dart';
import 'package:stringly/constants/globals.dart';
import 'package:stringly/models/check_user_match.dart';
import 'package:stringly/models/swipe_input_model.dart';
import 'package:stringly/models/update_user_account_model.dart';
import 'package:stringly/models/user_input_params.dart';
import 'package:stringly/webSocketRegisterLogin/initialize_socket.dart';
import 'package:stringly/webSocketRegisterLogin/websocket_login.dart';
import 'package:stringly/webSocketRegisterLogin/websocket_register.dart';
import 'integration.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:agent_dart/agent_dart.dart';

class Intraction {
  static Service idleService = FieldsMethod.idl;
  static String backendCanisterId = GlobalConstant.backendCanisterId;
  static CanisterActor? actor =
      AuthLogIn.getActor(backendCanisterId, idleService);

  // access some  static value
  static bool checkMatchUserResult = false;

  static String? loggedUserId;

  static String? loggedUserPrincipal;

  static Map<String, dynamic>? loggedUserAccount;

  // get userId and keep it for all function
  static Future<void> getLoggedUserIdAndKeepItForAllFunction() async {
    try {
      Map<String, dynamic> userId =
          await actor!.getFunc(FieldsMethod.get_user_id_by_principal)?.call([]);
      if (userId.containsKey('Ok')) {
        loggedUserId = userId['Ok'];
      }
    } catch (e) {
      print('getting error on calling function--get_user_id_by_principal $e');
    }
  }
  // end userId

  // get Logged user account and keep it for all function
  static Future<void> getLoggedUserAccountAndKeepItForAllFunction() async {
    try {
      if (loggedUserId == null) {
        await getLoggedUserIdAndKeepItForAllFunction();
      }
      Map<String, dynamic> result = await actor!
          .getFunc(FieldsMethod.get_an_account)
          ?.call([loggedUserId]);
      if (result.containsKey('Ok')) {
        loggedUserAccount = result;
      }
    } catch (e) {
      print('getting error on calling function --get-an-account $e');
    }
  }
  // end

  // getLoggedUserPrincipal And Save it for all function
  static Future<void> getLoggedUserPrincipalAndKeepItForAllFunction() async {
    try {
      var result = await actor!.getFunc(FieldsMethod.whoAmI)?.call([]);

      final regex = RegExp(r'"([a-z0-9-]+)"');
      final match = regex.firstMatch(result);
      String principal = match?.group(1) ?? '';
      if (principal.isNotEmpty) {
        loggedUserPrincipal = principal;
      }
    } catch (e) {
      print('getting error on calling function --- whoAmI $e');
    }
  }
  // end

  static Future<String> getUserIdByPrincipalId() async {
    if (loggedUserId != null) {
      return loggedUserId!;
    } else {
      await getLoggedUserIdAndKeepItForAllFunction();
      return loggedUserId!;
    }
  }

  static Future<Map<String, dynamic>> checkNewUser() async {
    try {
      var result = await actor!
          .getFunc(FieldsMethod.verify_account_for_caller)
          ?.call([]);
      bool value = result.containsKey('Ok') ? true : false;
      if (value) {
        await WebSocketRegisterForChat.registerUserWithPrincipalPublicUserId();
        await WebSocketLoginForChat.loginUserWithPrincipalPublicUserId();
        await InitializeSocket.socketInitializationMethod();
      }
      debugPrint(
          '=====================${result.containsKey('Ok')}  ${result['Err']} ${result['Ok']} ========================');
      return {'response': result};
    } catch (e) {
      return {'Err': e};
    }
  }

  static Future<Map<String, dynamic>> getAll() async {
    try {
      Map<String, dynamic> result =
          await actor!.getFunc(FieldsMethod.get_all)?.call([]);
      return result;
    } catch (e) {
      return {'Err': e};
    }
  }

  static Future<void> createAnUser(UserInputParams params) async {
    try {
      // check profile create or not
      Map<String, dynamic> value =
          await actor!.getFunc(FieldsMethod.get_user_id_by_principal)?.call([]);
      if (value.containsKey('Ok')) {
        String userid = value['Ok'];
        Map<String, dynamic> result = await actor!
            .getFunc(FieldsMethod.update_an_account)
            ?.call([userid, params.toMap()]);
        debugPrint('$result');
        loggedUserAccount = null;
      } else {
        Map<String, dynamic> result = await actor!
            .getFunc(FieldsMethod.create_an_account)
            ?.call([params.toMap()]);

        if (result.containsKey('Ok')) {
          await WebSocketRegisterForChat
              .registerUserWithPrincipalPublicUserId();
          await WebSocketLoginForChat.loginUserWithPrincipalPublicUserId();
          await InitializeSocket.socketInitializationMethod();
          debugPrint('Result: ${result['Ok']}');
        } else {
          debugPrint('Result:  ${result['Err']}');
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

//   get logged user account
  static Future<Map<String, dynamic>> getLoggedUserAccount() async {
    try {
      if (loggedUserId == null) {
        await getLoggedUserIdAndKeepItForAllFunction();
      }

      if (loggedUserAccount != null) {
        return loggedUserAccount!;
      } else {
        await getLoggedUserAccountAndKeepItForAllFunction();
        return loggedUserAccount!;
      }
    } catch (e) {
      return {'Err': e};
    }
  }

//  update logged user account
  static Future<Map<String, dynamic>> updateLoggedUserAccount(
      UpdateUserAccountModel params) async {
    try {
      if (loggedUserId == null) {
        await getLoggedUserIdAndKeepItForAllFunction();
      }
      String userid = loggedUserId!;
      Map<String, dynamic> result = await actor!
          .getFunc(FieldsMethod.update_an_account)
          ?.call([userid, params.toMap()]);
      loggedUserAccount = null;
      return result;
    } catch (e) {
      return {'Err': 'Something went wrong'};
    }
  }

  // right swipe
  static Future<String> rightSwipeAtProfilePage(SwipeInputModel params) async {
    var result =
        await actor!.getFunc(FieldsMethod.rightswipe)?.call([params.toMap()]);
    debugPrint('right swipe  like-- $result');
    return result;
  }

  static Future<void> rightSwipe(SwipeInputModel params) async {
    var result =
        await actor!.getFunc(FieldsMethod.rightswipe)?.call([params.toMap()]);
    debugPrint('right swipe  like-- $result');
  }

  // left swipe
  static Future<void> leftSwipe(SwipeInputModel params) async {
    var result =
        await actor!.getFunc(FieldsMethod.leftswipe)?.call([params.toMap()]);
    debugPrint('left swipe  like-- $result');
  }

// check user match
  static Future<void> checkUserMatch(CheckUserMatchModel params) async {
    bool result = await actor!
        .getFunc(FieldsMethod.check_user_match)
        ?.call([params.loggedUserId, params.currentProfileUserId]);
    checkMatchUserResult = result;
    debugPrint('$result');
  }

  // super like section
  static Future<void> addSuperLike(
      {required String userId, required String receiverId}) async {
    try {
      Map<String, dynamic> result = await actor!
          .getFunc(FieldsMethod.update_superlike)
          ?.call([userId, receiverId]);
      debugPrint('$result');
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

//   add to chat list
  static Future<void> addMatchQueueProfileToChatList(
      {required String userProfileId}) async {
    try {
      Map<String, dynamic> result = await actor!
          .getFunc(FieldsMethod.add_user_to_chatlist)
          ?.call([userProfileId]);
      debugPrint('$result');
    } catch (e) {
      debugPrint('Err: $e');
    }
  }

  // get add user chatList
  static Future<Map<String, dynamic>> getLoggedUserAddChatList() async {
    try {
      if (loggedUserId == null) {
        await getLoggedUserIdAndKeepItForAllFunction();
      }

      Map<String, dynamic> result = await actor!
          .getFunc(FieldsMethod.get_added_user_chatlist)
          ?.call([loggedUserId]);
      return result;
    } catch (e) {
      return {'Err': e};
    }
  }

//   get principal for chat box
  static Future<String> getPrincipalOnChaBox() async {
    if (loggedUserPrincipal != null) {
      return loggedUserPrincipal!;
    } else {
      await getLoggedUserPrincipalAndKeepItForAllFunction();
      return loggedUserPrincipal!;
    }
  }

  // unmatch User
  static Future<void> unmatchUser(
      {required String receiverId, required String senderId}) async {
    try {
      final resultValue = await actor!
          .getFunc(FieldsMethod.unmatch_user)
          ?.call([receiverId, senderId]);

      if (resultValue.containsKey('Ok')) {
        print('success: ${resultValue['Ok']}');
      } else {
        print('Err: ${resultValue['Err']}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // get an account
  static Future<Map<String, dynamic>> getAnAccount(
      {required String userId}) async {
    try {
      Map<String, dynamic> result =
          await actor!.getFunc(FieldsMethod.get_an_account)?.call([userId]);
      return result;
    } catch (e) {
      return {'Err': e};
    }
  }

  static Future<Map<String, dynamic>> getAllAccounts(
      {required String userId}) async {
    try {
      final result = await actor!
          .getFunc(FieldsMethod.get_all_accounts)
          ?.call([userId, 1, 10]);
      return result;
    } catch (e) {
      return {'Err': e.toString()};
    }
  }

  static Future<void> hideUser({required String receiverId}) async {
    try {
      if (loggedUserId == null) {
        await getLoggedUserIdAndKeepItForAllFunction();
      }

      String senderId = loggedUserId!;
      print(senderId);
      Map<String, dynamic> result = await actor!
          .getFunc(FieldsMethod.hide_user)
          ?.call([senderId, receiverId]);
      print('result: $result');
    } catch (e) {
      print('Err: $e');
    }
  }

  static Future<Map<String, dynamic>> getAllRightSwipedNewWithContext() async {
    try {
      if (loggedUserId == null) {
        await getLoggedUserIdAndKeepItForAllFunction();
      }
      Map<String, dynamic> result = await actor!
          .getFunc(FieldsMethod.get_allrightswipes)
          ?.call([loggedUserId]);
      return result;
    } catch (e) {
      print(e.toString());
      return {'Err': 'Something went wrong'};
    }
  }

  // get match queue with context
  static Future<Map<String, dynamic>>
      getLoggedUserMatchQueueNewWithContext() async {
    try {
      if (loggedUserId == null) {
        await getLoggedUserIdAndKeepItForAllFunction();
      }
      Map<String, dynamic> result = await actor!
          .getFunc(FieldsMethod.get_match_queue)
          ?.call([loggedUserId]);
      return result;
    } catch (e) {
      return {'Err': e};
    }
  }

  // delete account function
  static Future<Map<String, dynamic>> deleteUserAccount() async {
    try {
      if (loggedUserId == null) {
        await getLoggedUserIdAndKeepItForAllFunction();
      }
      Map<String, dynamic> result = await actor!
          .getFunc(FieldsMethod.delete_an_account)
          ?.call([loggedUserId]);
      return result;
    } catch (e) {
      return {'Err': e};
    }
  }
}
