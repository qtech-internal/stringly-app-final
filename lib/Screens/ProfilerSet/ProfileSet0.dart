import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
// import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stringly/Screens/loaders/custom_text_loader.dart';
import 'package:stringly/Screens/loaders/request_process_loader.dart';
import 'package:stringly/StorageServices/google_bucket_storage.dart';
import 'package:stringly/models/store_image_model.dart';
import 'package:stringly/models/user_input_params.dart';
import '../loaders/message_screen_loader.dart';
import '../share/newcustomimagepicker.dart'; // Ensure this points to the correct picker
import '../UserInfo5.dart'; // Ensure this import points to the correct screen

class ProfileSet0 extends StatefulWidget {
  const ProfileSet0({super.key});

  @override
  _ProfileSet0State createState() => _ProfileSet0State();
}

class _ProfileSet0State extends State<ProfileSet0> {
  List<File?> _selectedImages = List<File?>.filled(4, null);
  int completedSteps = 3;

  UserInputParams userInputParams = UserInputParams();

  /// Opens the CustomImagePicker to select multiple images
  Future<void> _pickImages({int? tappedIndex}) async {
    final List<String>? pickedFiles = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CustomImagePicker()), // Custom Picker
    );

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        if (tappedIndex != null && pickedFiles.length == 1) {
          // Check for duplicates
          if (!_selectedImages.any((image) => image?.path == pickedFiles[0])) {
            // Replace the tapped placeholder with the selected image
            _selectedImages[tappedIndex] = File(pickedFiles[0]);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('You cannot select the same image twice.')),
            );
          }
        } else {
          // Fill the placeholders sequentially with selected images
          int imageIndex = 0;
          for (int i = 0; i < _selectedImages.length; i++) {
            if (_selectedImages[i] == null && imageIndex < pickedFiles.length) {
              // Check for duplicates
              if (!_selectedImages
                  .any((image) => image?.path == pickedFiles[imageIndex])) {
                _selectedImages[i] = File(pickedFiles[imageIndex]);
                imageIndex++;
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('You cannot select the same image twice.')),
                );
              }
            }
          }
        }

        // Update progress steps
        completedSteps =
            _selectedImages.where((image) => image != null).length >= 2 ? 3 : 2;
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages[index] = null;
      completedSteps =
          _selectedImages.where((image) => image != null).length >= 2 ? 3 : 2;
    });
  }

  Future<void> _navigateToUserInfo() async {
    int selectedImageCount =
        _selectedImages.where((image) => image != null).length;
    bool isAnyImageTooLarge = _selectedImages.any(
      (image) => image != null && image!.lengthSync() > 5 * 1024 * 1024,
    );

    if (selectedImageCount < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least 2 photo.')),
      );
      return;
    } else if (isAnyImageTooLarge) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image size must be less than 5MB.')),
      );
      return;
    } else {
      // List<String> imagePaths = await Future.wait(
      //   _selectedImages
      //       .where((image) => image?.path != null) // Ensure image and path are not null
      //       .map((image) async {
      //     // Convert to File
      //     File profileImage = File(image!.path); // Safe because of the null check above
      //     // Read file as bytes
      //     Uint8List imageBytes = await profileImage.readAsBytes();
      //     // Encode bytes to base64
      //     return base64.encode(imageBytes);
      //
      //   })
      //       .toList(),
      // );
      Future<void> processSelectedImages() async {
        StoreImageFile.allSelectFile = await Future.wait(
          _selectedImages
              .where((image) => image?.path != null)
              .map((image) async {
            File profileImage = File(image!.path);
            return profileImage;
          }),
        );
      }

      await processSelectedImages();
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => UserPreferenceScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Progress',
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                              fontSize: 19,
                              color: Color(0xFFD83694),
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 17,
                          width: 17,
                          child: Image.asset('assets/coin2.png'),
                        ),
                        const SizedBox(width: 2),
                        const Text('+1', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          '$completedSteps',
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFFD83694),
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
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: (index <
                                      completedSteps) // Apply continuous gradient to the first 3 boxes
                                  ? LinearGradient(
                                      colors: [
                                        Color.lerp(
                                            const Color(0xFFD83694),
                                            const Color(0xFF0039C7),
                                            index / completedSteps)!,
                                        Color.lerp(
                                            const Color(0xFFD83694),
                                            const Color(0xFF0039C7),
                                            (index + 1) / completedSteps)!,
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
                    Text(
                      'Showcase yourself!',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    if (completedSteps == 2)
                      Column(
                        children: [
                          Text(
                            '2 pictures are compulsory to upload',
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 35),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _pickImages(tappedIndex: index),
                          child: Stack(
                            children: [
                              _selectedImages[index] != null
                                  ? DottedBorder(
                                      //  padding: EdgeInsets.zero,
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(10),
                                      dashPattern: const [4, 3],
                                      color: Colors.black,
                                      strokeWidth: 1.5,
                                      child: Container(
                                        height: 250,
                                        width: 250,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              10), // Match the border radius
                                          child: Image.file(
                                            _selectedImages[index]!,
                                            height: 250,
                                            width: 250,
                                            fit: BoxFit
                                                .cover, // Ensure the image fits the box
                                          ),
                                        ),
                                      ),
                                    )
                                  : DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(10),
                                      dashPattern: const [4, 3],
                                      color: Colors.black,
                                      strokeWidth: 1.5,
                                      child: Container(
                                        height: 250,
                                        width: 250,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            'assets/svg/Group.svg',
                                            width: 30,
                                            height: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                              if (_selectedImages[index] != null)
                                Positioned(
                                  top: 7,
                                  right: 7,
                                  child: GestureDetector(
                                    onTap: () => _removeImage(index),
                                    child: const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.black54,
                                      child: Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () async {
                    await _navigateToUserInfo();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(300, 50),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Set Profile',
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
