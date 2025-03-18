import 'package:aggar/features/new_vehicle/data/cubits/map_location/map_location_state.dart'
    show
        MapLocationError,
        MapLocationInitialized,
        MapLocationState,
        MapLocationUpdated,
        MapLocationUpdating;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

List<Marker> getMarkersFromState(MapLocationState state) {
  if (state is MapLocationInitialized) return state.markers;
  if (state is MapLocationUpdating) return state.markers;
  if (state is MapLocationUpdated) return state.markers;
  if (state is MapLocationError) return state.markers;
  return [];
}

LatLng? getLocationFromState(MapLocationState state) {
  if (state is MapLocationInitialized) return state.selectedLocation;
  if (state is MapLocationUpdating) return state.selectedLocation;
  if (state is MapLocationUpdated) return state.selectedLocation;
  if (state is MapLocationError) return state.selectedLocation;
  return null;
}

String getAddressFromState(MapLocationState state) {
  if (state is MapLocationInitialized) return state.selectedAddress;
  if (state is MapLocationUpdating) return state.selectedAddress;
  if (state is MapLocationUpdated) return state.selectedAddress;
  if (state is MapLocationError) return state.selectedAddress;
  return '';
}

bool isAddressLoadingFromState(MapLocationState state) {
  if (state is MapLocationInitialized) return state.isAddressLoading;
  if (state is MapLocationUpdating) return state.isAddressLoading;
  if (state is MapLocationUpdated) return state.isAddressLoading;
  if (state is MapLocationError) return state.isAddressLoading;
  return false;
}
