import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stringly/Reuseable%20Widget/multi_gradient_dropdown.dart';
import 'package:stringly/Screens/AccountSettings/AccountSettings.dart';
import 'package:stringly/Screens/loaders/request_process_loader.dart';
import 'package:stringly/GetxControllerAndBindings/controllers/profile/profile_controller.dart';
import 'package:stringly/intraction.dart';
import 'package:stringly/models/user_input_params.dart';
import '../../GetxControllerAndBindings/controllers/account/account_settings_controller.dart';
import '../../Reuseable Widget/GradientWidget.dart';
import '../../Reuseable Widget/gradienttextfield.dart';
import '../../models/update_user_account_model.dart';
import '../HobbyScreen.dart';
import '../loaders/message_screen_loader.dart';

class AccountSettingBioEdit extends StatefulWidget {
  @override
  _AccountSettingBioEditState createState() => _AccountSettingBioEditState();
}

class _AccountSettingBioEditState extends State<AccountSettingBioEdit> {
  String? aboutError;
  TextEditingController _bioController = TextEditingController();
  TextEditingController _jobRoleController = TextEditingController();
  String? _educationController;
  String? setEductionValue;
  TextEditingController _instituteNameController = TextEditingController();
  String? _graduationYearController;
  String? setGraduationYearValue;
  TextEditingController _jobTitleOccupationController = TextEditingController();
  TextEditingController _companyNameController = TextEditingController();
  // List to hold selected hobbies
  bool isProcessing = false;

  TextEditingController yourMainProfession = TextEditingController();
  TextEditingController educationControllerBioEdit = TextEditingController();
  TextEditingController what_you_looking_exactly = TextEditingController();

  List<String> selectedHobbies = [];

  late Future<dynamic> functionStatusData;

  @override
  void initState() {
    functionStatusData = _initiateSomeField();
    super.initState();
  }

  Future<Map<String, dynamic>> _initiateSomeField() async {
    Map<String, dynamic> data = await Intraction.getLoggedUserAccount();
    try {
      if (data.containsKey('Ok')) {
        final value = data['Ok']['params'];
        UpdateUserAccountModel userInputParams =
            UpdateUserAccountModel.fromMap(value);
        setState(() {
          selectedHobbies =
              (userInputParams.hobbies != null ? userInputParams.hobbies : [])!;
          _bioController.text = userInputParams.about ?? '';

          if (userInputParams.profession != null) {
            yourMainProfession.text = userInputParams.profession ?? '';
          }
          if (userInputParams.graduationYear != null) {
            setGraduationYearValue = '${userInputParams.graduationYear}' ?? '';
          }
          if (userInputParams.education != null) {
            // setEductionValue = userInputParams.education.toString() ?? '';
            educationControllerBioEdit.text =
                userInputParams.education.toString();
          }
          _educationController = userInputParams.education ?? '';
          _instituteNameController.text = userInputParams.instituteName ?? '';
          if (userInputParams.graduationYear != null) {
            _graduationYearController =
                userInputParams.graduationYear.toString();
          }
          if (userInputParams.lookingFor != null) {
            what_you_looking_exactly.text = userInputParams.lookingFor!;
          }
          _jobTitleOccupationController.text = userInputParams.jobTitle ?? '';
          _companyNameController.text = userInputParams.company ?? '';
          _jobRoleController.text = userInputParams.jobRole ?? '';
        });
      }
      return {'Ok': data};
    } catch (e) {
      debugPrint('Error ---------- $e');
      return {'Err': e};
    }
  }

  List<String> getYearList() {
    final currentYear = DateTime.now().year;
    const startYear = 1980;
    final endYear = currentYear + 5;
    return List.generate(
        endYear - startYear + 1, (index) => (startYear + index).toString());
  }

