import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/presentation/widgets/adding_vehicle_floating_action_button.dart';
import 'package:aggar/features/main_screen/presentation/widgets/vehicle_brand_section.dart';
import 'package:aggar/features/main_screen/presentation/widgets/main_header.dart';
import 'package:aggar/features/main_screen/presentation/widgets/popular_vehicles_section.dart';
import 'package:aggar/features/main_screen/presentation/widgets/vehicles_type_section.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final bool _isConnected = true;
  late final InternetConnectionChecker _internetChecker;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String? _accessToken;
  final bool _isLoading = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: const AddingVehicleFloatingActionButton(),
      backgroundColor: context.theme.white100_1,
      body: _accessToken == null
          ? const Center(child: Text('Please login to continue'))
          : SingleChildScrollView(
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
            ),
    );
  }
}

/**import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/presentation/widgets/adding_vehicle_floating_action_button.dart';
import 'package:aggar/features/main_screen/presentation/widgets/vehicle_brand_section.dart';
import 'package:aggar/features/main_screen/presentation/widgets/main_header.dart';
import 'package:aggar/features/main_screen/presentation/widgets/popular_vehicles_section.dart';
import 'package:aggar/features/main_screen/presentation/widgets/vehicles_type_section.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isConnected = true;
  late final InternetConnectionChecker _internetChecker;

  @override
  void initState() {
    super.initState();
    _internetChecker = InternetConnectionChecker.createInstance();
    _checkInternetConnection();
    _internetChecker.onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() {
        _isConnected = hasInternet;
      });

      if (!hasInternet) {
        _showNoNetworkDialog();
      }
    });
  }

  Future<void> _checkInternetConnection() async {
    final hasInternet = await _internetChecker.hasConnection;
    setState(() {
      _isConnected = hasInternet;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: const AddingVehicleFloatingActionButton(),
      backgroundColor: context.theme.white100_1,
      body: _isConnected
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
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
 */
