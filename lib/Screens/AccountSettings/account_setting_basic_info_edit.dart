import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:get/get.dart';
import 'package:stringly/GetxControllerAndBindings/controllers/profile/profile_controller.dart';
import 'package:stringly/intraction.dart';
import '../../GetxControllerAndBindings/controllers/account/account_settings_controller.dart';
import '../../Reuseable Widget/GradientWidget.dart';
import '../../Reuseable Widget/gradienttextfield.dart';
import '../../models/update_user_account_model.dart';
import '../../models/user_input_params.dart';
import '../loaders/message_screen_loader.dart';
import '../loaders/request_process_loader.dart';


class AccountSettingBasicInfoEdit extends StatefulWidget {
  @override
  _AccountSettingBasicInfoEditState createState() =>
      _AccountSettingBasicInfoEditState();
}

class _AccountSettingBasicInfoEditState
    extends State<AccountSettingBasicInfoEdit> {
  final FocusNode _focusNode = FocusNode();
  String? firstNameError;
  String? genderError;
  bool _hasFocus = false;
  TextEditingController first_name = TextEditingController();
  TextEditingController last_name = TextEditingController();
  DateTime? selectedDate;
  String? selectedGender;
  String? height_in_feet;
  String? height_in_inche;
  String? initialHeight_feet;
  String? initialHeight_inches;
  String? initial_gender;
  String? additionalGenderInfo;
  final _formKey = GlobalKey<FormState>();
  final SingleValueDropDownController _genderController =
      SingleValueDropDownController();
  bool isNextButtonEnabled =
      false; // Track if the Next button should be enabled
  late Future<dynamic> functionStatusData;

  UserInputParams userInputParams = UserInputParams();
  final controller = Get.find<AccountSettingsController>();
  final profileController = Get.find<ProfileController>();

  late SingleValueDropDownController _controller;
  void _showGenderInfoDialog(String? selectedGender) {
    String? tempSelectedOption;

    List<String> options = [];
    if (selectedGender == 'Male') {
      options = [
        'Cis Male',
        'Trans Male',
        'Demiboy',
        'Genderfluid',
        'Two-Spirit'
      ];
    } else if (selectedGender == 'Female') {
      options = [
        'Cis Female',
        'Trans Female',
        'Demigirl',
        'Genderfluid',
        'Two-Spirit'
      ];
    } else {
      // If 'Other' is selected, you might want to handle it differently
      options = ['Non-Binary', 'Genderqueer', 'Agender', 'Pangender'];
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(20),
          title: const Text(
            'Add more about your gender',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...options.map((option) {
                  return GestureDetector(
                    onTap: () {
                      tempSelectedOption = option;
                      (context as Element).markNeedsBuild();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(10),
                        border: tempSelectedOption == option
                            ? Border.all(
                                width: 2,
                                color: Colors.black,
                              )
                            : null,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          option,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (tempSelectedOption != null) {
                  setState(() {
                    additionalGenderInfo = tempSelectedOption;
                  });
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Save and Continue',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> resetUserInputParams() async {
    Map<String, dynamic> data = await Intraction.getLoggedUserAccount();
    try {
      if (data.containsKey('Ok')) {
        final value = data['Ok']['params'];
        UpdateUserAccountModel user = UpdateUserAccountModel.fromMap(value);
        setState(() {
          if (user.name != null) {
            Map<String, String> separateName(String fullName) {
              List<String> nameParts = fullName.split(' ');
              String firstName = nameParts.first;
              String lastName =
                  nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

              return {
                'firstName': firstName,
                'lastName': lastName,
              };
            }

            final data = separateName(user.name!);

            first_name.text = data['firstName']!;
            last_name.text = data['lastName']!;
          }
          if (user.dob != null) {
            isNextButtonEnabled = true;
            try {
              DateTime parsedDate = DateTime.parse(user.dob!.toString());
              selectedDate = parsedDate;
            } catch (e) {
              debugPrint('--------------------------------------$e');
            }
          }
          if (user.subgender != null) {
            additionalGenderInfo = user.subgender.toString();
          }
          if (user.gender != null) {
            initial_gender = user.gender;
            selectedGender = user.gender.toString();
          }
          if (user.height != null) {
            Map<String, String> separateHeight(String height) {
              List<String> heightParts = height.split('.');
              String mainPart = heightParts.first;
              String fractionalPart =
                  heightParts.length > 1 ? heightParts[1] : '';

              return {
                'mainPart': mainPart,
                'fractionalPart': fractionalPart,
              };
            }

            final height = separateHeight(user.height!);
            initialHeight_feet = height['mainPart'];
            initialHeight_inches = height['fractionalPart'];
          }
        });
      }
      return {'Ok': data};
    } catch (e) {
      debugPrint('Error ---------- $e');
      return {'Err': e};
    }
  }

  Future<void> createUser(UpdateUserAccountModel userInputParams) async {
    try {
      await Intraction.updateLoggedUserAccount(userInputParams);
    } catch (error) {
      print('Error: $error');
    } finally {
      RequestProcessLoader.stopLoading();
    }
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
      setState(() {
        this.selectedDate = selectedDate;

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
        isNextButtonEnabled = age >= 18;

        // Show Snackbar if age is less than 18
        if (!isNextButtonEnabled) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Must be above 18'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      });
    }
  }

  @override
  void initState() {
    functionStatusData = resetUserInputParams();
    _controller = SingleValueDropDownController();
    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder(
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
              return Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 26.88),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(Icons.arrow_back),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  'Basic Info',
                                  style: TextStyle(
                                    fontFamily: 'SFProDisplay',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 45),
                            GradientTextField(
                              controller: first_name,
                              label: Container(
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                                child: RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'First Name',
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
                              hintText: 'Write your first name',
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Please enter first name';
                              //   }
                              //   return null;
                              // },
                            ),
                            if (firstNameError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  '$firstNameError',
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                            const SizedBox(height: 20),
                            GradientTextField(
                              controller: last_name,
                              label: const Text('Last Name'),
                              hintText: 'Write your last name ',
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Please enter last name';
                              //   }
                              //   return null;
                              // },
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () => _selectDate(context),
                              child: AbsorbPointer(
                                child: TextField(
                                  controller: TextEditingController(
                                    text: selectedDate != null
                                        ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                                        : '',
                                  ),
                                  decoration: InputDecoration(
                                      hintText: 'Date of Birth ',
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffD6D6D6),
                                              width: 2),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      disabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffD6D6D6),
                                              width: 2),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffD6D6D6),
                                              width: 2),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffD6D6D6),
                                              width: 2),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 16.0, horizontal: 14),
                                      suffixIcon: const Icon(
                                        Icons.calendar_month,
                                        color: Colors.grey,
                                      ),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                      label: RichText(
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Date of Birth ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  backgroundColor: Colors.white,
                                                  fontSize: 14),
                                            ),
                                            TextSpan(
                                              text: '*',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize:
                                                      14), // Red asterisk style
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            GradientdropdownTextField(
                                hintText: 'Specify your gender',
                                items: const ['Male', 'Female', 'Other'],
                                initialValue: initial_gender ?? null,
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      selectedGender = value?.value;
                                      debugPrint('$selectedGender');
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
                                          text: 'Gender ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              backgroundColor: Colors.white,
                                              fontSize: 14),
                                        ),
                                        TextSpan(
                                          text: '*',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize:
                                                  14), // Red asterisk style
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                            if (genderError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  '$genderError',
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                // Call the dialog with the currently selected gender
                                _showGenderInfoDialog(selectedGender);
                              },
                              child: Container(
                                height: 56,
                                width: double.infinity,
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 15,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xffD6D6D6), width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      additionalGenderInfo ??
                                          'Add more about gender',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: selectedGender != null
                                            ? Colors
                                                .black // Selected gender in black
                                            : Colors
                                                .grey, // Placeholder in grey
                                      ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Colors.black,
                                      size:
                                          27, // Adjust icon size to match the design
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: GradientdropdownTextField(
                                      hintText: 'Specify your height in feet',
                                      items: const [
                                        '4',
                                        '5',
                                        '6',
                                        '7',
                                        '8',
                                        '9'
                                      ],
                                      initialValue: initialHeight_feet ?? null,
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            height_in_feet = value?.value;
                                            debugPrint('$height_in_feet');
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
                                                    backgroundColor:
                                                        Colors.white,
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
                                      initialValue:
                                          initialHeight_inches ?? null,
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            height_in_inche = value?.value;
                                            debugPrint('$height_in_inche');
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
                                                    backgroundColor:
                                                        Colors.white,
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
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: isNextButtonEnabled
                            ? () async {
                                if (first_name.text.trim().isNotEmpty &&
                                    selectedGender != null) {
                                  RequestProcessLoader.openLoadingDialog();
                                  UpdateUserAccountModel userInputParams =
                                      UpdateUserAccountModel();
                                  userInputParams.updateField('name',
                                      "${first_name.text.trim()} ${last_name.text.trim()}");
                                  if (selectedDate != null) {
                                    userInputParams.updateField(
                                        'dob', selectedDate.toString());
                                  }
                                  userInputParams.updateField(
                                      'gender', selectedGender);
                                  if (height_in_feet != null) {
                                    String height =
                                        '$height_in_feet.$height_in_inche';
                                    userInputParams.updateField(
                                        'height', height);
                                  }

                                  if (additionalGenderInfo != null) {
                                    userInputParams.updateField(
                                        'subgender', additionalGenderInfo);
                                  }

                                  await createUser(userInputParams);

                                  controller.nameController.value.text =
                                      "${first_name.text} ${last_name.text}";
                                  controller.birthdateController.value.text =
                                      "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";
                                  controller.genderController.value.text =
                                      selectedGender!;
                                  controller.selectedGender.value =
                                      selectedGender;

                                  controller.heightController.value.text =
                                      '${height_in_feet ?? initialHeight_feet}.${height_in_inche ?? initialHeight_inches}';
                                  Navigator.pop(context);
                                  controller.birthdateController.refresh();

                                  // Profile Controller updates
                                  profileController.nameController.value.text =
                                      "${first_name.text} ${last_name.text}";

                                  profileController
                                          .pronounsController.value.text =
                                      selectedGender == 'Male'
                                          ? "He/Him"
                                          : selectedGender == 'Female'
                                              ? "She/Her"
                                              : "Other";
                                  profileController.pronounsController
                                      .refresh();
                                } else {
                                  if (first_name.text.trim().isEmpty) {
                                    setState(() {
                                      firstNameError =
                                          "First name can't be empty";
                                    });
                                  } else {
                                    setState(() {
                                      firstNameError = null;
                                    });
                                  }
                                  if (selectedGender == null) {
                                    setState(() {
                                      genderError = 'Gender can’t be empty';
                                    });
                                  } else {
                                    genderError = null;
                                  }
                                }
                              }
                            : null, // Disable button if not eligible
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(400, 50),
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            fontFamily: 'SFProDisplay',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Optional spacing
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
