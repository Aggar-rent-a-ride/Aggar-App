import 'package:aggar/core/cubit/edit_user_info/edit_user_info_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/pick_location_on_map_button.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/selected_location_map_contnet.dart'
    show SelectedLocationMapContent;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

class PickUserLocation extends StatefulWidget {
  final LatLng? initialLocation;
  const PickUserLocation({
    super.key,
    this.initialLocation,
  });

  @override
  State<PickUserLocation> createState() => _PickUserLocationState();
}

class _PickUserLocationState extends State<PickUserLocation> {
  final GlobalKey<FormFieldState> _formFieldKey = GlobalKey<FormFieldState>();
  final String uniqueId = const Uuid().v4();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<EditUserInfoCubit>();
    if (widget.initialLocation != null) {
      cubit.selectedLocation = widget.initialLocation;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditUserInfoCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Location",
            style: AppStyles.medium20(context).copyWith(
              color: context.theme.black100,
            ),
          ),
        ),
        FormField(
          key: _formFieldKey,
          initialValue: cubit.selectedLocation,
          validator: (value) {
            if (cubit.selectedLocation == null) {
              return 'Please select a location on the map';
            }
            return null;
          },
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (cubit.selectedLocation == null)
                PickLocationOnMapButton(
                  onPickLocation: (LatLng location, String locationAddress) {
                    cubit.updateLocation(location, locationAddress);
                    field.didChange(location);
                    _formFieldKey.currentState?.validate();
                  },
                )
              else
                SelectedLocationMapContent(
                  location: cubit.selectedLocation!,
                  address: cubit.addressController.text,
                  onEditLocation: (LatLng location, String locationAddress) {
                    cubit.updateLocation(location, locationAddress);
                    field.didChange(location);
                    _formFieldKey.currentState?.validate();
                  },
                  uniqueId: uniqueId,
                ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                  child: Text(
                    field.errorText!,
                    style: AppStyles.regular14(context).copyWith(
                      color: context.theme.red100_1,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
