import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_icp_auth/authentication/login.dart';
import 'package:flutter_icp_auth/internal/url_listener.dart';
import 'package:get/get.dart';
import 'package:stringly/GetxControllerAndBindings/initialBindings.dart';
import 'package:stringly/Reuseable%20Widget/snackbar/custom_snack_bar.dart';
import 'package:stringly/Screens/error/technicalError.dart';
import 'package:stringly/Screens/loaders/first_loader.dart';
import 'package:stringly/StorageServices/get_storage_service.dart';
import 'package:stringly/constants/globals.dart';
import 'package:stringly/intraction.dart';

import './notifications/NotificationService.dart';
import 'Reuseable Widget/Routes/app_routes.dart';
import 'Screens/UserInfo1.dart';
import 'StorageServices/delete_all_cache_on_update.dart';
import 'integration.dart';

import 'package:flutter/material.dart';
import 'package:agent_dart/agent_dart.dart';
import 'Screens/mainScreenNav.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await clearCacheOnUpdate();
  await dotenv.load();
  await FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  await GetStorage.init();
  await NotificationService.initialize();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['FIREBASE_API_KEY']!,
      appId: dotenv.env['FIREBASE_APP_ID']!,
      messagingSenderId: dotenv.env['FIREBASE_MESSAGE_SENDER_ID']!,
      projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
      storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET_ID']!,
    ),
  );

  runApp(MyApp());
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Stringly',
      initialBinding: AllBindings(),
      theme: ThemeData(
        fontFamily: 'SFProDisplay', // Set default font family here
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white, // Set global AppBar color
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: Colors.white, // Set popup menu background color
          textStyle:
              TextStyle(color: Colors.black), // Set popup menu text color
        ),
      ),
      navigatorKey: GlobalConstant.navigatorKey,
      initialRoute:
          AppPages.initial, // Set the initial route for GetX navigation
      getPages: AppPages.routes, // Register your routes with GetX
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToWelcomePage();
      }
    });
  }

  void _navigateToWelcomePage() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const Welcomepage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var fadeAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );
          return FadeTransition(opacity: fadeAnimation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Image.asset(
            'assets/newImage/COLOURED LOGO.png',
            width: 174,
            height: 46.76,
          ),
        ),
      ),
    );
  }
}

class Welcomepage extends StatefulWidget {
  const Welcomepage({super.key});

  @override
  State<Welcomepage> createState() => _WelcomepageState();
}

