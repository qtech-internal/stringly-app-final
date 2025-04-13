import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class MultiSelectGradientDropdown extends StatefulWidget {
  final ValueChanged<List<String>>? onChanged;
  final List<String>? initialValues;

  const MultiSelectGradientDropdown(
      {super.key, this.onChanged, this.initialValues});

  @override
  _MultiSelectGradientDropdownState createState() =>
      _MultiSelectGradientDropdownState();
}

class _MultiSelectGradientDropdownState
    extends State<MultiSelectGradientDropdown> {
  late MultiValueDropDownController _dropDownController;
  List<String> _selectedValues = [];
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

    _dropDownController = MultiValueDropDownController();

    if (widget.initialValues != null && widget.initialValues!.isNotEmpty) {
      _selectedValues = List.from(widget.initialValues!);
      _dropDownController.setDropDown(
        _selectedValues
            .map((e) => DropDownValueModel(name: e, value: e))
            .toList(),
      );
    }
  }

  void _onItemSelected(List<DropDownValueModel> values) {
    List<String> selectedList = values.map((e) => e.value.toString()).toList();

    if (selectedList.length > 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You can select up to 3 options."),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _selectedValues = selectedList;
      _dropDownController.setDropDown(
        _selectedValues
            .map((e) => DropDownValueModel(name: e, value: e))
            .toList(),
      );
    });

    widget.onChanged?.call(_selectedValues);
  }

  void _removeSelectedItem(String value) {
    setState(() {
      _selectedValues.remove(value);
      _dropDownController.setDropDown(
        _selectedValues
            .map((e) => DropDownValueModel(name: e, value: e))
            .toList(),
      );
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
                child: DropDownTextField.multiSelection(
                  controller: _dropDownController,
                  clearOption: false,
                  checkBoxProperty: CheckBoxProperty(activeColor: Colors.black),
                  textFieldDecoration: InputDecoration(
                    hintText: "What are you looking for?",
                    hintStyle:
                    const TextStyle(color: Colors.grey, fontSize: 14),
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      backgroundColor: Colors.white,
                      fontSize: 14,
                    ),
                    label: _hasFocus
                        ? Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: const Text("What are you looking for?"))
                        : const Text("What are you looking for?"),
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
                  onChanged: (dynamic value) {
                    _onItemSelected(value);
                  },
                  submitButtonColor: Colors.black,
                  submitButtonTextStyle: const TextStyle(color: Colors.white),
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