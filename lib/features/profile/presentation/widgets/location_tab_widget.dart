import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';

class LocationTabWidget extends StatelessWidget {
  const LocationTabWidget({
    super.key,
    required this.user,
    required this.address,
  });

  final UserModel user;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: context.theme.blue100_1,
                      size: 24,
                    ),
                    const Gap(5),
                    Text(
                      maxLines: 5,
                      address.split(',').last.trim(),
                      style: AppStyles.bold24(context)
                          .copyWith(color: context.theme.blue100_1),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    address,
                    style: AppStyles.semiBold16(context).copyWith(
                      color: context.theme.black50,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: FlutterMap(
                mapController: MapController(),
                options: const MapOptions(
                  initialCenter: LatLng(30, 30),
                  initialZoom: 14.0,
                  maxZoom: 18.0,
                  minZoom: 2.0,
                  interactionOptions: InteractionOptions(
                    flags: InteractiveFlag.none,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.yourapp.name',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: const LatLng(30, 30),
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.location_on,
                          color: context.theme.red100_1,
                          size: 36,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
