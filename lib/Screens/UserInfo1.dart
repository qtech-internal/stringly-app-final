import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import '../Reuseable Widget/GradientWidget.dart';
import '../Reuseable Widget/gradienttextfield.dart';
import '../models/user_input_params.dart';
import 'UserInfo2.dart';

class Userinfo1 extends StatefulWidget {
  @override
  _Userinfo1State createState() => _Userinfo1State();
}

class _Userinfo1State extends State<Userinfo1> {
  final FocusNode _focusNode = FocusNode();
  String? firstNameError;
  String? genderError;
  bool _hasFocus = false;
  TextEditingController first_name = TextEditingController();
  TextEditingController last_name = TextEditingController();
  String? aboutError;
  TextEditingController _bioController = TextEditingController();
  DateTime? selectedDate;
  String? selectedGender;
  String? height_in_feet;
  String? height_in_inche;
  String? additionalGenderInfo;
  final _formKey = GlobalKey<FormState>();
  final SingleValueDropDownController _genderController =
      SingleValueDropDownController();
  bool isNextButtonEnabled =
      false; // Track if the Next button should be enabled

  UserInputParams userInputParams = UserInputParams();

  late SingleValueDropDownController _controller;

  void _showGenderInfoDialog(String? selectedGender) {
    String? tempSelectedOption;

    List<String> options = [];
    if (selectedGender == 'Male') {
      options = [
        'Intersex man',
        'Trans man',
        'Transmasculine',
        'Man and Nonbinary',
        'Cis man',
      ];
    } else if (selectedGender == 'Female') {
      options = [
        'Intersex woman',
        'Trans woman',
        'Transfeminine',
        'Woman and Nonbinary',
        'Cis woman',
      ];
    } else {
      // If 'Other' is selected, you might want to handle it differently
      options = [
        'Agender',
        'Bigender',
        'Genderfluid',
        'Genderqueer',
        'Gender nonconforming',
        'Gender questioning',
        'Gender variant',
        'Intersex',
        'Neutrois'
      ];
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
                  userInputParams.updateField(
                      'additional_gender_info', additionalGenderInfo);
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
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text(
                              'Progress',
                              style: TextStyle(
                                fontFamily: 'SFProDisplay',
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFD83694),
                              ),
                            ),
                            // const Spacer(),
                            // SizedBox(
                            //   height: 20,
                            //   width: 20,
                            //   child: Image.asset('assets/reward.png'),
                            // ),
                            // const Text(
                            //   '+1',
                            //   style: TextStyle(
                            //     fontFamily: 'SFProDisplay',
                            //     fontSize: 14,
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFFD83694), Color(0xFF0039C7)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(
                                Rect.fromLTWH(
                                    0, 0, bounds.width, bounds.height),
                              ),
                              child: const Text(
                                '0',
                                style: TextStyle(
                                  fontFamily: 'SFProDisplay',
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Text(
                              ' of 4 steps completed',
                              style: TextStyle(
                                fontFamily: 'SFProDisplay',
                                fontSize: 18,
                                color: Colors.grey,
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
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[300],
                                  ),
                                ),
                              );
                            })),
                        const SizedBox(height: 26.88),
                        const Text(
                          'Welcome! Let’s start with your vibe!',
                          style: TextStyle(
                            fontFamily: 'SFProDisplay',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 35),
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
                                          color: Color(0xffD6D6D6), width: 2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  disabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xffD6D6D6), width: 2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xffD6D6D6), width: 2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xffD6D6D6), width: 2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  contentPadding: const EdgeInsets.symmetric(
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
                          items: const ['Male', 'Female', 'Non Binary'],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedGender = value?.value;
                                debugPrint('$selectedGender');
                                genderError = null;
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
                                        fontSize: 14), // Red asterisk style
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  additionalGenderInfo ??
                                      'Add more about gender', // Show selected gender or label
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: additionalGenderInfo != null
                                        ? Colors
                                            .black // Selected gender in black
                                        : Colors.black, // Placeholder in grey
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
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: GradientdropdownTextField(
                                  hintText: 'Specify your height in feet',
                                  items: const ['4', '5', '6', '7', '8', '9'],
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
                                    '0',
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
                        const SizedBox(height: 20),
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
                        const SizedBox(height: 60),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: isNextButtonEnabled
                                ? () async {
                                    if (first_name.text.trim().isNotEmpty &&
                                        selectedGender != null &&
                                        _bioController.text.trim().isNotEmpty) {
                                      userInputParams.updateField('name',
                                          "${first_name.text.trim()} ${last_name.text.trim()}");
                                      userInputParams.updateField(
                                          'dob', selectedDate.toString());
                                      userInputParams.updateField(
                                          'gender', selectedGender);
                                      userInputParams.updateField(
                                          'about', _bioController.text);
                                      if (height_in_feet != null) {
                                        String height =
                                            '$height_in_feet.$height_in_inche';
                                        userInputParams.updateField(
                                            'height', height);
                                        if (additionalGenderInfo != null) {
                                          userInputParams.updateField(
                                              'subgender',
                                              additionalGenderInfo);
                                        }
                                      }
                                      print("gender ${additionalGenderInfo}");

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const UserInfo2()),
                                      );
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
                                        setState(() {
                                          genderError = null;
                                        });
                                      }
                                      if (_bioController.text.trim().isEmpty) {
                                        setState(() {
                                          aboutError =
                                              "About me can't be empty";
                                        });
                                      } else {
                                        setState(() {
                                          aboutError = null;
                                        });
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
                              'Next',
                              style: TextStyle(
                                fontFamily: 'SFProDisplay',
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
