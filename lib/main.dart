import 'package:aggar/features/messages/views/messages_status/presentation/views/messages_view.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

void main() => runApp(
/**      DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const MyApp(),
      ), */
      const MyApp(),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: const MessagesView(),
    );
  }
}
