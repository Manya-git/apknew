import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:responsive_framework/breakpoint.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:ride_mobile/app/modules/landing/views/splash_screen.dart';
import 'package:ride_mobile/app/services/mix_panel/mix_panel_init.dart';
import 'package:ride_mobile/app/services/user/push_notifications.dart';

import 'app/flavors.dart';

void setAppBar() {
  SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MixPanelAnalyticsManager().initializingMixPanel();

  PushNotifications.initLocalNotifications();
  setAppBar();

  await dotenv.load(fileName: ".env");
  FlavorConfig(flavor: Flavor.QA, appVersion: "1.0.0");
  FlavorConfig.instance.configure();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      enabled: false,
      builder: (context) => GetMaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
              child: ResponsiveBreakpoints.builder(
                child: child!,
                breakpoints: [
                  const Breakpoint(start: 0, end: 420, name: MOBILE),
                  const Breakpoint(start: 421, end: 800, name: TABLET),
                  const Breakpoint(start: 801, end: 1000, name: TABLET),
                  const Breakpoint(start: 1001, end: 1200, name: DESKTOP),
                  const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
                ],
              ),
            );
          },
          useInheritedMediaQuery: true,
          debugShowCheckedModeBanner: false,
          locale: DevicePreview.locale(context),
          title: "GB Mobile",
          home: const SplashScreen()),
    );
  }
}
