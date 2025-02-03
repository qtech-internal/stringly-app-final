import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stringly/Screens/AccountSettings/account_setting_basic_info_edit.dart';
import 'package:stringly/Screens/AccountSettings/upload_progress.dart';
import 'package:stringly/Screens/loaders/request_process_loader.dart';
import '../../GetxControllerAndBindings/controllers/account/account_settings_controller.dart';
import '../../Reuseable Widget/gradienttextfield.dart';
import '../../Reuseable Widget/profile_progress.dart';
import '../HobbyScreen.dart';
import '../loaders/message_screen_loader.dart';
import 'account_setting_bio_edit.dart';

class AccountSetting extends StatefulWidget {
  const AccountSetting({super.key});

  @override
  _AccountSettingState createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  late AccountSettingsController controller;

  // Launch the custom image picker

  Widget selectGenderFunction() {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0, bottom: 8),
      child: GradientdropdownTextField(
          hintText: 'Specify your gender',
          items: const ['Male', 'Female', 'Other'],
          initialValue: controller.selectedGender.value,
          onChanged: (value) {
            if (value != null) {
              controller.selectedGender.value = value?.value;
              debugPrint('${controller.selectedGender.value}');
            }
          },
          label: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: const Text(
                'Gender ',
                style: TextStyle(
                    color: Colors.black,
                    backgroundColor: Colors.white,
                    fontSize: 14),
              ))
          // validator: (value) {
          //   if (value == null || value.isEmpty) {
          //     return 'Please select your gender';
          //   }
          //   return null;
          // },
          ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textTheme: TextTheme(
              headlineMedium: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              labelSmall: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
              bodyLarge: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            dialogBackgroundColor: Colors.white,
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
            inputDecorationTheme: const InputDecorationTheme(
              border: InputBorder.none,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null && selectedDate != DateTime.now()) {
      controller.selectedDate.value = selectedDate;

      // Calculate age
      final currentDate = DateTime.now();
      int age = currentDate.year - selectedDate.year;

      // Adjust age if the birthday hasn't occurred yet this year
      if (currentDate.month < selectedDate.month ||
          (currentDate.month == selectedDate.month &&
              currentDate.day < selectedDate.day)) {
        age--;
      }

      // Update button enabled state based on age
      controller.isNextButtonEnabled.value = age >= 18;

      // Show Snackbar if age is less than 18
      if (!controller.isNextButtonEnabled.value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Must be above 18'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Widget _dobSelectFunction() {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0, bottom: 8),
      child: GestureDetector(
        onTap: () => _selectDate(context),
        child: AbsorbPointer(
          child: TextField(
            controller: TextEditingController(
              text: controller.selectedDate.value != null
                  ? "${controller.selectedDate.value!.day}/${controller.selectedDate.value!.month}/${controller.selectedDate.value!.year}"
                  : '',
            ),
            decoration: const InputDecoration(
                hintText: 'Date of Birth ',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffD6D6D6), width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffD6D6D6), width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffD6D6D6), width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffD6D6D6), width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16.0, horizontal: 14),
                suffixIcon: Icon(
                  Icons.calendar_month,
                  color: Colors.grey,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                label: Text(
                  'Date of Birth ',
                  style: TextStyle(
                      color: Colors.black,
                      backgroundColor: Colors.white,
                      fontSize: 14),
                )),
          ),
        ),
      ),
    );
  }

  Widget _selectedHeight() {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: Row(
        children: [
          Expanded(
            child: GradientdropdownTextField(
                hintText: 'Specify your height in feet',
                items: const ['4', '5', '6', '7', '8', '9'],
                initialValue: controller.selectedHeightFeet.value,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      controller.selectedHeightFeet.value = value?.value;
                      debugPrint('${controller.selectedHeightFeet.value}');
                    });
                  }
                },
                label: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'In feet',
                          style: TextStyle(
                              color: Colors.black,
                              backgroundColor: Colors.white,
                              fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: GradientdropdownTextField(
                hintText: 'Specify your height in inches',
                items: const [
                  '1',
                  '2',
                  '3',
                  '4',
                  '5',
                  '6',
                  '7',
                  '8',
                  '9',
                  '10',
                  '11'
                ],
                initialValue: controller.selectedHeightInches.value,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      controller.selectedHeightInches.value = value?.value;
                      debugPrint('${controller.selectedHeightInches.value}');
                    });
                  }
                },
                label: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'In Inches',
                          style: TextStyle(
                              color: Colors.black,
                              backgroundColor: Colors.white,
                              fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                )
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please select your gender';
                //   }
                //   return null;
                // },
                ),
          ),
        ],
      ),
    );
  }

  Widget _selectedHobbies() {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HobbiesScreen()),
        );
        if (result != null && result is Map<String, List<String>>) {
          setState(() {
            controller.selectedHobbies.value = result['selectedHobbies'] ?? [];
          });
        }
      },
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(color: Colors.grey), // Add grey border here
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 6),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Hobbies & Interests',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.arrow_right, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    controller = Get.put(AccountSettingsController());

    controller.accountSettingFunctionStatus.value = controller.initializeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        titleSpacing: 0,
        title: Row(
          children: [
            Image.asset('assets/personicon.png', width: 30),

            const SizedBox(
                width: 8), // Add space between the image and the title
            const Text(
              'Account Settings',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: Obx(() {
        return FutureBuilder(
          future: controller.accountSettingFunctionStatus.value,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return MessageScreenLoader.simpleLoader(text: 'Wait, Loading...');
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Obx(() {
                if (controller.deletingImage.value ||
                    controller.updatingImage.value) {
                  return MessageScreenLoader.simpleLoader(
                      text: 'Wait, Loading...');
                }
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Stack(
                            //   alignment: Alignment.center,
                            //   children: [
                            //     // Incomplete Circle Gradient Border
                            //     Container(
                            //       width: 130, // Size for border
                            //       height: 130,
                            //       decoration: const BoxDecoration(
                            //         shape: BoxShape.circle,
                            //         color: Colors
                            //             .transparent, // Make the background transparent
                            //       ),
                            //       child: Stack(
                            //         children: [
                            //           // Incomplete Circular Gradient
                            //           ClipPath(
                            //             clipper:
                            //                 IncompleteCircleClipper(), // Custom clipper for incomplete circle
                            //             child: Container(
                            //               width: 130,
                            //               height: 130,
                            //               decoration: const BoxDecoration(
                            //                 gradient: LinearGradient(
                            //                   colors: [
                            //                     Color(0xFFD83694),
                            //                     Color(0xFF0039C7)
                            //                   ],
                            //                   begin: Alignment.topLeft,
                            //                   end: Alignment.bottomRight,
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //     // Inner White Circle for padding
                            //     Container(
                            //       width:
                            //           120, // Slightly smaller for white padding effect
                            //       height: 120,
                            //       decoration: const BoxDecoration(
                            //         shape: BoxShape.circle,
                            //         color: Colors.white, // White padding
                            //       ),
                            //       child: Center(
                            //         child: ClipOval(
                            //           child: controller.profileImage.value != null
                            //               ? Image.file(
                            //                   controller.profileImage.value!,
                            //                   width: 110, // Profile image size
                            //                   height: 110,
                            //                   fit: BoxFit.cover,
                            //                 )
                            //               : controller.networkImageOfProfile
                            //                           .value !=
                            //                       null
                            //                   ? Image.network(
                            //                       controller.networkImageOfProfile
                            //                           .value!,
                            //                       width: 110,
                            //                       height: 110,
                            //                       fit: BoxFit.cover,
                            //                     )
                            //                   : null,
                            //         ),
                            //       ),
                            //     ),
                            //     Positioned(
                            //       bottom: 20,
                            //       right: 106,
                            //       child: Container(
                            //         width: 20,
                            //         height: 20,
                            //         decoration: const BoxDecoration(
                            //             shape: BoxShape.circle,
                            //             color: Colors.pink),
                            //         child: Center(
                            //           child: Text(
                            //             '${(0.75 * 100).toInt()}%', // Example percentage
                            //             style: const TextStyle(
                            //               fontSize: 8,
                            //               fontWeight: FontWeight.bold,
                            //               color: Colors.white,
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //     if (controller.isUserVerified.value)
                            // Positioned(
                            //   bottom: 5,
                            //   right: 5,
                            //   child: Container(
                            //     width: 40,
                            //     height: 30,
                            //     decoration: const BoxDecoration(
                            //       shape: BoxShape.rectangle,
                            //       color: Colors.transparent,
                            //     ),
                            //     child: const Center(
                            //       child: Image(
                            //           image: AssetImage(
                            //               'assets/verified_transparent.png')),
                            //     ),
                            //   ),
                            // ),
                            //   ],
                            // ),

                            Obx(() {
                              return ProfileCircleWidget(
                                isVerified: false,
                                imageUrl:
                                    controller.networkImageOfProfile.value,
                                progress: 0.75,
                                size: 0.30,
                              );
                            })
                          ],
                        ),
                        const SizedBox(height: 30),
                        //----------------new

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Obx(
                            () {
                              final combinedImages =
                                  controller.allCombinedImages.value;
                              final networkImages =
                                  controller.allNetworkImages.value;
                              final selectedImages =
                                  controller.selectedImages.value;

                              return Row(
                                children: [
                                  if (combinedImages.length < 4)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 15.0),
                                      child: GestureDetector(
                                        onTap: controller.openImagePicker,
                                        child: DottedBorder(
                                          borderType: BorderType.RRect,
                                          radius: const Radius.circular(10),
                                          color: const Color(0xFFE5E5E5),
                                          strokeWidth: 2,
                                          dashPattern: const [3, 3],
                                          child: Container(
                                            width: 90,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.grey[100],
                                            ),
                                            child: Center(
                                              child: Container(
                                                width: 33,
                                                height: 33,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xFFA3A3A3),
                                                ),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 30,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  Row(
                                    children: List.generate(
                                      networkImages.length,
                                      (i) => GestureDetector(
                                        onLongPress: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return TweenAnimationBuilder(
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                curve: Curves.easeOut,
                                                tween: Tween<double>(
                                                    begin: 0.8, end: 1.0),
                                                builder: (context, double value,
                                                    child) {
                                                  return Transform.scale(
                                                    scale: value,
                                                    child: Dialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Container(
                                                        width: 280,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            // Title
                                                            const Text(
                                                              'Set as Profile Picture',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 16),
                                                            // Image Preview
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              child:
                                                                  Image.network(
                                                                networkImages[
                                                                    i],
                                                                height: 200,
                                                                width: double
                                                                    .infinity,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 16),
                                                            // Buttons Row
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                // Cancel Button
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  style: TextButton
                                                                      .styleFrom(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            24),
                                                                  ),
                                                                  child:
                                                                      const Text(
                                                                    'Cancel',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                ),
                                                                // Confirm Button
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                        Navigator.pop(
                                                                            context);
                                                                        controller.setProfilePicture(
                                                                            networkImages[
                                                                            i]);
                                                                      },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .black,
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            24),
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      const Text(
                                                                    'Confirm',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          child: Stack(
                                            children: [
                                              Container(
                                                width: 90,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    networkImages[i],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              if (controller.iconState.value[
                                                      networkImages[i]] !=
                                                  true)
                                                Positioned(
                                                  bottom: 0,
                                                  right: 20,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      controller
                                                              .iconState.value[
                                                          networkImages[
                                                              i]] = true;
                                                      controller.iconState
                                                          .refresh();
                                                    },
                                                    child: Container(
                                                      height: 15,
                                                      width: 50,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                        ),
                                                      ),
                                                      child: const Image(
                                                        image: AssetImage(
                                                            'assets/image_delete_action.png'),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              if (controller.iconState.value[
                                                      networkImages[i]] ==
                                                  true)
                                                Positioned(
                                                  top: 30,
                                                  right: 30,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      if (networkImages.length >
                                                          1) {
                                                        final imageToRemove =
                                                            networkImages[i];
                                                        networkImages.remove(
                                                            imageToRemove);
                                                        controller
                                                            .iconState.value
                                                            .remove(
                                                                imageToRemove);
                                                        controller
                                                            .deleteImage();
                                                        if (networkImages
                                                            .isNotEmpty) {
                                                          controller
                                                                  .networkImageOfProfile
                                                                  .value =
                                                              networkImages
                                                                  .first;
                                                        }
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                              'One pic is required for profile',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            duration: Duration(
                                                                seconds: 2),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: List.generate(
                                      selectedImages.length,
                                      (i) => Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: 90,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.file(
                                                  selectedImages[i],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Positioned.fill(
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      "Uploading...",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    UploadProgressWidget(
                                                        index: i),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 30),
                        _buildCustomToggle(),

                        Obx(() {
                          if (controller.isBasicInfoSelected.value) {
                            return Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AccountSettingBasicInfoEdit()));
                                      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => FilterPreferences()));
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          'assets/pencil.png', // Your pencil image
                                          width: 20,
                                          height: 20,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        controller.isEditingBasic.value
                                            ? GestureDetector(
                                                onTap: () async {
                                                  if (controller
                                                          .selectedDate.value !=
                                                      null) {
                                                    if (controller
                                                        .isNextButtonEnabled
                                                        .value) {
                                                      RequestProcessLoader
                                                          .openLoadingDialog();
                                                      await controller
                                                          .updateUserBasicInfo();
                                                      RequestProcessLoader
                                                          .stopLoading();

                                                      controller.isEditingBasic
                                                              .value =
                                                          !controller
                                                              .isEditingBasic
                                                              .value;
                                                      controller.nameEditable
                                                              .value =
                                                          !controller
                                                              .nameEditable
                                                              .value;
                                                      controller.genderEditable
                                                              .value =
                                                          !controller
                                                              .genderEditable
                                                              .value;
                                                      controller
                                                              .birthdateEditable
                                                              .value =
                                                          !controller
                                                              .birthdateEditable
                                                              .value;
                                                      controller.heightEditable
                                                              .value =
                                                          !controller
                                                              .heightEditable
                                                              .value;
                                                      controller
                                                          .fetchUserInfoOnAccountSettings();
                                                    }
                                                  } else {
                                                    RequestProcessLoader
                                                        .openLoadingDialog();
                                                    await controller
                                                        .updateUserBasicInfo();
                                                    RequestProcessLoader
                                                        .stopLoading();
                                                    controller.isEditingBasic
                                                            .value =
                                                        !controller
                                                            .isEditingBasic
                                                            .value;
                                                    controller.nameEditable
                                                            .value =
                                                        !controller
                                                            .nameEditable.value;
                                                    controller.genderEditable
                                                            .value =
                                                        !controller
                                                            .genderEditable
                                                            .value;
                                                    controller.birthdateEditable
                                                            .value =
                                                        !controller
                                                            .birthdateEditable
                                                            .value;
                                                    controller.heightEditable
                                                            .value =
                                                        !controller
                                                            .heightEditable
                                                            .value;
                                                    controller
                                                        .fetchUserInfoOnAccountSettings();
                                                  }
                                                },
                                                child: const Text(
                                                  'Done',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily:
                                                          'SFProDisplay',
                                                      fontSize: 14),
                                                ),
                                              )
                                            : const Text(
                                                'Edit',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontFamily: 'SFProDisplay',
                                                    fontSize: 14),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                _buildQuestionSection(
                                    'Name',
                                    controller.nameController.value,
                                    controller.nameEditable.value,
                                    'name',
                                    TextInputType.text),
                                _buildQuestionSection(
                                    'Gender',
                                    controller.genderController.value,
                                    controller.genderEditable.value,
                                    'gender',
                                    TextInputType.text,
                                    optionalField: selectGenderFunction()),
                                _buildQuestionSection(
                                    'Birthdate',
                                    controller.birthdateController.value,
                                    controller.birthdateEditable.value,
                                    'birthdate',
                                    TextInputType.number,
                                    optionalField: _dobSelectFunction()),
                                _buildQuestionSection(
                                    'Height',
                                    controller.heightController.value,
                                    controller.heightEditable.value,
                                    'height',
                                    TextInputType.number,
                                    optionalField: _selectedHeight()),
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AccountSettingBioEdit()));
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          'assets/pencil.png', // Your pencil image
                                          width: 20,
                                          height: 20,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        const Text(
                                          'Edit',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: 'SFProDisplay',
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // About Me Section
                                      const Text(
                                        'About Me',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontFamily: 'SFProDisplay',
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        controller.aboutMeController.value.text
                                                .isNotEmpty
                                            ? controller
                                                .aboutMeController.value.text
                                            : 'Tell us about yourself',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontFamily: 'SFProDisplay',
                                        ),
                                      ),
                                      Divider(
                                          color: Colors.grey[300],
                                          thickness: 1),
                                      const SizedBox(height: 20),
                                      // what are you looking exatly
                                      const Text(
                                        'What you are looking for exactly?',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontFamily: 'SFProDisplay',
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                        padding: const EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          controller.whatAreYouLook.value.text
                                                  .isNotEmpty
                                              ? controller
                                                  .whatAreYouLook.value.text
                                              : 'Share Description of what you need',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                            fontFamily: 'SFProDisplay',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      // Hobbies Section
                                      const Text(
                                        'Hobbies & Interests',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontFamily: 'SFProDisplay',
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        controller.hobbiesController.value.text
                                                .isNotEmpty
                                            ? controller
                                                .hobbiesController.value.text
                                            : 'Tell us what excites you',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontFamily: 'SFProDisplay',
                                        ),
                                      ),
                                      Divider(
                                          color: Colors.grey[300],
                                          thickness: 1),
                                      const SizedBox(height: 20),

                                      // Education Section
                                      const Text(
                                        'Profession',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontFamily: 'SFProDisplay',
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        controller.professionController.value
                                                .text.isNotEmpty
                                            ? controller
                                                .professionController.value.text
                                            : 'Tell us about your profession',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontFamily: 'SFProDisplay',
                                        ),
                                      ),
                                      Divider(
                                          color: Colors.grey[300],
                                          thickness: 1),
                                      const SizedBox(height: 20),

                                      // Education Section
                                      const Text(
                                        'Education',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontFamily: 'SFProDisplay',
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        controller.educationController.value
                                                .text.isNotEmpty
                                            ? controller
                                                .educationController.value.text
                                            : 'Enter your education',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontFamily: 'SFProDisplay',
                                        ),
                                      ),
                                      Divider(
                                          color: Colors.grey[300],
                                          thickness: 1),
                                      const SizedBox(height: 20),

                                      // Education Section
                                      const Text(
                                        'Institute\'s Name',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontFamily: 'SFProDisplay',
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        controller.instituteController.value
                                                .text.isNotEmpty
                                            ? controller
                                                .instituteController.value.text
                                            : 'Enter your institute name',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontFamily: 'SFProDisplay',
                                        ),
                                      ),
                                      Divider(
                                          color: Colors.grey[300],
                                          thickness: 1),
                                      const SizedBox(height: 20),

                                      // Education Section
                                      const Text(
                                        'Graduation Year',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontFamily: 'SFProDisplay',
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        controller.graduationYear.value.text
                                                .isNotEmpty
                                            ? controller
                                                .graduationYear.value.text
                                            : 'Enter your graduation year',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontFamily: 'SFProDisplay',
                                        ),
                                      ),
                                      Divider(
                                          color: Colors.grey[300],
                                          thickness: 1),
                                      const SizedBox(height: 20),

                                      // Education Section
                                      const Text(
                                        'Job Title/Occupation',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontFamily: 'SFProDisplay',
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        controller.jobRoleController.value.text
                                                .isNotEmpty
                                            ? controller
                                                .jobRoleController.value.text
                                            : 'Enter your job role',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontFamily: 'SFProDisplay',
                                        ),
                                      ),
                                      Divider(
                                          color: Colors.grey[300],
                                          thickness: 1),
                                      const SizedBox(height: 20),

                                      // Education Section
                                      const Text(
                                        'Company\'s Name',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontFamily: 'SFProDisplay',
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        controller.companyName.value.text
                                                .isNotEmpty
                                            ? controller.companyName.value.text
                                            : 'Enter your company name',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontFamily: 'SFProDisplay',
                                        ),
                                      ),
                                      Divider(
                                          color: Colors.grey[300],
                                          thickness: 1),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                                // _buildQuestionSection('About Me', aboutMeController,
                                //     aboutMeEditable, 'aboutMe', TextInputType.text,
                                //     maxLine: 3),
                                // _buildQuestionSection(
                                //     'Hobbies & Interests',
                                //     hobbiesController,
                                //     hobbiesEditable,
                                //     'hobbies',
                                //     TextInputType.text,
                                //     optionalField: _selectedHobbies()),
                                // _buildQuestionSection('Education', educationController,
                                //     educationEditable, 'education', TextInputType.text),
                                // _buildQuestionSection('Job Role', jobRoleController,
                                //     jobRoleEditable, 'jobRole', TextInputType.text),
                              ],
                            );
                          }
                        }),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Linked Accounts',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 5),
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Instagram',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                  Image(
                                    image: AssetImage(
                                        'assets/socialMedia/hugeicons_instagram.png'),
                                    height: 18,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Divider(color: Colors.grey[300], thickness: 1),
                              const SizedBox(
                                height: 5,
                              ),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Facebook',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                  Image(
                                    image: AssetImage(
                                        'assets/socialMedia/facebook.png'),
                                    height: 18,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Divider(color: Colors.grey[300], thickness: 1),
                              const SizedBox(
                                height: 5,
                              ),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Spotify',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                  Image(
                                    image: AssetImage(
                                        'assets/socialMedia/Group.png'),
                                    height: 18,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Divider(color: Colors.grey[300], thickness: 1),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                );
              });
            }
            return MessageScreenLoader.simpleLoader(text: 'Wait, Loading...');
          },
        );
      }),
    );
  }

