import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationServices {
  final String orsApiKey =
      '5b3ce3597851110001cf624873891cbdefc5469692cfe07446254225';

  Future<LocationData?> getCurrentLocation() async {
    var location = Location();
    try {
      var userLocation = await location.getLocation();
      return userLocation;
    } on Exception {
      return null;
    }
  }

  Future<List<LatLng>?> getRoute(LatLng start, LatLng destination) async {
    final response = await http.get(
      Uri.parse(
          'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$orsApiKey&start=${start.longitude},${start.latitude}&end=${destination.longitude},${destination.latitude}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> coords =
          data['features'][0]['geometry']['coordinates'];
      return coords.map((coord) => LatLng(coord[1], coord[0])).toList();
    } else {
      return null;
    }
  }
}
