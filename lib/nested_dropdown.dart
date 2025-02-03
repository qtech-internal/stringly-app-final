import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NestedDropdownExample(),
    );
  }
}

class NestedDropdownExample extends StatefulWidget {
  @override
  _NestedDropdownExampleState createState() => _NestedDropdownExampleState();
}

class _NestedDropdownExampleState extends State<NestedDropdownExample> {
  List<GlobalKey<_DraggableCardState>> draggableCardKeys = [];

  Widget _buildDraggableMatchCard(int index) {
    final cardKey = GlobalKey<_DraggableCardState>();
    draggableCardKeys.add(cardKey);

    return DraggableCard(
      key: cardKey,
      onLeftButtonPressed: () {
        print('Card $index skipped');
      },
      onRightButtonPressed: () {
        print('Card $index matched');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Draggable Card Example'),
      ),
      body: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, index) {
          return _buildDraggableMatchCard(index);
        },
      ),
    );
  }
}

class DraggableCard extends StatefulWidget {
  final VoidCallback onLeftButtonPressed;
  final VoidCallback onRightButtonPressed;

  const DraggableCard({
    Key? key,
    required this.onLeftButtonPressed,
    required this.onRightButtonPressed,
  }) : super(key: key);

  @override
  State<DraggableCard> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard> {
  double _dragOffset = 0.0;
  final double _maxDrag = 100.0;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dx;
      _dragOffset = _dragOffset.clamp(-_maxDrag, 0.0);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_dragOffset <= -_maxDrag) {
      widget.onLeftButtonPressed();
    }
    reset();
  }

  void reset() {
    setState(() {
      _dragOffset = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.redAccent, Colors.purpleAccent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: TextButton(
                      onPressed: (){},
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: TextButton(
                      onPressed: () {

                      },
                      child: const Text(
                        'Match',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Foreground
          Transform.translate(
            offset: Offset(_dragOffset, 0),
            child: GestureDetector(
              onHorizontalDragUpdate: _onHorizontalDragUpdate,
              onHorizontalDragEnd: _onHorizontalDragEnd,
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  height: 150,
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Card Content',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
