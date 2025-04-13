import 'package:flutter/material.dart';

class Wholiked extends StatefulWidget {
  @override
  _WholikedState createState() => _WholikedState();
}

class _WholikedState extends State<Wholiked> {
  final List<Map<String, String>> images = [
    {
      'path': 'assets/img.png',
      'name': 'Jane Cooper, 25',
      'location': 'Lives in Portland, Illinois',
      'distance': '11 miles away',
    },
    {
      'path': 'assets/img_1.png',
      'name': 'John Doe, 30',
      'location': 'Lives in New York, NY',
      'distance': '5 miles away',
    },
    {
      'path': 'assets/img_2.png',
      'name': 'Alice Smith, 28',
      'location': 'Lives in Seattle, WA',
      'distance': '8 miles away',
    },
    {
      'path': 'assets/img_3.png',
      'name': 'Bob Johnson, 32',
      'location': 'Lives in Austin, TX',
      'distance': '15 miles away',
    },
    {
      'path': 'assets/img_4.png',
      'name': 'Emma Watson, 27',
      'location': 'Lives in Chicago, IL',
      'distance': '10 miles away',
    },
  ];

  int currentIndex = 0;
  Offset cardOffset = Offset.zero;
  double cardRotation = 0.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:const Text("Who liked you",
          style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          child: Stack(
            children: images.reversed.map((imageData) {
              int index = images.indexOf(imageData);
              if (index < currentIndex) {
                return Container(); // Don't show cards that are already swiped away
              }
              return Positioned(
                top: 20.0,
                left: 20.0,
                right: 20.0,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      cardOffset += details.delta;
                      cardRotation = cardOffset.dx * 0.001;
                    });
                  },
                  onPanEnd: (details) {
                    if (cardOffset.dx > 100) {
                      // Swipe right
                      setState(() {
                        currentIndex++;
                        cardOffset = Offset.zero;
                        cardRotation = 0.0;
                      });
                    } else if (cardOffset.dx < -100) {
                      // Swipe left
                      setState(() {
                        currentIndex++;
                        cardOffset = Offset.zero;
                        cardRotation = 0.0;
                      });
                    } else {
                      // Reset position
                      setState(() {
                        cardOffset = Offset.zero;
                        cardRotation = 0.0;
                      });
                    }
                  },
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 250,
                    child: Transform.translate(
                      offset: cardOffset,
                      child: Transform.rotate(
                        angle: cardRotation,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 4.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  imageData['path']!,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: 20,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        imageData['name']!,
                                        style:const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        imageData['location']!,
                                        style:const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        imageData['distance']!,
                                        style:const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
