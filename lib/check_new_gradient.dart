import 'package:flutter/material.dart';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stringly/constants/globals.dart';
import 'package:stringly/intraction.dart';
import 'package:stringly/models/image_field_url_to_update.dart';
import 'package:stringly/models/store_image_model.dart';
import 'package:stringly/models/user_input_params.dart';

import '../../models/update_user_account_model.dart';
import 'Reuseable Widget/gradienttextfield.dart';
import 'Screens/loaders/message_screen_loader.dart';
import 'Screens/loaders/request_process_loader.dart';




class FilterPreferencesNew extends StatefulWidget {
  @override
  _FilterPreferencesNewState createState() => _FilterPreferencesNewState();
}

class _FilterPreferencesNewState extends State<FilterPreferencesNew> {
  final _selectPreference = GlobalKey();
  final _key = GlobalKey<FormState>();
  double _ageRangeStart = 18;
  double _ageRangeEnd = 80;
  double _distance = 1;
  String? alreadySetInitialPreference;
  String? userSelectedPreference;
  final SingleValueDropDownController _preferenceController = SingleValueDropDownController();
  TextEditingController _userPreferenceControllerText = TextEditingController();
  final List<String> _preferenceOptions = [
    'Male',
    'Female',
    'Other',
    'I am open to dating everyone'
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
      if(data.containsKey('Ok')) {
        final value = data['Ok']['params'];
        UpdateUserAccountModel user = UpdateUserAccountModel.fromMap(value);
        setState(() {
          if(user.preferToDate != null) {
            alreadySetInitialPreference = user.preferToDate;
          }
          if(user.minPreferredAge != null) {
            _ageRangeStart = user.minPreferredAge!.toDouble();
          }
          if(user.maxPreferredAge != null) {
            _ageRangeEnd = user.maxPreferredAge!.toDouble();
          }
          if(user.distanceBound != null) {
            _distance = user.distanceBound!.toDouble();
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
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20,),
          child: FutureBuilder(
            future: functionStatusData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return MessageScreenLoader.simpleLoader(text: 'Wait, Loading...');
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
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 35,),
                    // Replace the DropdownButton with DropDownTextField
                    GradientdropdownTextFieldtestcheck(
                      hintText: 'Select your preference',
                      items: _preferenceOptions,
                      initialValue: alreadySetInitialPreference,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            userSelectedPreference = value?.value;
                          });
                        } else {
                          setState(() {
                            userSelectedPreference =  null;
                          });
                        }
                      },
                      label: const Text('What are you prefer to date?'),
                    ),



