import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:dropdown_textfield/dropdown_textfield.dart'; // Import the dropdown_textfield package
import 'package:stringly/Reuseable%20Widget/multi_gradient_dropdown.dart';
import 'package:stringly/models/user_input_params.dart';

import '../Reuseable Widget/GradientWidget.dart';
import '../Reuseable Widget/gradienttextfield.dart';
import '../googleMap/get_location.dart';
import 'MapScreen.dart';
import 'ProfilerSet/ProfileSet0.dart';
import 'UserInfo2.dart'; // Ensure correct import

class UserInfo3 extends StatefulWidget {
  const UserInfo3({super.key});

  @override
  _UserInfo3State createState() => _UserInfo3State();
}

class _UserInfo3State extends State<UserInfo3> {
  // Variables to hold the selected values
  String? address;
  String addLocationSnippet = 'Add your location';
  String? politicalViews;
  String? familyPlans;
  String? drinkPreference;
  String? smokePreference;
  List<String>? _lookingForItems;
  TextEditingController locationController = TextEditingController();
  TextEditingController what_you_looking_exactly = TextEditingController();
  UserInputParams userInputParams = UserInputParams();

  // Dropdown values for each question
  List<String> politicalViewsItems = [
    'Conservative',
    'Liberal',
    'Neutral',
    'Prefer Not to Say'
  ];
  List<String> familyPlansItems = ['Yes', 'No', 'Prefer Not to Say'];
  List<String> drinkItems = ['Yes', 'No', 'Occasionally', 'Prefer Not to Say'];
  List<String> smokeItems = ['Yes', 'No', 'Occasionally', 'Prefer Not to Say'];

  final SingleValueDropDownController _politicalViewsController =
      SingleValueDropDownController();
  final SingleValueDropDownController _familyPlansController =
      SingleValueDropDownController();
  final SingleValueDropDownController _drinkPreferenceController =
      SingleValueDropDownController();
  final SingleValueDropDownController _smokePreferenceController =
      SingleValueDropDownController();

  String? initialPoliticalViewValue;
  String? initialFamilyValue;
  String? initialDrinkValue;
  String? initialSmokePreferenceValue;

  @override
  void initState() {
    super.initState();
    _loadSavedValues();
  }

  Future<void> _loadSavedValues() async {
    setState(() {
      if (userInputParams.politicalViews != null) {
        _politicalViewsController.setDropDown(
          DropDownValueModel(
              name: userInputParams.politicalViews!,
              value: userInputParams.politicalViews),
        );
      }
      if (userInputParams.familyPlans != null) {
        _familyPlansController.setDropDown(
          DropDownValueModel(
              name: userInputParams.familyPlans!,
              value: userInputParams.familyPlans),
        );
      }
      if (userInputParams.drinking != null) {
        _drinkPreferenceController.setDropDown(
          DropDownValueModel(
              name: userInputParams.drinking!, value: userInputParams.drinking),
        );
      }
      if (userInputParams.smoking != null) {
        _smokePreferenceController.setDropDown(
          DropDownValueModel(
              name: userInputParams.smoking!, value: userInputParams.smoking),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            // Wrap the body with SingleChildScrollView
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gradient "Progress" text
                Row(
                  children: [
                    Text(
                      'Progress',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          fontSize: 19,
                          color: Color(
                              0xFFD83694), // The color is overridden by the gradient
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProfileSet0()));
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                // Progress Indicator Text
                Row(
                  children: [
                    Row(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFFD83694), Color(0xFF0039C7)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                          child: Text(
                            '2',
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                fontSize: 18,
                                color: Colors.white, // Overridden by gradient
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      ' of 4 steps completed',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(4, (index) {
                    return Expanded(
                      child: Container(
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: (index == 1 ||
                                  index ==
                                      0) // Apply continuous gradient to the first 3 boxes
                              ? LinearGradient(
                                  colors: [
                                    Color.lerp(const Color(0xFFD83694),
                                        const Color(0xFF0039C7), index / 1)!,
                                    Color.lerp(
                                        const Color(0xFFD83694),
                                        const Color(0xFF0039C7),
                                        (index + 1) / 1)!,
                                  ],
                                )
                              : LinearGradient(
                                  colors: [
                                    Colors.grey[300]!,
                                    Colors.grey[300]!
                                  ], // Grey for the last box
                                ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 26.88),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tell us your life’s playlist!',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 17,
                          width: 17,
                          child: Image.asset('assets/coin2.png'),
                        ),
                        const SizedBox(width: 2),
                        const Text(
                          '+1',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 35),

                MultiSelectGradientDropdown(
                  onChanged: (values) {
                    setState(() {
                      _lookingForItems = values;
                      what_you_looking_exactly.text = values.join(", ");
                    });
                    print(_lookingForItems);
                  },
                ),

                const SizedBox(height: 20),

                // Political Views question with DropDownTextField
                GradientdropdownTextField(
                  key: const Key('select your political '),
                  hintText: 'Select your political views',
                  initialValue: initialPoliticalViewValue ?? null,
                  items: politicalViewsItems,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        politicalViews = value?.value;
                      });
                    }
                  },
                  label: const Text('What are your political views?'),
                ),
                const SizedBox(height: 20),

                // Family Plans question with DropDownTextField
                GradientdropdownTextField(
                  key: Key('select your family plans'),
                  hintText: 'Select your family plans',
                  initialValue: initialFamilyValue ?? null,
                  items: familyPlansItems,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        familyPlans = value?.value;
                      });
                    }
                  },
                  label: const Text('What are your family plans?'),
                ),
                const SizedBox(height: 20),

                // Drink preference question with DropDownTextField
                GradientdropdownTextField(
                  key: Key('select drink preference'),
                  hintText: 'Select your drink preference',
                  initialValue: initialDrinkValue ?? null,
                  items: drinkItems,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        drinkPreference = value?.value;
                      });
                    }
                  },
                  label: const Text('Do you like to drink?'),
                ),
                const SizedBox(height: 20),

