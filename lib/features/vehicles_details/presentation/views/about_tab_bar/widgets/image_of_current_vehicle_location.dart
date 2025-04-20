import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ImageOfCurrentVehicleLocation extends StatefulWidget {
  const ImageOfCurrentVehicleLocation(
      {super.key, required this.latitude, required this.longitude});
  final double latitude;
  final double longitude;
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<ImageOfCurrentVehicleLocation> {
  late LatLng staticLocation;
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    staticLocation = LatLng(widget.latitude, widget.longitude);
    _setStaticLocation();
  }

  void _setStaticLocation() {
    setState(() {
      markers.add(Marker(
        width: 50,
        height: 50.0,
        point: staticLocation,
        child: Icon(
          Icons.my_location,
          color: context.theme.blue100_1,
          size: 40.0,
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: staticLocation,
        initialZoom: 15.0,
        maxZoom: 15.0,
        minZoom: 15.0,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.none,
        ),
      ),
      children: [
        TileLayer(
          //TODO : templete would be change
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: const ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: markers,
        ),
      ],
    );
  }
}
