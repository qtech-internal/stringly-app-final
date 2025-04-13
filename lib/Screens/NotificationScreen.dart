import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  double _messagesVolume = 50; // Initial volume value for Messages
  double _matchesVolume = 50; // Initial volume value for Matches

  // Push Notification Toggles
  bool _newMatchesPushEnabled = false;
  bool _likesPushEnabled = false;
  bool _messagesPushEnabled = false;
  bool _offersPushEnabled = false;
  bool _appUpdatesPushEnabled = false;
  bool _profileBoostPushEnabled = false;

  // Email Notification Toggles
  bool _newMatchesEmailEnabled = false;
  bool _offersEmailEnabled = false;
  bool _appUpdatesEmailEnabled = false;
  final AudioPlayer _messagesAudioPlayer = AudioPlayer();
  final AudioPlayer _matchesAudioPlayer = AudioPlayer();

  void _playSound(double volume, String type) async {
    if (type == 'messages') {
      await _messagesAudioPlayer.setVolume(volume / 100);
      await _messagesAudioPlayer.play(AssetSource('sound/sound.mp3')); // Replace with your message sound file
    } else if (type == 'matches') {
      await _matchesAudioPlayer.setVolume(volume / 100);
      await _matchesAudioPlayer.play(AssetSource('sound/match.mp3')); // Replace with your match sound file
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        leadingWidth: 45,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: const BoxConstraints(
                maxWidth: 40,
                maxHeight: 40,
              ),
              child: Image.asset(
                'assets/notificationicon.png',
                fit: BoxFit.contain,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 15),
            const Text(
              'Notifications',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            const Text(
              'Messages',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Vibrate',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Default',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 20),
            const Text(
              'Sound',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildGradientSlider(_messagesVolume, (value) {
              setState(() {
                _messagesVolume = value;
              });
              _playSound(_messagesVolume, 'messages'); // Play sound for messages
            }),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 10),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 12),
            const Text(
              'Matches',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Vibrate',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Default',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 20),
            const Text(
              'Sound',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildGradientSlider(_matchesVolume, (value) {
              setState(() {
                _matchesVolume = value;
              });
              _playSound(_matchesVolume, 'matches'); // Play sound for matches
            }),
            const SizedBox(height: 10),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              'Push Notifications',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            const SizedBox(height: 25),
            const Text(
              'Notification tone',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Default',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 25),
            _buildToggleRow(
              'New Matches',
              'Play sound for new matches',
              _newMatchesPushEnabled,
                  (value) => setState(() => _newMatchesPushEnabled = value),
            ),
            const SizedBox(height: 20),
            _buildToggleRow(
              'Likes',
              'Play sound for likes',
              _likesPushEnabled,
                  (value) => setState(() => _likesPushEnabled = value),
            ),
            const SizedBox(height: 20),
            _buildToggleRow(
              'Messages',
              'Play sound for messages',
              _messagesPushEnabled,
                  (value) => setState(() => _messagesPushEnabled = value),
            ),
            const SizedBox(height: 20),
            _buildToggleRow(
              'Profile Boost',
              'Play sound for Profile Boost',
              _profileBoostPushEnabled,
                  (value) => setState(() => _profileBoostPushEnabled = value),
            ),
            const SizedBox(height: 30),
            Container(height: 1, color: Colors.grey[300]),
            const SizedBox(height: 24),
            const Text(
              'Email Notifications',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            const SizedBox(height: 25),
            const Text(
              'Notification tone',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Default',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 25),
            _buildToggleRow(
              'New Matches',
              'Play sound for new matches',
              _newMatchesEmailEnabled,
                  (value) => setState(() => _newMatchesEmailEnabled = value),
            ),
            const SizedBox(height: 20),
            _buildToggleRow(
              'Offers',
              'Play sound for offers',
              _offersEmailEnabled,
                  (value) => setState(() => _offersEmailEnabled = value),
            ),
            const SizedBox(height: 20),
            _buildToggleRow(
              'App Updates',
              'Play sound for app Updates',
              _appUpdatesEmailEnabled,
                  (value) => setState(() => _appUpdatesEmailEnabled = value),
            ),
            const SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGradientSlider(double volume, ValueChanged<double> onChanged) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 4,
        // Reduced thickness
        // thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        thumbShape: const GradientThumbShape(
          thumbRadius: 10.0,
          strokeWidth: 3.0,
          gradientColors: [
            Color(0xFFD83694),
            Color(0xFF0039C7),
          ],
        ),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
        activeTrackColor: Colors.transparent,
        inactiveTrackColor: Colors.grey[300],
        trackShape: GradientTrackShape(),
        thumbColor: Colors.white, // Set thumb color to white
      ),
      child: Slider(
        value: volume,
        min: 0,
        max: 100,
        divisions: 100,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildToggleRow(String title, String subtitle, bool switchValue,
      ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        CustomToggleButton(
          initialValue: switchValue,
          onToggle: (value) {
            setState(() {
              switchValue = value;
            });
          },
        ),
        // Switch(
        //   value: switchValue,
        //   onChanged: onChanged,
        //   activeColor: Colors.white,
        //   // Thumb color when active
        //   activeTrackColor: Colors.black,
        //   // Track color when active
        //   inactiveThumbColor: Colors.white,
        //   // Thumb color when inactive
        //   inactiveTrackColor: Color(0xFFD2D5DA), // Track color when inactive
        // ),
      ],
    );
  }

}

class GradientTrackShape extends SliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 2;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
      PaintingContext context,
      Offset offset, {
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required Animation<double> enableAnimation,
        required Offset thumbCenter,
        Offset? secondaryOffset,
        bool isEnabled = false,
        bool isDiscrete = false,
        required TextDirection textDirection,
      }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
    );

    // Paint the inactive track
    Paint inactivePaint = Paint()..color = sliderTheme.inactiveTrackColor!;
    context.canvas.drawRect(trackRect, inactivePaint);

    // Paint the active track with gradient
    final double value = (thumbCenter.dx - trackRect.left) / trackRect.width;
    final Rect activeTrackRect = Rect.fromLTRB(
      trackRect.left,
      trackRect.top,
      trackRect.left + (value * trackRect.width),
      trackRect.bottom,
    );

    // Create gradient
    final Gradient gradient = LinearGradient(
      colors: [Color(0xffD83694), Color(0xff0039C7)],
    );

    final Paint activePaint = Paint()
      ..shader = gradient.createShader(activeTrackRect);

    context.canvas.drawRect(activeTrackRect, activePaint);
  }
}

