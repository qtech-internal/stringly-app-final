import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:stringly/constants/globals.dart';

import '../../../models/user_input_params.dart';

class MapController extends GetxController {
  late GoogleMapController mapController;
  final TextEditingController searchController = TextEditingController();

  final LatLng defaultPosition = const LatLng(28.6139, 77.2090);
  final String googleApiKey = GlobalConstant.googleMapApiKey;

  var currentPosition = const LatLng(28.6139, 77.2090).obs;
  var selectedAddress = ''.obs;
  var selectedMarker = Rxn<Marker>();

  var country = ''.obs;
  var state = ''.obs;
  var city = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }


  Future<void> getCurrentLocation() async {
    final hasPermission = await _checkLocationPermission();
    if (!hasPermission) return;

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    LatLng currentLatLng = LatLng(position.latitude, position.longitude);

    currentPosition.value = currentLatLng;
    selectedMarker.value = Marker(
      markerId: const MarkerId("current_location"),
      position: currentLatLng,
      infoWindow: const InfoWindow(title: "Current Location"),
    );

    mapController.animateCamera(CameraUpdate.newLatLngZoom(currentLatLng, 14));
    _getAddressFromCoordinates(position.latitude, position.longitude);
  }

  Future<bool> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;

    return true;
  }

  Future<void> _getAddressFromCoordinates(double lat, double lng) async {
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleApiKey";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == "OK") {
          selectedAddress.value = data["results"][0]["formatted_address"];
        }
      }
    } catch (e) {
      debugPrint("Error fetching address: $e");
    }
  }

  void onPlaceSelected(Prediction prediction) async {
    String? placeId = prediction.placeId;
    if (placeId == null) return;

    String url = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == "OK") {
          final location = data["result"]["geometry"]["location"];
          LatLng newPosition = LatLng(location["lat"], location["lng"]);

          currentPosition.value = newPosition;
          selectedMarker.value = Marker(
            markerId: const MarkerId("selected_location"),
            position: newPosition,
            infoWindow: InfoWindow(title: data["result"]["formatted_address"]),
          );
          selectedAddress.value = data["result"]["formatted_address"];

          mapController.animateCamera(CameraUpdate.newLatLngZoom(newPosition, 14));
        }
      }
    } catch (e) {
      debugPrint("Exception fetching place details: $e");
    }
  }

  void onMapTapped(LatLng position) async {
    selectedMarker.value = Marker(
      markerId: const MarkerId("selected_location"),
      position: position,
      infoWindow: const InfoWindow(title: "Selected Location"),
    );

    _getAddressFromCoordinates(position.latitude, position.longitude);
  }

  void onDoneButtonPressed() {
    if (selectedAddress.value.isEmpty) {
      Get.snackbar(
        "",
        "",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM, // Position the snackbar at the bottom
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Margin for spacing
        messageText: const Center( // Center the text inside the snackbar
          child: Text(
            "Please select an address.",
            style: TextStyle(
              color: Colors.white, // White color for the text
              fontSize: 16,
            ),
          ),
        ),
        titleText: const SizedBox.shrink(),
      );
      return;
    }

    _extractCityStateCountry(selectedAddress.value);
    Get.back();
  }

  void _extractCityStateCountry(String address) {
    List<String> components = address.split(',');
    if (components.isNotEmpty) {
      country.value = components.last.trim();
      if (components.length > 1) state.value = components[components.length - 2].trim();
      if (components.length > 2) city.value = components[components.length - 3].trim();

      UserInputParams userInputParams = UserInputParams();
      userInputParams.updateField('locationCountry', country.value);
      userInputParams.updateField('locationState', state.value);
      userInputParams.updateField('locationCity', city.value);
      debugPrint("Country: ${country.value}, State: ${state.value}, City: ${city.value}");
    } else {
      debugPrint("Unable to extract city, state, and country from address.");
    }
  }
}


