import 'package:flutter/material.dart';

showGenderBottomSheet(BuildContext context, String? initialGender,
    Function(Map<String, dynamic>) onGenderSelected) {
  String? selectedGender =
      initialGender; // Keep it null if initialGender is null
  String? selectedIdentity;
  bool isShownOnProfile = true;
  bool isDropdownVisible = false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          List<String> getGenderOptions() {
            if (selectedGender == "Male") {
              return [
                "Intersex man",
                "Trans man",
                "Transmasculine",
                "Man and Nonbinary",
                "Cis man"
              ];
            } else if (selectedGender == "Female") {
              return [
                "Intersex woman",
                "Trans woman",
                "Transfeminine",
                "Woman and Nonbinary",
                "Cis woman"
              ];
            } else if (selectedGender == "Nonbinary") {
              return [
                "Agender",
                "Bigender",
                "Genderfluid",
                "Genderqueer",
                "Gender nonconforming"
              ];
            }
            return [];
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Add your gender",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                  const Divider(),
                  const Text('Pick which best describes you',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  const Text('Then add more about your gender if you\'d like',
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 2),
                  const Text('Learn what this means',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline)),
                  _buildGenderTile(
                    "Female",
                    selectedGender,
                    selectedIdentity,
                    isDropdownVisible,
                    () => setState(() {
                      selectedGender = "Female";
                      selectedIdentity = null;
                    }),
                    () => setState(() {
                      isDropdownVisible = !isDropdownVisible;
                    }),
                    getGenderOptions(),
                    (String value) => setState(() {
                      selectedIdentity = value;
                      isDropdownVisible = false;
                    }),
                  ),
                  _buildGenderTile(
                    "Male",
                    selectedGender,
                    selectedIdentity,
                    isDropdownVisible,
                    () => setState(() {
                      selectedGender = "Male";
                      selectedIdentity = null;
                    }),
                    () => setState(() {
                      isDropdownVisible = !isDropdownVisible;
                    }),
                    getGenderOptions(),
                    (String value) => setState(() {
                      selectedIdentity = value;
                      isDropdownVisible = false;
                    }),
                  ),
                  _buildGenderTile(
                    "Nonbinary",
                    selectedGender,
                    selectedIdentity,
                    isDropdownVisible,
                    () => setState(() {
                      selectedGender = "Nonbinary";
                      selectedIdentity = null;
                    }),
                    () => setState(() {
                      isDropdownVisible = !isDropdownVisible;
                    }),
                    getGenderOptions(),
                    (String value) => setState(() {
                      selectedIdentity = value;
                      isDropdownVisible = false;
                    }),
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text("Shown on your profile",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Row(
                      children: [
                        const Text("Shown as: "),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              color: Colors.yellow[700],
                              borderRadius: BorderRadius.circular(4)),
                          child: Text(
                              selectedIdentity ?? selectedGender ?? "Not Set",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    value: isShownOnProfile,
                    onChanged: (value) =>
                        setState(() => isShownOnProfile = value),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      onGenderSelected({
                        'gender': selectedGender,
                        'identity': selectedIdentity,
                        'profile': isShownOnProfile
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Save and close",
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 20)
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildGenderTile(
  String title,
  String? selectedGender,
  String? selectedIdentity,
  bool isDropdownVisible,
  VoidCallback onTap,
  VoidCallback onMoreTap,
  List<String> options,
  Function(String) onOptionSelected,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      children: [
        ListTile(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade300)),
          title: Text(title),
          subtitle: selectedGender == title
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: onMoreTap,
                      child: Row(
                        children: [
                          const Text(
                            'Add more about your gender',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                          Icon(
                            isDropdownVisible
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                        ],
                      ),
                    ),
                    if (selectedIdentity != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          selectedIdentity,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                )
              : null,
          trailing: Icon(
            selectedGender == title
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: selectedGender == title ? Colors.black : Colors.grey,
          ),
          onTap: onTap,
        ),
        if (selectedGender == title && isDropdownVisible)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: options.map((option) {
                return ListTile(
                  title: Text(option),
                  leading: Radio<String>(
                    value: option,
                    groupValue: selectedIdentity,
                    onChanged: (value) => onOptionSelected(value!),
                  ),
                  onTap: () => onOptionSelected(option),
                );
              }).toList(),
            ),
          ),
      ],
    ),
  );
}
