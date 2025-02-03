import 'package:flutter/material.dart';

class ExpandableContainer extends StatefulWidget {
  @override
  _ExpandableContainerState createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<ExpandableContainer> {
  bool _isExpanded = false; // To track if the main container is expanded
  bool _showPlusIconSection1 = false; // To track if the + icon should be shown for section 1
  bool _showPlusIconSection2 = false; // To track if the + icon should be shown for section 2
  bool _showPlusIconSection3 = false; // To track if the + icon should be shown for section 3
  bool _isNestedExpanded = false; // To track if the nested container is expanded
  String _firstContainerText = 'Tap to Expand'; // Text for the first container

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 300),
        // Container with the same size as a TextField
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded; // Toggle main expansion state
              _showPlusIconSection1 = false; // Reset + icon visibility for section 1
              _showPlusIconSection2 = false; // Reset + icon visibility for section 2
              _showPlusIconSection3 = false; // Reset + icon visibility for section 3
              _isNestedExpanded = false; // Reset nested expansion state
            });
          },
          child: Container(
            height: 56.0, // Height of the TextField
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            alignment: Alignment.center,
            child: Text(
              _firstContainerText, // Use dynamic text based on the selection
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        // Expanded Container
        if (_isExpanded) // Only show if expanded
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: EdgeInsets.only(top: 8.0), // Space between containers
            width: double.infinity, // Expand to full width
            height: 200.0, // Height of the popup container
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column( // Divide the expanded container into 3 sections vertically
              children: [
                GestureDetector( // Make Section 1 clickable
                  onTap: () {
                    setState(() {
                      _showPlusIconSection1 = !_showPlusIconSection1; // Toggle icon visibility
                      _showPlusIconSection2 = false; // Hide section 2's icon
                      _showPlusIconSection3 = false; // Hide section 3's icon
                      if (_showPlusIconSection1) {
                        _isNestedExpanded = false; // Reset nested expansion when showing + icon
                      }
                    });
                  },
                  child: Container(
                    width: double.infinity, // Set width to full
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Section 1',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(height: 8), // Space between text and icon
                        // Show the + icon only if true
                        if (_showPlusIconSection1 && !_isNestedExpanded) // Only show + icon when section is clicked and nested is not expanded
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isNestedExpanded = true; // Show nested expansion for section 1
                                _isExpanded = false; // Hide the first expanded container
                              });
                            },
                            child: Icon(
                              Icons.add, // Plus icon
                              color: Colors.white,
                              size: 24, // Icon size
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                GestureDetector( // Make Section 2 clickable
                  onTap: () {
                    setState(() {
                      _showPlusIconSection2 = !_showPlusIconSection2; // Toggle icon visibility
                      _showPlusIconSection1 = false; // Hide section 1's icon
                      _showPlusIconSection3 = false; // Hide section 3's icon
                      if (_showPlusIconSection2) {
                        _isNestedExpanded = false; // Reset nested expansion when showing + icon
                      }
                    });
                  },
                  child: Container(
                    width: double.infinity, // Set width to full
                    color: Colors.green,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Section 2',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(height: 8), // Space between text and icon
                        // Show the + icon only if true
                        if (_showPlusIconSection2 && !_isNestedExpanded) // Only show + icon when section is clicked and nested is not expanded
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isNestedExpanded = true; // Show nested expansion for section 2
                                _isExpanded = false; // Hide the first expanded container
                              });
                            },
                            child: Icon(
                              Icons.add, // Plus icon
                              color: Colors.white,
                              size: 24, // Icon size
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                GestureDetector( // Make Section 3 clickable
                  onTap: () {
                    setState(() {
                      _showPlusIconSection3 = !_showPlusIconSection3; // Toggle icon visibility
                      _showPlusIconSection1 = false; // Hide section 1's icon
                      _showPlusIconSection2 = false; // Hide section 2's icon
                      if (_showPlusIconSection3) {
                        _isNestedExpanded = false; // Reset nested expansion when showing + icon
                      }
                    });
                  },
                  child: Container(
                    width: double.infinity, // Set width to full
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Section 3',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(height: 8), // Space between text and icon
                        // Show the + icon only if true
                        if (_showPlusIconSection3 && !_isNestedExpanded) // Only show + icon when section is clicked and nested is not expanded
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isNestedExpanded = true; // Show nested expansion for section 3
                                _isExpanded = false; // Hide the first expanded container
                              });
                            },
                            child: Icon(
                              Icons.add, // Plus icon
                              color: Colors.white,
                              size: 24, // Icon size
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        // Nested Expanded Container
        if (_isNestedExpanded) // Show nested container if expanded
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: EdgeInsets.only(top: 8.0), // Space between containers
            width: double.infinity, // Expand to full width
            height: 200.0, // Height of the nested popup container
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                // Back button
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white), // Back icon
                      onPressed: () {
                        setState(() {
                          _isNestedExpanded = false; // Hide nested expansion
                          _isExpanded = true; // Show the first expanded container
                        });
                      },
                    ),
                  ),
                ),
                // Nested sections
                Expanded(
                  child: GestureDetector( // Make Section 7 clickable
                    onTap: () {
                      setState(() {
                        _firstContainerText = 'Section 7'; // Update the text for Section 7
                        _isNestedExpanded = false; // Hide the nested expansion
                        _isExpanded = false; // Hide the first expanded container as well
                      });
                    },
                    child: Container(
                      width: double.infinity, // Set width to full
                      color: Colors.blue,
                      child: Center(
                        child: Text(
                          'Section 7',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
