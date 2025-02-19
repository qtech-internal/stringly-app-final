import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HobbiesScreen extends StatefulWidget {
  final List<String> initialHobbies;

  const HobbiesScreen({super.key, required this.initialHobbies});
  @override
  _HobbiesScreenState createState() => _HobbiesScreenState();
}

class _HobbiesScreenState extends State<HobbiesScreen> {
  // Map to hold the categories and hobbies
  List<String> titleLogos = [
    'assets/hobbies/active.png',
    'assets/hobbies/creative.png',
    'assets/hobbies/entertainment.png',
    'assets/hobbies/tech.png',
    'assets/hobbies/food.png',
    'assets/hobbies/social.png',
    'assets/hobbies/pets.png',
  ];

  final Map<String, List<Map<String, dynamic>>> hobbies = {
    "Active and Outdoor": [
      {'name': 'Fencing', 'emoji': '🤺'},
      {'name': 'Badminton', 'emoji': '🏸'},
      {'name': 'Cricket', 'emoji': '🏏'},
      {'name': 'Hiking', 'emoji': '🥾'},
      {'name': 'Yoga', 'emoji': '🧘‍♂'},
      {'name': 'Gym', 'emoji': '💪'},
      {'name': 'Swimming', 'emoji': '🏊'},
      {'name': 'Surfing', 'emoji': '🏄'},
      {'name': 'Rock Climbing', 'emoji': '🧗‍♀'},
      {'name': 'Camping', 'emoji': '🏕'},
      {'name': 'Tennis', 'emoji': '🎾'},
      {'name': 'Basketball', 'emoji': '⛹'},
      {'name': 'Soccer', 'emoji': '⚽'},
      {'name': 'Skateboarding', 'emoji': '🛹'},
      {'name': 'Sailing', 'image': 'assets/hobbies/sailing.png'},
      {'name': 'Scuba Diving', 'image': 'assets/hobbies/scuba-diving.png'},
      {'name': 'Running', 'emoji': '🏃'},
      {'name': 'Cycling', 'emoji': '🚴‍♂️'},
      {'name': 'Golf', 'emoji': '🏌'},
      {'name': 'Skiing', 'emoji': '⛷'},
    ],
    "Creative and Arts": [
      {'name': 'Photography', 'emoji': '📷'},
      {'name': 'Painting', 'emoji': '🎨'},
      {'name': 'Drawing', 'emoji': '✏'},
      {'name': 'Playing a musical instrument', 'emoji': '🎸'},
      {'name': 'Singing', 'image': 'assets/hobbies/singing.png'},
      {'name': 'Cooking/Baking', 'emoji': '🍪'},
      {'name': 'Fashion Design', 'emoji': '👗'},
      {
        'name': 'Interior Design',
        'image': 'assets/hobbies/interior-design.png'
      },
      {'name': 'Pottery', 'image': 'assets/hobbies/pottery.png'},
      {'name': 'Acting', 'emoji': '🎭'},
      {'name': 'Writing', 'emoji': '🖊'},
    ],
    "Entertainment and Pop Culture": [
      {'name': 'Movies', 'emoji': '🎬'},
      {'name': 'TV Shows/Series', 'emoji': '🍿'},
      {'name': 'Podcasts', 'emoji': '🎙'},
      {'name': 'Stand-up Comedy', 'emoji': '😆'},
      {'name': 'Theater Concerts', 'emoji': '🎤'},
      {'name': 'Gaming', 'emoji': '🎮'},
      {
        'name': 'Collecting (Vinyls, Comics, etc.)',
        'image': 'assets/hobbies/collecting.png'
      },
    ],
    "Tech & Learning": [
      {'name': 'Coding/Programming', 'image': 'assets/hobbies/coding.png'},
      {'name': '3D Printing', 'emoji': '🖨️'},
      {'name': 'Virtual Reality (VR)', 'emoji': '🕶'},
      {'name': 'Cryptocurrency/Blockchain', 'image': 'assets/svg/bitcoin.svg'},
      {'name': 'AI/Machine Learning', 'emoji': '🤖'},
      {'name': 'Reading Astronomy', 'emoji': '🌠'},
      {'name': 'History', 'emoji': '⚔'},
      {'name': 'Puzzle Solving', 'emoji': '🧩'},
      {'name': 'Robotics', 'emoji': '🤖'},
    ],
    "Food & Drink": [
      {'name': 'Wine Tasting', 'emoji': '🍷'},
      {'name': 'Coffee Culture', 'emoji': '☕'},
      {'name': 'Craft Beer', 'emoji': '🍺'},
      {'name': 'Cooking', 'emoji': '👨‍🍳'},
      {
        'name': 'Mixology/Cocktail Making',
        'image': 'assets/hobbies/mixology.png'
      },
      {'name': 'Food Blogging', 'emoji': '🥗'},
      {'name': 'Trying new restaurants', 'emoji': '🍜'},
      {'name': 'Baking', 'emoji': '🥐'},
    ],
    "Social & Leisure": [
      {'name': 'Travelling', 'image': 'assets/hobbies/travelling.png'},
      {'name': 'Volunteering', 'image': 'assets/hobbies/volunteering.png'},
      {'name': 'Partying/Clubbing', 'image': 'assets/hobbies/party.png'},
      {'name': 'Trivia Nights', 'emoji': '🎉'},
      {'name': 'Bar Hopping', 'emoji': '🍻'},
      {'name': 'Karaoke', 'emoji': '🎤'},
      {'name': 'Networking', 'emoji': '🛜'},
      {'name': 'Photography', 'emoji': '📷'},
      {'name': 'Meditation', 'image': 'assets/hobbies/meditation.png'},
      {'name': 'Festivals', 'emoji': '🎇'},
    ],
    "Pets & Animals": [
      {'name': 'Dog Lover', 'emoji': '🐕'},
      {'name': 'Cat Lover', 'emoji': '🐈'},
      {'name': 'Animal Rescue', 'emoji': '🦒'},
      {'name': 'Bird Watching', 'emoji': '🕊'},
      {'name': 'Horseback Riding', 'emoji': '🏇'},
      {'name': 'Pet Photography', 'emoji': '🐶'},
    ],
  };

