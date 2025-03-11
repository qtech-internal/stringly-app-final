// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class MultiSelectGradientDropdown extends StatefulWidget {
  final ValueChanged<List<String>>? onChanged;
  final String? initialValue;

  const MultiSelectGradientDropdown(
      {super.key, this.onChanged, this.initialValue});

  @override
  _MultiSelectGradientDropdownState createState() =>
      _MultiSelectGradientDropdownState();
}

class _MultiSelectGradientDropdownState
    extends State<MultiSelectGradientDropdown> {
  late SingleValueDropDownController _dropDownController;
  final List<String> _selectedValues = [];
  final List<String> _options = [
    "A long-term relationship",
    "Fun & casual dates",
    "Marriage",
    "Intimacy & without commitment",
    "A life partner",
    "Ethical non-monogamy"
  ];

  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _dropDownController = SingleValueDropDownController();

    if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      _selectedValues
          .addAll(widget.initialValue!.split(", ").map((e) => e.trim()));
      _updateDropDownText();
    }
  }

  void _onItemSelected(dynamic value) {
    if (value == null || value is! DropDownValueModel) return;
    String selectedValue = value.value;

    setState(() {
      if (_selectedValues.contains(selectedValue)) {
        _selectedValues.remove(selectedValue);
      } else {
        if (_selectedValues.length < 3) {
          _selectedValues.add(selectedValue);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("You can select up to 3 options."),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
      _updateDropDownText();
    });

    widget.onChanged?.call(_selectedValues);
  }

  void _updateDropDownText() {
    _dropDownController.setDropDown(DropDownValueModel(
      name: _selectedValues.join(", "),
      value: _selectedValues.join(", "),
    ));
  }

  void _removeSelectedItem(String value) {
    setState(() {
      _selectedValues.remove(value);
      _updateDropDownText();
    });

    widget.onChanged?.call(_selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 56,
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
            child: Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  _hasFocus = hasFocus;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DropDownTextField(
                  controller: _dropDownController,
                  clearOption: false,
                  textFieldDecoration: InputDecoration(
                    hintText: "What are you looking for?",
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 14),
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      backgroundColor: Colors.white,
                      fontSize: 14,
                    ),
                    label: _hasFocus || widget.initialValue != null || _dropDownController.dropDownValue != null ?  Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: const Text("What are you looking for?")) : const Text("What are you looking for?"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon:
                        const Icon(Icons.arrow_drop_down, color: Colors.black),
                  ),
                  dropDownList: _options
                      .map((item) => DropDownValueModel(
                            name: item,
                            value: item,
                          ))
                      .toList(),
                  onChanged: _onItemSelected,
                  dropDownIconProperty: IconProperty(
                    icon: Icons.keyboard_arrow_down,
                    size: 28,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_selectedValues.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedValues.map((item) {
              return Chip(
                label: Text(item, style: const TextStyle(fontSize: 12)),
                backgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Colors.transparent),
                ),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => _removeSelectedItem(item),
              );
            }).toList(),
          ),
        ]
      ],
    );
  }

  @override
  void dispose() {
    _dropDownController.dispose();
    super.dispose();
  }
}
