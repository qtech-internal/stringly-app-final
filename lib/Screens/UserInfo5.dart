import 'package:flutter/material.dart';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stringly/constants/globals.dart';
import 'package:stringly/intraction.dart';
import 'package:stringly/models/image_field_url_to_update.dart';
import 'package:stringly/models/store_image_model.dart';
import 'package:stringly/models/user_input_params.dart';
import '../Reuseable Widget/gradienttextfield.dart';
import '../models/update_user_account_model.dart';
import 'loaders/request_process_loader.dart';
import 'mainScreenNav.dart';
import 'ImageBioEdit/ImageBio.dart';
import 'ProfilerSet/ProfileSet0.dart';

class UserPreferenceScreen extends StatefulWidget {
  @override
  _UserPreferenceScreenState createState() => _UserPreferenceScreenState();
}

class _UserPreferenceScreenState extends State<UserPreferenceScreen> {
  bool checkUserSkip = false;
  double _ageRangeStart = 18;
  double _ageRangeEnd = 80;
  double _distance = 1;
  String? userSelectedPreference;
  final SingleValueDropDownController _preferenceController =
      SingleValueDropDownController();
  final List<String> _preferenceOptions = [
    'Male',
    'Female',
    'Other',
    'I am open to dating everyone'
  ];
  UserInputParams userInputParams = UserInputParams();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 50,
            left: 20,
            right: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Successful',
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontSize: 19,
                        color: Color(
                            0xFFD83694), // The color is overridden by the gradient
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageBioScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Progress Indicator Text
              Row(
                children: [
                  const SizedBox(
                      height: 25,
                      width: 25,
                      child:
                          Image(image: AssetImage('assets/check_circle.png'))),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFD83694), Color(0xFF0039C7)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                    child: Text(
                      '4',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          color: Colors.white, // Overridden by gradient
                        ),
                      ),
                    ),
                  ),
                  Text(
                    ' of 4 steps completed',
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) {
                  return Expanded(
                    child: Container(
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: (index <=
                                3) // Apply continuous gradient to the first 3 boxes
                            ? LinearGradient(
                                colors: [
                                  Color.lerp(const Color(0xFFD83694),
                                      const Color(0xFF0039C7), index / 3)!,
                                  Color.lerp(
                                      const Color(0xFFD83694),
                                      const Color(0xFF0039C7),
                                      (index + 1) / 3)!,
                                ],
                              )
                            : LinearGradient(
                                colors: [
                                  Colors.grey[300]!,
                                  Colors.grey[300]!
                                ], // Grey for the last box
                              ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 26.88),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Your Preference',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset('assets/reward.png'),
                      ),
                      const Text(
                        '+1',
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 35,
              ),
              // Replace the DropdownButton with DropDownTextField
              GradientdropdownTextField(
                hintText: 'Select your preference',
                items: _preferenceOptions,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      userSelectedPreference = value?.value;
                    });
                  }
                },
                label: const Text('Who would you prefer to date?'),
              ),

              const SizedBox(height: 20),
              const Text(
                'Specify the age range',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Lower Value
                  Text(
                    '${_ageRangeStart.round()}',
                    key: ValueKey(_ageRangeStart), // Unique key for animation
                    style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500),
                  ),

                  // Upper Value
                  Text(
                    '${_ageRangeEnd.round()}',
                    key: ValueKey(_ageRangeEnd), // Unique key for animation
                    style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),

              // The GradientRangeSlider widget
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: GradientRangeSlider(
                        lowerValue: _ageRangeStart,
                        upperValue: _ageRangeEnd,
                        minValue: 18,
                        maxValue: 80,
                        onChanged: (RangeValues values) {
                          setState(() {
                            _ageRangeStart = values.start;
                            _ageRangeEnd = values.end;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                'Specify the distance bound',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),

              const SizedBox(
                width: 260,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${_distance.round()} km', // Display value in km with brackets
                  key: ValueKey(_distance), // Unique key for animation
                  style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500),
                ),
              ), // End of Row for Distance Display

              // Distance Bound Slider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    // Gradient Slider
                    Expanded(
                      child: GradientSlider(
                        value: _distance,
                        onChanged: (double value) {
                          setState(() {
                            _distance = value; // Update the distance value
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ), // End of Row for Distance Slider

              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Increased size of both buttons equally
                  Expanded(
                    child: SizedBox(
                      height: 50, // Adjust height as needed
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.black),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        onPressed: () {
                          if (checkUserSkip == true) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Mainscreennav()));
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Back'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8), // Spacing between buttons
                  Expanded(
                    child: SizedBox(
                      height: 50, // Adjust height as needed
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        onPressed: () {
                          userInputParams.updateField(
                              'preferToDate', userSelectedPreference);
                          userInputParams.updateField(
                              'minPreferredAge', _ageRangeStart.round());
                          userInputParams.updateField(
                              'maxPreferredAge', _ageRangeEnd.round());
                          userInputParams.updateField(
                              'distanceBound', _distance.round());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageBioScreen(),
                            ),
                          );
                        },
                        child: const Text('Next'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              )
            ],
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

    final Paint gradientStrokePaint = Paint()
      ..shader = LinearGradient(
        colors: gradientColors,
      ).createShader(Rect.fromCircle(center: center, radius: thumbRadius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint solidCirclePaint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, thumbRadius, gradientStrokePaint);

    canvas.drawCircle(center, thumbRadius - strokeWidth / 2, solidCirclePaint);
  }
}

class GradientSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const GradientSlider({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 6,
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
        thumbColor: Colors.white,
        showValueIndicator: ShowValueIndicator.never,
      ),
      child: Slider(
        value: value,
        min: 1,
        max: 100,
        divisions: 99,
        label: '${value.round()} km',
        onChanged: onChanged,
      ),
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

    Paint inactivePaint = Paint()..color = sliderTheme.inactiveTrackColor!;
    context.canvas.drawRect(trackRect, inactivePaint);

    final double value = (thumbCenter.dx - trackRect.left) / trackRect.width;
    final Rect activeTrackRect = Rect.fromLTRB(
      trackRect.left,
      trackRect.top,
      trackRect.left + (value * trackRect.width),
      trackRect.bottom,
    );

    const Gradient gradient = LinearGradient(
      colors: [Color(0xFFD83694), Color(0xFF0039C7)],
    );

    final Paint activePaint = Paint()
      ..shader = gradient.createShader(activeTrackRect);

    context.canvas.drawRect(activeTrackRect, activePaint);
  }
}

class GradientRangeTrackShape extends RangeSliderTrackShape {
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
    required TextDirection textDirection,
    required Offset startThumbCenter,
    required Offset endThumbCenter,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    if (sliderTheme.trackHeight == 0) {
      return;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Paint inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor!;
    context.canvas.drawRect(trackRect, inactivePaint);

    final double startValue =
        (startThumbCenter.dx - trackRect.left) / trackRect.width;
    final double endValue =
        (endThumbCenter.dx - trackRect.left) / trackRect.width;

    final Rect activeTrackRect = Rect.fromLTRB(
      trackRect.left + (startValue * trackRect.width),
      trackRect.top,
      trackRect.left + (endValue * trackRect.width),
      trackRect.bottom,
    );

    const Gradient gradient = LinearGradient(
      colors: [Color(0xFFD83694), Color(0xFF0039C7)],
    );

    final Paint activePaint = Paint()
      ..shader = gradient.createShader(activeTrackRect);

    context.canvas.drawRect(activeTrackRect, activePaint);
  }
}

class GradientRangeSlider extends StatelessWidget {
  final double lowerValue;
  final double upperValue;
  final double minValue;
  final double maxValue;
  final ValueChanged<RangeValues> onChanged;

  const GradientRangeSlider({
    super.key,
    required this.lowerValue,
    required this.upperValue,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 6,
        rangeThumbShape: const GradientRangeThumbShape(
          thumbRadius: 10.0,
          strokeWidth: 3.0,
          gradientColors: [
            Color(0xFFD83694),
            Color(0xFF0039C7),
          ],
        ),
        //   overlayShape: const RoundRangeSliderOverlayShape(overlayRadius: 20),
        inactiveTrackColor: Colors.grey[300],
        rangeTrackShape: GradientRangeTrackShape(),
        thumbColor: Colors.white,
        showValueIndicator: ShowValueIndicator.never,
      ),
      child: RangeSlider(
        values: RangeValues(lowerValue, upperValue),
        min: minValue,
        max: maxValue,
        divisions: (maxValue - minValue).toInt(),
        labels: RangeLabels('${lowerValue.round()}', '${upperValue.round()}'),
        onChanged: onChanged,
      ),
    );
  }
}

class GradientRangeThumbShape extends RangeSliderThumbShape {
  final double thumbRadius;
  final double strokeWidth;
  final List<Color> gradientColors;

  const GradientRangeThumbShape({
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
    bool isDiscrete = false,
    bool isEnabled = false,
    bool isOnTop = false,
    TextDirection? textDirection,
    required SliderThemeData sliderTheme,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final Canvas canvas = context.canvas;

    final Paint gradientStrokePaint = Paint()
      ..shader = LinearGradient(
        colors: gradientColors,
      ).createShader(Rect.fromCircle(center: center, radius: thumbRadius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint solidFillPaint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, thumbRadius, gradientStrokePaint);

    canvas.drawCircle(center, thumbRadius - strokeWidth / 2, solidFillPaint);
  }
}
