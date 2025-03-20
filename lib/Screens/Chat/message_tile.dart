import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stringly/Screens/Chat/PreviewChatImage.dart';
import 'AudioPlayer.dart';

class MessageTile extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isSender;
  final bool isLastMessage;
  final VoidCallback scrollToBottom;
  final VoidCallback imageScrollController;

  const MessageTile({
    super.key,
    required this.message,
    required this.isSender,
    required this.isLastMessage,
    required this.scrollToBottom,
    required this.imageScrollController,
  });

  bool get isShortTextMessage {
    return message['photo'] == null &&
        message['text'] != null &&
        message['text'].length < 20;
  }

  @override
  Widget build(BuildContext context) {
    // Check if the message contains audio
    if (message['audio'] != null) {
      return AudioPlayerWidget(
          audioPath: message['audio'] as String,
          isSender: isSender,
          message: message); // Ensure this is a string
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
                minWidth: 0,
              ),
              child: IntrinsicWidth(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: message['photo'] != null ? 3 : 6,
                    horizontal: message['photo'] != null ? 3 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSender ? Colors.black : const Color(0xffE6E6E6),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12),
                      topRight: const Radius.circular(12),
                      bottomLeft:
                          isSender ? const Radius.circular(12) : Radius.zero,
                      bottomRight:
                          isSender ? Radius.zero : const Radius.circular(12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: _buildMessageContent(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent() {
    if (message['photo'] != null) {
      return _buildImageContent();
    }
    return isShortTextMessage
        ? _buildShortTextMessage(isSender)
        : _buildLongTextMessage(isSender);
  }

  Widget _buildShortTextMessage(bool isSender) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message['text'] ?? '', // Provide a default value if null
          style: TextStyle(
            color: isSender ? Colors.white : Colors.black87,
            fontSize: 16,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 2),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            message['timestamp'] ?? '',
            style: TextStyle(
              color:
                  isSender ? const Color(0xffFAFAFA) : const Color(0xff0B0A0A),
              fontSize: 9,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLongTextMessage(bool isSender) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message['text'] ?? '', // Provide a default value if null
          style: TextStyle(
            color: isSender ? Colors.white : Colors.black87,
            fontSize: 16,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            message['timestamp'] ?? '', // Provide a default value if null
            style: TextStyle(
              color:
                  isSender ? const Color(0xffFAFAFA) : const Color(0xff0B0A0A),
              fontSize: 9,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        message['local'] == true ? _buildLocalImage() : _buildNetworkImage(),
        const SizedBox(height: 2),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            message['timestamp'] ?? '', // Provide a default value if null
            style: TextStyle(
              color:
                  isSender ? const Color(0xffFAFAFA) : const Color(0xff0B0A0A),
              fontSize: 9,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocalImage() {
    return GestureDetector(
      onTap: () => _navigateToPreview(isLocal: true),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Image.file(
              message['photo'],
              height: 200,
              width: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  width: 200,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.error,
                    size: 50,
                    color: Colors.red,
                  ),
                );
              },
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (frame != null) {
                  scrollToBottom();
                }
                return AnimatedOpacity(
                  opacity: frame == null ? 0 : 1,
                  duration: const Duration(milliseconds: 300),
                  child: child,
                );
              },
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkImage() {
    return GestureDetector(
      onTap: () => _navigateToPreview(isLocal: false),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Image.network(
              message['photo'] ?? '', // Provide a default value if null
              height: 200,
              width: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  width: 200,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.error,
                    size: 50,
                    color: Colors.red,
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  imageScrollController();
                  return child;
                }
                return Container(
                  height: 200,
                  width: 200,
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPreview({required bool isLocal}) {
    Navigator.of(Get.context!).push(
      MaterialPageRoute(
        builder: (context) => PreviewchatImage(
          imagePath: message['photo'],
          isLocal: isLocal,
          name: message['senderName'] ??
              'Unknown', // Provide a default value if null
          time: message['rawTime'] ?? '', // Provide a default value if null
        ),
      ),
    );
  }
}
