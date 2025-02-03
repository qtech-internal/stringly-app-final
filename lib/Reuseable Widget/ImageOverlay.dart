import 'package:flutter/material.dart';

class ImageOverlay extends StatefulWidget {
  final List<String> images;

  ImageOverlay({required this.images});

  @override
  _ImageOverlayState createState() => _ImageOverlayState();
}

class _ImageOverlayState extends State<ImageOverlay> {
  int _currentIndex = 0; // Track the current image index
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9); // Slightly less than 1.0 for spacing
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width, // Full screen width for carousel
        height: MediaQuery.of(context).size.height * 0.6, // Taller height
        child: Stack(
          children: [
            Center(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.images.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add horizontal padding for spacing
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16), // Rounded corners
                      child: Image.network(
                        widget.images[index],
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width, // Full width for each image
                      ),
                    ),
                  );
                },
              ),
            ),
            // Rectangular Pagination Indicator
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20), // Spacing from bottom
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.images.length, (index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentIndex == index ? 16 : 8, // Wider for active indicator
                      height: 8, // Consistent height
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4), // Rounded corners for rectangular shape
                        color: _currentIndex == index ? Colors.white : Colors.grey,
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Function to show the full-width image overlay with spacing between images
void showImageOverlay(BuildContext context, List<String> images) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return ImageOverlay(images: images);
    },
  );
}
