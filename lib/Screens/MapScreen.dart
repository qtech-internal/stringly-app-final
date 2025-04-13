import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import '../GetxControllerAndBindings/controllers/mapScreen/mapScreenController.dart';
import 'Manually.dart';

class MapScreen extends StatelessWidget {
  final MapController controller = Get.find<MapController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(() => GoogleMap(
            compassEnabled: false,
            initialCameraPosition: CameraPosition(
              target: controller.currentPosition.value,
              zoom: 14,
            ),
            onMapCreated: (mapController) => controller.mapController = mapController,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onTap: controller.onMapTapped,
            markers: controller.selectedMarker.value != null ? {controller.selectedMarker.value!} : {},
          )),
          Obx(() => controller.selectedAddress.isNotEmpty
              ? Positioned(
            bottom: 155,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                controller.selectedAddress.value,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          )
              : const SizedBox.shrink()),
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: GooglePlaceAutoCompleteTextField(
                  textEditingController: controller.searchController,
                  googleAPIKey: controller.googleApiKey,
                  inputDecoration: const InputDecoration(
                    hintText: 'Search location...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    icon: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.search, color: Colors.grey),
                    ),
                  ),
                  debounceTime: 800,
                  countries: const ['in'],
                  getPlaceDetailWithLatLng: controller.onPlaceSelected,
                  itemClick: (prediction) {
                    controller.searchController.text = prediction.description!;
                  },
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 230,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => const LocationSelectionScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 40),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Add Manually',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 230,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.onDoneButtonPressed
                       // controller.getCurrentLocation;
                      ,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 40),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Use Location',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}