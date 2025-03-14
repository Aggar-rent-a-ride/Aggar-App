import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController mapController = MapController();
  LocationData? currentLocation;
  Marker? currentMarker;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    var location = Location();

    try {
      var userLocation = await location.getLocation();
      setState(() {
        currentLocation = userLocation;
      });
    } on Exception {
      currentLocation = null;
    }

    location.onLocationChanged.listen((LocationData newLocation) {
      setState(() {
        currentLocation = newLocation;
      });
    });
  }

  void _setSingleMarkerAndLog(LatLng point) {
    setState(() {
      currentMarker = Marker(
        width: 80.0,
        height: 80.0,
        point: point,
        child: const Icon(Icons.location_on, color: Colors.red, size: 40.0),
      );
    });
  }

  void _showCurrentLocation() {
    if (currentLocation != null) {
      final LatLng userLatLng = LatLng(
        currentLocation!.latitude!,
        currentLocation!.longitude!,
      );
      setState(() {
        currentMarker = Marker(
          width: 80.0,
          height: 80.0,
          point: userLatLng,
          child: const Icon(Icons.my_location, color: Colors.blue, size: 40.0),
        );
      });
      mapController.move(userLatLng, 16.0);
    }
  }

  void showCoordinatesDialog() {
    if (currentMarker != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Marker Coordinates'),
            content: Text(
              'Latitude: ${currentMarker!.point.latitude}\n'
              'Longitude: ${currentMarker!.point.longitude}',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set a marker first!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            showCoordinatesDialog();
          },
          icon: const Icon(Icons.check),
        ),
      ),
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!),
                initialZoom: 16.0,
                onTap: (tapPosition, point) => _setSingleMarkerAndLog(point),
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                ),
                if (currentMarker != null)
                  MarkerLayer(
                    markers: [currentMarker!],
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
