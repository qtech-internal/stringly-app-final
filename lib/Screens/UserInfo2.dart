import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:stringly/Screens/videoRecScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stringly/integration.dart';

import '../Reuseable Widget/GradientWidget.dart';
import '../Reuseable Widget/gradienttextfield.dart';
import '../models/user_input_params.dart';
import 'UserInfo2.1.dart';
import 'UserInfo3.dart'; // Import your overlay dialog file

class UserInfo2 extends StatefulWidget {
  const UserInfo2({super.key});

  @override
  _UserInfo2State createState() => _UserInfo2State();
}

class _UserInfo2State extends State<UserInfo2> {
  String? education;
  TextEditingController educationController = TextEditingController();
  TextEditingController instituteName = TextEditingController();
  String? graduationYear;
  TextEditingController occupation = TextEditingController();
  TextEditingController company_nmae = TextEditingController();
  String? youLikeNetworkWith;

  List<String> youLikeNetworkWithItems = [
    'Male',
    'Female',
    'Other',
    'Prefer Not to Say'
  ];

  final SingleValueDropDownController _youLikeNetworkWithController =
      SingleValueDropDownController();

  UserInputParams userInputParams = UserInputParams();
  void _navigateToNextScreen(BuildContext context) {
    // Show the overlay dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Overlay25(); // Show your overlay dialog
      },
    );
  }

  List<String> getYearList() {
    final currentYear = DateTime.now().year;
    const startYear = 1980;
    final endYear = currentYear + 5;
    return List.generate(
        endYear - startYear + 1, (index) => (startYear + index).toString());
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
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Your top content goes here
                        Row(
                          children: [
                            Text(
                              'Progress',
                              style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                  fontSize: 19,
                                  color: Color(0xFFD83694),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                _navigateToNextScreen(context);
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
                              child: Text(
                                '1',
                                style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
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
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: index == 0
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0xFFD83694),
                                            Color(0xFF0039C7)
                                          ],
                                        )
                                      : LinearGradient(
                                          colors: [
                                            Colors.grey[300]!,
                                            Colors.grey[300]!,
                                          ],
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
                              'Craft your pro vibe',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset('assets/reward.png'),
                                ),
                                const Text(
                                  '+1',
                                  style: TextStyle(
                                    fontFamily: 'SFProDisplay',
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 35),

                        // Your input fields go here
                        // GradientdropdownTextField(
                        //   hintText: 'Specify your highest education',
                        //   items: const [
                        //     'Post Graduate',
                        //     'Graduate',
                        //     'In College',
                        //     'Prefer Not To Say'
                        //   ],
                        //   onChanged: (value) {
                        //     if (value != null) {
                        //       setState(() {
                        //         education = value?.value;
                        //         debugPrint('$education');
                        //       });
                        //     }
                        //   },
                        //   label: const Text('Education'),
                        // ),

                        GradientTextField(
                            controller: educationController,
                            hintText: 'Specify your education',
                            label: const Text('Education')),
                        const SizedBox(height: 20),

                        GradientTextField(
                            controller: instituteName,
                            hintText: 'Institute \'s Name',
                            label: const Text('Institute \'s Name')),
                        const SizedBox(height: 20),
                        GradientdropdownTextField(
                          hintText: 'Specify your graduation year',
                          items: getYearList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                graduationYear = value?.value;
                                debugPrint('$graduationYear');
                              });
                            }
                          },
                          label: const Text('Graduation Year'),
                        ),
                        const SizedBox(height: 20),
                        GradientTextField(
                            controller: occupation,
                            label: const Text('Job title/Occupation'),
                            hintText: 'Job title / Occupation'),
                        const SizedBox(height: 20),
                        GradientTextField(
                          controller: company_nmae,
                          hintText: 'Company Name',
                          label: const Text('Company Name'),
                        ),
                        const SizedBox(height: 20),
                        GradientdropdownTextField(
                          hintText: 'Specify your preference',
                          items: const ['Men', 'Women', 'Other'],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                youLikeNetworkWith = value?.value;
                                debugPrint('$youLikeNetworkWith');
                              });
                            }
                          },
                          label:
                              const Text('Who would you like to network with'),
                        ),
                        const SizedBox(height: 50),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
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
                              ElevatedButton(
                                onPressed: () {
                                  if (educationController.text
                                      .trim()
                                      .isNotEmpty) {
                                    userInputParams.updateField('education',
                                        educationController.text.trim());
                                  }
                                  userInputParams.updateField(
                                      'instituteName', instituteName.text);
                                  if (graduationYear != null) {
                                    userInputParams.updateField(
                                        'graduationYear',
                                        int.tryParse(graduationYear!));
                                  }
                                  userInputParams.updateField(
                                      'jobTitle', occupation.text);
                                  userInputParams.updateField(
                                      'company', company_nmae.text);
                                  userInputParams.updateField(
                                      'likeToNetwork', youLikeNetworkWith);
                                  _navigateToNextScreen(context);
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Align the buttons at the bottom
            ],
          ),
        ),
      ),
    );
  }
}