class _WelcomepageState extends State<Welcomepage>
    with SingleTickerProviderStateMixin {
  bool isLoggedIn = false;
  late bool? checkUser;
  String _principalId = "Log in to see your principal";

  // ---------------------------------------------------
  // Must declare these in your application
  // ---------------------------------------------------
  bool isLocal = GlobalConstant.isLocal;
  Service idlService = FieldsMethod.idl;
  String backendCanisterId = GlobalConstant.backendCanisterId;
  String middlePageCanisterId = GlobalConstant.middlePageCanisterId;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // update checkUser value
  Future<void> _checkUser() async {
    try {
      final result = await Intraction.checkNewUser();
      if (result.containsKey('response')) {
        final value = result['response'];
        bool userType = value.containsKey('Ok');
        setState(() {
          checkUser = userType;
        });
      } else {
        Get.off(const TechnicalError());
      }
    } catch (e) {
      Get.off(const TechnicalError());
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(begin: 1.1, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _controller.forward();
      });
    });

    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    debugPrint("Starting login check...");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirstLoader.openLoadingDialog();
      if (!StorageService.hasData('FirstTimeOpeningThisApp')) {
        FirstLoader.stopLoading();
      }
    });

    // Perform the login check asynchronously
    bool loggedIn =
        await AuthLogIn.checkLoginStatus(isLocal, backendCanisterId);
    debugPrint("Login status from checkLoginStatus: $loggedIn");

    // If the widget is still part of the widget tree, update the state
    if (mounted) {
      setState(() {
        isLoggedIn = loggedIn;
      });

      // After setting the login status, navigate based on the login state
      if (isLoggedIn) {
        // Navigate based on user check
        // start loader
        // FirstLoader.openLoadingDialog();
        await _checkUser();

        if (checkUser != null && checkUser!) {
          debugPrint(
              "Navigating directly to Mainscreennav (without AnimatedSplashScreen)");
          // stop loader

          if (StorageService.hasData('FirstTimeOpeningThisApp'))
            FirstLoader.stopLoading();

          Get.off(Mainscreennav());
        } else {
          debugPrint("Navigating to Userinfo1 screen");
          // stop loader
          if (StorageService.hasData('FirstTimeOpeningThisApp'))
            FirstLoader.stopLoading();

          Get.off(Userinfo1());
        }
      } else {
        // If not logged in, set up manual login
        if (StorageService.hasData('FirstTimeOpeningThisApp'))
          FirstLoader.stopLoading();

        debugPrint("User not logged in. Setting up manual login listener.");
        UrlListener.initListener(_manualLogin);
      }
    }
  }

  Future<void> _manualLogin(Uri uri) async {
    debugPrint("Manual login triggered with URI: ${uri.toString()}");
    if (!StorageService.hasData('FirstTimeOpeningThisApp')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FirstLoader.openLoadingDialog();
      });
    } else {
      FirstLoader.openLoadingDialog();
    }
    List<dynamic> result = await AuthLogIn.fetchAgent(
        uri.queryParameters, isLocal, backendCanisterId, idlService);

    if (result.isNotEmpty) {
      // Ensure we are calling setState only after the build process
      // start loader

      if (mounted) {
        Intraction.actor = AuthLogIn.getActor(
            Intraction.backendCanisterId, Intraction.idleService);
        await _checkUser();

        setState(() {
          isLoggedIn = uri.queryParameters['status'] == "true";
          _principalId = result[0];

          // Only navigate if successfully logged in
          if (isLoggedIn) {
            debugPrint("Manual login successful, principal ID: $_principalId");

            if (checkUser != null && checkUser!) {
              debugPrint("Navigating directly to Mainscreennav (manual login)");
              // stop loader
              FirstLoader.stopLoading();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Mainscreennav(),
                ),
              );
            } else {
              debugPrint("Navigating to Userinfo1 screen (manual login)");
              // stop loader
              FirstLoader.stopLoading();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Userinfo1()),
              );
            }
          } else {
            debugPrint("Manual login failed, user not logged in.");
            // stop loader
            FirstLoader.stopLoading();
            _principalId = "Log in to see your principal";
            CustomSnackbar.errorSnackbar(
                message: 'Login failed, Please try again...');
          }
        });
      }
    } else {
      FirstLoader.stopLoading();
      CustomSnackbar.errorSnackbar(
          message: 'Login failed, Please try again...');
    }
  }

  @override
  void dispose() {
    UrlListener.cancelListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.39),
            ScaleTransition(
              scale: _scaleAnimation,
              child: Image.asset(
                'assets/newImage/COLOURED LOGO.png',
                width: 174,
                height: 46.76,
              ),
            ),
            const SizedBox(height: 5),
            FadeTransition(
              opacity: _fadeAnimation,
              child: const Text(
                'String your vibe.',
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontSize: 14,
                  color: Color(0xFF000000),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.15),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 13, right: 13),
                child: SizedBox(
                  width: 276,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      StorageService.write('FirstTimeOpeningThisApp', 'No');

                      if (!isLoggedIn) {
                        await AuthLogIn.authenticate(
                            isLocal,
                            middlePageCanisterId,
                            "exampleCallback",
                            "example");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 19, vertical: 15),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sign Up with Internet Identity',
                          style: TextStyle(
                              fontFamily: 'SFProDisplay',
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            const SizedBox(height: 10,),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                const Text('By signing up, you agree to our '),
                InkWell(
                  onTap: () async {
                    final Uri _url = Uri.parse("https://stringly.net/guidelines/termsofuse");
                    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
                      throw Exception('Could not launch $_url');
                    }
                  },
                  child: const Text(
                    'Terms.',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
                const Text(' See how we use your data in our '),
                InkWell(
                  onTap: () async {
                    final Uri _url = Uri.parse("https://stringly.net/privacy");
                    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
                      throw Exception('Could not launch $_url');
                    }
                  },
                  child: const Text(
                    'Privacy Policy.',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8,)
          ],
        ),
      ),
    );

    // return Scaffold(
    //     backgroundColor: Colors.white,
    //     body: SingleChildScrollView(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    // SizedBox(height: MediaQuery.of(context).size.height * 0.4),
    //           Column(
    //             children: [
    //               const Center(
    //                 child: Image(
    //                   image: AssetImage('assets/newImage/COLOURED LOGO.png'),
    //                   width: 174,
    //                   height: 46.19,
    //                 ),
    //               ),
    //               const SizedBox(height: 5),
    //               const Text(
    //                 'String your vibe.',
    //                 style: TextStyle(
    //                   fontFamily: 'SFProDisplay',
    //                   fontSize: 14,
    //                   color: Color(0xFF000000),
    //                 ),
    //               ),
    //               SizedBox(height: MediaQuery.of(context).size.height * 0.15),
    //               Padding(
    //                 padding:
    //                     const EdgeInsets.only(bottom: 200, left: 13, right: 13),
    //                 child: SizedBox(
    //                   width: 276,
    //                   height: 50,
    //                   child: ElevatedButton(
    //                     onPressed: () async {
    //                       StorageService.write('FirstTimeOpeningThisApp', 'No');

    //                       if (!isLoggedIn) {
    //                         await AuthLogIn.authenticate(
    //                             isLocal,
    //                             middlePageCanisterId,
    //                             "exampleCallback",
    //                             "example");
    //                       }
    //                     },
    //                     style: ElevatedButton.styleFrom(
    //                       padding: const EdgeInsets.symmetric(
    //                           horizontal: 19, vertical: 15),
    //                       backgroundColor: Colors.black,
    //                       shape: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(10),
    //                       ),
    //                     ),
    //                     child: const Row(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: [
    //                         Text(
    //                           'Sign Up with Internet Identity',
    //                           style: TextStyle(
    //                               fontFamily: 'SFProDisplay',
    //                               fontSize: 14,
    //                               color: Colors.white,
    //                               fontWeight: FontWeight.w500),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ));
  }
}
