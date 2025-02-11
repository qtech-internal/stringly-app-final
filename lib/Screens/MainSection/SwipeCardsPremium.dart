import 'package:flutter_svg/svg.dart';

import './../../matched_queue.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stringly/Reuseable%20Widget/animated_card.dart';
import 'package:stringly/Screens/loaders/dating_loader.dart';
import 'package:stringly/Screens/loaders/networking_loader.dart';
import 'package:stringly/Screens/loaders/simple_loader.dart';
import 'package:stringly/StorageServices/get_storage_service.dart';
import 'package:stringly/intraction.dart';
import 'package:stringly/models/user_profile_params_model.dart';
import '../../Reuseable Widget/CustomDropDown.dart';
import '../../models/global_constant_for_site_dating_networking.dart';
import '../../models/update_user_account_model.dart';
import '../filterPreferences/filter_preferences.dart';

class SwipingScreenPremium extends StatefulWidget {
  @override
  _SwipingScreenPremiumState createState() => _SwipingScreenPremiumState();
}

class _SwipingScreenPremiumState extends State<SwipingScreenPremium>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> images = [];
  late Future<dynamic> _allUserData;
  final MatchedQueue matchedQueue = MatchedQueue();
  final GlobalKey dialog1Key = GlobalKey();
  final GlobalKey dialog2Key = GlobalKey();
  List<String> skillsItem = [
    'Painting',
    'Journaling',
    'Dancing',
    'Writing Poems',
    'Sketching',
    'Photography',
    'Pottery',
    'Calligraphy',
    'Creative Writing',
    'Playing a Musical Instrument',
    'Singing',
    'Crafting',
    'Cooking/Baking',
    'Gardening',
    'Sewing/Knitting',
    'Origami',
    'Acting',
    'Meditation/Yoga',
    'Scrapbooking',
    'Storytelling',
    'Making Digital Art',
    'Learning a New Language',
    'Woodworking',
    'Learning Magic Tricks'
  ];
  List<String> items = [
    'Technology & Software Development',
    'Arts & Entertainment',
    'Media & Journalism',
    'Music & Performing Arts',
    'Banking & Finance',
    'Consulting',
    'Marketing & Advertising',
    'Healthcare & Medicine',
    'Education & Research',
    'Business & Management'
  ];
  List<String> selectedItems = [];

  bool? toggleStatus;
  bool newUserToShowForm = true;

  TextEditingController headLineController = TextEditingController();
  TextEditingController whatAreYouLookingForController =
      TextEditingController();
  TextEditingController skillsController = TextEditingController();

  int currentIndex = 0;
  Offset cardOffset = Offset.zero;
  double cardRotation = 0.0;
  bool isToggled =
      GlobalConstantForSiteDatingNetworking.toggleToNetwork == 'dating'
          ? false
          : true;
  bool isFirstSwipe = true;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool isSuperLikeAnimating = false;
  Offset buttonOffset = Offset.zero; // To store the button's position

  // function to set value to show pop form
  newUserValueToShowForm() {
    newUserToShowForm = StorageService.hasData('newUserToShowForm');
  }

  void showSuperLikeOverlay(String fullName, Offset buttonPosition) {
    setState(() {
      isSuperLikeAnimating = true;
      buttonOffset = buttonPosition; // Capture the button's position
    });

    // Start the animation
    _controller.forward().whenComplete(() {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          isSuperLikeAnimating = false;
        });
        _controller.reverse();
      });
    });
  }

  Future<bool> _onWillPop() async {
    // Show confirmation or close the app directly
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), // Stay in the app
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => exit(0), // Close the app
                child: const Text('Exit'),
              ),
            ],
          ),
        ) ??
        false;
  }

  // update userinfo through pop form
  Future<void> updateUserInfoWithShowPopupForm() async {
    try {
      UpdateUserAccountModel inputParams = UpdateUserAccountModel();
      if (whatAreYouLookingForController.text.isNotEmpty) {
        inputParams.updateField(
            'lookingFor', whatAreYouLookingForController.text.toString());
      }
      if (selectedItems.isNotEmpty) {
        inputParams.updateField('main_profession', selectedItems);
      }
      if (headLineController.text.isNotEmpty) {
        inputParams.updateField('headline', headLineController.text);
      }
      if (skillsController.text.isNotEmpty) {
        inputParams.updateField('skills', [skillsController.text]);
      }
      var result = await Intraction.updateLoggedUserAccount(inputParams);
      debugPrint('$result');
    } catch (e) {
      debugPrint('Err $e');
    }
  }

  void _showPopupForm(BuildContext context, GlobalKey key) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          key: key,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6), // No rounded corners
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                      onTap: () {
                        StorageService.write('newUserToShowForm', 'No');
                        setState(() {
                          toggleStatus = null;
                          newUserToShowForm = true;
                        });
                        Navigator.of(context).pop(false);
                      },
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.grey,
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    const Positioned(
                      top: -4,
                      child: Text(
                        'Headline', // Persistent label
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextField(
                      controller: headLineController,
                      decoration: const InputDecoration(
                        hintText: 'Type something',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                        border: InputBorder.none, // No outer border
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ), // Bottom border when enabled
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ), // Bottom border when focused
                        ),
                        contentPadding: EdgeInsets.only(
                            bottom:
                                -8), // Remove extra padding inside the field
                      ),
                      style: const TextStyle(
                          fontSize: 16), // Optional: Adjust font size
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    const Positioned(
                      top: -4,
                      child: Text(
                        'What are you exactly looking for?', // Persistent label
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextField(
                      controller: whatAreYouLookingForController,
                      decoration: const InputDecoration(
                        hintText: 'Type something',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                        border: InputBorder.none, // No outer border
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ), // Bottom border when enabled
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ), // Bottom border when focused
                        ),
                        contentPadding: EdgeInsets.only(
                            bottom:
                                -8), // Remove extra padding inside the field
                      ),
                      style: const TextStyle(
                          fontSize: 16), // Optional: Adjust font size
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    _showScrollablePopupFormProfession(
                        context, dialog2Key, items, selectedItems);
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Wrap Flexible directly around the Text widget
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              'What is your main professional focus?',
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis, // Handle overflow
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.keyboard_arrow_right,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomGradientdropdownTextField(
                  height: 49.5,
                  hintText: 'Specify your interest',
                  items: skillsItem,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        skillsController.text = value?.value;
                        debugPrint('${skillsController.text}');
                      });
                    }
                  },
                  label: const Text('Skills'),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      StorageService.write('newUserToShowForm', 'No');
                      setState(() {
                        toggleStatus = null;
                        newUserToShowForm = true;
                      });
                      updateUserInfoWithShowPopupForm();
                      Navigator.of(context).pop(false);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              6), // Adjust the radius as needed
                        ),
                        disabledBackgroundColor: Colors.black,
                        disabledForegroundColor: Colors.black),
                    child: const Text(
                      'Done',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showScrollablePopupFormProfession(BuildContext context, GlobalKey key,
      List<String> items, List<String> selectedItems) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          key: key,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6), // No rounded corners
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'What is your main professional focus?',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      // List of professions with scroll
                      Column(
                        children: items.map((item) {
                          bool isSelected = selectedItems.contains(item);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedItems.remove(item);
                                } else {
                                  selectedItems.add(item);
                                }
                              });
                            },
                            child: Container(
                              width: double.infinity, // Takes maximum width
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: isSelected
                                    ? const LinearGradient(
                                        colors: [Colors.purple, Colors.blue],
                                      )
                                    : null,
                                color: isSelected ? null : Colors.white,
                                border: Border.all(color: Colors.grey),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Text(
                                item,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      // Done button
                      SizedBox(
                        height: 50,
                        width:
                            double.infinity, // Make the button take full width
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Close dialog after selecting
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  6), // Adjust the radius as needed
                            ),
                          ),
                          child: const Text('Done'),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> initializeMatchedQueue() async {
    await MatchedQueue.getMatchedQueue();

    matchedQueue.getNewMessagesFromUser();
  }

  // Function to reset the card deck
  void _bringBackPreviousCard() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--; // Go back to the previous card
        cardOffset = Offset.zero; // Reset position
        cardRotation = 0.0; // Reset rotation
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initializeMatchedQueue();
    // Call the static methods from MatchedQueue
    _allUserData = _getAll();
    newUserValueToShowForm();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  Future<Map<String, dynamic>> _getAll() async {
    try {
      // Map<String, dynamic> result = await Intraction.getAll();
      var result2 = await Intraction.getLoggedUserAccount();
      UpdateUserAccountModel loggedUserInfo =
          UpdateUserAccountModel.fromMap(result2['Ok']['params']);
      String loggedUserId = result2['Ok']['user_id'];
      Map<String, dynamic> result =
          await Intraction.getAllAccounts(userId: loggedUserId);
      String loggedUserImage =
          (loggedUserInfo.images != null && loggedUserInfo.images!.isNotEmpty)
              ? loggedUserInfo.images![0]
              : '';
      if (result.containsKey('Ok')) {
        var usersAllData = result['Ok'];
        int? noOfUser = usersAllData.length;
        images.clear();
        for (int i = 0; i < noOfUser!; i++) {
          var singleUserInfo =
              userProfileParamsModel.fromMap(usersAllData[i]['params']);
          String currentProfileUserId = usersAllData[i]['user_id'];
          String imageBytesProfile = (singleUserInfo.images != null &&
                  singleUserInfo.images!.isNotEmpty)
              ? singleUserInfo.images![0]
              : '';
          images.add({
            'path': imageBytesProfile,
            'name': singleUserInfo.name ?? '',
            'age': singleUserInfo.dob != null
                ? _calculateAge(singleUserInfo.dob!).toString()
                : '',
            'location': singleUserInfo.locationCountry != null
                ? '${singleUserInfo.locationCity}, ${singleUserInfo.locationState}, ${singleUserInfo.locationCountry}'
                : '',
            'distance':
                '${singleUserInfo.distanceBound ?? 'Unknown'} miles away',
            'info': singleUserInfo.about ?? 'No information available',
            'logged_user_id': loggedUserId,
            'current_profile_user_id': currentProfileUserId,
            'forDetailNetworking': singleUserInfo,
            'logged_user_info': loggedUserInfo,
            'logged_user_image': loggedUserImage,
          });
        }
        return result;
      } else {
        return result;
      }
    } catch (e) {
      debugPrint('---------catch error--------------------$e');
      return {'error': e};
    }
  }

  int _calculateAge(String dob) {
    final birthDate = DateTime.parse(dob);
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFFD83694), Color(0xFF0039C7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: const Text(
                        'Stringly',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Image.asset(
                    //   'assets/newImage/COLOURED LOGO.png',
                    //   height: 60,
                    //   width: 90,
                    //   fit: BoxFit.contain,
                    // ),
                    CustomToggleSwitch(
                      isToggled: isToggled,
                      onToggle: (value) {
                        setState(() {
                          isToggled = value;
                          toggleStatus = true;
                          if (GlobalConstantForSiteDatingNetworking
                                  .toggleToNetwork ==
                              'networking') {
                            GlobalConstantForSiteDatingNetworking
                                .toggleToNetwork = 'dating';
                          } else {
                            GlobalConstantForSiteDatingNetworking
                                .toggleToNetwork = 'networking';
                          }
                        });
                      },
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => FilterPreferences()),
                            );
                          },
                          child: SvgPicture.asset(
                              'assets/svg/mage_filter-fill.svg',
                              width: 24,
                              height: 24),
                        ),

                        // GestureDetector(
                        //   onTap: () {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       const SnackBar(
                        //         content: Center(
                        //             child: Text('Coming soon...........')),
                        //         duration: Duration(seconds: 2),
                        //       ),
                        //     );
                        //   },
                        //   child: Row(
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: [
                        //       Image.asset(
                        //         'assets/coin2.png',
                        //         height: 12,
                        //         width: 12,
                        //       ),
                        //       const SizedBox(width: 2),
                        //       const Flexible(
                        //         // Use Flexible to prevent overflow
                        //         child: Text(
                        //           '0',
                        //           style: TextStyle(
                        //             fontSize: 18,
                        //             fontWeight: FontWeight.bold,
                        //             overflow: TextOverflow
                        //                 .ellipsis, // Handle overflow
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    )
                  ],
                ),
              ),
              // Remove padding/margin to close the gap between the row and card
              toggleStatus != null
                  ? FutureBuilder(
                      future: Future.delayed(const Duration(seconds: 3), () {
                        if (newUserToShowForm != false) {
                          setState(() {
                            toggleStatus = null;
                          });
                        }
                      }),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            newUserToShowForm == false) {
                          Future.delayed(Duration.zero, () {
                            _showPopupForm(context, dialog1Key);
                          });
                        }
                        if (GlobalConstantForSiteDatingNetworking
                                .toggleToNetwork ==
                            'networking') {
                          return NetworkingLoader.simpleLoader();
                        } else {
                          return DatingLoader.simpleLoader();
                        }
                      },
                    )
                  : FutureBuilder(
                      future: _allUserData, // The asynchronous operation
                      builder: (context, snapshot) {
                        // While the future is loading
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SimpleLoaderClass.simpleLoader(
                              text: 'Wait, Loading...');
                        } else if (snapshot.hasData) {
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      .025),
                              child: Stack(
                                children: currentIndex >= images.length
                                    ? [
                                        // Fallback container when no images are left
                                        const Center(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image(
                                              image: AssetImage(
                                                  'assets/noswipeleft.png'),
                                              height: 150,
                                            ),
                                            SizedBox(height: 20),
                                            Text(
                                              'Take a Breath',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'SFProDisplay',
                                                  fontSize: 22),
                                            ),

                                            SizedBox(height: 8),
                                            Text(
                                              'This is for now Come back later',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'SFProDisplay',
                                                  fontSize: 16),
                                            )

                                            // Spacer(),
                                            // Image(
                                            //     image: AssetImage('assets/no-swipe-left-more.png'),
                                            //     height: 260,
                                            // ),
                                            // Padding(
                                            //   padding: EdgeInsets.only(left: 45, right: 45, bottom: 90, top: 30),
                                            //   // child: SizedBox(
                                            //   //   height: 50,
                                            //   //   width: MediaQuery.of(context).size.width,
                                            //   //   child: ElevatedButton(
                                            //   //       onPressed: () {
                                            //   //         Navigator.of(context).push(MaterialPageRoute(builder: (context) => FilterPreferences()));
                                            //   //       },
                                            //   //         style: ElevatedButton.styleFrom(
                                            //   //           foregroundColor: Colors.white,
                                            //   //           backgroundColor: Colors.black,
                                            //   //           shape: const RoundedRectangleBorder(
                                            //   //             borderRadius: BorderRadius.all(Radius.circular(5)),
                                            //   //           ),
                                            //   //         ),
                                            //   //       child: const Text('Adjust Filter')
                                            //   //   ),
                                            //   // ),
                                            // )
                                          ],
                                        )),
                                      ]
                                    : images.reversed.map((imageData) {
                                        int index = images.indexOf(imageData);
                                        if (index < currentIndex)
                                          return Container();

                                        // // Apply overlap only to the card directly below the top card
                                        // double scale = index - currentIndex == 1
                                        //     ? 0.98
                                        //     : 1.0; // Scale down slightly for the 2nd card
                                        // double opacity = index - currentIndex == 1
                                        //     ? 0.9
                                        //     : 1.0; // Slightly reduce opacity for the 2nd card
                                        // double topOffset = (index -
                                        //             currentIndex ==
                                        //         1)
                                        //     ? -30.0
                                        //     : 0.0; // Small top offset only for the 2nd card
                                        return AnimatedCard(
                                          currentIndex: currentIndex,
                                          imageData: imageData,
                                          index: index,
                                          site:
                                              GlobalConstantForSiteDatingNetworking
                                                  .toggleToNetwork,
                                          isToggled:
                                              isToggled, // Ensure you have this variable defined in your context
                                          onSwipeComplete: () {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 200), () {
                                              setState(() {
                                                cardOffset = Offset.zero;
                                                cardRotation = 0.0;
                                                isFirstSwipe = false;
                                                currentIndex++;
                                              });
                                            });
                                          },
                                        );
                                        // return Positioned(
                                        //   top: 45 + topOffset,
                                        //   left: 20.0,
                                        //   right: 20.0,
                                        //   child: Opacity(
                                        //     opacity: opacity,
                                        //     child: Transform.scale(
                                        //       scale: scale,
                                        //       child: GestureDetector(
                                        //         onPanUpdate: index == currentIndex
                                        //             ? (details) {
                                        //                 setState(() {
                                        //                   cardOffset = Offset(
                                        //                     cardOffset.dx +
                                        //                         details.delta.dx,
                                        //                     -cardOffset.dx.abs() *
                                        //                         0.2,
                                        //                   );

                                        //                   cardRotation =
                                        //                       -cardOffset.dx *
                                        //                           0.001;
                                        //                 });
                                        //               }
                                        //             : null,
                                        //         onPanEnd: index == currentIndex
                                        //             ? (details) {
                                        //                 const double
                                        //                     velocityThreshold =
                                        //                     1000.0;
                                        //                 final double velocity =
                                        //                     details
                                        //                         .velocity
                                        //                         .pixelsPerSecond
                                        //                         .dx;

                                        //                 if (cardOffset.dx.abs() >
                                        //                         100 ||
                                        //                     velocity.abs() >
                                        //                         velocityThreshold) {
                                        //                   final bool isRight =
                                        //                       cardOffset.dx > 0 ||
                                        //                           velocity > 0;

                                        //                   setState(() {
                                        //                     cardOffset = Offset(
                                        //                       isRight
                                        //                           ? MediaQuery.of(
                                        //                                       context)
                                        //                                   .size
                                        //                                   .width *
                                        //                               1.5
                                        //                           : -MediaQuery.of(
                                        //                                       context)
                                        //                                   .size
                                        //                                   .width *
                                        //                               1.5,
                                        //                       -MediaQuery.of(
                                        //                                   context)
                                        //                               .size
                                        //                               .height *
                                        //                           0.4,
                                        //                     );

                                        //                     cardRotation = isRight
                                        //                         ? -0.2
                                        //                         : 0.2;
                                        //                   });

                                        // SwipeInputModel
                                        //     swipeInput =
                                        //     SwipeInputModel(
                                        //   receiverId: imageData[
                                        //       'current_profile_user_id'],
                                        //   senderId: imageData[
                                        //       'logged_user_id'],
                                        // );
                                        // if (isRight) {
                                        //   Intraction.rightSwipe(
                                        //       swipeInput);
                                        // } else {
                                        //   Intraction.leftSwipe(
                                        //       swipeInput);
                                        // }

                                        // Future.delayed(
                                        //     const Duration(
                                        //         milliseconds:
                                        //             200), () {
                                        //   setState(() {
                                        //     currentIndex++;
                                        //     cardOffset =
                                        //         Offset.zero;
                                        //     cardRotation = 0.0;
                                        //     isFirstSwipe =
                                        //         false;
                                        //   });
                                        // });
                                        //                 } else {
                                        //                   setState(() {
                                        //                     cardOffset =
                                        //                         Offset.zero;
                                        //                     cardRotation = 0.0;
                                        //                   });
                                        //                 }
                                        //               }
                                        //             : null,
                                        //         child: SizedBox(
                                        //           height: MediaQuery.of(context)
                                        //                   .size
                                        //                   .height *
                                        //               0.65,
                                        //           child: Transform.translate(
                                        //             offset: index == currentIndex
                                        //                 ? cardOffset
                                        //                 : Offset.zero,
                                        //             child: Transform.rotate(
                                        //               angle: index == currentIndex
                                        //                   ? cardRotation
                                        //                   : 0.0,
                                        //               // Adjust rotation origin for more natural movement
                                        //               origin: Offset(
                                        //                   0,
                                        //                   MediaQuery.of(context)
                                        //                           .size
                                        //                           .height *
                                        //                       0.65),
                                        //               child: Stack(
                                        //                 children: [
                                        //                   if (index ==
                                        //                           currentIndex &&
                                        //                       currentIndex !=
                                        //                           0) // Show button only on top card after first swipe
                                        //                     Positioned(
                                        //                       top: 10,
                                        //                       right: 10,
                                        //                       child:
                                        //                           ElevatedButton(
                                        //                               onPressed:
                                        //                                   () {
                                        //                                 // Add your button action here
                                        //                               },
                                        //                               child: const Icon(
                                        //                                   Icons
                                        //                                       .refresh)),
                                        //                     ),
                                        //                   Card(
                                        //                     shape:
                                        //                         RoundedRectangleBorder(
                                        //                       borderRadius:
                                        //                           BorderRadius
                                        //                               .circular(
                                        //                                   20),
                                        //                     ),
                                        //                     elevation: 4.0,
                                        //                     child: ClipRRect(
                                        //                       borderRadius:
                                        //                           BorderRadius
                                        //                               .circular(
                                        //                                   20),
                                        //                       child: Stack(
                                        //                         fit: StackFit
                                        //                             .expand,
                                        //                         children: [
                                        //                           Image.network(
                                        //                             imageData[
                                        //                                 'path']!,
                                        //                             errorBuilder: (BuildContext
                                        //                                     context,
                                        //                                 Object
                                        //                                     error,
                                        //                                 StackTrace?
                                        //                                     stackTrace) {
                                        //                               return Container(
                                        //                                 color: Colors
                                        //                                     .grey, // Placeholder background color
                                        //                                 child:
                                        //                                     const Icon(
                                        //                                   Icons
                                        //                                       .broken_image,
                                        //                                   color: Colors
                                        //                                       .white,
                                        //                                   size:
                                        //                                       50.0, // Placeholder icon size
                                        //                                 ),
                                        //                               );
                                        //                             },
                                        //                             fit: BoxFit
                                        //                                 .cover,
                                        //                           ),
                                        //                           Positioned.fill(
                                        //                             child:
                                        //                                 ClipRRect(
                                        //                               borderRadius:
                                        //                                   BorderRadius.circular(
                                        //                                       20),
                                        //                               child:
                                        //                                   Container(
                                        //                                 color: _getOverlayColor(
                                        //                                     index),
                                        //                               ),
                                        //                             ),
                                        //                           ),
                                        //                           Positioned(
                                        //                             bottom: 20,
                                        //                             left: 20,
                                        //                             right: 20,
                                        //                             child: Padding(
                                        //                                 // Added Padding here
                                        //                                 padding: const EdgeInsets.only(right: 30.0), // Adjust horizontal padding as needed
                                        //                                 child: Column(
                                        //                                   crossAxisAlignment:
                                        //                                       CrossAxisAlignment.start,
                                        //                                   children: [
                                        //                                     Text(
                                        //                                       '${imageData['name']}, ${imageData['age']}',
                                        //                                       style:
                                        //                                           const TextStyle(
                                        //                                         fontFamily: 'SFProDisplay',
                                        //                                         fontSize: 25,
                                        //                                         fontWeight: FontWeight.bold,
                                        //                                         color: Colors.white,
                                        //                                       ),
                                        //                                     ),
                                        //                                     Text(
                                        //                                       imageData['location']!,
                                        //                                       style:
                                        //                                           const TextStyle(
                                        //                                         fontFamily: 'SFProDisplay',
                                        //                                         fontSize: 16,
                                        //                                         color: Colors.white,
                                        //                                       ),
                                        //                                     ),
                                        //                                     Text(
                                        //                                       imageData['distance']!,
                                        //                                       style:
                                        //                                           const TextStyle(
                                        //                                         fontFamily: 'SFProDisplay',
                                        //                                         fontSize: 16,
                                        //                                         color: Colors.white,
                                        //                                       ),
                                        //                                     ),
                                        //                                     const SizedBox(
                                        //                                         height: 5),
                                        //                                     SizedBox(
                                        //                                       width:
                                        //                                           MediaQuery.of(context).size.width - 100,
                                        //                                       child:
                                        //                                           Padding(
                                        //                                         padding: const EdgeInsets.only(right: 20.0),
                                        //                                         child: Text(
                                        //                                           imageData['info']!,
                                        //                                           style: const TextStyle(
                                        //                                             color: Colors.white70,
                                        //                                             fontSize: 16,
                                        //                                           ),
                                        //                                           textAlign: TextAlign.left,
                                        //                                           softWrap: true,
                                        //                                           overflow: TextOverflow.ellipsis,
                                        //                                           maxLines: 4,
                                        //                                         ),
                                        //                                       ),
                                        //                                     ),
                                        //                                   ],
                                        //                                 )),
                                        //                           ),
                                        //                         ],
                                        //                       ),
                                        //                     ),
                                        //                   ),

                                        //                   // super like
                                        //                   Positioned(
                                        //                     bottom: 20,
                                        //                     right: 20,
                                        //                     child:
                                        //                         GestureDetector(
                                        //                       onTapDown:
                                        //                           (details) {
                                        //                         ScaffoldMessenger
                                        //                                 .of(
                                        //                                     context)
                                        //                             .showSnackBar(
                                        //                                 const SnackBar(
                                        //                           content: Center(
                                        //                               child: Text(
                                        //                                   'Comming soon!')),
                                        //                           duration:
                                        //                               Duration(
                                        //                                   seconds:
                                        //                                       1),
                                        //                         ));
                                        // Intraction.addSuperLike(
                                        //     userId: imageData[
                                        //         'logged_user_id']!,
                                        //     receiverId: imageData[
                                        //         'current_profile_user_id']!);
                                        // showSuperLikeOverlay(
                                        //     imageData['name']!,
                                        //     details
                                        //         .globalPosition);
                                        //                       },
                                        //                       child: Image.asset(
                                        //                         'assets/SUPERLIKE_new.png',
                                        //                         height: 38,
                                        //                         width: 38,
                                        //                       ),
                                        //                     ),
                                        //                   ),

                                        //                   // Display the button inside the top-right corner of each card after the first swipe
                                        //                   // if (!isFirstSwipe)
                                        //                   //   Positioned(
                                        //                   //     top: 10,
                                        //                   //     right: 10,
                                        //                   //     child: IconButton(
                                        //                   //       icon: const Icon(
                                        //                   //         Icons.refresh,
                                        //                   //         color: Colors.white,
                                        //                   //       ),
                                        //                   //       // refreshing card deck
                                        //                   //       onPressed:
                                        //                   //           _bringBackPreviousCard,
                                        //                   //     ),
                                        //                   //   ),
                                        //                   if (isSuperLikeAnimating)
                                        //                     AnimatedBuilder(
                                        //                       animation:
                                        //                           _controller,
                                        //                       builder: (context,
                                        //                           child) {
                                        //                         return Positioned(
                                        //                           left: 0,
                                        //                           right: 0,
                                        //                           bottom: 0,
                                        //                           child:
                                        //                               Container(
                                        //                             width: MediaQuery.of(
                                        //                                         context)
                                        //                                     .size
                                        //                                     .width *
                                        //                                 _scaleAnimation
                                        //                                     .value,
                                        //                             height: MediaQuery.of(
                                        //                                         context)
                                        //                                     .size
                                        //                                     .height *
                                        //                                 _scaleAnimation
                                        //                                     .value,
                                        //                             color: Colors
                                        //                                 .white
                                        //                                 .withOpacity(
                                        //                                     0.9),
                                        //                             child:
                                        //                                 Opacity(
                                        //                               opacity:
                                        //                                   _opacityAnimation
                                        //                                       .value,
                                        //                               child:
                                        //                                   Stack(
                                        //                                 children: [
                                        //                                   Align(
                                        //                                       alignment:
                                        //                                           Alignment.center, // Center the image

                                        //                                       child: Image.asset('assets/starol.png')),
                                        //                                   Positioned(
                                        //                                       bottom:
                                        //                                           230,
                                        //                                       right:
                                        //                                           0,
                                        //                                       left:
                                        //                                           0,
                                        //                                       child:
                                        //                                           Center(
                                        //                                         child: Text(
                                        //                                           'You superliked ${images[index]['name']}',
                                        //                                           textAlign: TextAlign.center,
                                        //                                           style: const TextStyle(
                                        //                                             fontSize: 20,
                                        //                                             fontWeight: FontWeight.bold,
                                        //                                             color: Colors.black,
                                        //                                           ),
                                        //                                         ),
                                        //                                       )),
                                        //                                 ],
                                        //                               ),
                                        //                             ),
                                        //                           ),
                                        //                         );
                                        //                       },
                                        //                     ),
                                        //                 ],
                                        //               ),
                                        //             ),
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // );
                                      }).toList(),
                              ),
                            ),
                          );
                        }
                        return SimpleLoaderClass.simpleLoader(
                            text: 'Wait, Loading...');
                      })
            ],
          ),
        ),
      ),
    );
  }
}

