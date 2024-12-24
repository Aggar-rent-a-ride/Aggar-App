import 'package:flutter/material.dart';

class CardType extends StatelessWidget {
  const CardType({
    super.key,
    this.icon,
    this.title,
    this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final IconData? icon;
  final String? title;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: isSelected ? Colors.blue : Colors.grey, // Change color
            ),
            borderRadius: BorderRadius.circular(10),
            color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white, // Optional background
          ),
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon ?? Icons.person, size: 50),
              const SizedBox(height: 8),
              Text(
                title ?? 'User',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle ?? 'Can use cars & buy for them',
                style: const TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
