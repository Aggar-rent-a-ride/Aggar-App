import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/cache/cache_helper.dart';
import 'package:aggar/core/cubit/theme/theme_cubit.dart';
import 'package:aggar/core/extensions/theme_cubit_extension.dart';
import 'package:aggar/core/themes/dark_theme.dart';
import 'package:aggar/core/themes/light_theme.dart';
import 'package:aggar/features/authorization/data/cubit/Login/login_cubit.dart';
import 'package:aggar/features/authorization/data/cubit/credentials/credentials_cubit.dart';
import 'package:aggar/features/authorization/data/cubit/pick_image/pick_image_cubit.dart';
import 'package:aggar/features/authorization/data/cubit/sign_up/sign_up_cubit.dart';
import 'package:aggar/features/authorization/presentation/views/sign_in_view.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_cubit.dart';
import 'package:aggar/features/edit_vehicle/presentation/cubit/edit_vehicle_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/main_screen/main_screen_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/vehicle_brand/vehicle_brand_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/vehicle_type/vehicle_type_cubit.dart';
import 'package:aggar/features/main_screen/presentation/views/bottom_navigation_bar_views.dart';
import 'package:aggar/features/main_screen/presentation/views/main_screen.dart';
import 'package:aggar/features/new_vehicle/data/cubits/add_vehicle_cubit/add_vehicle_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/additinal_images_cubit/additinal_images_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/main_image_cubit/main_image_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/map_location/map_location_cubit.dart';
import 'package:aggar/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:aggar/features/settings/presentation/views/settings_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  CacheHelper().init();
  const secureStorage = FlutterSecureStorage();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(
        secureStorage: secureStorage,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final FlutterSecureStorage secureStorage;

  const MyApp({super.key, required this.secureStorage});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => MapLocationCubit(),
        ),
        BlocProvider(
          create: (context) => VehicleTypeCubit(),
        ),
        BlocProvider(
          create: (context) => VehicleBrandCubit(),
        ),
        BlocProvider(
          create: (context) => AdditionalImageCubit(),
        ),
        BlocProvider(
          create: (context) => MainImageCubit(),
        ),
        BlocProvider(
          create: (context) => AddVehicleCubit(
            DioConsumer(dio: Dio()),
            MainImageCubit(),
            AdditionalImageCubit(),
            MapLocationCubit(),
          ),
        ),
        BlocProvider(
          create: (context) => PickImageCubit(),
        ),
        BlocProvider(
          create: (context) => DiscountCubit(),
        ),
        BlocProvider(
          create: (context) => SignUpCubit(),
        ),
        BlocProvider(
          create: (context) => CredentialsCubit(),
        ),
        BlocProvider(
          create: (context) => EditVehicleCubit(
            DioConsumer(dio: Dio()),
            MainImageCubit(),
            AdditionalImageCubit(),
            MapLocationCubit(),
          ),
        ),
        BlocProvider(
          create: (context) => LoginCubit(
            dioConsumer: DioConsumer(dio: Dio()),
            secureStorage: secureStorage,
          ),
        ),
        // Add MainScreenCubit
        BlocProvider(
          create: (context) => MainScreenCubit(
            secureStorage: secureStorage,
          ),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            themeMode: context.themeCubit.themeMode,
            darkTheme: darkTheme,
            theme: darkTheme,
            debugShowCheckedModeBanner: false,
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
