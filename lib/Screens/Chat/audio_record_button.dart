import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecordButton extends StatefulWidget {
  final Function(String) onAudioComplete;
  final int maxDuration;

  const AudioRecordButton({
    Key? key,
    required this.onAudioComplete,
    this.maxDuration = 60,
  }) : super(key: key);

  @override
  State<AudioRecordButton> createState() => _AudioRecordButtonState();
}

class _AudioRecordButtonState extends State<AudioRecordButton>
    with SingleTickerProviderStateMixin {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  int _recordingDuration = 0;
  Timer? _recordingTimer;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  Offset _startPosition = Offset.zero;
  bool _isRecorderInitialized = false;
  bool _showDeleteIcon = false;
  final double _cancelThreshold =
      50.0; // Threshold to detect significant movement

  @override
  void initState() {
    super.initState();
    _initRecorder();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    await _recorder.openRecorder();
    _isRecorderInitialized = true;
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _recorder.closeRecorder();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _startRecording(LongPressStartDetails details) async {
    if (!_isRecorderInitialized || _isRecording) return;

    _startPosition = details.globalPosition;

    String path = '${(await getTemporaryDirectory()).path}/audio_note.aac';

    try {
      await _recorder.startRecorder(
        toFile: path,
        codec: Codec.aacADTS,
      );

      setState(() {
        _isRecording = true;
        _recordingDuration = 0;
        _showDeleteIcon = false;
      });

      _animationController.forward();

      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _recordingDuration++;
        });

        if (_recordingDuration >= widget.maxDuration) {
          _stopRecording();
        }
      });
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording({bool cancelled = false}) async {
    if (!_isRecorderInitialized || !_isRecording) return;

    _recordingTimer?.cancel();
    _animationController.reverse();

    try {
      String? path = await _recorder.stopRecorder();

      if (path != null && !cancelled) {
        widget.onAudioComplete(path);
      }
    } catch (e) {
      print('Error stopping recording: $e');
    }

    setState(() {
      _isRecording = false;
      _recordingDuration = 0;
      _showDeleteIcon = false;
    });
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    if (!_isRecording) return;

    final offset = details.globalPosition - _startPosition;

    setState(() {
      _showDeleteIcon = offset.distance > _cancelThreshold;
    });
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isRecording)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.graphic_eq,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDuration(_recordingDuration),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),
        GestureDetector(
          onLongPressStart: _startRecording,
          onLongPressEnd: (details) =>
              _stopRecording(cancelled: _showDeleteIcon),
          onLongPressMoveUpdate: _onLongPressMoveUpdate,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: SizedBox(
              height: 45,
              width: 45,
              child: Icon(
                _showDeleteIcon
                    ? Icons.delete
                    : (_isRecording ? Icons.mic : Icons.mic_none),
                color: _isRecording ? Colors.red : Colors.black,
                size: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
