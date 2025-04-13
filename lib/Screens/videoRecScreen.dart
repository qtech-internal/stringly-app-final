import 'dart:async';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stringly/models/user_input_params.dart';
import 'package:video_player/video_player.dart';

import 'dart:io';

import '../StorageServices/video_compress_and_upload.dart';
import 'UserInfo3.dart';

class VideoRecordingScreen extends StatefulWidget {
  @override
  _VideoRecordingScreenState createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen> {
  CameraController? _cameraController;
  Timer? _timer;
  int _elapsedTime = 0; // in seconds
  late List<CameraDescription> cameras;
  bool isRecording = false;
  String? _videoPath;
  bool _isPreviewing = false;
  bool _stepTwoComplete = false; // Track if step 2 is complete
  VideoPlayerController? _videoController;
  bool isVideoUploading = false;
  int buttonClickTimes = 0;

  List<int> _randomNumbers = [];

  // fill number in box
  int getRandomNumber() {
    Random random = Random();
    return random
        .nextInt(10); // This will generate a random number between 0 and 9
  }

  Widget _buildNumberDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          _randomNumbers.map((num) => _buildNumberBox(num.toString())).toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _randomNumbers = List.generate(3, (index) => getRandomNumber());
    _initializeCamera();
  }

  Future<void> _requestPermissions() async {
    PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      print("Storage permission granted!");
    } else if (status.isDenied) {
      print(
          "Storage permission denied. Please grant permission from settings.");
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
    if (Platform.isAndroid &&
        await Permission.manageExternalStorage.isGranted) {
      print("Manage external storage permission granted.");
    } else if (Platform.isAndroid &&
        !await Permission.manageExternalStorage.isGranted) {
      await Permission.manageExternalStorage.request();
    }
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
    );

    await _cameraController?.initialize();
    setState(() {});
  }

  Future<void> _startRecording() async {
    if (!_cameraController!.value.isRecordingVideo) {
      await _cameraController?.startVideoRecording();
      setState(() {
        _randomNumbers = List.generate(3, (index) => getRandomNumber());
        isRecording = true;
        _elapsedTime = 0; // Reset elapsed time
      });

      // Start the timer
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          _elapsedTime++; // Increment elapsed time
        });
      });
    }
  }

  Future<void> _stopRecording() async {
    if (_cameraController!.value.isRecordingVideo) {
      final videoFile = await _cameraController?.stopVideoRecording();
      _videoPath = videoFile?.path;
      setState(() {
        isRecording = false;
      });
      print("Video recorded to: $_videoPath");

      // Stop the timer
      _timer?.cancel();
    }
  }

  Future<void> _previewVideo() async {
    if (_videoPath != null && File(_videoPath!).existsSync()) {
      _videoController?.dispose();
      _videoController = VideoPlayerController.file(File(_videoPath!));

      await _videoController!.initialize();

      _videoController?.play();

      setState(() {
        _isPreviewing = true;
      });
    } else {
      print("Video file not found at $_videoPath");
    }
  }

  void _showProofOfHumanityDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildProofOfHumanityDialog(context);
      },
    );
    setState(() {
      _stepTwoComplete = true; // Mark step 2 as complete
    });
  }

  // video upload url
  Future<void> _uploadVideo() async {
    if (_videoPath == null) {
      print("No video to upload.");
      return;
    }
    bool waitingScreen = buttonClickTimes > 1 ? true : false;
    if (isVideoUploading & waitingScreen) {
      _showProofOfHumanityDialog();
      return;
    }

    _showUploadingDialog(context);

    File videoFile = File(_videoPath!);
    final result =
        await VideoUploadAndGetUrl.uploadVideoAndGetUrl(videoFile: videoFile);

    if (result.containsKey('Ok')) {
      print("Video URL: ${result['Ok']}");
      UserInputParams userInputParams = UserInputParams();
      userInputParams.updateField('videolink', result['Ok'].toString());
      userInputParams.updateField('verified', true);
      _dismissDialog(context);
      _showSuccessDialog(context);
      Future.delayed(const Duration(seconds: 1));
      _dismissDialog(context);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => UserInfo3()),
        ModalRoute.withName('/userinfo2'),
      );
    } else {
      print("Error: ${result['Err']}");
      _dismissDialog(context);
      _showErrorDialog(context);
      Future.delayed(const Duration(seconds: 1));
      _dismissDialog(context);
      setState(() {
        buttonClickTimes = 0;
      });
    }
  }
