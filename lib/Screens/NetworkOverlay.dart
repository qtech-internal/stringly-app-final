import 'package:flutter/material.dart';

class Networkoverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: 600,  // Set the height of the dialog
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close Button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              SizedBox(height: 8),

              // Headline Input
              Text(
                'Headline',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Type something',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                  ),
                  border: UnderlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Second Input Field
              Text(
                'What are you exactly looking for?',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Type something',
                  hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400
                  ),
                  border: UnderlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Professional Focus Button
              Container(
                height: 60,
                child: TextButton(
                  onPressed: () {
                    // Action for professional focus button
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey[300]!, width: 1),  // Grey border
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('What is your main professional focus?'),
                  ),
                ),
              ),

              SizedBox(height: 12),

              // Skills Button
              Container(
                height: 60,
                child: TextButton(
                  onPressed: () {
                    // Action for skills button
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey[300]!, width: 1),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Skills'),
                  ),
                ),
              ),
              Spacer(),

              // Done Button
              Center(
                child: Container(
                  height: 50,width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Done', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