                // Smoke preference question with DropDownTextField
                GradientdropdownTextField(
                  key: Key('select-smoke-preference'),
                  hintText: 'Select your smoke preference',
                  initialValue: initialSmokePreferenceValue ?? null,
                  items: smokeItems,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        smokePreference = value?.value;
                      });
                    }
                  },
                  label: const Text('Do you like to smoke?'),
                ),
                const SizedBox(height: 20),

                // "Add Location" styled like a text field but behaves as a button
                InkWell(
                  onTap: () async {
                    if (politicalViews != null) {
                      userInputParams.updateField(
                          'politicalViews', politicalViews);
                    }

                    if (familyPlans != null) {
                      userInputParams.updateField('familyPlans', familyPlans);
                    }

                    if (drinkPreference != null) {
                      userInputParams.updateField('drinking', drinkPreference);
                    }

                    if (smokePreference != null) {
                      userInputParams.updateField('smoking', smokePreference);
                    }

                    if (what_you_looking_exactly.text.isNotEmpty) {
                      userInputParams.updateField(
                          'lookingFor', what_you_looking_exactly.text);
                    }

                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MapScreen()), // Ensure MapScreen is correctly implemented
                    );

                    setState(() {
                      UserInputParams userInput = UserInputParams();
                      address =
                          '${userInput.locationCity}, ${userInput.locationState},  ${userInput.locationCountry},';
                      addLocationSnippet = 'Edit your location';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: const Color(0xffD6D6D6), width: 2),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.my_location_rounded, color: Colors.black),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            addLocationSnippet,
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, color: Colors.black),
                      ],
                    ),
                  ),
                ),
                if (address != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('$address'),
                  ),

                const SizedBox(height: 50), // Add space for buttons

                // "Next" button
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 50),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Back',
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            if (politicalViews != null) {
                              userInputParams.updateField(
                                  'politicalViews', politicalViews);
                            }
                            if (familyPlans != null) {
                              userInputParams.updateField(
                                  'familyPlans', familyPlans);
                            }
                            if (drinkPreference != null) {
                              userInputParams.updateField(
                                  'drinking', drinkPreference);
                            }

                            if (smokePreference != null) {
                              userInputParams.updateField(
                                  'smoking', smokePreference);
                            }

                            if (what_you_looking_exactly.text.isNotEmpty) {
                              userInputParams.updateField(
                                  'lookingFor', what_you_looking_exactly.text);
                            }
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProfileSet0()));
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 50),
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Next',
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
