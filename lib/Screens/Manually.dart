import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stringly/models/user_input_params.dart';
import '../constants/globals.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:http/http.dart' as http;

class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({super.key});

  @override
  _LocationSelectionScreenState createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {

  String? countryValue;
  String? stateValue;
  String? cityValue;
  UserInputParams userInputParams = UserInputParams();
  final String _googleApiKey = GlobalConstant.googleMapApiKey;
  String _selectedAddress = "";
  bool _isLoading = false;

  Future<void> _getCurrentLocationOnManualScreen() async {
    final hasPermission = await _checkLocationPermissionOnManualScreen();
    if (!hasPermission) return;
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _getAddressFromCoordinatesOnManualScreen(position.latitude, position.longitude);
  }

  // Check for location permission and enable it if necessary
  Future<bool> _checkLocationPermissionOnManualScreen() async {
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
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<void> _getAddressFromCoordinatesOnManualScreen(double lat, double lng) async {
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$_googleApiKey";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == "OK") {
          setState(() {
            _selectedAddress = data["results"][0]["formatted_address"];
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching address: $e");
    }
  }

  Future<void> _onUserCurrentLocationButtonPressed() async {
    setState(() {
      _isLoading = true; // Set loading to true when the button is pressed
    });

    bool hasPermission = await _checkLocationPermissionOnManualScreen();
    if (!hasPermission) {
      debugPrint("Location permission not granted.");
      setState(() {
        _isLoading = false; // Reset loading if permission fails
      });
      return;
    }

    Position position;
    try {
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      debugPrint("Location fetched: ${position.latitude}, ${position.longitude}");
      await _getAddressFromCoordinatesOnManualScreen(position.latitude, position.longitude);
      _extractCityStateCountry(_selectedAddress);
    } catch (e) {
      debugPrint("Error fetching location: $e");
    } finally {
      setState(() {
        _isLoading = false; // Reset loading after fetching location
      });
    }
  }


  void _extractCityStateCountry(String address) {
    String? country;
    String? state;
    String? city;
    List<String> components = address.split(',');
    if (components.isNotEmpty) {
      setState(() {
        country = components.last.trim(); // The last component is typically the country
        if (components.length > 1) state = components[components.length - 2].trim();
        if (components.length > 2) city = components[components.length - 3].trim();
      });
      UserInputParams userInputParams = UserInputParams();
      userInputParams.updateField('locationCountry', country);
      userInputParams.updateField('locationState', state);
      userInputParams.updateField('locationCity', city);
      debugPrint("Country: $country, State: $state, City: $city");
    } else {
      debugPrint("Unable to extract city, state, and country from address.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20,),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location',
                    style: GoogleFonts.roboto(
                      textStyle:const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Text(
                    'Add Manually',
                    style: GoogleFonts.roboto(
                      textStyle:const TextStyle(
                        fontSize: 17,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CSCPicker(
                    layout: Layout.vertical,
                    showStates: true,
                    showCities: true,
                    flagState: CountryFlag.ENABLE,
                    dropdownDecoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        border:
                        Border.all(color: const Color(0xffD6D6D6), width: 2)),

                    ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                    disabledDropdownDecoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        border:
                        Border.all(color: const Color(0xffD6D6D6), width: 2)),

                    ///placeholders for dropdown search field
                    countrySearchPlaceholder: "Country",
                    stateSearchPlaceholder: "State",
                    citySearchPlaceholder: "City",

                    ///labels for dropdown
                    countryDropdownLabel: "Country",
                    stateDropdownLabel: "State",
                    cityDropdownLabel: "City",

                    defaultCountry: CscCountry.India,
                    //disableCountry: true,

                    // countryFilter: [CscCountry.India,CscCountry.United_States,CscCountry.Canada],

                    ///selected item style [OPTIONAL PARAMETER]
                    selectedItemStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      height: 2.5,
                    ),

                    ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                    dropdownHeadingStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),

                    ///DropdownDialog Item style [OPTIONAL PARAMETER]
                    dropdownItemStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),

                    ///Dialog box radius [OPTIONAL PARAMETER]
                    dropdownDialogRadius: 10.0,

                    ///Search bar radius [OPTIONAL PARAMETER]
                    searchBarRadius: 10.0,

                    ///triggers once country selected in dropdown
                    onCountryChanged: (value) {
                      setState(() {
                        ///store value in country variable
                        countryValue = value;
                      });
                    },

                    ///triggers once state selected in dropdown
                    onStateChanged: (value) {
                      setState(() {
                        ///store value in state variable
                        stateValue = value;
                      });
                    },

                    ///triggers once city selected in dropdown
                    onCityChanged: (value) {
                      setState(() {
                        ///store value in city variable
                        cityValue = value;
                      });
                    },
                  ),

                  const  SizedBox(height: 220),
                  // "Use Current Location" Button
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () async {
                       await _onUserCurrentLocationButtonPressed();
                       if (mounted) {
                         Navigator.of(context).pop(); // Close current screen after fetching location
                         Navigator.of(context).pop(); // Close the previous screen
                       }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize:const Size(double.infinity, 50),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.blue,
                      )
                          : Text(
                        'Use Current Location',
                        style: GoogleFonts.roboto(
                          textStyle:const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // "Add Location" Button
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () {
                        if(countryValue != null && stateValue != null && cityValue != null) {
                           userInputParams.updateField('locationCountry', countryValue);
                           userInputParams.updateField('locationState', stateValue);
                           userInputParams.updateField('locationCity', cityValue);
                           Navigator.of(context).pop(); // Step 1: Close current screen
                           Navigator.of(context).pop();
                        }

                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize:const Size(double.infinity, 50),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Add Location',
                        style: GoogleFonts.roboto(
                          textStyle:const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
