import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/profile/presentation/widgets/review_user_section.dart';
import 'package:aggar/features/profile/presentation/widgets/saved_vehicle_section.dart';
import 'package:flutter/material.dart';

class ProfileTabBarSection extends StatefulWidget {
  const ProfileTabBarSection({super.key});

  @override
  State<ProfileTabBarSection> createState() => _ProfileTabBarSectionState();
}

class _ProfileTabBarSectionState extends State<ProfileTabBarSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedTabIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          controller: _tabController,
          padding: EdgeInsets.zero,
          indicatorPadding: EdgeInsets.zero,
          indicatorColor: context.theme.blue100_2,
          dividerColor: context.theme.black25,
          labelColor: context.theme.blue100_2,
          unselectedLabelColor: context.theme.gray100_2,
          labelStyle: AppStyles.bold18(context)
              .copyWith(color: context.theme.blue100_2),
          unselectedLabelStyle: AppStyles.bold18(context).copyWith(
            color: context.theme.black25,
          ),
          tabs: const [
            Tab(text: 'Saved'),
            Tab(text: 'Reviews'),
          ],
        ),
        _selectedTabIndex == 0
            ? const SavedVehicleSection()
            : const ReviewUserSection()
      ],
    );
  }
}
