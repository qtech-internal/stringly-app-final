import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../GetxControllerAndBindings/controllers/whoLikeYouController/whoLikedYouController.dart';
import '../Reward Settings/RewardsPage.dart';
import 'RewardAcheivedOverlay.dart';

class PremiumVariation1 extends StatelessWidget {
  const PremiumVariation1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WhoLikeYouPageController controller = Get.put(WhoLikeYouPageController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        title: const Text('Who liked you', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else if (controller.errorMessage.value.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          } else if (controller.allRightSwipeData.isEmpty && !controller.dataFetched.value) {
            return const Center(child: Text('No Likes Just Yet!'));
          } else {
            return Column(
              children: [
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${controller.allRightSwipeData.length} Liked Your Profile',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.allRightSwipeData.length,
                    itemBuilder: (BuildContext context, int index) {
                      var data = controller.allRightSwipeData[index];
                      return MatchCard(
                        image: data['image'],
                        sideColor: data['context'] == 'dating' ? Color(0xFFDC73B6) : Color(0xFFC6C6EF),
                        overlayIcon: data['context'] == 'dating' ? 'assets/heart.png' : 'assets/link2.png',
                      );
                    },
                  ),
                ),
                // Always show the Upgrade to Premium button
                SizedBox(
                  height: 50,
                  width: 300, // Set the width to 300 pixels
                  child: ElevatedButton(
                    onPressed: () {
                      // Show the overlay dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return RewardAchievedOverlay();
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Button background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                      ),
                    ),
                    child: const Text(
                      'Upgrade to Premium',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}

class MatchCard extends StatelessWidget {
  final String image;
  final Color sideColor;
  final String overlayIcon; // New parameter for overlay icon

  const MatchCard({
    Key? key,
    required this.image,
    required this.sideColor,
    required this.overlayIcon, // Receive the overlay icon as a parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: sideColor), // Use the provided side color
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        height: 100,
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Image with fit
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                // Blur effect since the user is not premium
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                // Lock image overlay since the user is not premium
                const Icon(Icons.lock_outline, color: Colors.white),

                // Add the icon image in the corner (outside the blur area)
                Positioned(
                  bottom: 2,
                  right: -3,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white, // Add background color to make it stand out
                    ),
                    padding: const EdgeInsets.all(2), // Add padding inside the container
                    child: Image.asset(
                      overlayIcon, // Use the passed icon image
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          title: const Text(
            'Someone liked you! Unlock premium to see who.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text('Located within 10 miles'),
        ),
      ),
    );
  }
}