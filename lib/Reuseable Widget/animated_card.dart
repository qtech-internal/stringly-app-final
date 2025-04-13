import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stringly/Screens/MainSection/detailedNetworking.dart';
import 'package:stringly/Screens/MainSection/detaileddating.dart';
import 'package:stringly/intraction.dart';
import 'package:stringly/models/global_constant_for_site_dating_networking.dart';
import 'package:stringly/models/swipe_input_model.dart';

import '../Screens/MainSection/LikeScreenVariationMatched.dart';
import '../Screens/MainSection/super_like_animation.dart';

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

  Future<void> rightSwipeWithPop(
      SwipeInputModel swipeInput, Map<String, String> matchPopParams) async {
    final result = await Intraction.rightSwipeAtProfilePage(swipeInput);

    if (result ==
        GlobalConstantForSiteDatingNetworking.matchFoundConditionStatement) {
      showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return PremiumVariation2Matched(
            usersInfo: matchPopParams,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 45 + ((widget.index - widget.currentIndex == 1) ? -30.0 : 0.0),
      left: 20.0,
      right: 20.0,
      child: Opacity(
        // opacity: widget.index - widget.currentIndex == 1 ? 0.9 : 1.0,
        opacity: 1.0,
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
                ? (details) async {
                    const double velocityThreshold = 1000.0;
                    final double velocity = details.velocity.pixelsPerSecond.dx;

                    if (cardOffset.dx.abs() > 100 ||
                        velocity.abs() > velocityThreshold) {
                      final bool isRight = cardOffset.dx > 0 || velocity > 0;
                      widget.onSwipeComplete();
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
                        'loggedUserImage':
                            widget.imageData['logged_user_image']!,
                        'currentUserProfileImage': widget.imageData['path']!,
                        'profileUserName': widget.imageData['name']!,
                        'ProfileUserId':
                            widget.imageData['current_profile_user_id'],
                        'loggedUserId': widget.imageData['logged_user_id'],
                      };

                      SwipeInputModel swipeInput = SwipeInputModel(
                        receiverId: widget.imageData['current_profile_user_id'],
                        site: widget.site,
                        senderId: widget.imageData['logged_user_id'],
                      );

                      if (isRight) {
                        // Intraction.rightSwipe(swipeInput);

                        await rightSwipeWithPop(swipeInput, matchPopParams);
                      } else {
                        Intraction.leftSwipe(swipeInput);
                      }
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
                              data: widget.imageData['forDetailNetworking'],
                            userId: widget.imageData['current_profile_user_id'],
                          ),
                        ),
                      );
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DetailedDating(
                              data: widget.imageData['forDetailNetworking'],
                              userId: widget.imageData['current_profile_user_id'],
                          ),
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
                              CachedNetworkImage(
                                imageUrl: widget.imageData['path']!,
                                fit: BoxFit.cover,
                                maxWidthDiskCache: 600,
                                maxHeightDiskCache: 600,
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    color: Colors.white,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const SizedBox.shrink(),
                              ),
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(
                                            0.7), // Dark overlay at the bottom
                                        Colors.transparent,
                                      ],
                                      stops: const [
                                        0.0, // Start gradient at the bottom
                                        0.5, // End gradient at 50% height (can be adjusted)
                                      ],
                                    ),
                                  ),
                                ),
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
                                              color: Colors.white,
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
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: Center(
                                    child: SuperLikeAnimation(
                                        username: widget.imageData['name']
                                            .split(' ')[0]),
                                  ),
                                );
                              },
                            );
                            Intraction.addSuperLike(
                                userId: widget.imageData['logged_user_id']!,
                                receiverId: widget
                                    .imageData['current_profile_user_id']!);
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
