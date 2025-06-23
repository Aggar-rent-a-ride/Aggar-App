import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_state.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/loading_main_screen.dart';
import 'package:aggar/features/main_screen/renter/presentation/views/main_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        const SnackBar(
          content: Text('Session expired. Please login again.'),
          backgroundColor: Colors.red,
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
              body: MainScreenBody(
                onRefresh: _initializeToken,
              ),
            ),
    );
  }
}