// class overlay extends StatefulWidget {
//   const overlay({super.key});

//   @override
//   State<overlay> createState() => _overlayState();
// }

// class _overlayState extends State<overlay> {
//   @override
//   Widget build(BuildContext context) {
    // return Dialog(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(12),
    //   ),
    //   backgroundColor:
    //       Colors.transparent, // Set to transparent for gradient border
    //   child: Container(
    //     decoration: BoxDecoration(
    //       gradient: const LinearGradient(
    //         colors: [Color(0xFFD83694), Color(0xFF0039C7)],
    //         end: Alignment.topRight,
    //         begin: Alignment.bottomLeft,
    //       ),
    //       borderRadius: BorderRadius.circular(12),
    //     ),
    //     padding:
    //         const EdgeInsets.all(3), // Padding for gradient border thickness
    //     child: Container(
    //       decoration: BoxDecoration(
    //         color: Colors.white, // Inner container color
    //         borderRadius: BorderRadius.circular(12),
    //       ),
    //       height: 309,
    //       width: 275,
    //       child: SingleChildScrollView(
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             // Close button
    //             Padding(
    //               padding: const EdgeInsets.only(
    //                 left: 8.0,
    //               ),
    //               child: Align(
    //                 alignment: Alignment.topRight,
    //                 child: IconButton(
    //                   icon: Container(
    //                     decoration: const BoxDecoration(
    //                       shape: BoxShape.circle,
    //                       // color: Colors.red, // Background color for the close button
    //                     ),
    //                     child: const Icon(
    //                       Icons.close,
    //                       color: Colors.grey,
    //                       size: 14,
    //                     ),
    //                   ),
    //                   onPressed: () {
    //                     Navigator.of(context).pop(); // Close the dialog
    //                   },
    //                 ),
    //               ),
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.only(
    //                   top: 5, left: 16, right: 16, bottom: 16),
    //               child: Column(
    //                 children: [
    //                   const SizedBox(height: 20),
    //                   const Text(
    //                     'Proof of Humanity',
    //                     style: TextStyle(
    //                       fontSize: 20,
    //                       fontWeight: FontWeight.bold,
    //                       color: Colors.black,
    //                     ),
    //                   ),
    //                   const SizedBox(height: 16),
    //                   const Text(
    //                     'You have not submitted your Proof of Humanity. Please do so now.',
    //                     textAlign: TextAlign.center,
    //                     style: TextStyle(
    //                       fontSize: 14,
    //                       color: Colors.black,
    //                     ),
    //                   ),
    //                   const SizedBox(height: 50),
    //                   Container(
    //                     width: 200,
    //                     child: ElevatedButton(
    //                       onPressed: () {
    //                        _re
    //                       },
    //                       style: ElevatedButton.styleFrom(
    //                         backgroundColor: Colors.black,
    //                         shape: RoundedRectangleBorder(
    //                           borderRadius: BorderRadius.circular(8),
    //                         ),
    //                       ),
    //                       child: const Text(
    //                         'Continue',
    //                         style: TextStyle(color: Colors.white),
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
//   }
// }
