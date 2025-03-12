import 'package:flutter/material.dart';


// call this by using this:showGenderBottomSheet(context),

void showGenderBottomSheet(BuildContext context) {
  String selectedGender = "Man";
  bool isShownOnProfile = true;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
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
                    Text("Update your gender", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
                Divider(),
                SizedBox(height: 10),
                Text("Pick which best describes you", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text("Then add more about your gender if you’d like"),
                SizedBox(height: 10),
                _buildGenderTile("Woman", selectedGender, () => setState(() => selectedGender = "Woman")),
                _buildGenderTile("Man", selectedGender, () => setState(() => selectedGender = "Man"), hasDropdown: true),
                _buildGenderTile("Nonbinary", selectedGender, () => setState(() => selectedGender = "Nonbinary")),
                SizedBox(height: 10),
                Divider(),
                SwitchListTile(
                  title: Text("Shown on your profile"),
                  subtitle: Row(
                    children: [
                      Text("Shown as: "),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(selectedGender, style: TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  value: isShownOnProfile,
                  onChanged: (value) => setState(() => isShownOnProfile = value),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text("Save and close", style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildGenderTile(String title, String selectedGender, VoidCallback onTap, {bool hasDropdown = false}) {
  return ListTile(
    title: Text(title),
    subtitle: hasDropdown ? Text("Add more about your gender") : null,
    trailing: Icon(
      selectedGender == title ? Icons.radio_button_checked : Icons.radio_button_unchecked,
      color: selectedGender == title ? Colors.black : null,
    ),
    onTap: onTap,
  );
}