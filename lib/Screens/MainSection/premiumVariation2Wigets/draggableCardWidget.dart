import 'package:flutter/material.dart';
import '../detailedNetworking.dart';
import '../detaileddating.dart';

// DraggableCard Widget
class DraggableCardWidget extends StatefulWidget {
  final String name;
  final String image;
  final String age;
  final int interests;
  final String location;
  final int index;
  final Color sideColor;
  final String overlayIcon;
  final dynamic userDetail;
  final String userId;
  final String loggedUserId;
  final VoidCallback onLeftButtonPressed;
  final VoidCallback onRightButtonPressed;
  final VoidCallback onLeftSwipeMore;
  final VoidCallback onRightSwipeMore;
  final String context;

  const DraggableCardWidget({
    Key? key,
    required this.name,
    required this.image,
    required this.age,
    required this.interests,
    required this.location,
    required this.index,
    required this.sideColor,
    required this.overlayIcon,
    required this.userDetail,
    required this.userId,
    required this.loggedUserId,
    required this.onLeftButtonPressed,
    required this.onRightButtonPressed,
    required this.onLeftSwipeMore,
    required this.onRightSwipeMore,
    required this.context
  }) : super(key: key);

  @override
  _DraggableCardWidgetState createState() => _DraggableCardWidgetState();
}

class _DraggableCardWidgetState extends State<DraggableCardWidget> {
  double _dragOffset = 0.0;
  final double _maxDrag = 100.0;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dx;
      _dragOffset = _dragOffset.clamp(-_maxDrag, _maxDrag);
    });

    if (_dragOffset <= -_maxDrag) {
      widget.onLeftSwipeMore();
      _resetDragOffset();
    } else if (_dragOffset >= _maxDrag) {
      widget.onRightSwipeMore();
      _resetDragOffset();
    }
  }

  void _resetDragOffset() {
    setState(() {
      _dragOffset = 0.0;
    });
  }

  void reset() {
    setState(() {
      _dragOffset = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xffd8509f), Color(0xe7df46c0)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0, left: 6),
                    child: TextButton(
                        onPressed: widget.onRightButtonPressed,
                        child: const Text(
                          'Match',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0, right: 6),
                    child: TextButton(
                        onPressed: widget.onLeftButtonPressed,
                        child: const Text('Skip',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600))),
                  ),
                ],
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(_dragOffset, 0),
            child: GestureDetector(
              onHorizontalDragUpdate: _onHorizontalDragUpdate,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: widget.sideColor, width: 1.3),
                ),
                margin: EdgeInsets.zero,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: widget.sideColor, width: 1.8),
                                image: DecorationImage(
                                  image: NetworkImage(widget.image),
                                  fit: BoxFit.cover,
                                  onError: null,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: -2.6,
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.all(2),
                                child: Image.asset(
                                  widget.overlayIcon,
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.name}, ${widget.age}',
                              style: TextStyle(
                                  color: widget.sideColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                            const SizedBox(height: 4),
                            Text('${widget.interests} interests in common'),
                            Text('Lives in ${widget.location}'),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                widget.context == 'dating'
                                    ? Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailedDating(
                                                data: widget.userDetail)))
                                    : Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Detailednetworking(
                                                data: widget.userDetail)));
                              },
                              child: const Text(
                                'Click to view details',
                                style: TextStyle(color: Colors.grey),
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
        ],
      ),
    );
  }
}