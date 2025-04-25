import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/cache/cache_helper.dart';
import 'package:aggar/core/cubit/language/language_cubit.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/cubit/theme/theme_cubit.dart';
import 'package:aggar/core/extensions/theme_cubit_extension.dart';
import 'package:aggar/core/themes/dark_theme.dart';
import 'package:aggar/core/themes/light_theme.dart';
import 'package:aggar/core/translations/l10n.dart';
import 'package:aggar/features/authorization/data/cubit/Login/login_cubit.dart';
import 'package:aggar/features/authorization/data/cubit/credentials/credentials_cubit.dart';
import 'package:aggar/features/authorization/data/cubit/pick_image/pick_image_cubit.dart';
import 'package:aggar/features/authorization/data/cubit/sign_up/sign_up_cubit.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_cubit.dart';
import 'package:aggar/features/discount/presentation/views/discount_screen.dart';
import 'package:aggar/features/edit_vehicle/presentation/cubit/edit_vehicle_cubit.dart';
import 'package:aggar/features/edit_vehicle/presentation/views/edit_vehicle_view.dart';
import 'package:aggar/features/main_screen/presentation/cubit/main_screen/main_screen_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/vehicle_brand/vehicle_brand_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/vehicle_type/vehicle_type_cubit.dart';
import 'package:aggar/features/main_screen/presentation/views/main_screen.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_cubit.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/views/messages_view.dart';
import 'package:aggar/features/new_vehicle/data/cubits/add_vehicle_cubit/add_vehicle_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/additinal_images_cubit/additinal_images_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/main_image_cubit/main_image_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/map_location/map_location_cubit.dart';
import 'package:aggar/features/settings/presentation/views/settings_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CacheHelper().init();
  const secureStorage = FlutterSecureStorage();

  final languageCubit = LanguageCubit();
  languageCubit.changeToEnglish();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(
        secureStorage: secureStorage,
        initialLanguageCubit: languageCubit,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final FlutterSecureStorage secureStorage;
  final LanguageCubit? initialLanguageCubit;

  const MyApp({
    super.key,
    required this.secureStorage,
    this.initialLanguageCubit,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => initialLanguageCubit ?? LanguageCubit(),
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
          create: (context) => MessageCubit(),
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
        BlocProvider<TokenRefreshCubit>(
          create: (context) => TokenRefreshCubit(
            apiConsumer: DioConsumer(dio: Dio()),
            secureStorage: const FlutterSecureStorage(),
          ),
        ),
        BlocProvider(
          create: (context) => LoginCubit(
            dioConsumer: DioConsumer(dio: Dio()),
            secureStorage: secureStorage,
          ),
        ),
        BlocProvider(
          create: (context) => MainCubit(
            tokenRefreshCubit: context.read<TokenRefreshCubit>(),
            vehicleBrandCubit: context.read<VehicleBrandCubit>(),
            vehicleTypeCubit: context.read<VehicleTypeCubit>(),
          ),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return BlocBuilder<LanguageCubit, LanguageState>(
            builder: (context, languageState) {
              return MaterialApp(
                themeMode: context.themeCubit.themeMode,
                darkTheme: darkTheme,
                theme: darkTheme,
                debugShowCheckedModeBanner: false,
                locale: languageState is LanguageChanged
                    ? languageState.locale
                    : DevicePreview.locale(context),
                supportedLocales: const [
                  Locale('en', 'US'),
                  Locale('ar', 'SA'),
                ],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                builder: DevicePreview.appBuilder,
                home: const MessagesView(),
              );
            },
          );
        },
      ),
    );
  }
}
/* EditVehicleView(vehicleId: "127")*/
/** DiscountScreenView()*/
/**MessagesView() */
/*const MainScreen()*/
