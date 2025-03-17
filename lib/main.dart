import 'package:aggar/core/cache/cache_helper.dart';
import 'package:aggar/features/authorization/data/cubit/pick_image_cubit.dart';
import 'package:aggar/features/authorization/presentation/views/sign_in_view.dart';
import 'package:aggar/features/new_vehicle/data/cubits/add_vehicle_cubit/add_vehicle_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/additinal_images_cubit/additinal_images_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/main_image_cubit/main_image_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/map_location/map_location_cubit.dart';
import 'package:aggar/features/new_vehicle/presentation/views/add_vehicle_screen.dart'
    show AddVehicleScreen;
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  CacheHelper().init();
  runApp(
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => const MyApp(),
    // ),
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MapLocationCubit(),
          ),
          BlocProvider(
            create: (context) => AdditionalImageCubit(),
          ),
          BlocProvider(
            create: (context) => MainImageCubit(),
          ),
          BlocProvider(
            create: (context) => AddVehicleCubit(),
          ),
          BlocProvider(
            create: (context) => PickImageCubit(),
          ),
        ],
        child: const AddVehicleScreen(),
      ),
    );
  }
}