// video upload url

  void _showUploadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _uploadingProcess(context);
      },
    );
  }

  void _dismissDialog(BuildContext context) {
    Navigator.of(context).pop(); // Dismiss the current dialog
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _buildProofOfHumanityOfSuccess(context);
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _buildProofOfError(context);
      },
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
        body: SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStepIndicator("1", isComplete: true),
                  const SizedBox(width: 10),
                  _buildDottedLine(),
                  const SizedBox(width: 10),
                  _buildStepIndicator("2", isComplete: _stepTwoComplete),
                ],
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 25.0, top: 5),
                    child: Text(
                      'Please record yourself saying\nthese numbers',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.22),
                  const Text(
                    'Confirm',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )
                ],
              ),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFE4E4E4)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: 300,
                          width: 250,
                          child: AspectRatio(
                            aspectRatio: 9 / 16,
                            child: CameraPreview(_cameraController!),
                          ),
                        ),
                        // Inside the build method
                        Positioned(
                          left: 20,
                          bottom: -10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                onPressed: isRecording || _videoPath == null
                                    ? null
                                    : _previewVideo, // Disable if recording
                                icon: const Text("Preview"),
                                label: Image.asset(
                                  'assets/cam.png',
                                  width: 24,
                                  height: 24,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              // Center the timer
                              Row(
                                children: [
                                  if (isRecording)
                                    Text(
                                      '${_elapsedTime}s',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  // Record button positioned at the left of the frame
                                  InkWell(
                                    onTap: isRecording
                                        ? _stopRecording
                                        : _startRecording,
                                    child: Image.asset(
                                      'assets/rec.png',
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    const Center(
                      child: Text(
                        "Record yourself saying the following numbers in order:",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildNumberDisplay(),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Container(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: _videoPath == null
                          ? null
                          : () {
                              setState(() {
                                buttonClickTimes++;
                              });
                              if (!isVideoUploading) {
                                setState(() {
                                  isVideoUploading = true;
                                });
                                _uploadVideo();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _videoPath == null ? Colors.grey : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (_isPreviewing && _videoController != null)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.8),
                child: Center(
                  child: AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  ),
                ),
              ),
            ),
          if (_isPreviewing)
            Positioned(
              top: 30,
              right: 30,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () {
                  setState(() {
                    _isPreviewing = false;
                    _videoController?.pause();
                  });
                },
              ),
            ),
        ],
      ),
    ));
  }

  Widget _buildStepIndicator(String step, {bool isComplete = false}) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: isComplete ? null : Border.all(color: Colors.grey, width: 2),
      ),
      child: isComplete
          ? ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [Color(0xFFD83694), Color(0xFF0039C7)],
                ).createShader(bounds);
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 2, color: Colors.white),
                ),
                alignment: Alignment.center,
                child: Text(
                  step,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            )
          : Center(
              child: Text(
                step,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }

  Widget _buildProofOfHumanityDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          height: 350,
          width: 250,
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  "Thank You for submitting.",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30),
                  child: Text(
                    "Your verification is in progress,Please check back soon.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.pushAndRemoveUntil(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => UserInfo3()),
                      //   ModalRoute.withName('/userinfo2'),
                      // );
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8), // Adjust this value for less rounding
                      ),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildProofOfHumanityOfSuccess(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          height: 350,
          width: 250,
          padding: const EdgeInsets.all(16),
          child: const SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                Image(image: AssetImage('assets/verified_transparent.png')),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Verified Successfully!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildProofOfError(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          height: 350,
          width: 250,
          padding: const EdgeInsets.all(16),
          child: const SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                Image(image: AssetImage('assets/verified_transparent.png')),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Error",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "We are facing some Technical Errors at the moment. Please wait a while.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _uploadingProcess(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          height: 350,
          width: 250,
          padding: const EdgeInsets.all(16),
          child: const SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                Image(
                  image: AssetImage('assets/loading_animation.gif'),
                  height: 170,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Please take a breathe",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildDottedLine() {
    return CustomPaint(
      size: Size(150, 2),
      painter: DottedLinePainter(),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;

    double dashWidth = 4, dashSpace = 4, startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

Widget _buildNumberBox(String number) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5.0),
    child: Container(
      width: 80,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          number,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}
