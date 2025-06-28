import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/options_button.dart';
import 'package:aggar/features/profile/presentation/widgets/location_tab_widget.dart';
import 'package:aggar/features/profile/presentation/widgets/name_with_user_name_with_role.dart';
import 'package:aggar/features/profile/presentation/widgets/user_profile_with_image_path.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/app_styles.dart';
import '../../../main_screen/admin/model/user_model.dart';
import '../widgets/reviews_tab_widget.dart';

class ShowProfileScreen extends StatefulWidget {
  const ShowProfileScreen({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  State<ShowProfileScreen> createState() => _ShowProfileScreenState();
}

class _ShowProfileScreenState extends State<ShowProfileScreen>
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
    return Scaffold(
      backgroundColor: context.theme.white100_1,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                    color: context.theme.blue100_1,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 50,
                        ),
                        Text(
                          "Profile Account",
                          style: AppStyles.bold20(context).copyWith(
                            color: context.theme.white100_1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        OptionsButton(
                          user: widget.user,
                          color: AppConstants.myWhite100_1,
                        )
                      ],
                    ),
                  ),
                ),
                UserProfileWithImagePath(widget: widget),
              ],
            ),
            const Gap(60),
            const NameWithUserNameWithRole(),
            const Gap(20),
            TabBar(
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              controller: _tabController,
              padding: EdgeInsets.zero,
              indicatorPadding: EdgeInsets.zero,
              indicatorColor: context.theme.blue100_1,
              dividerColor: context.theme.black10,
              labelColor: context.theme.blue100_1,
              unselectedLabelColor: context.theme.gray100_2,
              labelStyle: AppStyles.bold18(context)
                  .copyWith(color: context.theme.blue100_1),
              unselectedLabelStyle: AppStyles.bold18(context).copyWith(
                color: context.theme.black25,
              ),
              tabs: const [
                Tab(text: 'Location'),
                Tab(text: 'Reviews'),
              ],
            ),
            const Gap(20),
            _selectedTabIndex == 0
                ? LocationTabWidget(
                    user: widget.user,
                  )
                : ReviewsTabWidget(
                    user: widget.user,
                    rate: 5,
                  ),
          ],
        ),
      ),
    );
  }
}
