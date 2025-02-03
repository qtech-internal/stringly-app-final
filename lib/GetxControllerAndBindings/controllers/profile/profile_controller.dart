import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stringly/intraction.dart';
import 'package:stringly/models/update_user_account_model.dart';

class ProfileController extends GetxController {
  // ------------- Controllers -----------------------

  var nameController = Rx<TextEditingController>(TextEditingController());
  var pronounsController = Rx<TextEditingController>(TextEditingController());
  var aboutMeController = Rx<TextEditingController>(TextEditingController());
  var hobbiesController = Rx<TextEditingController>(TextEditingController());
  var educationController = Rx<TextEditingController>(TextEditingController());
  var whatYouLookingController =
      Rx<TextEditingController>(TextEditingController());
  var professionController = Rx<TextEditingController>(TextEditingController());
  var instituteNameController =
      Rx<TextEditingController>(TextEditingController());
  var graduationYearController =
      Rx<TextEditingController>(TextEditingController());
  var jobTitleController = Rx<TextEditingController>(TextEditingController());
  var companyNameController =
      Rx<TextEditingController>(TextEditingController());

  // ----------------- Variables ---------------------

  var userProfileImage = Rx<String?>(null);
  List<String> selectedHobbies = [];
  String? yourMainProfession;

  UpdateUserAccountModel updateUserModel = UpdateUserAccountModel();

  // ------------- Futures -----------------------
  var allProfileFunction = Rx<Future<dynamic>?>(null);

  // ------------ Methods -------------------------

  Future<void> fetchUserData() async {
    Map<String, dynamic> result = await Intraction.getLoggedUserAccount();
    if (result.containsKey('Ok')) {
      var data = result['Ok']['params'];

      if (data['images'][0] != null && data['images'][0].isNotEmpty) {
        userProfileImage.value = data['images'][0].first;
      }
      nameController.value.text = data['name'][0];
      if (data['gender'] != null && data['gender'].isNotEmpty) {
        genderPronouns(data);
      }
      aboutMeController.value.text =
          (data['about'] != null && data['about'].isNotEmpty)
              ? data['about'][0]
              : '';
      whatYouLookingController.value.text =
          (data['looking_for'] != null && data['looking_for'].isNotEmpty)
              ? data['looking_for'][0]
              : '';
      hobbiesController.value.text =
          (data['hobbies'] != null && data['hobbies'].isNotEmpty)
              ? '${data['hobbies'][0].join(", ")}'
              : '';
      professionController.value.text =
          (data['profession'] != null && data['profession'].isNotEmpty)
              ? data['profession'][0]
              : '';
      educationController.value.text =
          (data['education'] != null && data['education'].isNotEmpty)
              ? data['education'][0]
              : '';
      instituteNameController.value.text =
          (data['institute_name'] != null && data['institute_name'].isNotEmpty)
              ? data['institute_name'][0]
              : '';
      if (data['gradutation_year'] != null &&
          data['gradutation_year'].isNotEmpty) {
        graduationYearController.value.text =
            data['gradutation_year'][0].toString();
      }
      jobTitleController.value.text =
          (data['job_title'] != null && data['job_title'].isNotEmpty)
              ? data['job_title'][0]
              : '';
      companyNameController.value.text =
          (data['company'] != null && data['company'].isNotEmpty)
              ? data['company'][0]
              : '';
    } else {
      debugPrint('${result['Err']}');
    }
  }

  void genderPronouns(var data) {
    if (data['gender'][0] == 'Male') {
      pronounsController.value.text = 'He/Him';
    } else if (data['gender'][0] == 'Female') {
      pronounsController.value.text = 'She/Her';
    } else {
      pronounsController.value.text = 'Other';
    }
  }
}
