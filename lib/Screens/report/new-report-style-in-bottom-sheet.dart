import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Reuseable Widget/GradientWidget.dart';

void showReportBottomSheet(BuildContext context) {
  String selectedReason = "";
  TextEditingController detailsController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Report User",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text("Which best describes what happened?"),
                    const SizedBox(height: 10),
                    _buildExpandableTile(
                        null,
                        "Scam, fake account, or selling something",
                        [
                          "They’re using photos of someone else",
                          "They’re asking for money",
                          "I sent them money",
                          "Sexual or pornographic content",
                          "They seem fake",
                        ],
                        selectedReason, (reason) {
                      setState(() => selectedReason = reason);
                    }),
                    _buildExpandableTile(
                        'Reason for reporting',
                        "Report a photo",
                        [
                          'Not the person',
                          'Person is under 18',
                          'Nudity or Pornographic',
                          'This infringes on my copyright',
                          'Inappropriate photo',
                        ],
                        selectedReason, (reason) {
                      setState(() => selectedReason = reason);
                    }),
                    _buildExpandableTile(
                        ' Please choose the option that best describes what happened',
                        "Inappropriate message or profile",
                        [
                          "Abusive, violent, or threatening language",
                          "Bullying or harassment",
                          "Unwanted sexual message or sexual harassment",
                          "Other",
                        ],
                        selectedReason, (reason) {
                      setState(() => selectedReason = reason);
                    }),
                    _buildExpandableTile(
                        ' How do you know this person?',
                        "In-person harm or unsafe situation",
                        [
                          "I went on a date with them",
                          "Sexual assault, coercion, or rape",
                          "Physical injury or harm",
                          "Harassment, abusive language, or threats",
                          "Stalking",
                          "Other",
                        ],
                        selectedReason, (reason) {
                      setState(() => selectedReason = reason);
                    }),
                    _buildExpandableTile(
                        null,
                        "Underage (under 18)",
                        [
                          "I suspect them of being under 18",
                          "They said they’re under 18",
                          "I know them in real life",
                        ],
                        selectedReason, (reason) {
                      setState(() => selectedReason = reason);
                    }),
                    const SizedBox(height: 30),
                    GradientTextField(
                      controller: detailsController,
                      height: 100,
                      maxLines: null,
                      label: const Text("Provide more details"),
                      hintText: 'Write something...',
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // (selectedReason + "\n" + detailsController.text);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Submit Report",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    },
  );
}

Widget _buildExpandableTile(String? subtitle, String title,
    List<String> options, String selectedReason, Function(String) onSelect) {
  return Theme(
    data: Theme.of(Get.context!).copyWith(dividerColor: Colors.transparent),
    child: ExpansionTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      childrenPadding: EdgeInsets.zero,
      tilePadding: const EdgeInsets.symmetric(horizontal: 0),
      shape: Border.all(color: Colors.transparent),
      collapsedShape: Border.all(color: Colors.transparent),
      children: [
        // Title above options
        subtitle != null
            ? Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    subtitle,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700]),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        // List of options
        ...options.map((option) => ListTile(
              title: Text(option),
              leading: Icon(
                selectedReason == option
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selectedReason == option ? Colors.blue : null,
              ),
              onTap: () => onSelect(option),
            )),
      ],
    ),
  );
}
