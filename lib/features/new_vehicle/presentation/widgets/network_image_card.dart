import 'package:flutter/material.dart';

class NetworkImageCard extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onRemove;

  const NetworkImageCard({
    super.key,
    required this.imageUrl,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(
                  // Add your base URL if needed
                  "https://aggarapi.runasp.net$imageUrl"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
