import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../GetxControllerAndBindings/controllers/account/account_settings_controller.dart';

class UploadProgressWidget extends StatefulWidget {
  final int index; // index to track individual progress

  const UploadProgressWidget({super.key, required this.index});

  @override
  _UploadProgressWidgetState createState() => _UploadProgressWidgetState();
}

class _UploadProgressWidgetState extends State<UploadProgressWidget> {
  final AccountSettingsController controller =
      Get.find<AccountSettingsController>();

  @override
  void initState() {
    super.initState();
    controller.startUploadProgress(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 6,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: LinearProgressIndicator(
                    value: controller.progress[widget.index]!
                        .value, // Bind the progress here
                    backgroundColor: Colors.white,
                    color: Colors.lightBlueAccent,
                    // Progress color
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
