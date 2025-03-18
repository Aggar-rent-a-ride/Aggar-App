import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../core/services/location_service.dart';
import 'map_location_state.dart';

class MapLocationCubit extends Cubit<MapLocationState> {
  static const LatLng defaultLocation = LatLng(30.0444, 31.2357);
  final MapController mapController = MapController();
  final TextEditingController searchController = TextEditingController();
  LatLng? selectedLocation;
  List<Marker> markers = [];
  String selectedAddress = '';
  bool isAddressLoading = false;
  final LocationService _locationService = LocationService();

  MapLocationCubit({LatLng? initialLocation}) : super(MapLocationLoading()) {
    initializeWithLocation(initialLocation ?? defaultLocation);
    fetchCurrentLocationInBackground();
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }

  void initializeWithLocation(LatLng location) {
    selectedLocation = location;
    markers = [createMarker(location)];
    emit(MapLocationInitialized(
      selectedLocation: location,
      markers: markers,
      selectedAddress: '',
      isAddressLoading: true,
    ));
    fetchAddressForLocation(location);
  }

  Marker createMarker(LatLng position) {
    return Marker(
      point: position,
      width: 80,
      height: 80,
      child: const Icon(
        Icons.location_pin,
        color: Colors.red,
        size: 40,
      ),
    );
  }

  Future<void> fetchAddressForLocation(LatLng position) async {
    try {
      final address =
          await _locationService.getAddressFromOpenStreetMap(position);
      selectedAddress = address;
      isAddressLoading = false;

      emit(MapLocationUpdated(
        selectedLocation: selectedLocation,
        markers: markers,
        selectedAddress: selectedAddress,
        isAddressLoading: isAddressLoading,
      ));
    } catch (e) {
      debugPrint('Error resolving address: $e');
      selectedAddress =
          'Coordinates: ${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}';
      isAddressLoading = false;

      emit(MapLocationUpdated(
        selectedLocation: selectedLocation,
        markers: markers,
        selectedAddress: selectedAddress,
        isAddressLoading: isAddressLoading,
      ));
    }
  }

  void updateSelectedLocation(LatLng position) {
    selectedLocation = position;
    markers = [createMarker(position)];
    selectedAddress = 'Loading address...';
    isAddressLoading = true;

    emit(MapLocationUpdating(
      selectedLocation: selectedLocation,
      markers: markers,
      selectedAddress: selectedAddress,
      isAddressLoading: isAddressLoading,
    ));

    fetchAddressForLocation(position);
  }

  Future<void> fetchCurrentLocationInBackground() async {
    try {
      final position = await _locationService.getCurrentPositionSilently();
      if (position != null) {
        LatLng currentLatLng = LatLng(position.latitude, position.longitude);
        if (currentLatLng.latitude != 0 && currentLatLng.longitude != 0) {
          mapController.move(currentLatLng, 15.0);
          updateSelectedLocation(currentLatLng);
        }
      }
    } catch (e) {
      debugPrint('Error getting current location: $e');
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      final permissionResult =
          await _locationService.checkAndRequestPermission();

      if (permissionResult == PermissionStatus.denied) {
        emit(MapLocationError(
          error: 'Location permissions are denied',
          selectedLocation: selectedLocation,
          markers: markers,
          selectedAddress: selectedAddress,
          isAddressLoading: isAddressLoading,
        ));
        return;
      }

      if (permissionResult == PermissionStatus.deniedForever) {
        emit(MapLocationError(
          error: 'Location permissions are permanently denied',
          selectedLocation: selectedLocation,
          markers: markers,
          selectedAddress: selectedAddress,
          isAddressLoading: isAddressLoading,
        ));
        return;
      }

      emit(MapLocationLoading());

      final position = await _locationService.getCurrentPosition();
      if (position != null) {
        LatLng currentLatLng = LatLng(position.latitude, position.longitude);
        mapController.move(currentLatLng, 15.0);
        updateSelectedLocation(currentLatLng);
      }
    } catch (e) {
      debugPrint('Error getting current location: $e');
      emit(MapLocationError(
        error: 'Failed to get current location: $e',
        selectedLocation: selectedLocation,
        markers: markers,
        selectedAddress: selectedAddress,
        isAddressLoading: isAddressLoading,
      ));
    }
  }

  Future<void> searchLocation(String query) async {
    if (query.isEmpty) return;

    selectedAddress = 'Searching...';
    isAddressLoading = true;

    emit(MapLocationUpdating(
      selectedLocation: selectedLocation,
      markers: markers,
      selectedAddress: selectedAddress,
      isAddressLoading: isAddressLoading,
    ));

    try {
      if (query.toLowerCase() == "egypt") {
        const egyptLatLng = LatLng(26.8206, 30.8025);
        mapController.move(egyptLatLng, 5.0);
        updateSelectedLocation(egyptLatLng);
        return;
      }

      final searchResult = await _locationService.searchByQuery(query);
      if (searchResult != null) {
        mapController.move(searchResult, 10.0);
        updateSelectedLocation(searchResult);
      } else {
        // Fallback to built-in geocoding
        searchUsingGeocoding(query);
      }
    } catch (e) {
      debugPrint('Error searching for location: $e');
      searchUsingGeocoding(query);
    }
  }

  Future<void> searchUsingGeocoding(String query) async {
    try {
      final searchResult = await _locationService.searchUsingGeocoding(query);
      if (searchResult != null) {
        mapController.move(searchResult, 10.0);
        updateSelectedLocation(searchResult);
      } else {
        selectedAddress = 'No results found';
        isAddressLoading = false;

        emit(MapLocationError(
          error: 'No locations found',
          selectedLocation: selectedLocation,
          markers: markers,
          selectedAddress: selectedAddress,
          isAddressLoading: isAddressLoading,
        ));
      }
    } catch (e) {
      debugPrint('Geocoding error: $e');
      selectedAddress = 'Location search failed';
      isAddressLoading = false;

      emit(MapLocationError(
        error: 'Search error: $e',
        selectedLocation: selectedLocation,
        markers: markers,
        selectedAddress: selectedAddress,
        isAddressLoading: isAddressLoading,
      ));
    }
  }

  Map<String, dynamic> getSelectedLocationData() {
    if (selectedLocation == null) {
      return {};
    }

    return {
      'latitude': selectedLocation!.latitude,
      'longitude': selectedLocation!.longitude,
      'address': selectedAddress.contains('Loading')
          ? 'Coordinates: ${selectedLocation!.latitude.toStringAsFixed(5)}, ${selectedLocation!.longitude.toStringAsFixed(5)}'
          : selectedAddress,
    };
  }
}
