import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../share/newcustomimagepicker.dart';
import '../SettingScreen.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _profileImage; // Variable to hold the profile image file

  // Controllers for text fields
  final TextEditingController _twoLinerController = TextEditingController(text: 'Your two-liner here...');
  final TextEditingController _aboutMeController = TextEditingController(text: 'I am a passionate software developer with a focus on mobile app development and a love for Flutter. I am always eager to learn new technologies and improve my skills.');
  final TextEditingController _hobbiesController = TextEditingController(text: 'I enjoy exploring new technologies, traveling, watching movies, and reading books on personal development and business.');
  final TextEditingController _educationController = TextEditingController(text: 'B.Tech in Computer Science and Engineering, XYZ University, 2023. Specializing in software development and mobile application frameworks.');
  final TextEditingController _jobRoleController = TextEditingController(text: 'Flutter Developer Intern at QuadB Technologies, responsible for developing and maintaining mobile applications using Flutter.');

  // Editable states for each text field
  bool _isTwoLinerEditable = false;
  bool _isAboutMeEditable = false;
  bool _isHobbiesEditable = false;
  bool _isEducationEditable = false;
  bool _isJobRoleEditable = false;

  // Function to pick an image from the CustomImagePicker
  Future<void> _pickImage() async {
    final selectedPaths = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CustomImagePicker()),
    );

    if (selectedPaths != null && selectedPaths.isNotEmpty) {
      setState(() {
        _profileImage = File(selectedPaths[0]); // Use the first selected image as the profile picture
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 66,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'SFProDisplay',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
            icon: const Icon(Icons.settings, color: Colors.white, size: 28),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Title
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'SFProDisplay',
                ),
              ),
              const SizedBox(height: 20),

              // Centered Profile Image, Name, and Pronouns
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer Container with Gradient Border
                    Container(
                      width: 130,
                      height: 130,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.purple],
                        ),
                      ),
                      child: Center(
                        // Inner White Circle for padding
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Center(
                            child: ClipOval(
                              child: _profileImage != null
                                  ? Image.file(
                                _profileImage!,
                                width: 110,
                                height: 110,
                                fit: BoxFit.cover,
                              )
                                  : const Image(
                                image: AssetImage('assets/img_1.png'),
                                width: 110,
                                height: 110,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: _pickImage, // Use the updated _pickImage function
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Name and Pronouns
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(text: TextSpan(children: [
                      TextSpan(
                          text: 'John Doe',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500)),
                      TextSpan(
                          text: '(She/Her)',
                          style: TextStyle(
                              color: Colors.black, fontSize: 17)),
                    ])),
                  )
                ],
              ),
              const SizedBox(height: 30),

              // A Two-Liner Section
              const Text(
                'A Two-Liner:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'SFProDisplay',
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _twoLinerController,
                      maxLines: 2,
                      enabled: _isTwoLinerEditable,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontFamily: 'SFProDisplay',
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isTwoLinerEditable = !_isTwoLinerEditable;
                      });
                    },
                    child: Image.asset(
                      'assets/pencil.png', // Replace icon with asset image
                      width: 24,
                      height: 24,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.grey[300], thickness: 1),

              const SizedBox(height: 10),

              // About Me Section
              const Text(
                'About Me:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'SFProDisplay',
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _aboutMeController,
                      maxLines: 3,
                      enabled: _isAboutMeEditable,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontFamily: 'SFProDisplay',
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isAboutMeEditable = !_isAboutMeEditable;
                      });
                    },
                    child: Image.asset(
                      'assets/pencil.png', // Replace icon with asset image
                      width: 24,
                      height: 24,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.grey[300], thickness: 1),

              const SizedBox(height: 10),

              // Hobbies and Interests Section
              const Text(
                'Hobbies and Interests:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'SFProDisplay',
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _hobbiesController,
                      maxLines: 3,
                      enabled: _isHobbiesEditable,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontFamily: 'SFProDisplay',
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isHobbiesEditable = !_isHobbiesEditable;
                      });
                    },
                    child: Image.asset(
                      'assets/pencil.png', // Replace icon with asset image
                      width: 24,
                      height: 24,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.grey[300], thickness: 1),

              const SizedBox(height: 10),

              // Education Section
              const Text(
                'Education:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'SFProDisplay',
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _educationController,
                      maxLines: 3,
                      enabled: _isEducationEditable,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontFamily: 'SFProDisplay',
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isEducationEditable = !_isEducationEditable;
                      });
                    },
                    child: Image.asset(
                      'assets/pencil.png', // Replace icon with asset image
                      width: 24,
                      height: 24,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.grey[300], thickness: 1),

              const SizedBox(height: 10),

              // Job Role Section
              const Text(
                'Job Role:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'SFProDisplay',
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _jobRoleController,
                      maxLines: 3,
                      enabled: _isJobRoleEditable,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontFamily: 'SFProDisplay',
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isJobRoleEditable = !_isJobRoleEditable;
                      });
                    },
                    child: Image.asset(
                      'assets/pencil.png', // Replace icon with asset image
                      width: 24,
                      height: 24,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.grey[300], thickness: 1),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
