import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

enum PermissionStatus {
  granted,
  denied,
  deniedForever,
}

class LocationService {
  Future<String> getAddressFromOpenStreetMap(LatLng position) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}&zoom=18&addressdetails=1&accept-language=en');

    try {
      final response = await http.get(
        url,
        headers: {'User-Agent': 'LocationPickerApp/1.0'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['display_name'] ?? 'Address not found';
      } else {
        throw Exception('Failed to load address: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('OpenStreetMap error: $e');
      return 'Coordinates: ${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}';
    }
  }

  Future<PermissionStatus> checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return PermissionStatus.denied;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return PermissionStatus.deniedForever;
    }

    return PermissionStatus.granted;
  }

  Future<Position?> getCurrentPositionSilently() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      debugPrint('Silent location error: $e');
      return null;
    }
  }

  Future<Position?> getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      debugPrint('Error getting current position: $e');
      rethrow;
    }
  }

  Future<LatLng?> searchByQuery(String query) async {
    final encodedQuery = Uri.encodeComponent(query);
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$encodedQuery&format=json&limit=1&accept-language=en');

    try {
      final response = await http.get(
        url,
        headers: {'User-Agent': 'LocationPickerApp/1.0'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          return LatLng(lat, lon);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Search error: $e');
      return null;
    }
  }

  Future<LatLng?> searchUsingGeocoding(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        return LatLng(
          locations.first.latitude,
          locations.first.longitude,
        );
      }
      return null;
    } catch (e) {
      debugPrint('Geocoding error: $e');
      rethrow;
    }
  }
}
