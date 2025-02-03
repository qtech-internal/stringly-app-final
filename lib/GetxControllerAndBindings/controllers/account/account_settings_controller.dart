import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stringly/Reuseable%20Widget/SelectOneImageAtOneTime.dart';
import 'package:stringly/GetxControllerAndBindings/controllers/profile/profile_controller.dart';
import 'package:stringly/intraction.dart';
import 'package:stringly/models/store_image_model.dart';
import 'package:stringly/models/update_user_account_model.dart';

class AccountSettingsController extends GetxController {
  // --------- Observable Variables -------------
  // Lists
  var allNetworkImages = Rx<List<String>>([]);
  var selectedImages = Rx<List<File>>([]);
  var allCombinedImages = Rx<List>([]);
  var selectedHobbies = Rx<List<String>>([]);
  // Files
  var profileImage = Rx<File?>(null);
  // Strings
  var networkImageOfProfile = Rx<String?>(null);
  var selectedGender = Rx<String?>(null);
  var selectedHeightFeet = Rx<String?>(null);
  var selectedHeightInches = Rx<String?>(null);
  var progress = <int, Rx<double>>{}.obs;
  // Bools
  RxBool isUserVerified = RxBool(false);
  RxBool isEditingBasic = RxBool(false);
  RxBool isEditingBio = RxBool(false);
  RxBool isBasicInfoSelected = RxBool(true);
  RxBool isNextButtonEnabled = RxBool(false);
  RxBool aboutMeEditable = RxBool(false);
  RxBool hobbiesEditable = RxBool(false);
  RxBool educationEditable = RxBool(false);
  RxBool jobRoleEditable = RxBool(false);
  RxBool nameEditable = RxBool(false);
  RxBool genderEditable = RxBool(false);
  RxBool birthdateEditable = RxBool(false);
  RxBool heightEditable = RxBool(false);
  RxBool deletingImage = RxBool(false);
  RxBool updatingImage = RxBool(false);
  // Date Time
  var selectedDate = Rx<DateTime?>(null);

  // Maps

  var iconState = Rx<Map<String, bool>>({});

  // ---------- Futures ----------------

  var accountSettingFunctionStatus = Rx<Future<dynamic>?>(null);

  // ------------- Controllers -----------------------

  var aboutMeController = Rx<TextEditingController>(TextEditingController());
  var whatAreYouLook = Rx<TextEditingController>(TextEditingController());
  var hobbiesController = Rx<TextEditingController>(TextEditingController());
  var educationController = Rx<TextEditingController>(TextEditingController());
  var professionController = Rx<TextEditingController>(TextEditingController());
  var instituteController = Rx<TextEditingController>(TextEditingController());
  var graduationYear = Rx<TextEditingController>(TextEditingController());
  var companyName = Rx<TextEditingController>(TextEditingController());
  var jobRoleController = Rx<TextEditingController>(TextEditingController());
  var nameController = Rx<TextEditingController>(TextEditingController());
  var genderController = Rx<TextEditingController>(TextEditingController());
  var birthdateController = Rx<TextEditingController>(TextEditingController());
  var heightController = Rx<TextEditingController>(TextEditingController());

  // -------------- Getx Controllers --------------------------

  final profileController = Get.find<ProfileController>();

  // -------------- Methods ------------------------

  // Method to fetch user account info
  Future<Map<String, dynamic>> fetchUserInfoOnAccountSettings() async {
    var result = await Intraction.getLoggedUserAccount();
    if (result.containsKey('Ok')) {
      UpdateUserAccountModel userInfo =
          UpdateUserAccountModel.fromMap(result['Ok']['params']);

      if (userInfo.name != null) {
        nameController.value.text = userInfo.name!;
      }
      if (userInfo.gender != null) {
        genderController.value.text = userInfo.gender!;
        selectedGender.value = userInfo.gender!;
      }
      if (userInfo.education != null) {
        educationController.value.text = userInfo.education!;
      }
      if (userInfo.jobRole != null) {
        jobRoleController.value.text = userInfo.jobRole!;
      }
      if (userInfo.height != null) {
        heightController.value.text = userInfo.height!;
      }
      if (userInfo.dob != null) {
        String dob = userInfo.dob!;
        String formattedDate = dob.split(' ')[0];
        birthdateController.value.text = formattedDate;
        // selectedDate = userInfo.dob!;
      }
      if (userInfo.hobbies != null) {
        hobbiesController.value.text =
            userInfo.hobbies!.join(', ').replaceAll(RegExp(r'[\[\]]'), '');
      }
      if (userInfo.about != null) {
        aboutMeController.value.text = userInfo.about!;
      }
      if (userInfo.images!.isNotEmpty) {
        networkImageOfProfile.value = userInfo.images!.first;
        allNetworkImages.value = userInfo.images!;
      }

      if (userInfo.lookingFor != null) {
        whatAreYouLook.value.text = userInfo.lookingFor!;
      }
      if (userInfo.profession != null) {
        professionController.value.text = userInfo.profession!;
      }
      if (userInfo.instituteName != null) {
        instituteController.value.text = userInfo.instituteName!;
      }
      if (userInfo.graduationYear != null) {
        graduationYear.value.text = userInfo.graduationYear!.toString();
      }
      if (userInfo.jobTitle != null) {
        jobRoleController.value.text = userInfo.jobTitle!;
      }
      if (userInfo.company != null) {
        companyName.value.text = userInfo.company!;
      }

      return result;
    } else {
      return result;
    }
  }

  // Method to Fetch User Data
  Future<void> initializeData() async {
    await fetchUserInfoOnAccountSettings();
    await _allImagesToShow();
  }

