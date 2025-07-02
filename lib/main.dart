import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/cache/cache_helper.dart';
import 'package:aggar/core/cubit/edit_user_info/edit_user_info_cubit.dart';
import 'package:aggar/core/cubit/language/language_cubit.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/cubit/report/report_creation_cubit.dart';
import 'package:aggar/core/cubit/reportId/report_by_id_cubit.dart';
import 'package:aggar/core/cubit/theme/theme_cubit.dart';
import 'package:aggar/core/extensions/theme_cubit_extension.dart';
import 'package:aggar/core/themes/dark_theme.dart';
import 'package:aggar/core/themes/light_theme.dart';
import 'package:aggar/core/translations/l10n.dart';
import 'package:aggar/features/Splash/presentation/views/splash_view.dart';
import 'package:aggar/features/authorization/data/cubit/Login/login_cubit.dart';
import 'package:aggar/features/authorization/data/cubit/credentials/credentials_cubit.dart';
import 'package:aggar/features/authorization/data/cubit/pick_image/pick_location_cubit.dart';
import 'package:aggar/features/authorization/data/cubit/sign_up/sign_up_cubit.dart';
import 'package:aggar/features/booking/data/cubit/booking_cubit.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_cubit.dart';
import 'package:aggar/features/edit_vehicle/presentation/cubit/edit_vehicle_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/admin_main_cubit/admin_main_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/filter_cubit/filter_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/report_cubit/report_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/statistics_cubit/statistics_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_statistics/user_statistics_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/main_screen/main_screen_cubit.dart';
import 'package:aggar/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:aggar/features/profile/presentation/customer/presentation/cubit/profile/profile_cubit.dart';
import 'package:aggar/core/cubit/user_cubit/user_info_cubit.dart';
import 'package:aggar/features/search/presentation/cubit/search_field/search_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicle_brand/vehicle_brand_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicle_type/vehicle_type_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicles/vehicle_cubit.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_cubit.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/personal_chat/personal_chat_cubit.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/real%20time%20chat/real_time_chat_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/add_vehicle_cubit/add_vehicle_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/additinal_images_cubit/additinal_images_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/main_image_cubit/main_image_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/map_location/map_location_cubit.dart';
import 'package:aggar/features/notification/data/cubit/notification_cubit.dart';
import 'package:aggar/features/rent_history/data/cubit/rent_history_cubit.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehicle_type/admin_vehicle_type_cubit.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehilce_brand/admin_vehicle_brand_cubit.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/edit_vehicle_brand/edit_vehicle_brand_cubit.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/edit_vehicle_type/edit_vehicle_type_cubit.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_count/review_count_cubit.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_cubit/review_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CacheHelper().init();
  const secureStorage = FlutterSecureStorage();

  final languageCubit = LanguageCubit();
  languageCubit.changeToEnglish();

  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => MyApp(
      secureStorage: secureStorage,
      initialLanguageCubit: languageCubit,
    ),
  ));
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
    final dio = Dio();
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
          create: (context) => AdminVehicleBrandCubit(),
        ),
        BlocProvider(
          create: (context) => EditVehicleTypeCubit(),
        ),
        BlocProvider(
          create: (context) => EditVehicleBrandCubit(),
        ),
        BlocProvider(
          create: (context) => AdminVehicleTypeCubit(),
        ),
        BlocProvider(
          create: (context) => AdditionalImageCubit(),
        ),
        BlocProvider(
          create: (context) => VehicleCubit(),
        ),
        BlocProvider(
          create: (context) => MainImageCubit(),
        ),
        BlocProvider(
          create: (context) => PickLocationCubit(),
        ),
        BlocProvider<TokenRefreshCubit>(
          create: (context) => TokenRefreshCubit(
            apiConsumer: DioConsumer(dio: dio),
            secureStorage: const FlutterSecureStorage(),
          ),
        ),
        BlocProvider(
          create: (context) => AddVehicleCubit(
            DioConsumer(dio: dio),
            MainImageCubit(),
            AdditionalImageCubit(),
            MapLocationCubit(),
          ),
        ),
        BlocProvider(
          create: (context) => NotificationCubit(
              tokenRefreshCubit: context.read<TokenRefreshCubit>()),
        ),
        BlocProvider(
          create: (context) => RentalHistoryCubit(
            dio: dio,
            pageSize: 10,
            tokenRefreshCubit: context.read<TokenRefreshCubit>(),
          ),
        ),
        BlocProvider(
          create: (context) => DiscountCubit(
            tokenRefreshCubit: context.read<TokenRefreshCubit>(),
          ),
        ),
        BlocProvider(
          create: (context) => MessageCubit(
            dioConsumer: DioConsumer(dio: dio),
          ),
        ),
        BlocProvider(
          create: (context) => ReviewCubit(),
        ),
        BlocProvider(
          create: (context) => SignUpCubit(),
        ),
        BlocProvider(
          create: (context) => PersonalChatCubit(),
        ),
        BlocProvider(
          create: (context) => RealTimeChatCubit(
            MessageCubit(
              dioConsumer: DioConsumer(dio: dio),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ReportCubit(),
        ),
        BlocProvider(
          create: (context) => UserCubit(),
        ),
        BlocProvider(
          create: (context) => SearchCubit(),
        ),
        BlocProvider(
          create: (context) => CredentialsCubit(),
        ),
        BlocProvider(
          create: (context) => ReportByIdCubit(),
        ),
        BlocProvider(
          create: (context) => ReviewCountCubit(),
        ),
        BlocProvider(
          create: (context) => PaymentCubit(),
        ),
        BlocProvider(
          create: (context) => ProfileCubit(),
        ),
        BlocProvider(
          create: (context) => UserInfoCubit(),
        ),
        BlocProvider(
          create: (context) => EditUserInfoCubit(),
        ),
        BlocProvider(
          create: (context) => FilterCubit(),
        ),
        BlocProvider(
          create: (context) => BookingCubit(
            dioConsumer: DioConsumer(dio: dio),
            tokenRefreshCubit: context.read<TokenRefreshCubit>(),
          ),
        ),
        BlocProvider(
          create: (context) => EditVehicleCubit(
            DioConsumer(dio: dio),
            MainImageCubit(),
            AdditionalImageCubit(),
            MapLocationCubit(),
          ),
        ),
        BlocProvider(
          create: (context) => LoginCubit(
            dioConsumer: DioConsumer(dio: dio),
            secureStorage: secureStorage,
          ),
        ),
        BlocProvider(
          create: (context) => ReportCreationCubit(),
        ),
        BlocProvider(
          create: (context) => MainCubit(
            tokenRefreshCubit: context.read<TokenRefreshCubit>(),
            vehicleBrandCubit: context.read<VehicleBrandCubit>(),
            vehicleTypeCubit: context.read<VehicleTypeCubit>(),
            vehicleCubit: context.read<VehicleCubit>(),
            userInfoCubit: context.read<UserInfoCubit>(),
          ),
        ),
        BlocProvider(
          create: (context) => StatisticsCubit(),
        ),
        BlocProvider(
          create: (context) => UserStatisticsCubit(),
        ),
        BlocProvider(
          create: (context) => AdminMainCubit(
            userInfoCubit: context.read<UserInfoCubit>(),
            vehicleBrandCubit: context.read<AdminVehicleBrandCubit>(),
            vehicleTypeCubit: context.read<AdminVehicleTypeCubit>(),
            userStatisticsCubit: context.read<UserStatisticsCubit>(),
            tokenRefreshCubit: context.read<TokenRefreshCubit>(),
            reportCubit: context.read<ReportCubit>(),
            statisticsCubit: context.read<StatisticsCubit>(),
          ),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return BlocBuilder<LanguageCubit, LanguageState>(
            builder: (context, languageState) {
              return MaterialApp(
                  locale: DevicePreview.locale(context),
                  builder: DevicePreview.appBuilder,
                  themeMode: context.themeCubit.themeMode,
                  darkTheme: darkTheme,
                  theme: lightTheme,
                  debugShowCheckedModeBanner: false,
                  /* locale: languageState is LanguageChanged
                      ? languageState.locale
                      : DevicePreview.locale(context),*/
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
                  // builder: DevicePreview.appBuilder,
                  home: const SplashView());
            },
          );
        },
      ),
    );
  }
}