class CustomToggleSwitch extends StatelessWidget {
  final bool isToggled;
  final ValueChanged<bool> onToggle;

  const CustomToggleSwitch({
    Key? key,
    required this.isToggled,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onToggle(!isToggled),
      child: Container(
        width: 80,
        height: 30,
        decoration: BoxDecoration(
          color: isToggled ? const Color(0xff3639C7) : const Color(0xffCD3596),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Heart Icon - rises up from the bottom to its initial position
            // AnimatedPositioned(
            //   duration: Duration(milliseconds: 400),
            //   left: 12, // Adjust left position when toggled off
            //   bottom: isToggled
            //       ? 6
            //       : -10, // Adjust bottom position when toggled off
            //   child: AnimatedOpacity(
            //     opacity: isToggled ? 1 : 0,
            //     duration: Duration(milliseconds: 300),
            //     child: Image.asset(
            //       'assets/Component 4.png',
            //       width: 25,
            //       height: 25,
            //       color: Colors.red[400],
            //     ),
            //   ),
            // ),
            // Link Icon - rises up from the bottom when toggled off
            // AnimatedPositioned(
            //   duration: Duration(milliseconds: 400),
            //   right: 10,
            //   bottom:
            //       isToggled ? -10 : 8, // Keep link icon down when toggled on
            //   child: AnimatedOpacity(
            //     opacity: isToggled ? 0 : 1,
            //     duration: Duration(milliseconds: 300),
            //     child: Image.asset(
            //       'assets/go.png',
            //       width: 25,
            //       height: 25,
            //       color: Colors.blueAccent,
            //     ),
            //   ),
            // ),
            // Thumb Animation
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              left: isToggled ? 56 : 8,
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
