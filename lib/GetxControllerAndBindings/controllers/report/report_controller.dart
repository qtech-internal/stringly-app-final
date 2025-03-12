import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:stringly/Reuseable%20Widget/snackbar/custom_snack_bar.dart';
import 'package:stringly/intraction.dart';

class ReportController extends GetxController {
  var isReporting = false.obs;

  String url =
      "https://script.google.com/macros/s/AKfycbzxvuCxKRt-wqJAdog9gGmRg5R27SHp3KbtS36g7tpiRy80EqGEpI209vXX6jjN-igY/exec";
  final String loggedUserId = Intraction.loggedUserId!;
  Future<void> submitReportFunction(
      {required String selectedOption,
      required String userId,
      required String message}) async {
    // try {
    isReporting.value = true;
    Navigator.pop(Get.context!);
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "fromUser": loggedUserId,
        "toUser": userId,
        "optionSelected": selectedOption,
        "message": message,
      }),
    );
    isReporting.value = false;
    CustomSnackbar.successSnackbar(message: 'Report submitted successfully...');
  }
}
