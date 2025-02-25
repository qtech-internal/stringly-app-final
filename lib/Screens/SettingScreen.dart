import 'package:flutter/material.dart';
import 'package:flutter_icp_auth/authentication/logout.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stringly/intraction.dart';

import '../constants/globals.dart';
import '../main.dart';
import 'AccountSettings/AccountSettings.dart';
import 'FAQ Qusetions/Helpandsupport.dart';
import 'Location/LocationSettings.dart';
import 'NotificationScreen.dart';
import 'PrivacyScreen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // List of settings options
  List<SettingOptionData> allSettingOptions = [
    SettingOptionData(
        imagePath: 'assets/svg/ic_outline-person.svg',
        text: 'Account Settings',
        route: AccountSetting()),
    SettingOptionData(
        imagePath: 'assets/svg/ic_outline-privacy-tip.svg',
        text: 'Privacy',
        route: PrivacyScreen()),
    SettingOptionData(
        imagePath: 'assets/svg/octicon_bell-24.svg',
        text: 'Notifications',
        route: NotificationScreen()),
    // SettingOptionData(
    //     imagePath: 'assets/svg/fluent_payment-16-regular.svg',
    //     text: 'Subscription & Payment',
    //     route: SubscriptionScreen()),
    // SettingOptionData(
    //     imagePath: 'assets/svg/fluent_reward-20-regular.svg',
    //     text: 'Reward Points Management',
    //     route: RewardPointsSettings()),
    SettingOptionData(
        imagePath: 'assets/svg/material-symbols_help-outline.svg',
        text: 'Help & Support',
        route: HelpScreen()),
    SettingOptionData(
        imagePath: 'assets/svg/basil_location-outline.svg',
        text: 'Location',
        route: LocationSettings()),
  ];

  // List to hold filtered search results
  List<SettingOptionData> filteredSettingOptions = [];

  @override
  void initState() {
    super.initState();
    // Initially, show all settings options
    filteredSettingOptions = allSettingOptions;
  }

  // Search functionality
  void _filterSettings(String query) {
    setState(() {
      filteredSettingOptions = allSettingOptions
          .where((setting) =>
              setting.text.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showGpsPermissionDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Color(0xFFE4E4E4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Are you sure you want to Log Out?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE4E4E4),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style:
                            TextStyle(color: Color(0xFFE4626F), fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () async {
                    List<Object> logoutValidation = await AuthLogout.logout(
                        GlobalConstant.isLocal,
                        GlobalConstant.backendCanisterId);
                    setState(() {
                      GlobalConstant.isLoggedIn =
                          logoutValidation.whereType<bool>().first;
                    });
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => Welcomepage()));

                    Intraction.loggedUserAccount = null;
                    Intraction.loggedUserId = null;
                    Intraction.loggedUserPrincipal = null;
                    Intraction.actor = null;
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) =>
                              Welcomepage()), // Replace LoginScreen with your login page widget.
                      (Route<dynamic> route) =>
                          false, // Remove all the previous routes.
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Color(0xFF5355D0), fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Color(0xFFE4E4E4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Are you sure you want to Delete Account?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE4E4E4),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style:
                            TextStyle(color: Color(0xFFE4626F), fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) =>
                              const Welcomepage()), // Replace LoginScreen with your login page widget.
                      (Route<dynamic> route) =>
                          false, // Remove all the previous routes.
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Delete Account',
                    style: TextStyle(color: Color(0xFF5355D0), fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        );
      },
    );
  }

  // Controller for the search bar
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            Container(
              constraints: const BoxConstraints(
                maxWidth: 40,
                maxHeight: 40,
              ),
              child: Image.asset(
                'assets/setting.png',
                fit: BoxFit.contain,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFF1F1F1),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 15),
                TextField(
                  controller: searchController,
                  onChanged: _filterSettings, // Filter when text changes
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Search Here...',
                    labelStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  // padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      // Dynamically generated list of settings options based on search query
                      ...filteredSettingOptions.map((setting) {
                        if (setting.text == 'Notifications' ||
                            setting.text == 'Reward Points Management' ||
                            setting.text == 'Location') {
                          return Column(
                            children: [
                              SettingOption(
                                imagePath: setting.imagePath,
                                text: setting.text,
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => setting.route));
                                },
                              ),
                              const SizedBox(height: 40),
                              const Divider(
                                color: Color(0xfff1eeee),
                                height: 0.1,
                              ),
                              const SizedBox(height: 40),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              SettingOption(
                                imagePath: setting.imagePath,
                                text: setting.text,
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => setting.route));
                                },
                              ),
                              const SizedBox(height: 40),
                            ],
                          );
                        }
                      }).toList(),
                      SettingOption(
                        imagePath: 'assets/svg/remove-user.svg',
                        text: 'Delete Account',
                        onTap: _showDeleteAccountDialog,
                      ),
                      const SizedBox(height: 50),
                      SettingOption(
                        imagePath: 'assets/svg/material-symbols_logout.svg',
                        text: 'Logout',
                        onTap: _showGpsPermissionDialog,
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingOptionData {
  final String imagePath;
  final String text;
  final Widget route;

  SettingOptionData(
      {required this.imagePath, required this.text, required this.route});
}

class SettingOption extends StatelessWidget {
  final String imagePath;
  final String text;
  final VoidCallback onTap;
  final double imageSize;

  const SettingOption({
    Key? key,
    required this.imagePath,
    required this.text,
    required this.onTap,
    this.imageSize = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            SvgPicture.asset(
              imagePath,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
            ),
            // Image.asset(
            //   imagePath,
            //   width: imageSize,
            //   height: imageSize,
            //   fit: BoxFit.cover,
            // ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 18.5),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }
}
