// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioPath;
  final bool isSender;
  final Map<String, dynamic> message;

  const AudioPlayerWidget({
    Key? key,
    required this.audioPath,
    required this.isSender,
    required this.message,
  }) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final FlutterSoundPlayer _audioPlayer = FlutterSoundPlayer();
  StreamSubscription? _playerSubscription;
  bool _isPlaying = false;
  bool _isLoading = false;
  double _currentPosition = 0.0;
  double _duration = 0.0;
  double _totalTime = 0.0;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      await _audioPlayer.openPlayer();
      await _audioPlayer
          .setSubscriptionDuration(const Duration(milliseconds: 100));

      FFprobeKit.getMediaInformation(widget.audioPath).then((session) async {
        final info = session.getMediaInformation();
        String? durationString = info?.getDuration();

        if (durationString != null) {
          double? durationInSeconds = double.tryParse(durationString);
          if (durationInSeconds != null && mounted) {
            setState(() {
              _totalTime = durationInSeconds;
            });
          }
        }

        if (mounted) {
          setState(() {
            _isPlayerReady = true;
          });
        }
      });
    } catch (e) {
      print('Error initializing audio player: $e');
    }
  }

  void _updatePosition(Duration position, Duration duration) {
    setState(() {
      _currentPosition = position.inMilliseconds / 1000.0;
      _duration = duration.inMilliseconds / 1000.0;
    });
  }

  Future<void> _startPlaying() async {
    if (!_isPlayerReady || _isPlaying) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _playerSubscription?.cancel();

      await _audioPlayer.startPlayer(
        fromURI: widget.audioPath,
        codec: Codec.aacADTS,
        whenFinished: () {
          setState(() {
            _isPlaying = false;
            _currentPosition = 0.0;
          });
        },
      );

      // Set up position tracking
      _playerSubscription = _audioPlayer.onProgress?.listen(
        (event) {
          _updatePosition(event.position, event.duration);
        },
        onError: (error) {
          print('Error tracking position: $error');
        },
      );

      setState(() {
        _isPlaying = true;
        _isLoading = false;
      });
    } catch (e) {
      print('Error playing audio: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _stopPlaying() async {
    if (!_isPlaying) return;

    try {
      await _playerSubscription?.cancel();
      await _audioPlayer.stopPlayer();

      setState(() {
        _isPlaying = false;
        _currentPosition = 0.0;
      });
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }

  Future<void> _togglePlaying() async {
    if (_isPlaying) {
      await _stopPlaying();
    } else {
      await _startPlaying();
    }
  }

  String _formatDuration(double seconds) {
    Duration duration = Duration(seconds: seconds.toInt());
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  @override
  void dispose() {
    _playerSubscription?.cancel();
    _audioPlayer.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      child: Row(
        mainAxisAlignment:
            widget.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 2,
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color:
                      widget.isSender ? Colors.black : const Color(0xffE6E6E6),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomLeft: widget.isSender
                        ? const Radius.circular(12)
                        : Radius.zero,
                    bottomRight: widget.isSender
                        ? Radius.zero
                        : const Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _togglePlaying,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: widget.isSender
                                ? Colors.white.withOpacity(0.2)
                                : Colors.black.withOpacity(0.1),
                            child: _isLoading
                                ? CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      widget.isSender
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  )
                                : Icon(
                                    _isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: widget.isSender
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: _duration > 0
                                  ? _currentPosition / _duration
                                  : 0.0,
                              backgroundColor: widget.isSender
                                  ? Colors.white.withOpacity(0.2)
                                  : Colors.black.withOpacity(0.1),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                widget.isSender ? Colors.white : Colors.black,
                              ),
                              minHeight: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(_totalTime),
                          style: TextStyle(
                            fontSize: 12,
                            color: widget.isSender
                                ? Colors.white.withOpacity(0.7)
                                : Colors.black.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          _formatDuration(_currentPosition),
                          style: TextStyle(
                            fontSize: 12,
                            color: widget.isSender
                                ? Colors.white.withOpacity(0.7)
                                : Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        widget.message['timestamp'] ?? '',
                        style: TextStyle(
                          color: widget.isSender
                              ? const Color(0xffFAFAFA)
                              : const Color(0xff0B0A0A),
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
