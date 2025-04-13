import 'package:flutter/material.dart';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stringly/Reuseable%20Widget/GradientWidget.dart';
import 'package:stringly/constants/globals.dart';
import 'package:stringly/intraction.dart';
import 'package:stringly/models/image_field_url_to_update.dart';
import 'package:stringly/models/store_image_model.dart';
import 'package:stringly/models/user_input_params.dart';

import '../../Reuseable Widget/gradienttextfield.dart';
import '../../models/update_user_account_model.dart';
import '../loaders/message_screen_loader.dart';
import '../loaders/request_process_loader.dart';
import '../mainScreenNav.dart';

class FilterPreferences extends StatefulWidget {
  @override
  _FilterPreferencesState createState() => _FilterPreferencesState();
}

class _FilterPreferencesState extends State<FilterPreferences> {
  double _ageRangeStart = 18;
  double _ageRangeEnd = 80;
  double _distance = 1;
  String? selectedState;
  String? initialSelectedState;
  String? alreadySetInitialPreference;
  String? userSelectedPreference;
  final TextEditingController _selectedState = TextEditingController();
  final SingleValueDropDownController _preferenceController =
      SingleValueDropDownController();
  final List<String> _preferenceOptions = [
    'Male',
    'Female',
    'Non Binary',
    'I am open to dating everyone'
  ];
  List<String> states = [
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chhattisgarh",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal"
  ];

  late Future<dynamic> functionStatusData;

  @override
  void initState() {
    functionStatusData = resetUserInputParams();
    super.initState();
  }

// if user all ready exist, reset userInputParams so that update function perform perfectly
  Future<Map<String, dynamic>> resetUserInputParams() async {
    Map<String, dynamic> data = await Intraction.getLoggedUserAccount();
    try {
      if (data.containsKey('Ok')) {
        final value = data['Ok']['params'];
        UpdateUserAccountModel user = UpdateUserAccountModel.fromMap(value);
        setState(() {
          if (user.preferToDate != null) {
            alreadySetInitialPreference = user.preferToDate;
          }
          if (user.minPreferredAge != null) {
            _ageRangeStart = user.minPreferredAge!.toDouble();
          }
          if (user.maxPreferredAge != null) {
            _ageRangeEnd = user.maxPreferredAge!.toDouble();
          }
          if (user.distanceBound != null) {
            _distance = user.distanceBound!.toDouble();
          }
          if (user.preferredState != null) {
            initialSelectedState = user.preferredState;
            _selectedState.text = user.preferredState!;
          }
        });
      }
      return {'Ok': data};
    } catch (e) {
      debugPrint('Error ---------- $e');
      return {'Err': e};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 50,
                left: 20,
                right: 20,
              ),
              child: FutureBuilder(
                future: functionStatusData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return MessageScreenLoader.simpleLoader(
                        text: 'Wait, Loading...');
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Something went wrong! Please try again later.',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Select Your Preference',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        // Replace the DropdownButton with DropDownTextField
                        GradientdropdownTextField(
                          hintText: 'Select your preference',
                          items: _preferenceOptions,
                          initialValue: alreadySetInitialPreference ?? null,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                userSelectedPreference = value?.value;
                              });
                            }
                          },
                          label: const Text('Who would you prefer to connect?'),
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
                              key: ValueKey(
                                  _ageRangeStart), // Unique key for animation
                              style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                            ),

                            // Upper Value
                            Text(
                              '${_ageRangeEnd.round()}',
                              key: ValueKey(
                                  _ageRangeEnd), // Unique key for animation
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
                            key:
                                ValueKey(_distance), // Unique key for animation
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
                                      _distance = value;
                                      selectedState = null;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ), // End of Row for Distance Slider
                        const SizedBox(height: 30),
                        if (_distance >= 100)
                          GradientTextField(
                              controller: _selectedState,
                              label: const Text('State'),
                              hintText: 'Enter a State'),
                        // GradientdropdownTextField(
                        //   hintText: 'Choose a State',
                        //   items: states,
                        //   initialValue: initialSelectedState,
                        //   onChanged: (value) {
                        //     if (value != null) {
                        //       setState(() {
                        //         selectedState = value?.value;
                        //       });
                        //     }
                        //   },
                        //   label: const Text('Select Your State'),
                        // ),

                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 50, // Adjust height as needed
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.black,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                  ),
                                  onPressed: () async {
                                    RequestProcessLoader.openLoadingDialog();
                                    UpdateUserAccountModel updateUserModel =
                                        UpdateUserAccountModel();
                                    updateUserModel.updateField(
                                        'preferToDate', userSelectedPreference);
                                    updateUserModel.updateField(
                                        'minPreferredAge',
                                        _ageRangeStart.round());
                                    updateUserModel.updateField(
                                        'maxPreferredAge',
                                        _ageRangeEnd.round());
                                    updateUserModel.updateField(
                                        'distanceBound', _distance.round());
                                    updateUserModel.updateField(
                                        'preferredState', _selectedState.text);
                                    await Intraction.updateLoggedUserAccount(
                                        updateUserModel);
                                    RequestProcessLoader.stopLoading();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Mainscreennav(),
                                      ),
                                    );
                                  },
                                  child: const Text('Done'),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        )
                      ],
                    );
                  }
                },
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
        //    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),

        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
        activeTrackColor: Colors.transparent,
        inactiveTrackColor: Colors.grey[300],
        trackShape: GradientTrackShape(),
        thumbColor: Colors.white,
        showValueIndicator: ShowValueIndicator.never, // Disable value indicator
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

    // Paint inactive track
    final Paint inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor!;
    context.canvas.drawRect(trackRect, inactivePaint);

    // Paint active track with gradient
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
