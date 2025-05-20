import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/widgets/main_header.dart';
import 'package:aggar/features/notification/presentation/views/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.white100_1,
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: context.theme.blue100_8,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 55, bottom: 20),
                child: MainHeader(
                  //will be changed
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationScreen(),
                      )),
                ),
              ),
              const Gap(15),
            ],
          ),
        ),
      ),
    );
  }
}
