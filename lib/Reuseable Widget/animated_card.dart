import 'package:flutter/material.dart';
import 'package:stringly/Screens/MainSection/detailedNetworking.dart';
import 'package:stringly/Screens/MainSection/detaileddating.dart';
import 'package:stringly/intraction.dart';
import 'package:stringly/models/global_constant_for_site_dating_networking.dart';
import 'package:stringly/models/swipe_input_model.dart';

import '../Screens/MainSection/LikeScreenVariationMatched.dart';

class AnimatedCard extends StatefulWidget {
  final Map<String, dynamic> imageData;
  final int index;
  final int currentIndex;
  final VoidCallback onSwipeComplete;
  final bool isToggled;
  final String site;

  const AnimatedCard({
    Key? key,
    required this.imageData,
    required this.index,
    required this.currentIndex,
    required this.isToggled,
    required this.onSwipeComplete,
    required this.site,
  }) : super(key: key);

  @override
  _AnimatedCardState createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard> {
  Offset cardOffset = Offset.zero;
  double cardRotation = 0.0;
  bool isFirstSwipe = true;

  Color _getOverlayColor(int cardIndex) {
    if (cardIndex != widget.currentIndex) return Colors.transparent;

    final double swipeProgress = (cardOffset.dx.abs() / 100.0).clamp(0.0, 1.0);
    final double thresholdProgress =
    ((swipeProgress - 0.8) * 1.25).clamp(0.0, 0.2);

    if (cardOffset.dx > 0) {
      return Colors.green.withOpacity(thresholdProgress);
    } else if (cardOffset.dx < 0) {
      return Colors.red.withOpacity(thresholdProgress);
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 45 + ((widget.index - widget.currentIndex == 1) ? -30.0 : 0.0),
      left: 20.0,
      right: 20.0,
      child: Opacity(
        opacity: widget.index - widget.currentIndex == 1 ? 0.9 : 1.0,
        child: Transform.scale(
          scale: widget.index - widget.currentIndex == 1 ? 0.98 : 1.0,
          child: GestureDetector(
            onPanUpdate: widget.index == widget.currentIndex
                ? (details) {
              setState(() {
                cardOffset = Offset(
                  cardOffset.dx + details.delta.dx,
                  -cardOffset.dx.abs() * 0.2,
                );

                cardRotation = -cardOffset.dx * 0.001;
              });
            }
                : null,
            onPanEnd: widget.index == widget.currentIndex
                ? (details) {
              const double velocityThreshold = 1000.0;
              final double velocity = details.velocity.pixelsPerSecond.dx;

              if (cardOffset.dx.abs() > 100 ||
                  velocity.abs() > velocityThreshold) {
                final bool isRight = cardOffset.dx > 0 || velocity > 0;

                setState(() {
                  cardOffset = Offset(
                    isRight
                        ? MediaQuery.of(context).size.width * 1.5
                        : -MediaQuery.of(context).size.width * 1.5,
                    -MediaQuery.of(context).size.height * 0.4,
                  );

                  cardRotation = isRight ? -0.2 : 0.2;
                });

                Map<String, String> matchPopParams = {
                  'loggedUserImage':  widget.imageData['logged_user_image']!,
                  'currentUserProfileImage':  widget.imageData['path']!,
                  'profileUserName':  widget.imageData['name']!,
                  'ProfileUserId': widget.imageData['current_profile_user_id'],
                  'loggedUserId': widget.imageData['logged_user_id'],
                };

                SwipeInputModel swipeInput = SwipeInputModel(
                  receiverId: widget.imageData['current_profile_user_id'],
                  site: widget.site,
                  senderId: widget.imageData['logged_user_id'],
                );

                if (isRight) {
                  // Intraction.rightSwipe(swipeInput);
                  Future<void> rightSwipeWithPop() async {
                    final result = await Intraction.rightSwipeAtProfilePage(swipeInput);
                    if(result == GlobalConstantForSiteDatingNetworking.matchFoundConditionStatement) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return PremiumVariation2Matched(
                            usersInfo: matchPopParams,
                          );
                        },
                      );
                    }
                  }
                  rightSwipeWithPop();
                } else {
                  Intraction.leftSwipe(swipeInput);
                }

                widget.onSwipeComplete();
              } else {
                setState(() {
                  cardOffset = Offset.zero;
                  cardRotation = 0.0;
                });
              }
            }
                : null,
            onTap: widget.index == widget.currentIndex
                ? () {
              if (widget.isToggled) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Detailednetworking(
                        data: widget.imageData['forDetailNetworking']),
                  ),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetailedDating(
                        data: widget.imageData['forDetailNetworking']),
                  ),
                );
              }
            }
                : null,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: Transform.translate(
                offset: widget.index == widget.currentIndex
                    ? cardOffset
                    : Offset.zero,
                child: Transform.rotate(
                  angle:
                  widget.index == widget.currentIndex ? cardRotation : 0.0,
                  origin: Offset(0, MediaQuery.of(context).size.height * 0.65),
                  child: Stack(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 4.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                widget.imageData['path']!,
                                errorBuilder: (BuildContext context,
                                    Object error, StackTrace? stackTrace) {
                                  return Container(
                                    color: Colors.grey,
                                    child: const Icon(
                                      Icons.broken_image,
                                      color: Colors.white,
                                      size: 50.0,
                                    ),
                                  );
                                },
                                fit: BoxFit.cover,
                              ),
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    color: _getOverlayColor(widget.index),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 20,
                                right: 20,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 30.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${widget.imageData['name']}, ${widget.imageData['age']}',
                                        style: const TextStyle(
                                          fontFamily: 'SFProDisplay',
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        widget.imageData['location']!,
                                        style: const TextStyle(
                                          fontFamily: 'SFProDisplay',
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        widget.imageData['distance']!,
                                        style: const TextStyle(
                                          fontFamily: 'SFProDisplay',
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      SizedBox(
                                        width:
                                        MediaQuery.of(context).size.width -
                                            100,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 20.0),
                                          child: Text(
                                            widget.imageData['info']!,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.left,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: GestureDetector(
                          onTapDown: (details) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Center(child: Text('Coming soon!')),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Image.asset(
                            'assets/SUPERLIKE_new.png',
                            height: 38,
                            width: 38,
                          ),
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
  }
}
