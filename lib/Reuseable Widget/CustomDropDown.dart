import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class CustomGradientdropdownTextField extends StatefulWidget {
  final String hintText;
  final Widget? label;
  final double height;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;
  final List<String>? items; // Dropdown items
  final ValueChanged<dynamic?>? onChanged;
  final String? initialValue; // New parameter for preselected value

  const CustomGradientdropdownTextField({
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
  _CustomGradientdropdownTextFieldState createState() => _CustomGradientdropdownTextFieldState();
}

class _CustomGradientdropdownTextFieldState extends State<CustomGradientdropdownTextField> {
  final FocusNode _focusNode = FocusNode();
  late SingleValueDropDownController _dropDownController;
  bool _hasFocus = false;
  late GlobalKey _key;

  @override
  void initState() {
    super.initState();
    _key = GlobalKey();
    // Initialize the controller with the initial value if provided
    _dropDownController = SingleValueDropDownController(
      data: widget.initialValue != null
          ? DropDownValueModel(name: widget.initialValue!, value: widget.initialValue!)
          : null,
    );

    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _dropDownController.dispose();
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
          color: _hasFocus ? Colors.transparent : Colors.grey,
          width: 1,
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
              key: _key,
              controller: _dropDownController,
              clearOption: false,
              textFieldDecoration: InputDecoration(
                label: widget.label,
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
                icon:  _hasFocus ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, // Replace with your custom icon
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
              labelText: widget.initialValue ?? widget.hintText,
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
