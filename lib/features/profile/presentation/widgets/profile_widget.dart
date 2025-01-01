import 'package:aggar/features/profile/data/profile_model.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final Profile profile;

  const ProfileWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage(profile.avatarAsset),
        ),
        const SizedBox(height: 10),
        Text(profile.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(profile.role, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(profile.description, textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
