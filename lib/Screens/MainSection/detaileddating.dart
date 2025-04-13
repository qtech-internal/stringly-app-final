import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stringly/GetxControllerAndBindings/controllers/report/report_controller.dart';
import 'package:stringly/Screens/FAQ%20Qusetions/Repor.dart';
import 'package:stringly/Screens/loaders/request_process_loader.dart';
import 'package:stringly/Screens/loaders/simple_loader.dart';
import 'package:stringly/Screens/report/new-report-style-in-bottom-sheet.dart';

import '../../Reuseable Widget/ImageOverlay.dart';
import '../../intraction.dart';
import '../../models/user_profile_params_model.dart';
import '../mainScreenNav.dart';

class DetailedDating extends StatefulWidget {
  DetailedDating({Key? key, required this.data, required this.userId})
      : super(key: key);
  userProfileParamsModel data;
  String userId;

  @override
  State<DetailedDating> createState() => _DetailedDatingState();
}

class _DetailedDatingState extends State<DetailedDating> {
  final List<String> images = [];
  final ReportController reportController = Get.put(ReportController());

  Future<void> _hideUserFunctionDating() async {
    try {
      RequestProcessLoader.openLoadingDialog();
      await Intraction.hideUser(receiverId: widget.userId);
      RequestProcessLoader.stopLoading();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) =>
                Mainscreennav()), // Replace LoginScreen with your login page widget.
        (Route<dynamic> route) => false, // Remove all the previous routes.
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _handleMenuItemClick(BuildContext context, String value) async {
    if (value == 'report') {
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (_) => ReportIssueScreen()));
      showReportBottomSheet(context, userId: widget.userId);
    } else if (value == 'hide') {
      await _hideUserFunctionDating();
    }
  }

  void _addImage() {
    // for(int i = 0; i < data.images!.length; i++) {
    //   String singleImage = data.images![0];
    //   images.add(singleImage);
    // }
    widget.data.images?.forEach((image) {
      images.add(image);
    });
  }

  int _calculateAge(String dob) {
    try {
      final birthDate = DateTime.parse(dob);
      final today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    _addImage();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          PopupMenuButton<String>(
            key: UniqueKey(),
            onSelected: (value) => _handleMenuItemClick(context, value),
            icon: const Icon(Icons.more_vert),
            offset: const Offset(0, 40),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'report',
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Report',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              const PopupMenuItem(
                value: 'hide',
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Hide',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: const Color(0xffFFF2FA), // Light pink background
      body: Obx(() {
        return reportController.isReporting.value
            ? Center(
                child: SimpleLoaderClass.simpleLoader(
                    text: 'Submitting Report...'))
            : SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // The image with error handling and gradient
                            SizedBox(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Stack(
                                  children: [
                                    // Image with error handling
                                    images.isEmpty
                                        ? const SizedBox(
                                            width: double.infinity,
                                            height: 200,
                                          )
                                        : Image.network(
                                            images[0],
                                            height: 400,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              // Show a broken image icon if there's an error
                                              return const Center(
                                                child: Icon(
                                                  Icons.broken_image,
                                                  size: 50,
                                                  color: Colors.grey,
                                                ),
                                              );
                                            },
                                          ),
                                    // Gradient overlay with specific height
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black.withOpacity(
                                                  0.7), // Dark overlay at the bottom
                                              Colors.transparent,
                                            ],
                                            stops: [
                                              0.0, // Start gradient at the bottom
                                              0.5, // End gradient at 50% height (can be adjusted)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // White background container for the text
                            Positioned(
                              left: 0, // Position to the left end
                              bottom: 20, // Position from the bottom
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      color: Colors.white, // Text color
                                      fontSize:
                                          24, // Base font size for the main text
                                    ),
                                    children: <TextSpan>[
                                      if (widget.data.name != null)
                                        TextSpan(
                                          text: widget
                                              .data.name!, // Main name text
                                          style: const TextStyle(
                                            fontSize:
                                                24, // Size for the main text
                                            fontWeight: FontWeight
                                                .bold, // Optional: make it bold
                                          ),
                                        ),
                                      if (widget.data.dob != null)
                                        TextSpan(
                                          text:
                                              ' ${_calculateAge(widget.data.dob!).toString()}, ', // Main name text
                                          style: const TextStyle(
                                            fontSize:
                                                24, // Size for the main text
                                            fontWeight: FontWeight
                                                .bold, // Optional: make it bold
                                          ),
                                        ),
                                      TextSpan(
                                        text: widget.data.gender == 'Male'
                                            ? " He/Him"
                                            : widget.data.gender == 'Female'
                                                ? " She/her"
                                                : " Other", // Pronouns text
                                        style: TextStyle(
                                          fontSize:
                                              16, // Smaller size for pronouns
                                          fontStyle: FontStyle
                                              .italic, // Optional: italicize the pronouns
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // About Me Section
                        if (widget.data.about?.isNotEmpty ?? false)
                          const Align(
                            alignment:
                                Alignment.centerLeft, // Align to the left
                            child: Text(
                              'About me',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.data.about ?? "",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Icons and Info Section
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                // First Row with vertical dividers
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // First item at the start
                                    if (widget.data.dob != null)
                                      buildInfoItem(
                                          'assets/cakeiconDD.png',
                                          _calculateAge(widget.data.dob!)
                                              .toString()),

                                    Spacer(),
                                    buildVerticalDivider(),
                                    Spacer(),

                                    // Middle item with equal spacing
                                    buildInfoItem('assets/DDgender.png',
                                        widget.data.gender ?? ' '),

                                    // Spacer to provide equal spacing for the last item
                                    Spacer(),
                                    buildVerticalDivider(),
                                    Spacer(),

                                    // Last item at the end
                                    buildInfoItem(
                                        'assets/locationDating.png',
                                        widget.data.distanceBound != null
                                            ? "${widget.data.distanceBound!}km"
                                            : ' '),
                                  ],
                                ),

                                const Divider(
                                  color: Color(0xffDC73B6),
                                  thickness: 0.29,
                                ),
                                // Second Row: Liberal
                                buildDetailItem('assets/DDpolitical.png',
                                    widget.data.politicalViews ?? ' '),
                                const Divider(
                                  color: Color(0xffDC73B6),
                                  thickness: 0.29,
                                ),
                                // Third Row: Want Children
                                buildDetailItem('assets/DDchildren.png',
                                    widget.data.familyPlans ?? ''),
                                const Divider(
                                  color: Color(0xffDC73B6),
                                  thickness: 0.29,
                                ),
                                // Fourth Row: Location
                                if (widget.data.locationCountry != null &&
                                    widget.data.locationState != null)
                                  buildDetailItem(
                                      'assets/DDaddress.png',
                                      widget.data.locationCountry != null
                                          ? "${widget.data.locationState!}, ${widget.data.locationCountry}"
                                          : ' '),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        if (widget.data.lookingFor != null)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                  10.0), // Increased border radius for rounder corners
                            ),
                            height: 110,
                            width: 380,
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 8.0, left: 10),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "What are you looking for?",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      widget.data.lookingFor ?? "",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 20),

                        // Second Image
                        if (images.length > 1)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              images[1], // Placeholder for second image
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        const SizedBox(height: 16),

                        // Hobbies Section with Image
                        Row(
                          children: [
                            if (images.length > 2)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    images[2], // Replace with your image path
                                    height:
                                        200, // Increased height for the image
                                    width: 170, // Increased width for the image
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            if (images.length > 2) const SizedBox(width: 10),
                            if (widget.data.hobbies != null)
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Hobbies',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: widget.data.hobbies !=
                                                      null &&
                                                  widget
                                                      .data.hobbies!.isNotEmpty
                                              ? [
                                                  for (int i = 0;
                                                      i <
                                                          widget.data.hobbies!
                                                              .length;
                                                      i++) ...[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 4.0),
                                                      child: Text(
                                                        '• ${widget.data.hobbies![i]}',
                                                        style: const TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  ],
                                                ]
                                              : [Text('')],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),

                        // New Image Container with View More Box
                        if (images.isNotEmpty)
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  children: [
                                    // Blurred Image
                                    Image.network(
                                      images.first,
                                      // Replace with your new image path
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.fill,
                                    ),
                                    // Applying the blur effect
                                    BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10.0, sigmaY: 10.0),
                                      // Adjust blur intensity
                                      child: Container(
                                        color: Colors.black.withOpacity(
                                            0), // Transparent container to enable the blur effect
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // View More Box
                              Positioned(
                                bottom: 35,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.white, // Border color
                                      width: 2, // Border width
                                    ),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      showImageOverlay(context, images);
                                    },
                                    child: const Text(
                                      'View More',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(
                            height: 20), // Add some spacing below the image
                      ],
                    ),
                  ),
                ),
              );
      }),
    );
  }
}

class IconWithLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const IconWithLabel({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 30, color: Colors.pink),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

Widget buildDetailItem(String imagePath, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Image.asset(
          imagePath,
          width: 16.0, // Set the desired width for the image
          height: 16.0, // Set the desired height for the image
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'SFProDisplay',
              fontSize: 16.0,
              color: Colors.black,
              fontWeight: FontWeight.w300,
              decoration: TextDecoration.none, // Ensure no underline
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildInfoItem(String imagePath, String text) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        imagePath,
        width: 18.0, // Set the desired width for the image
        height: 18.0, // Set the desired height for the image
      ),
      const SizedBox(width: 8.0),
      Text(
        text,
        style: const TextStyle(
          fontFamily: 'SFProDisplay',
          fontSize: 16.0,
          color: Colors.black,
          fontWeight: FontWeight.w300,
          decoration: TextDecoration.none, // Ensure no underline
        ),
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
    ],
  );
}

Widget buildVerticalDivider() {
  return Container(
    height: 24.0, // Adjust the height as needed
    width: 0.29,
    color: const Color(0xffDC73B6),
    margin: const EdgeInsets.symmetric(horizontal: 8.0),
  );
}
