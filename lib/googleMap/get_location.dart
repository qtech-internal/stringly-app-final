import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stringly/constants/globals.dart';

class GetLocation {
  static Future<bool> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permission denied.');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied.');
      return false;
    }
    return true;
  }

  static Future<Map<String, String>> _getAddressFromLatLng(LatLng position) async {
    final String apiKey = GlobalConstant.googleMapApiKey;
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['results'] != null && data['results'].isNotEmpty) {
          final components = data['results'][0]['address_components'] as List;
          String country = '';
          String state = '';
          String city = '';

          for (var component in components) {
            final types = component['types'] as List;
            if (types.contains('country')) {
              country = component['long_name'];
            } else if (types.contains('administrative_area_level_1')) {
              state = component['long_name'];
            } else if (types.contains('locality')) {
              city = component['long_name'];
            }
          }

          print('-------$country, $state, $city');
          return {
            'country': country,
            'state': state,
            'city': city,
          };
        }
      }
    } catch (e) {
      print('Error getting address: $e');
    }
    print('not gettnng-------');
    return {
      'country': '',
      'state': '',
      'city': '',
    };
  }


  static Future<Map<String, String>> getCurrentLocationDetails() async {
    final hasPermission = await _checkLocationPermission();
    if (!hasPermission) return {'country': '', 'state': '', 'city': ''};

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final currentPosition = LatLng(position.latitude, position.longitude);
    print('--------------------------location: $currentPosition');
    return await _getAddressFromLatLng(currentPosition);
  }

}