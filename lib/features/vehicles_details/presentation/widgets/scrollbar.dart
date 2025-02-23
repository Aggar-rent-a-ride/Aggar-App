import 'package:flutter/cupertino.dart' show ScrollController;
import 'package:flutter/material.dart'
    show AppBar, BuildContext, Colors, Scaffold, StatelessWidget;
import 'package:flutter/widgets.dart';

class CustomScrollDemo extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  CustomScrollDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Scrollbar Demo'),
      ),
      body: RawScrollbar(
        thumbVisibility: true,
        padding: const EdgeInsets.symmetric(horizontal: 150),
        trackVisibility: true,
        trackRadius: const Radius.circular(50),
        trackColor: const Color(0xFF000000),
        controller: _scrollController,
        thumbColor: Colors.red, // Change the thumb color here
        radius: const Radius.circular(20),
        thickness: 5,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          child: Row(
            spacing: 50,
            children: List.generate(9, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 50), // Add spacing between items
                child: const Text("jjjjjj"),
              );
            }),
          ),
        ),
      ),
    );
  }
}
