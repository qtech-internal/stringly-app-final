import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stringly/Screens/MainSection/premiumVariation2Wigets/draggableCardWidget.dart';
import '../../GetxControllerAndBindings/controllers/whoLikeYouController/whoLikedYouController.dart';
import '../loaders/message_screen_loader.dart';
import '../mainScreenNav.dart';
import 'LikeScreenVariationMatched.dart';
import '../error/tech_error_widget.dart';

class PremiumVariation2 extends StatelessWidget {
  const PremiumVariation2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.delete<WhoLikeYouPageController>();
    final WhoLikeYouPageController controller =
    Get.put(WhoLikeYouPageController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => Mainscreennav()));
            },
            icon: const Icon(Icons.arrow_back)),
        titleSpacing: 0,
        title: const Text(
          'Who liked you',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'SFProDisplay',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Obx(() {
          if (controller.isLoading.value) {
            return MessageScreenLoader.simpleLoader(text: 'Wait, Loading...');
          } else if (controller.errorMessage.value.isNotEmpty) {
            return technicalErrorWidget();
          } else if (controller.allRightSwipeData.isEmpty &&
              !controller.dataFetched.value) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/no_likes.png'),
                    height: 120,
                    width: 120,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No Likes Just Yet!',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SFProDisplay'),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Finding the right match takes time. Stay active—you never know who’s next!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'SFProDisplay'),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${controller.allRightSwipeData.length} ${controller.profileText}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.allRightSwipeData.length,
                    itemBuilder: (BuildContext context, int index) {
                      var data = controller.allRightSwipeData[index];
                      return DraggableCardWidget(
                        interests: data['interest'],
                        name: data['name'],
                        image: data['image'],
                        age: data['age'],
                        location: data['location'],
                        index: index,
                        context: data['context'],
                        sideColor: data['context'] == 'dating'
                            ? const Color(0xFFDC73B6)
                            : const Color(0xFF5355D0),
                        overlayIcon: data['context'] == 'dating'
                            ? 'assets/heart.png'
                            : 'assets/link2.png',
                        userDetail: data['forDetailNetworking'],
                        userId: data['userId'],
                        loggedUserId: data['loggedUserId'],
                        onLeftButtonPressed: () {
                          controller.onLeftSwipe(data, index);
                        },
                        onRightButtonPressed: () {
                          controller.onRightSwipe(data, index);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return PremiumVariation2Matched(
                                usersInfo: {
                                  'loggedUserImage':
                                  controller.loggedUserInfo['image'],
                                  'currentUserProfileImage': data['image'],
                                  'profileUserName': data['name'],
                                  'ProfileUserId': data['userId'],
                                  'loggedUserId':
                                  controller.loggedUserInfo['userId'],
                                },
                              );
                            },
                          );
                        },
                        onLeftSwipeMore: () {
                          controller.onLeftSwipeMore(data, index);
                        },
                        onRightSwipeMore: () {
                          controller.onRightSwipeMore(data, index);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return PremiumVariation2Matched(
                                usersInfo: {
                                  'loggedUserImage':
                                  controller.loggedUserInfo['image'],
                                  'currentUserProfileImage': data['image'],
                                  'profileUserName': data['name'],
                                  'ProfileUserId': data['userId'],
                                  'loggedUserId':
                                  controller.loggedUserInfo['userId'],
                                },
                              );
                            },
                          );
                        },
                      );
                    },
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
