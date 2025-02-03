import 'package:get/get.dart';
import 'package:stringly/models/swipe_input_model.dart';
import 'package:stringly/models/update_user_account_model.dart';
import 'package:stringly/models/user_profile_params_model.dart';
import 'package:stringly/intraction.dart';
import 'package:stringly/models/global_constant_for_site_dating_networking.dart';

class WhoLikeYouPageController extends GetxController {
  // Observable data
  var allRightSwipeData = <Map<String, dynamic>>[].obs;
  var loggedUserInfo = <String, dynamic>{}.obs;
  var numberOfLikes = 0.obs;
  var profileText =
      'liked your profile. Swipe right to match or left to skip'.obs;
  var dataFetched = false.obs;

  // Loader and error state
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializationOfFunction();
  }

  // Initialization functions
  Future<void> _initializationOfFunction() async {
    isLoading.value = true;
    try {
      await _getLoggedUserAccount();
      await _showAllLikeAndRightSwipe();
    } catch (error) {
      errorMessage.value = 'An error occurred: $error';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _getLoggedUserAccount() async {
    var result = await Intraction.getLoggedUserAccount();
    if (result.containsKey('Ok')) {
      loggedUserInfo['userId'] = result['Ok']['user_id'];
      final userInfo = UpdateUserAccountModel.fromMap(result['Ok']['params']);
      loggedUserInfo['image'] =
      (userInfo.images != null && userInfo.images!.isNotEmpty)
          ? userInfo.images![0]
          : '';
    }  else {
      throw Exception('Failed to fetch logged user account');
    }
  }

  Future<void> _showAllLikeAndRightSwipe() async {
    Map<String, dynamic> result = await Intraction.getAllRightSwipedNewWithContext();
    var result2 = await Intraction.getLoggedUserAccount();
    String loggedUserId = result2['Ok']['user_id'];

    if (result.containsKey('Ok')) {
      final allData = result['Ok'];
      allRightSwipeData.clear(); // Reset the list before populating it.
      for (var dataWithContext in allData) {
        final context = dataWithContext['context'];
        final data = dataWithContext['profile'];
        final interest = data['matched_profiles'];
        final userId = data['user_id'];
        final singleUserInfo = UpdateUserAccountModel.fromMap(data['params']);
        userProfileParamsModel detailNetworking =
        userProfileParamsModel.fromMap(data['params']);
        String imageBytesProfile = (singleUserInfo.images != null &&
            singleUserInfo.images!.isNotEmpty)
            ? singleUserInfo.images![0]
            : '';
        allRightSwipeData.add({
          'image': imageBytesProfile,
          'name': singleUserInfo.name ?? '',
          'age': singleUserInfo.dob != null
              ? _calculateAge(singleUserInfo.dob!).toString()
              : '',
          'location': singleUserInfo.locationCountry != null
              ? '${singleUserInfo.locationState}, ${singleUserInfo.locationCountry}'
              : '',
          'distance': '${singleUserInfo.distanceBound ?? 'Unknown'} miles away',
          'forDetailNetworking': detailNetworking,
          'userId': userId,
          'loggedUserId': loggedUserId,
          'context': context,
          'interest': interest.length,
        });
      }
      numberOfLikes.value = allRightSwipeData.length;
      if(numberOfLikes >= 1) {
        dataFetched.value = true;
      }
    } else {
      throw Exception('Failed to fetch right swiped data');
    }
  }

  // Age calculation
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

  void removeCard(int index) {
      allRightSwipeData.removeAt(index);
  }
  // Swipe actions
  void onLeftSwipe(Map<String, dynamic> data, int index) {
    SwipeInputModel swipeInput = SwipeInputModel(
      receiverId: data['userId'],
      site: GlobalConstantForSiteDatingNetworking.toggleToNetwork,
      senderId: data['loggedUserId'],
    );
    Intraction.leftSwipe(swipeInput);
    allRightSwipeData.removeAt(index);
    numberOfLikes.value = allRightSwipeData.length;
  }

  void onRightSwipe(Map<String, dynamic> data, int index) {
    SwipeInputModel swipeInput = SwipeInputModel(
      receiverId: data['userId'],
      site: GlobalConstantForSiteDatingNetworking.toggleToNetwork,
      senderId: data['loggedUserId'],
    );
    Intraction.rightSwipe(swipeInput);
    allRightSwipeData.removeAt(index);
    numberOfLikes.value = allRightSwipeData.length;
  }

  void onRightSwipeMore(Map<String, dynamic> data, int index) {
    SwipeInputModel swipeInput = SwipeInputModel(
      receiverId: data['userId'],
      site: GlobalConstantForSiteDatingNetworking.toggleToNetwork,
      senderId: data['loggedUserId'],
    );
    Intraction.rightSwipe(swipeInput);
    allRightSwipeData.removeAt(index);
    numberOfLikes.value = allRightSwipeData.length;
  }

  void onLeftSwipeMore(Map<String, dynamic> data, int index) {
    SwipeInputModel swipeInput = SwipeInputModel(
      receiverId: data['userId'],
      site: GlobalConstantForSiteDatingNetworking.toggleToNetwork,
      senderId: data['loggedUserId'],
    );
    Intraction.leftSwipe(swipeInput);
    allRightSwipeData.removeAt(index);
    numberOfLikes.value = allRightSwipeData.length;
  }
}
