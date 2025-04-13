import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stringly/Reuseable%20Widget/snackbar/custom_snack_bar.dart';

class WhatAreYouLookingWidgets {
static List<String> items = [
  "A long-term relationship",
  "Fun & casual dates",
  "Marriage",
  "Intimacy & without commitment",
  "A life partner",
  "Ethical non-monogamy"
  ];

static Future<List<String>> showScrollablePopupFormProfession(
    BuildContext context, GlobalKey key, List<String> selectedItems) async {
  String? warning;
  return await showDialog<List<String>>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        key: key,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(selectedItems);
                        },
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'What are you looking for?',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    if(warning != null) const SizedBox(height: 20),
                    if(warning != null) Align(alignment: Alignment.center, child: Text(warning!, style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),)),
                    const SizedBox(height: 20),
                    // List of options
                    Column(
                      children: items.map((item) {
                        bool isSelected = selectedItems.contains(item);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedItems.remove(item);
                                warning = null;
                              } else {
                                if (selectedItems.length < 3) {
                                  selectedItems.add(item);
                                  warning = null;
                                } else {
                                 warning =  "You can select up to 3 options only.";
                                }
                              }
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: isSelected
                                  ? const LinearGradient(
                                colors: [Colors.purple, Colors.blue],
                              )
                                  : null,
                              color: isSelected ? null : Colors.white,
                              border: Border.all(color: Colors.grey),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Text(
                              item,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    // Done button
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(selectedItems);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text('Done'),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                );
              },
            ),
          ),
        ),
      );
    },
  ) ?? selectedItems; // If dialog is dismissed without a result, return current selection.
}

}
