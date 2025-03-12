import 'package:flutter/material.dart';

import '../../Reuseable Widget/GradientWidget.dart';

void showReportBottomSheet(BuildContext context) {
  String selectedReason = "";
  TextEditingController detailsController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text("Which best describes what happened?"),
                    const SizedBox(height: 10),
                    _buildExpandableTile("Scam, fake account, or selling something", [
                      "They’re using photos of someone else",
                      "They’re asking for money",
                      "I sent them money",
                      "Sexual or pornographic content",
                      "They seem fake",
                    ], selectedReason, (reason) {
                      setState(() => selectedReason = reason);
                    }),
                    _buildExpandableTile("Inappropriate message or profile", [
                      "Abusive, violent, or threatening language",
                      "Bullying or harassment",
                      "Unwanted sexual message or sexual harassment",
                      "Other",
                    ], selectedReason, (reason) {
                      setState(() => selectedReason = reason);
                    }),
                    _buildExpandableTile("In-person harm or unsafe situation", [
                      "I went on a date with them",
                      "Sexual assault, coercion, or rape",
                      "Physical injury or harm",
                      "Harassment, abusive language, or threats",
                      "Stalking",
                      "Other",
                    ], selectedReason, (reason) {
                      setState(() => selectedReason = reason);
                    }),
                    _buildExpandableTile("Underage (under 18)", [
                      "I suspect them of being under 18",
                      "They said they’re under 18",
                      "I know them in real life",
                    ], selectedReason, (reason) {
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

Widget _buildExpandableTile(String title, List<String> options, String selectedReason, Function(String) onSelect) {
  return ExpansionTile(
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
    children: options
        .map((option) => ListTile(
      title: Text(option),
      leading: Icon(
        selectedReason == option ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: selectedReason == option ? Colors.blue : null,
      ),
      onTap: () => onSelect(option),
    ))
        .toList(),
  );
}
