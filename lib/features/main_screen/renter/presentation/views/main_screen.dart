import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_state.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/loading_main_screen.dart';
import 'package:aggar/features/main_screen/renter/presentation/views/main_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../new_vehicle/data/cubits/add_vehicle_cubit/add_vehicle_cubit.dart';
import '../../../../new_vehicle/data/cubits/additinal_images_cubit/additinal_images_cubit.dart';
import '../../../../new_vehicle/data/cubits/main_image_cubit/main_image_cubit.dart';
import '../../../../new_vehicle/data/cubits/map_location/map_location_cubit.dart';
import '../../../../new_vehicle/presentation/views/add_vehicle_screen.dart';
import 'package:aggar/core/services/signalr_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  bool _isLoadingToken = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeToken();
      _startSignalR();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _initializeToken();
    }
  }

  Future<void> _initializeToken() async {
    if (!mounted) return;

    setState(() {
      _isLoadingToken = true;
    });

    try {
      final tokenCubit = context.read<TokenRefreshCubit>();
      final token = await tokenCubit.ensureValidToken();

      if (mounted) {
        setState(() {
          _isLoadingToken = false;
        });

        if (token != null && token.isNotEmpty) {
          print('Token loaded successfully: ${token.substring(0, 10)}...');
        } else {
          print('Failed to load token');
        }
      }
    } catch (e) {
      print('Error initializing token: $e');
      if (mounted) {
        setState(() {
          _isLoadingToken = false;
        });
      }
    }
  }

  Future<void> _startSignalR() async {
    const secureStorage = FlutterSecureStorage();
    String? userIdStr = await secureStorage.read(key: 'userId');
    int? userId = userIdStr != null ? int.tryParse(userIdStr) : null;
    if (userId != null && userId > 0) {
      await SignalRService().initialize(userId: userId);
      print('SignalRService initialized for renter with userId: $userId');
    } else {
      print('SignalRService not started: userId not found');
    }
  }

  void _handleTokenRefreshSuccess(String accessToken) {
    if (mounted) {
      setState(() {
        _isLoadingToken = false;
      });
      print('Token updated from BLoC: ${accessToken.substring(0, 10)}...');
    }
  }

  void _handleTokenRefreshFailure(String errorMessage) {
    if (mounted) {
      setState(() {
        _isLoadingToken = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          context,
          "Error",
          "Authentication failed. Please login again.",
          SnackBarType.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TokenRefreshCubit, TokenRefreshState>(
      listener: (context, tokenState) {
        if (tokenState is TokenRefreshSuccess) {
          _handleTokenRefreshSuccess(tokenState.accessToken);
        } else if (tokenState is TokenRefreshFailure) {
          _handleTokenRefreshFailure(tokenState.errorMessage);
        }
      },
      child: _isLoadingToken
          ? Scaffold(
              backgroundColor: context.theme.blue100_8,
              body: const LoadingMainScreen(),
            )
          : Scaffold(
              backgroundColor: Colors.grey[50],
              floatingActionButton: FloatingActionButton(
                heroTag: "Dddd",
                onPressed: () {
                  context.read<AddVehicleCubit>().reset();
                  context.read<MainImageCubit>().reset();
                  context.read<AdditionalImageCubit>().reset();
                  context.read<MapLocationCubit>().reset();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddVehicleScreen(),
                    ),
                  );
                },
                backgroundColor: context.theme.blue100_1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.add,
                  color: context.theme.white100_1,
                  size: 30,
                ),
              ),
              body: MainScreenBody(
                onRefresh: _initializeToken,
              ),
            ),
    );
  }
}
