import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import to use File
import 'package:dotted_border/dotted_border.dart';
import 'package:stringly/StorageServices/google_bucket_storage.dart';
import 'package:stringly/constants/globals.dart';
import 'package:stringly/integration.dart';
import 'package:stringly/models/image_field_url_to_update.dart';
import 'package:stringly/models/store_image_model.dart';
import 'package:stringly/models/user_input_params.dart';

import '../../intraction.dart';
import '../loaders/request_process_loader.dart';
import '../mainScreenNav.dart';
import '../share/newcustomimagepicker.dart';
import 'BioEdit.dart'; // Import the dotted_border package

class ImageBioScreen extends StatefulWidget {
  @override
  _ImageBioScreenState createState() => _ImageBioScreenState();
}

class _ImageBioScreenState extends State<ImageBioScreen> {
  UserInputParams userInputParams = UserInputParams();

  List<String> enteredHobbies = [];
  TextEditingController _hobbyController = TextEditingController();

  // List to hold selected image paths
  List<File> selectedImages = [];
  List allCombinedImages = [];

  Future<void> showSelectedProfileImageHere() async {
    setState(() {
      if (StoreImageFile.allSelectFile.length >= 1) {
        selectedImages = StoreImageFile.getAllImages();
      }
    });
  }

  Future<void> _processSelectedImages() async {
    StoreImageFile.allSelectFile = await Future.wait(
      selectedImages.where((image) => image?.path != null).map((image) async {
        File profileImage = File(image!.path);
        return profileImage;
      }),
    );
  }

  @override
  void initState() {
    _initializeAll();
    super.initState();
  }

  Future<void> _initializeAll() async {
    await showSelectedProfileImageHere();
    await _allImagesToShow();
  }

  // Function to pick an image from the gallery
  Future<void> _openImagePicker() async {
    if (selectedImages.length >= 4) {
      // Show a message if the user tries to add more than 4 images
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You can only add up to 4 images.')),
      );
      return;
    }

