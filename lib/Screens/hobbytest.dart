import 'package:flutter/material.dart';

class HobbiesScreen extends StatefulWidget {
  @override
  _HobbiesScreenState createState() => _HobbiesScreenState();
}

class _HobbiesScreenState extends State<HobbiesScreen> {
  final List<String> hobbies = ["Reading", "Traveling", "Cooking", "Music", "Sports", "Fencing"];
  List<String> selectedHobbies = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Hobbies")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: hobbies.map((hobby) {
            final isSelected = selectedHobbies.contains(hobby);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedHobbies.remove(hobby);
                  } else {
                    selectedHobbies.add(hobby);
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                    colors: [Colors.pink, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                      : null,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2), // Padding for the gradient border
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.grey[200],
                      borderRadius: BorderRadius.circular(22), // Slightly smaller for inner border
                    ),
                    child: Text(
                      hobby,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
