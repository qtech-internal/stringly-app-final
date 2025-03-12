import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import '../../Reuseable Widget/gradienttextfield.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  ReportIssueScreenState createState() => ReportIssueScreenState();
}

class ReportIssueScreenState extends State<ReportIssueScreen> {
  final List<String> issueItems = [
    'Scam, fake account, or selling something',
    'Report a photo',
    'Inappropriate message or profile',
    'In person harm or unsafe situation',
    'Underage (under 18)',
    'Other',
  ];

  final List<String> fakeAccountReasons = [
    'They’re using photos of someone else',
    'They’re asking for money',
    'I sent them money',
    'Sexual or pornographic content',
    'They seem fake',
  ];

  final List<String> photoReasons = [
    'Not the person',
    'Person is under 18',
    'Nudity or Pornographic',
    'This infringes on my copyright',
    'Inappropriate photo',
  ];

  String? selectedIssue;
  String? selectedReason;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: const Row(
          children: [
            Image(
                image: AssetImage('assets/report2.png'), width: 32, height: 32),
            SizedBox(width: 8),
            Text('Report an Issue', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Center(
                child: Image.asset('assets/COLOURED LOGO 1.png', height: 40)),
            const SizedBox(height: 16),
            const Text(
              'How can we help you?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            _buildDropdown(
              items: issueItems,
              hintText: 'What\'s the issue?',
              label: 'What Issues are you facing?',
              selectedIssue: selectedIssue,
              onChanged: (value) {
                setState(() {
                  if (selectedIssue != value) {
                    selectedReason = null;
                  }
                  selectedIssue = value;
                });
              },
            ),
            if (selectedIssue ==
                'Scam, fake account, or selling something') ...[
              const SizedBox(height: 20),
              _buildDropdown(
                  hintText: 'Select a reason',
                  label: 'Select an issue',
                  items: fakeAccountReasons,
                  selectedIssue: selectedReason,
                  onChanged: (value) {
                    setState(() {
                      selectedReason = value;
                    });
                  }),
            ],
            if (selectedIssue == 'Report a photo') ...[
              const SizedBox(height: 20),
              _buildDropdown(
                  hintText: 'Reason for reporting',
                  label: 'Reason for reporting',
                  items: photoReasons,
                  selectedIssue: selectedReason,
                  onChanged: (value) {
                    setState(() {
                      selectedReason = value;
                    });
                  }),
            ],
            //
            const SizedBox(height: 300),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
      {required String? selectedIssue,
      required String hintText,
      required String label,
      required Function(String?) onChanged,
      required List<String> items}) {
    return GradientdropdownTextField(
      hintText: hintText,
      items: items,
      onChanged: (value) {
        if (value is DropDownValueModel) {
          onChanged(value.name);
        } else if (value is String) {
          onChanged(value);
        }
      },
      label: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () => _showReportedSuccessfullyDialog(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text('Submit Report',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildLabel(String text) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child:
          Text(text, style: const TextStyle(color: Colors.black, fontSize: 14)),
    );
  }

  void _showReportedSuccessfullyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 30),
                Image.asset('assets/tick.png', height: 100, width: 100),
                const SizedBox(height: 8),
                const Text(
                  'Report Submitted Successfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Thank you for helping us keep Stringly safe and enjoyable for everyone. Our team will review your report within 24-72 hours. If further information is needed, we’ll reach out to you.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
