import 'package:flutter/material.dart';

class GradientTextField extends StatefulWidget {
  final Widget? label;
  final String hintText;
  final double height;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final TextInputType textInputType;
  final FormFieldValidator<String>? validator; // Add this line
  final ValueChanged<String>? onChanged;
  final int? maxLines;

  const GradientTextField(
      {Key? key,
      required this.hintText,
      this.validator, // Add this line

      this.height = 56.0,
      this.controller,
      this.suffixIcon,
      this.textInputType = TextInputType.text,
      this.label,
      this.onChanged,
      this.maxLines = 1})
      : super(key: key);

  @override
  _GradientTextFieldState createState() => _GradientTextFieldState();
}

class _GradientTextFieldState extends State<GradientTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        // Gradient Border Container
        Container(
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
          padding: const EdgeInsets.all(1),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              validator: widget.validator, // Use validator here

              controller: widget.controller,
              focusNode: _focusNode,
              keyboardType: widget.textInputType,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                label: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: widget.label),
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                // labelText: widget.label == null ? widget.hintText : null,
                labelStyle: const TextStyle(
                  // color: _hasFocus ? Colors.black : Colors.grey,
                  color: Colors.black,
                  fontSize: 14,
                  backgroundColor: Colors.white,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                floatingLabelStyle: const TextStyle(
                  color: Colors.black,
                  backgroundColor: Colors.white,
                  fontSize: 14,
                ),

                contentPadding: const EdgeInsets.only(
                    top: 14.0,
                    bottom: 14,
                    left: 14.0,
                    right: 14.0), // Add padding for text field content
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
              maxLines: widget.maxLines,
            ),
          ),
        ),
      ],
    );
  }
}
