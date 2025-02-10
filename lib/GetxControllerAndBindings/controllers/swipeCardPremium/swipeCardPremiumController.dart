import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stringly/StorageServices/get_storage_service.dart';
import 'package:stringly/intraction.dart';
import 'package:stringly/matched_queue.dart';
import 'package:stringly/models/global_constant_for_site_dating_networking.dart';
import 'package:stringly/models/update_user_account_model.dart';
import 'package:stringly/models/user_profile_params_model.dart';

class Swipecardpremiumcontroller extends GetxController {
  var images = Rx<List<Map<String, dynamic>>>([]);
  var allUserData = Rx<Future<dynamic>?>(null);
  var matchedQueue = Rx<MatchedQueue>(MatchedQueue());

  var selectedItems = Rx<List<String>>([]);

  var toggleStatus = Rx<bool?>(null);
  var newUserToShowForm = Rx<bool>(true);

  var headLineController = TextEditingController().obs;
  var whatAreYouLookingForController = TextEditingController().obs;
  var skillsController = TextEditingController().obs;

  var currentIndex = 0.obs;
  var cardOffset = Rx<Offset>(Offset.zero);
  var cardRotation = 0.0.obs;
  var isToggled =
      GlobalConstantForSiteDatingNetworking.toggleToNetwork == 'dating'
          ? false.obs
          : true.obs;
  var isFirstSwipe = true.obs;

  // ---------------------------- METHODS ----------------------------------

  Future<void> initializeMatchedQueue() async {
    allUserData.value = null;
    await MatchedQueue.getMatchedQueue();

    matchedQueue.value.getNewMessagesFromUser();

    allUserData.value = getAll();
    images.refresh();
  }

  void bringBackPreviousCard() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      cardOffset.value = Offset.zero;
      cardRotation.value = 0.0;
    }
  }

  // ------ get all images ----------------------
  Future<Map<String, dynamic>> getAll() async {
    try {
      // Map<String, dynamic> result = await Intraction.getAll();
      images.value = [];
      var result2 = await Intraction.getLoggedUserAccount();
      UpdateUserAccountModel loggedUserInfo =
          UpdateUserAccountModel.fromMap(result2['Ok']['params']);
      String loggedUserId = result2['Ok']['user_id'];
      Map<String, dynamic> result =
          await Intraction.getAllAccounts(userId: loggedUserId);
      String loggedUserImage =
          (loggedUserInfo.images != null && loggedUserInfo.images!.isNotEmpty)
              ? loggedUserInfo.images![0]
              : '';
      if (result.containsKey('Ok')) {
        var usersAllData = result['Ok'];
        int? noOfUser = usersAllData.length;
        images.value.clear();
        for (int i = 0; i < noOfUser!; i++) {
          var singleUserInfo =
              userProfileParamsModel.fromMap(usersAllData[i]['params']);
          String currentProfileUserId = usersAllData[i]['user_id'];
          String imageBytesProfile = (singleUserInfo.images != null &&
                  singleUserInfo.images!.isNotEmpty)
              ? singleUserInfo.images![0]
              : '';
          images.value.add({
            'path': imageBytesProfile,
            'name': singleUserInfo.name ?? '',
            'age': singleUserInfo.dob != null
                ? _calculateAge(singleUserInfo.dob!).toString()
                : '',
            'location': singleUserInfo.locationCountry != null
                ? '${singleUserInfo.locationCity}, ${singleUserInfo.locationState}, ${singleUserInfo.locationCountry}'
                : '',
            'distance':
                '${singleUserInfo.distanceBound ?? 'Unknown'} miles away',
            'info': singleUserInfo.about ?? 'No information available',
            'logged_user_id': loggedUserId,
            'current_profile_user_id': currentProfileUserId,
            'forDetailNetworking': singleUserInfo,
            'logged_user_info': loggedUserInfo,
            'logged_user_image': loggedUserImage,
          });
        }

        return result;
      } else {
        return result;
      }
    } catch (e) {
      debugPrint('---------catch error--------------------$e');
      return {'error': e};
    }
  }

  newUserValueToShowForm() {
    newUserToShowForm.value = StorageService.hasData('newUserToShowForm');
  }

  Future<void> updateUserInfoWithShowPopupForm() async {
    try {
      UpdateUserAccountModel inputParams = UpdateUserAccountModel();
      if (whatAreYouLookingForController.value.text.isNotEmpty) {
        inputParams.updateField(
            'lookingFor', whatAreYouLookingForController.value.text.toString());
      }
      if (selectedItems.value.isNotEmpty) {
        inputParams.updateField('main_profession', selectedItems.value);
      }
      if (headLineController.value.text.isNotEmpty) {
        inputParams.updateField('headline', headLineController.value.text);
      }
      if (skillsController.value.text.isNotEmpty) {
        inputParams.updateField('skills', [skillsController.value.text]);
      }
      var result = await Intraction.updateLoggedUserAccount(inputParams);
      debugPrint('$result');
    } catch (e) {
      debugPrint('Err $e');
    }
  }

  // -------------- Calculate user age ------------------

  int _calculateAge(String dob) {
    final birthDate = DateTime.parse(dob);
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