  // Method to Update User Basic Info
  Future<void> updateUserBasicInfo() async {
    UpdateUserAccountModel updateUserModel = UpdateUserAccountModel();
    if (nameController.value.text.isNotEmpty) {
      updateUserModel.updateField('name', nameController.value.text);
    }
    if (selectedGender.value != null) {
      updateUserModel.updateField('gender', selectedGender.toString());
    }
    if (selectedHeightFeet.value != null ||
        selectedHeightInches.value != null) {
      String height = '${selectedHeightFeet.value}';
      if (selectedHeightInches.value != null) {
        height = '$height.${selectedHeightInches.value}';
      }
      updateUserModel.updateField('height', height);
    }
    if (selectedDate.value != null) {
      updateUserModel.updateField('dob', selectedDate.toString());
    }
    await Intraction.updateLoggedUserAccount(updateUserModel);
  }

  // Method to Update User Bio
  Future<void> updateUserBio() async {
    UpdateUserAccountModel updateUserModel = UpdateUserAccountModel();
    if (aboutMeController.value.text.isNotEmpty) {
      updateUserModel.updateField('about', aboutMeController.value.text);
    }
    if (selectedHobbies.value.isNotEmpty) {
      updateUserModel.updateField('hobbies', selectedHobbies.value);
    }
    if (educationController.value.text.isNotEmpty) {
      updateUserModel.updateField('education', educationController.value.text);
    }
    if (jobRoleController.value.text.isNotEmpty) {
      updateUserModel.updateField('jobRole', jobRoleController.value.text);
    }
    await Intraction.updateLoggedUserAccount(updateUserModel);
  }

  // Method to Select Images and Upload them
  Future<void> openImagePicker() async {
    if (selectedImages.value.length >= 4) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text("You can only upload up to 4 images.")),
      );
      return;
    }

    final List<String> imagePaths = await Navigator.push(
      Get.context!,
      MaterialPageRoute(builder: (context) => CustomImagePickerOneAtATime()),
    );

    if (imagePaths.isNotEmpty) {
      int remainingSlots = 4 - selectedImages.value.length;

      List<File> newImages = imagePaths
          .map((path) => File(path))
          .where((file) => !selectedImages.value.contains(file))
          .take(remainingSlots)
          .toList();
      print(newImages);
      selectedImages.value.addAll(newImages);
      allCombinedImages.value.addAll(newImages);
      print('Selected Images ${selectedImages.value}');
      print('C Images ${selectedImages.value}');

      await updateProfileImages();
    }
  }

  Future<void> updateProfileImages() async {
    try {
      if (selectedImages.value.isNotEmpty) {
        selectedImages.refresh();
        await processSelectedImages();
        List<String?> imageUrls =
            await UpdateProfileImageToGetUrl.imageUrlFiles();
        if (imageUrls.isNotEmpty) {
          debugPrint('$imageUrls');
          allNetworkImages.value = [
            ...allNetworkImages.value,
            ...imageUrls.whereType<String>(),
          ];
          selectedImages.value.clear();

          UpdateUserAccountModel updateUserModel = UpdateUserAccountModel();
          updateUserModel.updateField('images', allNetworkImages.value);
          debugPrint('Updated USER model ------------');
          debugPrint(updateUserModel.images.toString());
          await Intraction.updateLoggedUserAccount(updateUserModel);

          StoreImageFile.resetImages();
          allNetworkImages.refresh();
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Method to show all Profile Images
  Future<void> _allImagesToShow() async {
    allCombinedImages.value = [
      ...allNetworkImages.value,
      ...selectedImages.value,
    ];
  }

  Future<void> processSelectedImages() async {
    StoreImageFile.allSelectFile = await Future.wait(
      selectedImages.value
          .where((image) => image?.path != null)
          .map((image) async {
        File profileImage = File(image!.path);
        return profileImage;
      }),
    );
  }

  // Method to delete user image
  Future<void> deleteImage() async {
    deletingImage.value = true;
    UpdateUserAccountModel updateUserModel = UpdateUserAccountModel();
    updateUserModel.updateField('images', allNetworkImages.value);
    await Intraction.updateLoggedUserAccount(updateUserModel);

    allCombinedImages.value = [
      ...allNetworkImages.value,
      ...selectedImages.value
    ];
    deletingImage.value = false;
    profileController.userProfileImage.value = networkImageOfProfile.value;
  }

  // Method to update upload progress
  Future<void> startUploadProgress(int index) async {
    if (!progress.containsKey(index)) {
      progress[index] = Rx<double>(0.0);
    }

    while (progress[index]!.value < 0.8) {
      await Future.delayed(const Duration(seconds: 2));
      progress[index]!.value += 0.1;
    }

    progress[index]!.value = 0.8;
  }

  void setProfilePicture(String selectedImage) async {
    try {
      updatingImage.value = true;
      int selectedIndex = allNetworkImages.value.indexOf(selectedImage);

      if (selectedIndex != -1) {
        allNetworkImages.value.removeAt(selectedIndex);

        allNetworkImages.value.insert(0, selectedImage);

        UpdateUserAccountModel updateUserModel = UpdateUserAccountModel();
        updateUserModel.updateField('images', allNetworkImages.value);
        await Intraction.updateLoggedUserAccount(updateUserModel);

        networkImageOfProfile.value = allNetworkImages.value.first;
        profileController.userProfileImage.value = networkImageOfProfile.value;
      }
    } catch (e) {
      updatingImage.value = false;
      debugPrint(e.toString());
    } finally {
      updatingImage.value = false;
    }
  }
}
