import 'package:aggar/core/widgets/comment_section.dart';
import 'package:aggar/features/profile/presentation/views/profile_screen.dart';
import 'package:aggar/features/profile/presentation/widgets/car_item_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_assets.dart' show AppAssets;

class CarsTab extends StatelessWidget {
  const CarsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final cars =
        (context.findAncestorStateOfType<ProfileScreenState>())?.cars ?? [];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
        childAspectRatio: 0.8,
      ),
      itemCount: cars.length,
      itemBuilder: (context, index) {
        return CarItemWidget(car: cars[index]);
      },
    );
  }
}

class FavoriteTab extends StatelessWidget {
  const FavoriteTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Favorite Tab Content'),
    );
  }
}

class StaticsTab extends StatelessWidget {
  const StaticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Statics Tab Content'),
    );
  }
}

class ReviewsTab extends StatelessWidget {
  const ReviewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        CommentSection(
          name: "Scarlett  Johansson",
          commentText: "Was a good deal, nice person but bad car , fix it mf",
          date: "11/8/2024",
          rate: 3,
          imageUrl: AppAssets.assetsImagesNotificationPic2,
        ),
        CommentSection(
          name: "Scarlett  Johansson",
          commentText: "Was a good deal, nice person but bad car , fix it mf",
          date: "11/8/2024",
          rate: 3,
          imageUrl: AppAssets.assetsImagesNotificationPic2,
        ),
      ],
    );
  }
}
