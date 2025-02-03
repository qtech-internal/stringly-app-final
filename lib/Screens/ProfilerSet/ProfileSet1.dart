import 'package:flutter/material.dart';

import 'ProfileSet2.dart';

class ProfileSet1 extends StatelessWidget {
  final List<String> images = [
    'assets/img.png',
    'assets/img_1.png',
    'assets/img_2.png',
    'assets/img_3.png',
    'assets/img_4.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Custom App Bar with Back Arrow and Select Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon:const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  onPressed: () {
                    // Handle select action
                  },
                  child:const Text(
                    'Select',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),

          // Main Image with White Space Around it
          Expanded(
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8, // Reduce the width for white space
                child: Image.asset(
                  'assets/img.png', // Main image
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Rounded Black Container for Recent Images and Upload Button
          Container(
            decoration:const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding:const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Recents Text and Dropdown Icon
                const  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recents',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.white),
                  ],
                ),
                const  SizedBox(height: 16),

                // Grid View for Recent Images
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        images[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),

                const  SizedBox(height: 16),

                // Upload Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    padding:const EdgeInsets.symmetric(vertical: 16),
                    minimumSize:const Size(double.infinity, 50), // Set width to full width
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileSet2Screen()));

                  },
                  child:const Text('Set Profile'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
