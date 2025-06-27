import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/profile/presentation/widgets/location_tab_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/app_styles.dart';
import '../../../main_screen/admin/model/user_model.dart';
import '../../../messages/views/messages_status/presentation/widgets/widgets/avatar_chat_view.dart';
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
                    child: Text(
                      "Profile Account",
                      style: AppStyles.bold20(context).copyWith(
                        color: context.theme.white100_1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.1,
                  left: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: context.theme.white100_1,
                    radius: 55,
                    child: CircleAvatar(
                      radius: 48,
                      child: AvatarChatView(
                        image: widget.user.imagePath,
                        size: 90,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.user.name,
                    style: AppStyles.bold24(context).copyWith(
                      color: context.theme.blue100_1,
                    ),
                  ),
                  const Gap(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const Gap(4),
                      Text(
                        "4.8",
                        style: AppStyles.medium16(context).copyWith(
                          color: context.theme.gray100_2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        "(24 reviews)",
                        style: AppStyles.medium14(context).copyWith(
                          color: context.theme.gray100_2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(30),
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
                Tab(text: 'Location'),
                Tab(text: 'Reviews'),
              ],
            ),
            const Gap(20),
            _selectedTabIndex == 0
                ? LocationTabWidget(
                    user: widget.user,
                    address:
                        "12, Al Rashidy Street, Minya Al Qamh City, Eastern, 44692, Egypt",
                  )
                : ReviewsTabWidget(user: widget.user),
          ],
        ),
      ),
    );
  }
}