  // Set to hold selected hobbies
  final Set<String> selectedHobbies = {};
  final List<String> selected_filter_hobies = [];
  String searchText = "";

  void toggleSelection(String hobby, String category) {
    setState(() {
      if (selectedHobbies.contains(hobby)) {
        selectedHobbies.remove(hobby);
        _removeFromCategoryList(hobby, category);
      } else {
        if (selectedHobbies.length >= 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You can only select up to 5 hobbies.'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          selectedHobbies.add(hobby);
          _addToCategoryList(hobby, category);
        }
      }
    });
  }

  void _addToCategoryList(String hobby, String category) {
    if (category == "Active and Outdoor") {
      selected_filter_hobies.add(hobby);
    } else if (category == "Creative and Arts") {
      selected_filter_hobies.add(hobby);
    } else if (category == "Entertainment and Pop Culture") {
      selected_filter_hobies.add(hobby);
    } else if (category == "Food & Drink") {
      selected_filter_hobies.add(hobby);
    } else if (category == "Social & Leisure") {
      selected_filter_hobies.add(hobby);
    } else if (category == "Pets & Animals") {
      selected_filter_hobies.add(hobby);
    } else if (category == "Tech & Learning") {
      selected_filter_hobies.add(hobby);
    }
  }

  void _removeFromCategoryList(String hobby, String category) {
    if (category == "Active and Outdoor") {
      selected_filter_hobies.remove(hobby);
    } else if (category == "Creative and Arts") {
      selected_filter_hobies.remove(hobby);
    } else if (category == "Entertainment and Pop Culture") {
      selected_filter_hobies.remove(hobby);
    } else if (category == "Food & Drink") {
      selected_filter_hobies.remove(hobby);
    } else if (category == "Social & Leisure") {
      selected_filter_hobies.remove(hobby);
    } else if (category == "Pets & Animals") {
      selected_filter_hobies.remove(hobby);
    } else if (category == "Tech & Learning") {
      selected_filter_hobies.remove(hobby);
    }
  }

  @override
  void initState() {
    super.initState();
    selectedHobbies.addAll(widget.initialHobbies);
    selected_filter_hobies.addAll(widget.initialHobbies);
  }

  // Build each category with its hobbies
  Widget buildCategory(
      String category, List<Map<String, dynamic>> items, String logo) {
    final filteredItems = items
        .where((hobby) =>
            hobby['name'].toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (filteredItems.isNotEmpty) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Image.asset(logo),
              const SizedBox(width: 6),
              Text(
                category,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: filteredItems
                .map((hobby) => buildHobbyChip(hobby, category))
                .toList(),
          ),
          const SizedBox(height: 10)
        ],
      ],
    );
  }

  Widget buildHobbyChip(Map<String, dynamic> hobby, String category) {
    final isSelected = selectedHobbies.contains(hobby['name']);

    Widget chipContent;
    if (hobby.containsKey('emoji')) {
      chipContent = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${hobby['emoji']} '),
          Text(
            '${hobby['name']} ',
            style: TextStyle(color: isSelected ? Colors.white : Colors.black),
          ),
        ],
      );
    } else if (hobby.containsKey('image')) {
      bool isSvg = hobby['image'].split('.')[1] == 'svg';
      chipContent = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isSvg
              ? SvgPicture.asset(hobby['image'], width: 20, height: 20)
              : Image.asset(hobby['image'], width: 20, height: 20),
          const SizedBox(width: 8),
          Text(
            hobby['name'],
            style: TextStyle(color: isSelected ? Colors.white : Colors.black),
          )
        ],
      );
    } else {
      chipContent = Text(hobby['name']);
    }

    return GestureDetector(
      onTap: () => toggleSelection(hobby['name'], category),
      child: Stack(
        children: [
          if (isSelected)
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.pinkAccent, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: chipContent,
              ),
            ),
          if (!isSelected)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
              ),
              child: chipContent,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 40,
            left: 20,
            right: 20,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Hobbies & Interests',
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
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
              const SizedBox(
                height: 35,
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    hintText: "Search Here...",
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: hobbies.entries
                        .toList()
                        .asMap()
                        .entries
                        .map((entry) => buildCategory(
                              entry.value.key,
                              entry.value.value,
                              titleLogos[entry.key],
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 350,
                child: ElevatedButton(
                  onPressed: () {
                    print(selected_filter_hobies);
                    Navigator.pop(
                        context, {'selectedHobbies': selected_filter_hobies});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                  ),
                  child: const Text('Done',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