    final List<String> imagePaths = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CustomImagePicker()),
    );

    if (imagePaths.isNotEmpty) {
      setState(() {
        // Ensure no more than 4 images are added
        final remainingSlots = 4 - selectedImages.length;
        List<File> newImages = imagePaths
            .map((path) => File(path))
            .where(
                (file) => !selectedImages.contains(file)) // Exclude duplicates
            .take(remainingSlots) // Respect the remaining slots limit
            .toList();
        selectedImages.addAll(newImages);
        allCombinedImages.addAll(newImages);
      });
    }
  }

  void _addHobby(String hobby) {
    if (hobby.isNotEmpty && !enteredHobbies.contains(hobby)) {
      setState(() {
        enteredHobbies.add(hobby);
        _hobbyController.clear();
      });
    }
  }

  void _removeHobby(String hobby) {
    setState(() {
      enteredHobbies.remove(hobby);
    });
  }

  Future<void> _allImagesToShow() async {
    setState(() {
      allCombinedImages = [
        ...ImageFieldUrlToUpdate.allNetworkImages,
        ...selectedImages,
      ];
    });
  }

  Map<int, bool> iconState = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 50, left: 16, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Image',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 35),

              // Dotted border container for images
              GestureDetector(
                onTap: _openImagePicker, // Open the custom image picker on tap
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (allCombinedImages.length < 4)
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(10),
                            color: const Color(0xFFE5E5E5),
                            strokeWidth: 2,
                            dashPattern: const [
                              3,
                              3
                            ], // Adjust these values for stroke length and gap
                            child: Container(
                              width: 90, // Updated width
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[
                                    100], // Set the background color to grey
                              ),
                              child: Center(
                                child: Container(
                                  width:
                                      33, // Set the width of the circular button
                                  height:
                                      33, // Set the height of the circular button
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(
                                        0xFFA3A3A3), // Set the circle color to dark grey
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.add,
                                      size: 30, // Size of the "+" icon
                                      color: Colors
                                          .white, // Change the icon color to white
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      for (int i = 0; i < allCombinedImages.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Stack(
                            children: [
                              // Image container
                              Container(
                                width: 90,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: allCombinedImages[i] is String
                                      ? Image.network(
                                          allCombinedImages[i],
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          allCombinedImages[i],
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              if (iconState[i] == true)
                                Positioned(
                                    top: 30,
                                    right: 35,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          allCombinedImages.removeAt(i);
                                          iconState.remove(i);
                                        });
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: const Center(
                                            child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 20,
                                        )),
                                      ),
                                    )),
                              if (iconState[i] != true)
                                Positioned(
                                    bottom: 0,
                                    right: 20,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          iconState[i] =
                                              true; // Show the center icon
                                        });
                                      },
                                      child: Container(
                                        height: 15,
                                        width: 50,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(5),
                                                topLeft: Radius.circular(5))),
                                        child: const Image(
                                          image: AssetImage(
                                              'assets/image_delete_action.png'),
                                        ),
                                      ),
                                    ))
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
              // Closing DottedBorder

              const SizedBox(height: 41),

              // Bio Section
              // Bio Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bio',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  // RichText for Edit with Icon
                  GestureDetector(
                    onTap: () async {
                      await _processSelectedImages();
                      if (!GlobalConstant.checkUserProfileCreateOrNot) {
                        if (StoreImageFile.allSelectFile.length < 2) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please Select At Least Two Photos",
                                style: TextStyle(
                                    fontSize:
                                        16), // Optional: Customize text size
                              ),
                              duration: Duration(
                                  seconds: 3), // Duration to show the SnackBar
                              backgroundColor: Colors
                                  .black, // Optional: Change background color
                            ),
                          );
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BioEditScreen()));
                        }
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BioEditScreen()));
                      }
                    },
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(Icons.edit,
                                size: 16, color: Colors.grey), // Pencil icon
                          ),
                          TextSpan(
                            text: ' Edit',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey, // Set the text color to grey
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 30,
              ),
              _buildBioField(
                  'Hobbies & Interests',
                  userInputParams.hobbies != null
                      ? userInputParams.hobbies!.join(', ')
                      : 'Hobbies and Interest'),
              const SizedBox(
                height: 20,
              ),
              _buildBioField(
                  'Profession', userInputParams.profession ?? 'Profession'),
              const SizedBox(
                height: 20,
              ),
              _buildBioField(
                  'Education', userInputParams.education ?? 'Education'),
              const SizedBox(
                height: 20,
              ),
              _buildBioField('Institute\'s name',
                  userInputParams.instituteName ?? 'Institute\'s name'),
              SizedBox(
                height: 20,
              ),
              _buildBioField(
                  'Graduation Year',
                  userInputParams.graduationYear != null
                      ? userInputParams.graduationYear.toString()
                      : 'Graduation Year'),
              SizedBox(
                height: 20,
              ),
              _buildBioField('Job Role', userInputParams.jobRole ?? 'Job Role'),
              SizedBox(
                height: 20,
              ),
              _buildBioField('Company\'s name',
                  userInputParams.company ?? 'Company\'s name'),
              const SizedBox(height: 50),

              // Next Button
              Center(
                child: SizedBox(
                  height: 50,
                  width: 350,
                  child: ElevatedButton(
                    onPressed: () async {
                      RequestProcessLoader.openLoadingDialog();
                      await _processSelectedImages();
                      if (!GlobalConstant.checkUserProfileCreateOrNot) {
                        if (StoreImageFile.allSelectFile.length < 2) {
                          RequestProcessLoader.stopLoading();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please Select At Least Two Photos",
                                style: TextStyle(
                                    fontSize:
                                        16), // Optional: Customize text size
                              ),
                              duration: Duration(
                                  seconds: 3), // Duration to show the SnackBar
                              backgroundColor: Colors
                                  .black, // Optional: Change background color
                            ),
                          );
                        } else {
                          await GetImageUrlOfUploadFile.imageUrlFiles();
                          await Intraction.createAnUser(userInputParams);
                          RequestProcessLoader.stopLoading();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Mainscreennav()));
                        }
                      } else {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => BioEditScreen()));
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
                        fontSize: 15,
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

  Widget _buildBioField(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          content,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildHobbiesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hobbies & Interests',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _hobbyController,
                decoration: InputDecoration(
                  hintText: 'Enter hobby',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onSubmitted: (value) {
                  _addHobby(value);
                },
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _addHobby(_hobbyController.text);
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: enteredHobbies.map((hobby) {
            return Chip(
              label: Text(hobby),
              backgroundColor: Colors.black,
              labelStyle: const TextStyle(color: Colors.white),
              deleteIcon: const Icon(
                Icons.close,
                size: 18,
                color: Colors.white,
              ),
              onDeleted: () {
                _removeHobby(hobby);
              },
            );
          }).toList(),
        ),
        const Divider(),
      ],
    );
  }
}
