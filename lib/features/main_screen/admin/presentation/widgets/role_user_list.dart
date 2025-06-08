import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_state.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart' show Shimmer;

class RoleUserList extends StatefulWidget {
  const RoleUserList(
      {super.key, required this.accessToken, required this.role});
  final String accessToken;
  final String role;

  @override
  _RoleUserListState createState() => _RoleUserListState();
}

class _RoleUserListState extends State<RoleUserList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    print('Scroll position: current=$currentScroll, max=$maxScroll');
    if (currentScroll >= maxScroll * 0.9 &&
        !context.read<UserCubit>().isLoadingMore) {
      final cubit = context.read<UserCubit>();
      print(
          'Scroll trigger: currentPage=${cubit.currentPage}, totalPages=${cubit.totalPages}');
      if (cubit.currentPage <= cubit.totalPages) {
        cubit.isLoadingMore = true;
        cubit.getUserWithRole(widget.accessToken, widget.role,
            isLoadMore: true);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        print('UI state: $state');
        if (state is UserLoaded || state is UsersLoadingMore) {
          final users = state is UserLoaded
              ? state.users.data
              : (state as UsersLoadingMore).users.data;

          if (users.isEmpty) {
            return Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_off,
                      size: 64,
                      color: context.theme.gray100_1,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No users found',
                      style: TextStyle(
                        fontSize: 18,
                        color: context.theme.gray100_1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try adjusting your filters',
                      style: TextStyle(
                        fontSize: 14,
                        color: context.theme.gray100_1,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Expanded(
            child: Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await context
                          .read<UserCubit>()
                          .refreshUsers(widget.accessToken, widget.role);
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        print('Rendering user: ${users[index].toString()}');
                        return UserCard(user: users[index]);
                      },
                    ),
                  ),
                ),
                if (state is UsersLoadingMore)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Shimmer.fromColors(
                      baseColor: context.theme.gray100_1,
                      highlightColor: context.theme.white100_1,
                      child: const CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          );
        } else if (state is UserError) {
          return Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: context.theme.red100_1,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading users',
                    style: TextStyle(
                      fontSize: 18,
                      color: context.theme.black100,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: context.theme.gray100_1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context
                        .read<UserCubit>()
                        .getUserWithRole(widget.accessToken, widget.role),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        } else {
          // Loading or NoSearch state
          return Expanded(
            child: Shimmer.fromColors(
              baseColor: context.theme.gray100_1,
              highlightColor: context.theme.white100_1,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  children: List.generate(
                    5,
                    (index) => Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: context.theme.white100_1,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.only(bottom: 15),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
