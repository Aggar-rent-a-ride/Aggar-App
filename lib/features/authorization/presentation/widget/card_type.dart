import 'package:flutter/material.dart';

class CardType extends StatelessWidget {
  const CardType({super.key, this.icon, this.title, this.subtitle});

  final IconData? icon;
  final String? title;
  final String? subtitle;
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // setState(() {
          //   selectedType = 'User';
          // });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              // color: selectedType == 'User' ? Colors.blue : Colors.grey,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(8),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person, size: 50),
              SizedBox(height: 8),
              Text(
                'User',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 4),
              Text('Can use cars & buy for them', textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
