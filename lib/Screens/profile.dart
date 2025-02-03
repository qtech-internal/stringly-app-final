import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stringly/Reuseable%20Widget/profile_progress.dart';
import 'package:stringly/GetxControllerAndBindings/controllers/profile/profile_controller.dart';
import 'package:stringly/models/update_user_account_model.dart';
import 'AccountSettings/AccountSettings.dart';
import 'loaders/message_screen_loader.dart';
import 'SettingScreen.dart';
import 'mainScreenNav.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // File? _profileImage; // Variable to hold the profile image file

  // bool isUserVerified = false;

  // late Future<dynamic> _allProfileFunction;
  // String? uploadImageProfile;
  // List<String> selectedHobbies = [];
  // String? yourMainProfession;
  // List<String> yourMainProfessionItems = [
  //   'Technology & Software Development',
  //   'Arts & Entertainment',
  //   'Media & Journalism',
  //   'Music & Performing Arts',
  //   'Banking & finance',
  //   'Consulting',
  //   'Marketing & Advertising',
  //   'Healthcare & Medicine',
  //   'Education & Research',
  //   'Business & Management'
  // ];
  // final SingleValueDropDownController _mainProfessionController =
  //     SingleValueDropDownController();
  // Controllers for text fields
  // final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _pronounsController = TextEditingController();
  // final TextEditingController _aboutMeController = TextEditingController();
  // final TextEditingController _hobbiesController = TextEditingController();
  // final TextEditingController _educationController = TextEditingController();
  // final TextEditingController _whatYouLookingController =
  //     TextEditingController();
  // final TextEditingController _professionController = TextEditingController();
  // final TextEditingController _instituteNameController =
  //     TextEditingController();
  // final TextEditingController _graduationYearController =
  //     TextEditingController();
  // final TextEditingController _jobTitleController = TextEditingController();
  // final TextEditingController _companyNameController = TextEditingController();

  UpdateUserAccountModel updateUserModel = UpdateUserAccountModel();

  // Variable to control edit mode

  // Future<void> _pickImage() async {
  //   final selectedPaths = await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => CustomImagePicker()),
  //   );

  //   if (selectedPaths != null && selectedPaths.isNotEmpty) {
  //     setState(() {
  //       _profileImage = File(selectedPaths[
  //           0]); // Use the first selected image as the profile picture
  //     });
  //   }
  // }

  // @override
  // void initState() {
  //   _allProfileFunction = _fetchUserData();
  //   super.initState();
  // }

  // Future<Map<String, dynamic>> _updateUserInfo() async {
  //   updateUserModel.updateField('about', _aboutMeController.text);
  //   updateUserModel.updateField('lookingFor', _whatYouLookingController.text);
  //   if (selectedHobbies.isNotEmpty) {
  //     updateUserModel.updateField('hobbies', selectedHobbies ?? []);
  //   }
  //   if (yourMainProfession != null) {
  //     updateUserModel.updateField('profession', yourMainProfession);
  //   }
  //   updateUserModel.updateField('education', _educationController.text);
  //   updateUserModel.updateField(
  //       'graduationYear', int.tryParse(_graduationYearController.text));
  //   updateUserModel.updateField('jobTitle', _jobTitleController.text);
  //   updateUserModel.updateField('company', _jobTitleController.text);

  //   if (_profileImage != null) {
  //     File userSelectProfileImage = File(_profileImage!.path);
  //     final imageUrl = await ImageUploadAndGetUrl.uploadImageAndGetUrl(
  //         pickedFile: userSelectProfileImage);
  //     if (imageUrl != null &&
  //         imageUrl.containsKey('Ok') &&
  //         imageUrl['Ok'] is String) {
  //       String url = imageUrl['Ok'] as String;
  //       debugPrint('$url');
  //       updateUserModel.updateField('images', [url]);
  //     }
  //   }

  //   Map<String, dynamic> result =
  //       await Intraction.updateLoggedUserAccount(updateUserModel);
  //   return result;
  // }

  // Future<void> _fetchUserData() async {
  //   Map<String, dynamic> result = await Intraction.getLoggedUserAccount();
  //   if (result.containsKey('Ok')) {
  //     var data = result['Ok']['params'];
  //     setState(() {
  //       if (data['images'][0] != null && data['images'][0].isNotEmpty) {
  //         uploadImageProfile = data['images'][0].first;
  //       }
  //       _nameController.text = data['name'][0];
  //       if (data['gender'] != null && data['gender'].isNotEmpty) {
  //         if (data['gender'][0] == 'Male') {
  //           _pronounsController.text = 'He/Him';
  //         } else if (data['gender'][0] == 'Female') {
  //           _pronounsController.text = 'She/Her';
  //         } else {
  //           _pronounsController.text = 'Other';
  //         }
  //       }
  //       _aboutMeController.text =
  //           (data['about'] != null && data['about'].isNotEmpty)
  //               ? data['about'][0]
  //               : '';
  //       _whatYouLookingController.text =
  //           (data['looking_for'] != null && data['looking_for'].isNotEmpty)
  //               ? data['looking_for'][0]
  //               : '';
  //       _hobbiesController.text =
  //           (data['hobbies'] != null && data['hobbies'].isNotEmpty)
  //               ? '${data['hobbies'][0].join(", ")}'
  //               : '';
  //       _professionController.text =
  //           (data['profession'] != null && data['profession'].isNotEmpty)
  //               ? data['profession'][0]
  //               : '';
  //       _educationController.text =
  //           (data['education'] != null && data['education'].isNotEmpty)
  //               ? data['education'][0]
  //               : '';
  //       _instituteNameController.text = (data['institute_name'] != null &&
  //               data['institute_name'].isNotEmpty)
  //           ? data['institute_name'][0]
  //           : '';
  //       if (data['gradutation_year'] != null &&
  //           data['gradutation_year'].isNotEmpty) {
  //         _graduationYearController.text =
  //             data['gradutation_year'][0].toString();
  //       }
  //       _jobTitleController.text =
  //           (data['job_title'] != null && data['job_title'].isNotEmpty)
  //               ? data['job_title'][0]
  //               : '';
  //       _companyNameController.text =
  //           (data['company'] != null && data['company'].isNotEmpty)
  //               ? data['company'][0]
  //               : '';
  //     });
  //   } else {
  //     debugPrint('${result['Err']}');
  //   }
  // }

  // Widget _selectedHobbies() {
  //   return GestureDetector(
  //     onTap: () async {
  //       final result = await Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => HobbiesScreen()),
  //       );
  //       if (result != null && result is Map<String, List<String>>) {
  //         setState(() {
  //           selectedHobbies = result['selectedHobbies'] ?? [];
  //         });
  //       }
  //     },
  //     child: Container(
  //       height: 50,
  //       width: double.infinity,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(8),
  //         color: Colors.white,
  //         border: Border.all(color: Colors.grey), // Add grey border here
  //         boxShadow: [
  //           BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 6),
  //         ],
  //       ),
  //       child: const Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 16.0),
  //             child: Text(
  //               'Hobbies & Interests',
  //               style: TextStyle(color: Colors.black, fontSize: 16),
  //             ),
  //           ),
  //           Padding(
  //             padding: EdgeInsets.only(right: 8.0),
  //             child: Icon(Icons.arrow_right, color: Colors.black),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  late ProfileController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.put(ProfileController());
    controller.allProfileFunction.value = controller.fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => Mainscreennav()));
            },
            icon: const Icon(Icons.arrow_back)),
        elevation: 0,
        toolbarHeight: 66,
        titleSpacing: 0,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'SFProDisplay',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsScreen()));
              // WidgetsBinding.instance.addPostFrameCallback((_) {
              //   Navigator.of(context).push(
              //     MaterialPageRoute(builder: (context) => TryNotification()),
              //   );
              // });

              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(
              //     content: Center(child: Text('Coming soon...........')),
              //     duration: Duration(seconds: 2),
              //   ),
              // );
            },
            icon: const Icon(Icons.settings, color: Colors.white, size: 28),
          ),
        ],
      ),
      body: Obx(() {
        return FutureBuilder(
          future: controller.allProfileFunction.value,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return MessageScreenLoader.simpleLoader(text: 'Wait, Loading...');
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Obx(() {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Title with Edit Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Profile',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'SFProDisplay',
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                // setState(() {
                                //   _isEditing = !_isEditing; // Toggle edit mode
                                // });
                                // if (!_isEditing) {
                                //   RequestProcessLoader.openLoadingDialog();
                                //   Map<String, dynamic> result = await _updateUserInfo();
                                //   await _fetchUserData();
                                //   RequestProcessLoader.stopLoading();
                                //   debugPrint('$result');
                                // }

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AccountSetting()));
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
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Centered Profile Image
                        Obx(() {
                          return Center(
                              child: ProfileCircleWidget(
                            isVerified: false,
                            imageUrl: controller.userProfileImage.value,
                            progress: 0.75,
                            size: 0.30,
                          ));
                        }),
                        // Center(
                        //   child: Stack(
                        //     alignment: Alignment.center,
                        //     children: [
                        //       // Outer Container with Gradient Border
                        //       Container(
                        //         width: 130,
                        //         height: 130,
                        //         decoration: const BoxDecoration(
                        //           shape: BoxShape.circle,
                        //           gradient: LinearGradient(
                        //             colors: [Colors.blue, Colors.purple],
                        //           ),
                        //         ),
                        //         child: Center(
                        //           child: Container(
                        //             width: 120,
                        //             height: 120,
                        //             decoration: const BoxDecoration(
                        //               shape: BoxShape.circle,
                        //               color: Colors.white,
                        //             ),
                        //             child: Center(
                        //               child: ClipOval(
                        //                 child: uploadImageProfile != null
                        //                     ? _profileImage != null
                        //                     ? Image.file(_profileImage!,
                        //                     width: 110,
                        //                     height: 110,
                        //                     fit: BoxFit.cover)
                        //                     : Image.network(
                        //                   uploadImageProfile!,
                        //                   width: 110,
                        //                   height: 110,
                        //                   fit: BoxFit.cover,
                        //                 )
                        //                     : const Image(
                        //                   image: AssetImage('assets/img_1.png'),
                        //                   width: 110,
                        //                   height: 110,
                        //                   fit: BoxFit.cover,
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       // Plus icon for changing profile picture
                        //       if (_isEditing) // Show only when editing
                        //         Positioned(
                        //           bottom: 10,
                        //           right: 10,
                        //           child: GestureDetector(
                        //             onTap: _pickImage,
                        //             // Use the updated _pickImage function
                        //             child: Container(
                        //               padding: const EdgeInsets.all(8),
                        //               decoration: BoxDecoration(
                        //                 color: Colors.grey,
                        //                 borderRadius: BorderRadius.circular(8),
                        //               ),
                        //               child: const Icon(
                        //                 Icons.add,
                        //                 size: 20,
                        //                 color: Colors.white,
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //     ],
                        //   ),
                        // ),

                        const SizedBox(height: 10),

                        // Name and Pronouns
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              controller.nameController.value.text,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'SFProDisplay',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              controller.pronounsController.value.text,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                                fontFamily: 'SFProDisplay',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

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
                        // _isEditing
                        //     ? Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Expanded(
                        //             child: TextField(
                        //               controller: _aboutMeController,
                        //               maxLines: null,
                        //               style: const TextStyle(
                        //                 fontSize: 14,
                        //                 color: Colors.black54,
                        //                 fontFamily: 'SFProDisplay',
                        //               ),
                        //               decoration: const InputDecoration(
                        //                 border: InputBorder.none,
                        //                 hintText: 'Tell us about yourself',
                        //               ),
                        //             ),
                        //           ),
                        //           IconButton(
                        //             icon:
                        //                 const Icon(Icons.edit, color: Colors.grey),
                        //             onPressed: () {
                        //               // Add functionality to edit the about section if necessary
                        //             },
                        //           ),
                        //         ],
                        //       )
                        //     :
                        Text(
                          controller.aboutMeController.value.text.isNotEmpty
                              ? controller.aboutMeController.value.text
                              : 'Tell us about yourself',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontFamily: 'SFProDisplay',
                          ),
                        ),
                        Divider(color: Colors.grey[300], thickness: 1),
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
                        // _isEditing
                        //     ? Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Expanded(
                        //             child: TextField(
                        //               controller: _whatYouLookingController,
                        //               maxLines: null,
                        //               style: const TextStyle(
                        //                 fontSize: 14,
                        //                 color: Colors.black54,
                        //                 fontFamily: 'SFProDisplay',
                        //               ),
                        //               decoration: const InputDecoration(
                        //                 border: InputBorder.none,
                        //                 hintText: 'What you are looking exatly?',
                        //               ),
                        //             ),
                        //           ),
                        //           IconButton(
                        //             icon:
                        //                 const Icon(Icons.edit, color: Colors.grey),
                        //             onPressed: () {},
                        //           ),
                        //         ],
                        //       )
                        //     :
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            controller.whatYouLookingController.value.text
                                    .isNotEmpty
                                ? controller.whatYouLookingController.value.text
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
                        // _isEditing
                        //     ? Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Expanded(child: _selectedHobbies()),
                        //         ],
                        //       )
                        //     :
                        Text(
                          controller.hobbiesController.value.text.isNotEmpty
                              ? controller.hobbiesController.value.text
                              : 'Tell us what excites you',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontFamily: 'SFProDisplay',
                          ),
                        ),
                        Divider(color: Colors.grey[300], thickness: 1),
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
                        // _isEditing
                        //     ? Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Expanded(
                        //             child: DropDownTextField(
                        //               controller: _mainProfessionController,
                        //               clearOption: true,
                        //               dropDownItemCount: 6,
                        //               dropDownList:
                        //                   yourMainProfessionItems.map((item) {
                        //                 return DropDownValueModel(
                        //                     name: item, value: item);
                        //               }).toList(),
                        //               onChanged: (value) {
                        //                 setState(() {
                        //                   yourMainProfession = value
                        //                       .value; // Update the selected value
                        //                 });
                        //               },
                        //               textFieldDecoration: InputDecoration(
                        //                   labelText: 'Profession',
                        //                   labelStyle:
                        //                       const TextStyle(color: Colors.grey),
                        //                   border: OutlineInputBorder(
                        //                       borderRadius:
                        //                           BorderRadius.circular(10)),
                        //                   hintText: 'Select profession',
                        //                   hintStyle:
                        //                       const TextStyle(color: Colors.grey)),
                        //             ),
                        //           ),
                        //         ],
                        //       )
                        //     :
                        Text(
                          controller.professionController.value.text.isNotEmpty
                              ? controller.professionController.value.text
                              : 'Tell us about your profession',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontFamily: 'SFProDisplay',
                          ),
                        ),
                        Divider(color: Colors.grey[300], thickness: 1),
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
                        // _isEditing
                        //     ? Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Expanded(
                        //             child: TextField(
                        //               controller: _educationController,
                        //               maxLines: null,
                        //               style: const TextStyle(
                        //                 fontSize: 14,
                        //                 color: Colors.black54,
                        //                 fontFamily: 'SFProDisplay',
                        //               ),
                        //               decoration: const InputDecoration(
                        //                 border: InputBorder.none,
                        //                 hintText: 'Profession',
                        //               ),
                        //             ),
                        //           ),
                        //           IconButton(
                        //             icon:
                        //                 const Icon(Icons.edit, color: Colors.grey),
                        //             onPressed: () {
                        //               // Add functionality to edit the about section if necessary
                        //             },
                        //           ),
                        //         ],
                        //       )
                        //     :
                        Text(
                          controller.educationController.value.text.isNotEmpty
                              ? controller.educationController.value.text
                              : 'Enter your education',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontFamily: 'SFProDisplay',
                          ),
                        ),
                        Divider(color: Colors.grey[300], thickness: 1),
                        const SizedBox(height: 20),

                        // Education Section
                        const Text(
                          'Institute Name',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'SFProDisplay',
                          ),
                        ),
                        const SizedBox(height: 5),
                        // _isEditing
                        //     ? Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Expanded(
                        //             child: TextField(
                        //               controller: _instituteNameController,
                        //               maxLines: null,
                        //               style: const TextStyle(
                        //                 fontSize: 14,
                        //                 color: Colors.black54,
                        //                 fontFamily: 'SFProDisplay',
                        //               ),
                        //               decoration: const InputDecoration(
                        //                 border: InputBorder.none,
                        //                 hintText: 'Institute\'s Name',
                        //               ),
                        //             ),
                        //           ),
                        //           IconButton(
                        //             icon:
                        //                 const Icon(Icons.edit, color: Colors.grey),
                        //             onPressed: () {
                        //               // Add functionality to edit the about section if necessary
                        //             },
                        //           ),
                        //         ],
                        //       )
                        //     :
                        Text(
                          controller
                                  .instituteNameController.value.text.isNotEmpty
                              ? controller.instituteNameController.value.text
                              : 'Enter your institute name',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontFamily: 'SFProDisplay',
                          ),
                        ),
                        Divider(color: Colors.grey[300], thickness: 1),
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
                        // _isEditing
                        //     ? Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Expanded(
                        //             child: TextField(
                        //               controller: _graduationYearController,
                        //               maxLines: null,
                        //               keyboardType: TextInputType.number,
                        //               style: const TextStyle(
                        //                 fontSize: 14,
                        //                 color: Colors.black54,
                        //                 fontFamily: 'SFProDisplay',
                        //               ),
                        //               decoration: const InputDecoration(
                        //                 border: InputBorder.none,
                        //                 hintText: 'Graduation Year',
                        //               ),
                        //             ),
                        //           ),
                        //           IconButton(
                        //             icon:
                        //                 const Icon(Icons.edit, color: Colors.grey),
                        //             onPressed: () {
                        //               // Add functionality to edit the about section if necessary
                        //             },
                        //           ),
                        //         ],
                        //       )
                        //     :
                        Text(
                          controller.graduationYearController.value.text
                                  .isNotEmpty
                              ? controller.graduationYearController.value.text
                              : 'Enter your graduation year',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontFamily: 'SFProDisplay',
                          ),
                        ),
                        Divider(color: Colors.grey[300], thickness: 1),
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
                        // _isEditing
                        //     ? Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Expanded(
                        //             child: TextField(
                        //               controller: _jobTitleController,
                        //               maxLines: null,
                        //               style: const TextStyle(
                        //                 fontSize: 14,
                        //                 color: Colors.black54,
                        //                 fontFamily: 'SFProDisplay',
                        //               ),
                        //               decoration: const InputDecoration(
                        //                 border: InputBorder.none,
                        //                 hintText: 'Job Title/Occupation',
                        //               ),
                        //             ),
                        //           ),
                        //           IconButton(
                        //             icon:
                        //                 const Icon(Icons.edit, color: Colors.grey),
                        //             onPressed: () {
                        //               // Add functionality to edit the about section if necessary
                        //             },
                        //           ),
                        //         ],
                        //       )
                        //     :
                        Text(
                          controller.jobTitleController.value.text.isNotEmpty
                              ? controller.jobTitleController.value.text
                              : 'Enter your job role',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontFamily: 'SFProDisplay',
                          ),
                        ),
                        Divider(color: Colors.grey[300], thickness: 1),
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
                        // _isEditing
                        //     ? Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Expanded(
                        //             child: TextField(
                        //               controller: _companyNameController,
                        //               maxLines: null,
                        //               style: const TextStyle(
                        //                 fontSize: 14,
                        //                 color: Colors.black54,
                        //                 fontFamily: 'SFProDisplay',
                        //               ),
                        //               decoration: const InputDecoration(
                        //                 border: InputBorder.none,
                        //                 hintText: 'Company\'s Name',
                        //               ),
                        //             ),
                        //           ),
                        //           IconButton(
                        //             icon:
                        //                 const Icon(Icons.edit, color: Colors.grey),
                        //             onPressed: () {
                        //               // Add functionality to edit the about section if necessary
                        //             },
                        //           ),
                        //         ],
                        //       )
                        //     :
                        Text(
                          controller.companyNameController.value.text.isNotEmpty
                              ? controller.companyNameController.value.text
                              : 'Enter your company name',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontFamily: 'SFProDisplay',
                          ),
                        ),
                        Divider(color: Colors.grey[300], thickness: 1),
                        const SizedBox(height: 50),
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
