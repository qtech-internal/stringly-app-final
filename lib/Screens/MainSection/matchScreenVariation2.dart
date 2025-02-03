import 'package:flutter/material.dart';

import '../Chat/MessageScreen.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({Key? key}) : super(key: key);

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  // List of images representing matches
  List<String> matches = [
    'assets/img.png',
    'assets/img_1.png',
    'assets/img_2.png',
    'assets/img_3.png',
    'assets/img_4.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Matches', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final image = matches[index];
            return Dismissible(
              key: ValueKey(image), // Unique key for each item
              direction: DismissDirection.endToStart, // Swipe left to delete
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                color: Colors.red,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) {
                setState(() {
                  matches.removeAt(index); // Remove the match from the list
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Match deleted')),
                );
              },
              child: MatchCard(
                image: image,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  MessagesScreen(),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

// Match Card Widget
class MatchCard extends StatelessWidget {
  final String image;
  final VoidCallback onTap;

  const MatchCard({Key? key, required this.image, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.pink.shade100),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: onTap, // Navigate to MessageScreen on tap
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(image),
        ),
        title: const Text(
          'Hey! Jane Cooper is your Match now!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text('Start your conversation now.'),
        trailing: const CircleAvatar(
          radius: 6,
          backgroundColor: Colors.pink,
        ),
      ),
    );
  }
}