// Custom toggle switch widget
  Widget _buildCustomToggle() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 250,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Stack(
            children: [
              // Animated Positioned toggle for smooth transitions
              AnimatedPositioned(
                duration: const Duration(milliseconds: 100),
                left: controller.isBasicInfoSelected.value
                    ? 0
                    : 125, // Adjust to half of 250
                child: Container(
                  width: 125, // Adjust width for new size
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    controller.isBasicInfoSelected.value ? 'Basic Info' : 'Bio',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Row for the two toggle options
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      controller.isBasicInfoSelected.value = true;
                      print(controller.isBasicInfoSelected.value);
                    },
                    splashColor: Colors.transparent, // Disables splash color
                    highlightColor:
                        Colors.transparent, // Disables highlight color
                    focusColor: Colors.transparent, // Disables focus color
                    hoverColor: Colors.transparent,
                    child: Container(
                      width: 125, // Adjust width for each toggle section
                      alignment: Alignment.center,
                      child: Text(
                        'Basic Info',
                        style: TextStyle(
                          color: controller.isBasicInfoSelected.value
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      controller.isBasicInfoSelected.value = false;
                      print(controller.isBasicInfoSelected.value);
                    },
                    splashColor: Colors.transparent, // Disables splash color
                    highlightColor:
                        Colors.transparent, // Disables highlight color
                    focusColor: Colors.transparent, // Disables focus color
                    hoverColor: Colors.transparent,
                    child: Container(
                      width: 125, // Adjust width for each toggle section
                      alignment: Alignment.center,
                      child: Text(
                        'Bio',
                        style: TextStyle(
                          color: controller.isBasicInfoSelected.value
                              ? Colors.black
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build dynamic question sections
  Widget _buildQuestionSection(String title, TextEditingController controller,
      bool isEditable, String section, TextInputType inputType,
      {int? maxLine = 1, dynamic optionalField}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          // Editable dummy text
          isEditable
              ? optionalField ??
                  SizedBox(
                    height: 25,
                    child: TextField(
                      controller: controller,
                      keyboardType: inputType,
                      maxLines: maxLine,
                      decoration: const InputDecoration(
                        border: InputBorder.none, // No border for TextField
                      ),
                    ),
                  )
              : Text(
                  controller.text.isNotEmpty
                      ? controller.text
                      : 'Type $section...',
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54), // Style the dummy text
                ),
          // Divider immediately after the text
          Divider(color: Colors.grey[300], thickness: 1),
        ],
      ),
    );
  }
}

class GradientCircularProgressPainter extends CustomPainter {
  final double progress;

  GradientCircularProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the background circle with reduced thickness
    Paint paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5; // Reduced thickness

    // Draw the progress arc with a gradient and reduced thickness
    Paint progressPaint = Paint()
      ..shader = const SweepGradient(
        colors: [
          Color(0xFFD83694), // Pink color
          Color(0xFF0039C7), // Blue color
        ],
        stops: [0.0, 1.0],
      ).createShader(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5; // Reduced thickness

    // Draw the background circle
    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);

    // Draw the arc indicating progress
    canvas.drawArc(
      Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2),
      -1.57, // Starting angle (in radians, for the top of the circle)
      6.28 * progress, // Angle for the progress (in radians)
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// class IncompleteCircleClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();
//     // Adjust the angle to increase the gap on the right side (e.g., from 3.14 to 2.5 radians)
//     path.addArc(
//         Rect.fromCircle(
//             center: Offset(size.width / 2, size.height / 2),
//             radius: size.width / 2),
//         4.6,
//         4.9);
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => true;
// }

class IncompleteCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Full circle from 0 to 2π radians
    double startAngle = 0; // Starting from 0 radians (right side of the circle)
    double sweepAngle = 2 * 3.141592653589793; // Full circle (360 degrees)

    path.addArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ),
      startAngle,
      sweepAngle,
    );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