  final profileController = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: functionStatusData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MessageScreenLoader.simpleLoader(text: 'Wait, Loading...');
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Something went wrong! Please try again later.',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bio',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 35),
                    Column(
                      children: [
                        GradientTextField(
                          controller: _bioController,
                          height: 125,
                          maxLines: null,
                          label: Container(
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'About me',
                                    style: TextStyle(
                                        color: Colors.black,
                                        backgroundColor: Colors.white,
                                        fontSize: 14),
                                  ),
                                  TextSpan(
                                    text: ' *',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14), // Red asterisk style
                                  ),
                                ],
                              ),
                            ),
                          ),
                          hintText: 'Specify about yourself',
                        ),
                        if (aboutError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '$aboutError',
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12),
                                )),
                          ),
                        const SizedBox(height: 20),

                        // Hobbies & Interests Field
                        GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HobbiesScreen(
                                        initialHobbies: selectedHobbies,
                                      )),
                            );
                            if (result != null &&
                                result is Map<String, List<String>>) {
                              setState(() {
                                selectedHobbies =
                                    result['selectedHobbies'] ?? [];
                              });
                            }
                          },
                          child: Container(
                            height: 56,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color(0xffD6D6D6), width: 2),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12.0),
                                  child: Text(
                                    'Hobbies & Interests',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Icon(Icons.keyboard_arrow_right,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),

                        if (selectedHobbies.isNotEmpty)
                          const SizedBox(
                            height: 20,
                          ),
                        // Display selected hobbies
                        if (selectedHobbies.isNotEmpty)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: selectedHobbies.map(
                                (hobby) {
                                  return Chip(
                                    label: Text(hobby),
                                    deleteIcon: const Icon(Icons.close),
                                    onDeleted: () {
                                      setState(() {
                                        selectedHobbies.remove(hobby);
                                      });
                                    },
                                    backgroundColor: Colors.grey[300],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      side: const BorderSide(
                                          color: Colors.transparent),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ),

                        const SizedBox(height: 20),

                        // Profession Text Field
                        GradientTextField(
                          controller: yourMainProfession,
                          label: const Text('+ Profession'),
                          hintText: 'Write your profession ',
                        ),
                        const SizedBox(height: 20),
                        // GradientdropdownTextField(
                        //   hintText: 'Specify your highest education',
                        //   items: const [
                        //     'Post Graduate',
                        //     'Graduate',
                        //     'In College',
                        //     'Prefer Not To Say'
                        //   ],
                        //   initialValue: setEductionValue ?? null,
                        //   onChanged: (value) {
                        //     if (value != null) {
                        //       setState(() {
                        //         _educationController = value?.value;
                        //         debugPrint('$_educationController');
                        //       });
                        //     }
                        //   },
                        //   label: const Text('Education'),
                        // ),

                        GradientTextField(
                            controller: educationControllerBioEdit,
                            hintText: 'Specify your education',
                            label: const Text('Education')),
                        const SizedBox(height: 20),
                        GradientTextField(
                            controller: _instituteNameController,
                            hintText: 'Institute \'s Name',
                            label: const Text('Institute \'s Name')),
                        const SizedBox(height: 20),
                        GradientdropdownTextField(
                          hintText: 'Specify your graduation year',
                          items: getYearList(),
                          initialValue: setGraduationYearValue ?? null,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _graduationYearController = value?.value;
                                debugPrint('$_graduationYearController');
                              });
                            }
                          },
                          label: const Text('Graduation Year'),
                        ),
                        const SizedBox(height: 20),
                        GradientTextField(
                            controller: _jobTitleOccupationController,
                            label: const Text('Job title/Occupation'),
                            hintText: 'Job title / Occupation'),
                        const SizedBox(height: 20),
                        GradientTextField(
                          controller: _companyNameController,
                          hintText: 'Company Name',
                          label: const Text('Company Name'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    MultiSelectGradientDropdown(
                      initialValues: what_you_looking_exactly.text.split(', '),
                      onChanged: (values) {
                        setState(() {
                          what_you_looking_exactly.text = values.join(", ");
                        });
                      },
                    ),

                    const SizedBox(height: 100),
                    // Next Button
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isProcessing
                              ? null
                              : () async {
                                  if (_bioController.text.trim().isEmpty) {
                                    setState(() {
                                      aboutError = "About me can't be empty";
                                    });
                                  } else {
                                    setState(() {
                                      isProcessing = true;
                                      aboutError = null;
                                    });

                                    RequestProcessLoader.openLoadingDialog();
                                    await Future.delayed(Duration.zero);

                                    UserInputParams userInputParams =
                                        UserInputParams();
                                    userInputParams.reset();
                                    userInputParams.updateField(
                                        'about', _bioController.text);
                                    userInputParams.updateField(
                                        'hobbies', selectedHobbies);
                                    if (yourMainProfession.text.isNotEmpty) {
                                      userInputParams.updateField('profession',
                                          yourMainProfession.text);
                                    }
                                    if (educationControllerBioEdit.text
                                        .trim()
                                        .isNotEmpty) {
                                      userInputParams.updateField(
                                          'education',
                                          educationControllerBioEdit.text
                                              .trim());
                                    }
                                    userInputParams.updateField('instituteName',
                                        _instituteNameController.text);
                                    if (_graduationYearController != null) {
                                      userInputParams.updateField(
                                          'graduationYear',
                                          int.tryParse(
                                              _graduationYearController!));
                                    }
                                    userInputParams.updateField('jobTitle',
                                        _jobTitleOccupationController.text);
                                    userInputParams.updateField(
                                        'company', _companyNameController.text);
                                    userInputParams.updateField(
                                        'jobRole', _jobRoleController.text);

                                    if (what_you_looking_exactly.text
                                        .trim()
                                        .isNotEmpty) {
                                      userInputParams.updateField('lookingFor',
                                          what_you_looking_exactly.text);
                                    }

                                    Future<void> createUser() async {
                                      try {
                                        await Intraction.createAnUser(
                                            userInputParams);
                                      } catch (error) {
                                        print('Error: $error');
                                      } finally {
                                        RequestProcessLoader.stopLoading();
                                      }
                                    }

                                    await createUser();
                                    final controller =
                                        Get.find<AccountSettingsController>();
                                    controller.aboutMeController.value.text =
                                        _bioController.text;
                                    controller.selectedHobbies.value =
                                        selectedHobbies;
                                    controller.hobbiesController.value.text =
                                        selectedHobbies
                                            .join(', ')
                                            .replaceAll(RegExp(r'[\[\]]'), '');
                                    controller.professionController.value.text =
                                        yourMainProfession.text;
                                    controller.educationController.value.text =
                                        _educationController ?? '';
                                    controller.instituteController.value.text =
                                        _instituteNameController.text;
                                    controller.graduationYear.value.text =
                                        _graduationYearController ?? '';
                                    controller.jobRoleController.value.text =
                                        _jobTitleOccupationController.text;
                                    controller.whatAreYouLook.value.text =
                                        what_you_looking_exactly.text;
                                    controller.companyName.value.text =
                                        _companyNameController.text;

                                    Navigator.pop(context);
                                    controller.companyName.refresh();

                                    // Profile Controller updates

                                    profileController.aboutMeController.value
                                        .text = _bioController.text;
                                    profileController
                                            .hobbiesController.value.text =
                                        selectedHobbies
                                            .join(', ')
                                            .replaceAll(RegExp(r'[\[\]]'), '');
                                    profileController.professionController.value
                                        .text = yourMainProfession.text;
                                    profileController.educationController.value
                                        .text = _educationController ?? '';
                                    profileController
                                        .instituteNameController
                                        .value
                                        .text = _instituteNameController.text;
                                    profileController
                                        .graduationYearController
                                        .value
                                        .text = _graduationYearController ?? '';
                                    profileController
                                            .jobTitleController.value.text =
                                        _jobTitleOccupationController.text;
                                    profileController
                                        .whatYouLookingController
                                        .value
                                        .text = what_you_looking_exactly.text;
                                    profileController
                                        .companyNameController
                                        .value
                                        .text = _companyNameController.text;
                                    profileController.companyNameController
                                        .refresh();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Done',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
