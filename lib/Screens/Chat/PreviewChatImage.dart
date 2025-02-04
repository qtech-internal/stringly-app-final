import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PreviewchatImage extends StatelessWidget {
  final dynamic imagePath;
  final bool isLocal;
  final String name;
  final dynamic time;
  const PreviewchatImage(
      {super.key,
      required this.imagePath,
      required this.isLocal,
      required this.name,
      this.time});

  String _formatWhatsAppDateOnPreviewImage(String dateTimeString) {
    // Parse the string into a DateTime object (assumed to be in UTC)
    DateTime dateTime = DateTime.parse(dateTimeString)
        .add(Duration(hours: 5, minutes: 30)); // Convert to IST

    // Get the current date and time in IST
    DateTime now = DateTime.now()
        .toUtc()
        .add(Duration(hours: 5, minutes: 30)); // Convert now to IST

    // Remove the time component for accurate day comparison
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime inputDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    // Get the difference in days
    int daysDifference = today.difference(inputDate).inDays;

    // Format the time
    String timeString = DateFormat('hh:mm a').format(dateTime);

    // Determine the appropriate date format
    if (daysDifference == 0) {
      // Today
      return 'Today, $timeString';
    } else if (daysDifference == 1) {
      // Yesterday
      return "Yesterday, $timeString";
    } else if (daysDifference < 7) {
      // Within the last week
      return "${DateFormat('EEEE').format(dateTime)}, $timeString"; // Day of the week (e.g., Monday)
    } else if (dateTime.year == now.year) {
      // Within the same year
      return "${DateFormat('d MMM').format(dateTime)}, $timeString"; // Day and month (e.g., 16 Jan)
    } else {
      // For dates in a different year
      return "${DateFormat('d MMM yyyy').format(dateTime)}, $timeString"; // Full date (e.g., 16 Jan 2024)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  name,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                )),
            Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  _formatWhatsAppDateOnPreviewImage(time),
                  style: const TextStyle(fontSize: 12),
                )),
          ],
        ),
      ),
      body: Center(
        child: isLocal == true
            ? Image.file(
                imagePath,
              )
            : Image.network(
                imagePath,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child:
                        CircularProgressIndicator(), // Show loading indicator while the image is loading
                  );
                },
              ),
      ),
    );
  }
}
