import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:stringly/Screens/loaders/request_process_loader.dart';
import 'package:stringly/Screens/share/loading-screen2.dart';
import 'package:stringly/integration.dart';
import 'package:stringly/intraction.dart';
import 'package:stringly/models/store_image_model.dart';
import 'package:stringly/models/user_input_params.dart';

import '../../Reuseable Widget/GradientWidget.dart';
import '../../Reuseable Widget/gradienttextfield.dart';
import '../HobbyScreen.dart';
import '../mainScreenNav.dart';
import '../share/loadinscreen.dart';

class BioEditScreen extends StatefulWidget {
  @override
  _BioEditScreenState createState() => _BioEditScreenState();
}

class _BioEditScreenState extends State<BioEditScreen> {
  String? aboutError;
  UserInputParams userInputParams = UserInputParams();
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

  TextEditingController educationControllerBio = TextEditingController();

  List<String> selectedHobbies = [];

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _initiateSomeField();
    super.initState();
  }

  void _initiateSomeField() {
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
        educationControllerBio.text = userInputParams.education.toString();
      }
      _educationController = userInputParams.education ?? '';
      _instituteNameController.text = userInputParams.instituteName ?? '';
      if (userInputParams.graduationYear != null) {
        _graduationYearController = userInputParams.graduationYear.toString();
      }
      _jobTitleOccupationController.text = userInputParams.jobTitle ?? '';
      _companyNameController.text = userInputParams.company ?? '';
      _jobRoleController.text = userInputParams.jobRole ?? '';
    });
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
      body: SingleChildScrollView(
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
                  const SizedBox(height: 20),

                  // Hobbies & Interests Field
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HobbiesScreen()),
                      );
                      if (result != null &&
                          result is Map<String, List<String>>) {
                        setState(() {
                          selectedHobbies = result['selectedHobbies'] ?? [];
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
                            color: const Color(0xffD6D6D6),
                            width: 2), // Add grey border here
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              'Hobbies & Interests',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
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

                  if(selectedHobbies.isNotEmpty)  const SizedBox(
                    height: 20,
                  ),
                  // Display selected hobbies
                  if(selectedHobbies.isNotEmpty)   Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: selectedHobbies
                          .map(
                            (hobby) => Chip(
                              label: Text(hobby),
                              deleteIcon: Icon(Icons.close),
                              onDeleted: () {
                                setState(() {
                                  selectedHobbies.remove(hobby);
                                });
                              },
                              backgroundColor:
                                  Colors.grey[300], // Grey fill color
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: const BorderSide(
                                      color:
                                          Colors.transparent) // Rounded corners
                                  ),
                            ),
                          )
                          .toList(),
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
                      controller: educationControllerBio,
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
                            setState(() {
                              isProcessing = true;
                              aboutError = null;
                            });

                            RequestProcessLoader.openLoadingDialog();
                            await Future.delayed(Duration.zero);

                            userInputParams.updateField(
                                'hobbies', selectedHobbies);
                            if (yourMainProfession.text.isNotEmpty) {
                              userInputParams.updateField(
                                  'profession', yourMainProfession.text);
                            }
                            if (educationControllerBio.text.trim().isNotEmpty) {
                              userInputParams.updateField(
                                  'education', educationControllerBio.text.trim());
                            }
                            userInputParams.updateField(
                                'instituteName', _instituteNameController.text);
                            if (_graduationYearController != null) {
                              userInputParams.updateField('graduationYear',
                                  int.tryParse(_graduationYearController!));
                            }
                            userInputParams.updateField(
                                'jobTitle', _jobTitleOccupationController.text);
                            userInputParams.updateField(
                                'company', _companyNameController.text);
                            userInputParams.updateField(
                                'jobRole', _jobRoleController.text);

                            Future<void> createUser() async {
                              try {
                                if (StoreImageFile.getAllImages().isNotEmpty) {
                                  await GetImageUrlOfUploadFile.imageUrlFiles();
                                }
                                await Intraction.createAnUser(userInputParams);
                              } catch (error) {
                                print('Error: $error');
                              } finally {
                                RequestProcessLoader.stopLoading();
                              }
                            }

                            await createUser();

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => Mainscreennav()),
                            );
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
            ],
          ),
        ),
      ),
    );
  }
}
