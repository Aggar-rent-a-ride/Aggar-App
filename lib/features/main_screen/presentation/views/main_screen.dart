import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/authorization/presentation/views/sign_in_view.dart';
import 'package:aggar/features/main_screen/presentation/widgets/adding_vehicle_floating_action_button.dart';
import 'package:aggar/features/main_screen/presentation/widgets/loading_main_screen.dart';
import 'package:aggar/features/main_screen/presentation/widgets/vehicle_brand_section.dart';
import 'package:aggar/features/main_screen/presentation/widgets/main_header.dart';
import 'package:aggar/features/main_screen/presentation/widgets/popular_vehicles_section.dart';
import 'package:aggar/features/main_screen/presentation/widgets/vehicles_type_section.dart';
import 'package:aggar/features/main_screen/presentation/cubit/vehicle_brand/vehicle_brand_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/vehicle_type/vehicle_type_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String? _accessToken;
  bool _isLoading = true;
  bool isConnected = true;
  late final InternetConnectionChecker _internetChecker;

  @override
  void initState() {
    super.initState();
    _loadAccessToken();
    _internetChecker = InternetConnectionChecker.createInstance();
    _checkInternetConnection();
    _internetChecker.onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() {
        isConnected = hasInternet;
      });

      if (!hasInternet) {
        _showNoNetworkDialog();
      }
    });
  }

  Future<void> _checkInternetConnection() async {
    final hasInternet = await _internetChecker.hasConnection;
    setState(() {
      isConnected = hasInternet;
    });

    if (!hasInternet) {
      _showNoNetworkDialog();
    }
  }

  void _showNoNetworkDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text(
            'Please check your internet connection and try again.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _checkInternetConnection();
              },
              child: const Text('Retry'),
            ),
            TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text('Exit App'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadAccessToken() async {
    try {
      final token = await _secureStorage.read(key: 'accessToken');

      setState(() {
        _accessToken = token;
        _isLoading = false;
      });

      if (_accessToken != null) {
        _fetchData();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Login required. Please sign in again.')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignInView()),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error retrieving access token: ${e.toString()}')),
        );
      }
    }
  }

  void _fetchData() {
    if (_accessToken != null) {
      context.read<VehicleBrandCubit>().fetchVehicleBrands(_accessToken!);
      context.read<VehicleTypeCubit>().fetchVehicleTypes(_accessToken!);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: LoadingMainScreen());
    }

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton:
          isConnected ? const AddingVehicleFloatingActionButton() : null,
      backgroundColor: context.theme.white100_1,
      body: isConnected
          ? SingleChildScrollView(
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
                    child: const MainHeader(),
                  ),
                  const Gap(15),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VehiclesTypeSection(),
                        Gap(10),
                        BrandsSection(),
                        Gap(10),
                        PopularVehiclesSection(),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const LoadingMainScreen(),
    );
  }
}
