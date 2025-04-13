import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../ImageBioEdit/ImageBio.dart';
import '../UserInfo5.dart';

class ProfileSet2Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) =>const LinearGradient(
                    colors: [Color(0xFFD83694), Color(0xFF0039C7)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
                  child: Text(
                    'Progress',
                    style: GoogleFonts.roboto(
                      textStyle:const TextStyle(
                        fontSize: 19,
                        color: Colors.white, // The color is overridden by the gradient
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 230),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: Image.asset('assets/reward.png'),
                ),
                const Text(
                  '+1',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Progress Indicator Text
            Row(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) =>const LinearGradient(
                    colors: [Color(0xFFD83694), Color(0xFF0039C7)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
                  child: Text(
                    '3',
                    style: GoogleFonts.roboto(
                      textStyle:const TextStyle(
                        fontSize: 18,
                        color: Colors.white, // Overridden by gradient
                      ),
                    ),
                  ),
                ),
                Text(
                  ' of 4 steps completed',
                  style: GoogleFonts.roboto(
                    textStyle:const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) {
                return Expanded(
                  child: Container(
                    height: 8,
                    margin:const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: (index <= 2) // Apply gradient to first 3 bars
                          ?const LinearGradient(
                        colors: [Color(0xFFD83694), Color(0xFF0039C7)],
                      )
                          : LinearGradient(
                        colors: [Colors.grey[300]!, Colors.grey[300]!],
                      ),
                    ),
                  ),
                );
              }),
            ),
            const  SizedBox(height: 20),
            // Profile Section
            const Text(
              'Set Profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Profile Image Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
                children: [
                  // First image
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/img_1.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Placeholder images
                  for (int i = 0; i < 3; i++)
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:const Center(
                        child: Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const  SizedBox(height: 10),
            // Set Profile Button
            Center(
              child: SizedBox(
                width: double.infinity, // Set the button to take the full width of the screen
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserPreferenceScreen()));

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding:const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child:const Text(
                    'Set Profile',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
