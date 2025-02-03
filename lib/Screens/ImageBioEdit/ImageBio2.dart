import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import to use File
import 'package:dotted_border/dotted_border.dart';

import 'BioEdit.dart'; // Import the dotted_border package

class ImageBio2 extends StatefulWidget {
  @override
  _ImageBio2State createState() => _ImageBio2State();
}

class _ImageBio2State extends State<ImageBio2> {
  // List to hold selected image paths
  List<File> selectedImages = [];

  // Predefined list of hobbies
  List<String> predefinedHobbies = [
    'Reading',
    'Traveling',
    'Cooking',
    'Sports'
  ];
  List<String> enteredHobbies = [];

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    if (selectedImages.length < 4) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          selectedImages.add(File(image.path));
        });
      }
    } else {
      // Optional: Show a message if the limit is reached
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You can only select up to 4 images.')),
      );
    }
  }

  void _removeHobby(String hobby) {
    setState(() {
      enteredHobbies.remove(hobby);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Image',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(10),
                color: Colors.grey,
                strokeWidth: 2,
                child: Container(
                  height: 200,
                  color: Colors.grey[100],
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      // First Image
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          width: 100,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/img_2.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      // Second Image with Blur Effect
                      // Second Image with Blur Effect
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Stack(
                          children: [
                            // Blurred Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 200.0, sigmaY: 200.0),
                                child: Container(
                                  width: 100,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.grey
                                        .withOpacity(0.3), // Slightly tinted
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.asset(
                                    'assets/img_1.png',
                                    fit: BoxFit.cover,
                                    color: Colors.black
                                        .withOpacity(0.2), // Optional tint
                                    colorBlendMode: BlendMode.darken,
                                  ),
                                ),
                              ),
                            ),
                            // Stacked Image with reduced size
                            Positioned(
                              left:
                                  10, // Centering horizontally (adjust as needed)
                              top:
                                  50, // Centering vertically (adjust as needed)
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'assets/Group2.png',
                                  width: 80, // Reduced width
                                  height: 30, // Reduced height
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Images from the selectedImages list
                      for (var image in selectedImages)
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            width: 100,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                      // Add image button
                      GestureDetector(
                        onTap: _pickImage,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: Radius.circular(10),
                          color: Colors.grey,
                          strokeWidth: 2,
                          child: Container(
                            width: 100,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[100],
                            ),
                            child: Center(
                              child: Container(
                                width: 33,
                                height: 33,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[600],
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
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BioEditScreen()));
                    },
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const WidgetSpan(
                            child:
                                Icon(Icons.edit, size: 20, color: Colors.grey),
                          ),
                          const TextSpan(
                            text: ' Edit',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              _buildHobbiesField(),
              const SizedBox(height: 20),
              _buildBioField('Education',
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed'),
              const SizedBox(height: 20),
              _buildBioField('Job Role',
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed'),
              const SizedBox(height: 70),
              Center(
                child: SizedBox(
                  height: 50,
                  width: 350,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BioEditScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 20,
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 2,
          color: Colors.grey,
        ),
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
        Wrap(
          spacing: 8.0,
          children: predefinedHobbies.map((hobby) {
            return Chip(
              label: Text(hobby),
              deleteIcon: const Icon(Icons.cancel, size: 16), // Delete icon
              onDeleted: () => _removeHobby(hobby), // Remove hobby on delete
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
