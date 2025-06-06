import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/vehicle_id_section.dart';
import 'package:flutter/material.dart';

class VehilceImageSection extends StatelessWidget {
  const VehilceImageSection({
    super.key,
    required this.imagePath,
    required this.id,
  });

  final String imagePath;
  final int id;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          Image.network(
            EndPoint.baseUrl + imagePath,
            height: MediaQuery.sizeOf(context).height * 0.25,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.25,
                child: const Center(child: CircularProgressIndicator()),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                AppAssets.assetsImagesCar,
                height: MediaQuery.sizeOf(context).height * 0.25,
                width: double.infinity,
                fit: BoxFit.cover,
              );
            },
          ),
          IdSection(id: id),
        ],
      ),
    );
  }
}