class CustomToggleButton extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onToggle;

  const CustomToggleButton({
    Key? key,
    required this.initialValue,
    required this.onToggle,
  }) : super(key: key);

  @override
  _CustomToggleButtonState createState() => _CustomToggleButtonState();
}

class _CustomToggleButtonState extends State<CustomToggleButton> {
  late bool _isToggled;

  @override
  void initState() {
    super.initState();
    _isToggled = widget.initialValue;
  }

  void _toggleSwitch() {
    setState(() {
      _isToggled = !_isToggled;
    });
    widget.onToggle(_isToggled);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleSwitch,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 60,
        height: 30,
        decoration: BoxDecoration(
          color: _isToggled ? Colors.black : Color(0xFFD2D5DA),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Align(
            alignment:
            _isToggled ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GradientThumbShape extends SliderComponentShape {
  final double thumbRadius;
  final double strokeWidth;
  final List<Color> gradientColors;

  const GradientThumbShape({
    this.thumbRadius = 12.0,
    this.strokeWidth = 2.0,
    required this.gradientColors,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;

    // Paint gradient stroke
    final Paint gradientStrokePaint = Paint()
      ..shader = LinearGradient(
        colors: gradientColors,
      ).createShader(Rect.fromCircle(center: center, radius: thumbRadius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Paint solid inner circle
    final Paint solidCirclePaint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.white
      ..style = PaintingStyle.fill;

    // Draw the thumb
    canvas.drawCircle(
        center, thumbRadius - strokeWidth / 2, gradientStrokePaint);
    canvas.drawCircle(center, thumbRadius - strokeWidth, solidCirclePaint);
  }
}