                    const SizedBox(height: 20),
                    const Text('Specify the age range', style: TextStyle(fontSize: 14),),
                    const SizedBox(height: 20,),
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
                              fontWeight: FontWeight.w500
                          ),
                        ),

                        // Upper Value
                        Text(
                          '${_ageRangeEnd.round()}',
                          key: ValueKey(_ageRangeEnd), // Unique key for animation
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ],
                    ),

                    // The GradientRangeSlider widget
                    Row(
                      children: [
                        Expanded(
                          child: GradientRangeSlider(
                            lowerValue: _ageRangeStart,
                            upperValue: _ageRangeEnd,
                            minValue: 18,
                            maxValue: 80,
                            onChangedLower: (double newValue) {
                              setState(() {
                                _ageRangeStart = newValue;
                              });
                            },
                            onChangedUpper: (double newValue) {
                              setState(() {
                                _ageRangeEnd = newValue;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    const Text('Specify the distance bound', style: TextStyle(fontSize: 14),),
                    const SizedBox(height: 20),

                    const SizedBox(width: 260,),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${_distance.round()} km', // Display value in km with brackets
                        key: ValueKey(_distance), // Unique key for animation
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ), // End of Row for Distance Display

                    // Distance Bound Slider
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                              onPressed: () async {
                                RequestProcessLoader.openLoadingDialog();
                                UpdateUserAccountModel updateUserModel = UpdateUserAccountModel();
                                updateUserModel.updateField('preferToDate', userSelectedPreference);
                                updateUserModel.updateField('minPreferredAge', _ageRangeStart.round());
                                updateUserModel.updateField('maxPreferredAge', _ageRangeEnd.round());
                                updateUserModel.updateField('distanceBound', _distance.round());
                                await Intraction.updateLoggedUserAccount(updateUserModel);
                                RequestProcessLoader.stopLoading();
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => Mainscreennav(),
                                //   ),
                                // );
                              },
                              child: const Text('Done'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,)
                  ],
                );
              }
            },
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
    canvas.drawCircle(center, thumbRadius - strokeWidth / 2, gradientStrokePaint);
    canvas.drawCircle(center, thumbRadius - strokeWidth, solidCirclePaint);
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
        // thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),

        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
        activeTrackColor: Colors.transparent,
        inactiveTrackColor: Colors.grey[300],
        trackShape: GradientTrackShape(),
        thumbColor: Colors.grey[300],
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
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
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

class GradientRangeSlider extends StatelessWidget {
  final double lowerValue;
  final double upperValue;
  final double minValue;
  final double maxValue;
  final ValueChanged<double> onChangedLower;
  final ValueChanged<double> onChangedUpper;

  const GradientRangeSlider({
    Key? key,
    required this.lowerValue,
    required this.upperValue,
    required this.minValue,
    required this.maxValue,
    required this.onChangedLower,
    required this.onChangedUpper,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 4,
        thumbShape: const GradientThumbShape(
          thumbRadius: 10.0,
          strokeWidth: 3.0,
          gradientColors: [
            Color(0xFF0039C7),
            Color(0xFFD83694),
          ],
        ),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
        inactiveTrackColor: Colors.grey[300],
        trackShape: GradientTrackShape(),
        thumbColor: Colors.white,
        showValueIndicator: ShowValueIndicator.never,
      ),
      child: RangeSlider(
        values: RangeValues(lowerValue, upperValue),
        min: minValue,
        max: maxValue,
        divisions: (maxValue - minValue).toInt(),
        labels: RangeLabels('${lowerValue.round()}', '${upperValue.round()}'),
        onChanged: (RangeValues values) {
          onChangedLower(values.start);
          onChangedUpper(values.end);
        },
      ),
    );
  }
}


class GradientdropdownTextFieldtestcheck extends StatefulWidget {
  final String hintText;
  final Widget? label;
  final double height;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;
  final List<String>? items; // Dropdown items
  final ValueChanged<dynamic?>? onChanged;
  final String? initialValue; // New parameter for preselected value

  const GradientdropdownTextFieldtestcheck({
    Key? key,
    required this.hintText,
    this.validator,
    this.height = 56.0,
    this.controller,
    this.suffixIcon,
    this.items,
    this.onChanged,
    this.label,
    this.initialValue,
  }) : super(key: key);

  @override
  _GradientdropdownTextFieldtestcheckState createState() => _GradientdropdownTextFieldtestcheckState();
}

class _GradientdropdownTextFieldtestcheckState extends State<GradientdropdownTextFieldtestcheck> with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  late SingleValueDropDownController _dropDownController;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  bool _hasFocus = false;

  @override
  void initState() {
    if (widget.initialValue != null) {
      _dropDownController = SingleValueDropDownController(
        data: DropDownValueModel(name: widget.initialValue!, value: widget.initialValue!),
      );
    } else {
      _dropDownController = SingleValueDropDownController();
    }
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(_animationController);

  }

  @override
  void dispose() {
    _focusNode.dispose();
    _dropDownController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: _hasFocus
            ? const LinearGradient(
          colors: [Color(0xFFD83694), Color(0xFF0039C7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : null,
        border: Border.all(
          color: _hasFocus ? Colors.transparent : const Color(0xffD6D6D6),
          width: 2,
        ),
      ),
      padding: const EdgeInsets.all(1), // Padding for gradient border
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0), // Added padding
          child: widget.items != null
              ? Focus(
            onFocusChange: (hasFocus) {
              setState(() {
                _hasFocus = hasFocus;
              });
            },
            child: DropDownTextField(
              controller: widget.initialValue != null ? _dropDownController : null,
              clearOption: false,
              textFieldDecoration: InputDecoration(
                label:  widget.label,
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                labelStyle: const TextStyle(
                  color: Colors.black,
                  backgroundColor: Colors.white,
                  fontSize: 14,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: widget.suffixIcon,
              ),
              validator: widget.validator,
              dropDownList: widget.items!
                  .map((item) => DropDownValueModel(
                name: item,
                value: item,
              ))
                  .toList(),
              onChanged: widget.onChanged,
              dropDownIconProperty: IconProperty(
               icon:  _hasFocus ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,// Replace with your custom icon
                size: 28,
                color: Colors.black, // Customize color
              ),
            ),
          )
              : TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            validator: widget.validator,
            decoration: InputDecoration(
              label:  widget.label,
              hintText: widget.hintText,
              labelStyle: TextStyle(
                  color: _hasFocus ? Colors.black : Colors.grey,
                  backgroundColor: Colors.white,
                  fontSize: 16 // Fixes floating text cut
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              floatingLabelStyle: const TextStyle(
                color: Colors.black,
                backgroundColor: Colors.white,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: widget.suffixIcon,
            ),
            style: const TextStyle(fontSize: 16.0),
            cursorColor: Colors.black,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}

