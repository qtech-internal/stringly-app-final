import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  @override
  _FAQScreenState createState() => _FAQScreenState();
}



class _FAQScreenState extends State<FAQScreen> {
  late List<bool> _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = List<bool>.filled(10, false);
  }

  void _toggleExpansion(int index) {
    setState(() {
      _isExpanded[index] = !_isExpanded[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: const Row(
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              child: Image(
                image: AssetImage('assets/FAQ2.png'),
                width: 32,
                height: 32,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'FAQ',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              height: 730,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    9,  // Changed from 10 to 9
                        (index) => Column(
                      children: [
                        TextButtonRow(
                          text: _getQuestion(index),
                          onTap: () => _toggleExpansion(index),
                          isExpanded: _isExpanded[index],
                          showArrow: true,  // Always show arrow
                        ),
                        if (_isExpanded[index])
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _getAnswer(index),
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getQuestion(int index) {
    switch (index) {
      case 0:
        return 'What is Stringly?';
      case 1:
        return 'How do I Sign up?';
      case 2:
        return 'How is my data protected?';
      case 3:
        return 'What are reward points and how do I earn them?';
      case 4:
        return 'How can I use reward points?';
      case 5:
        return 'What is AI verification?';
      case 6:
        return 'How does premium subscription work?';
      case 7:
        return 'Can I cancel my subscription any time?';
      case 8:
        return 'How do I report a problem or User?';
      default:
        return '';
    }
  }

  String _getAnswer(int index) {
    switch (index) {
      case 0:
        return 'Stringly is a Web3-powered dating and networking app designed to provide you with control over your connections and privacy';
      case 1:
        return 'You can sign up using Internet Identity (ICP) or NFID for secure and decentralised authentication';
      case 2:
        return 'Your data is securely stored and encrypted within decentralised canisters, ensuring maximum privacy and protection.';
      case 3:
        return 'Reward points are in-app currency earned through activities like connecting with others, completing your profile, or engaging with daily challenges.';
      case 4:
        return  'Use reward points to unlock premium features, boost your profile visibility, or purchase virtual gifts.';
      case 5:
        return 'AI verification ensures that profiles are genuine by validating photos through advanced AI algorithms, awarding verified profiles a special badge';
      case 6:
        return 'Stringly offers multiple premium plans that unlock exclusive features like ‘Who Liked Me,’ Incognito Mode, and profile boosts.';
      case 7:
        return 'Subscriptions are non-refundable and cannot be cancelled once purchased. We kindly encourage you to choose your plan thoughtfully, as we won’t be able to process refunds or cancellations after the transaction is complete.';
      case 8:
        return 'Subscriptions are non-refundable and cannot be cancelled once purchased. We kindly encourage you to choose your plan thoughtfully, as we won’t be able to process refunds or cancellations after the transaction is complete.';
      default:
        return '';
    }
  }
}
class TextButtonRow extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool showArrow;
  final bool isExpanded;

  const TextButtonRow({
    Key? key,
    required this.text,
    required this.onTap,
    this.showArrow = true,
    required this.isExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Color(0xFF4E4949),
              ),
              softWrap: true,
              maxLines: null,
              overflow: TextOverflow.visible,
            ),
          ),
          if (showArrow)  // This will always show the arrow if showArrow is true
            AnimatedRotation(
              turns: isExpanded ? -0.5 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: const Icon(Icons.arrow_downward_outlined, color: Color(0xFF4E4949)),
            ),
        ],
      ),
    );
  }
}
