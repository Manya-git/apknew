import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ride_mobile/app/services/basic_api.dart';
import 'package:ride_mobile/app/utils/assets.dart';

enum Flavor { DEV, QA, STAGING, PRODUCTION }

class FlavorConfig {
  final Flavor? flavor;
  final String? appVersion;

  static FlavorConfig? _instance;

  factory FlavorConfig({
    required Flavor flavor,
    required String appVersion,
  }) {
    _instance ??= FlavorConfig._internal(flavor, appVersion);
    return _instance!;
  }

  FlavorConfig._internal(
    this.flavor,
    this.appVersion,
  );

  static FlavorConfig get instance {
    return _instance!;
  }

  void configure() {
    if (isDevelopment()) {
      BasicAPI.baseURL = dotenv.env['DEVURL']!;
      Assets.GB_ID = dotenv.env['DEVCID']!;
    } else if (isQA()) {
      BasicAPI.baseURL = dotenv.env['QAURL']!;
      Assets.GB_ID = dotenv.env['QACID']!;
    } else if (isStaging()) {
      BasicAPI.baseURL = dotenv.env['STAGINGURL']!;
      Assets.GB_ID = dotenv.env['STAGINGCID']!;
    } else if (isProduction()) {
      BasicAPI.baseURL = dotenv.env['PRODURL']!;
      Assets.GB_ID = dotenv.env['PRODCID']!;
    }
  }

  static bool isProduction() => _instance!.flavor == Flavor.PRODUCTION;
  static bool isDevelopment() => _instance!.flavor == Flavor.DEV;
  static bool isStaging() => _instance!.flavor == Flavor.STAGING;
  static bool isQA() => _instance!.flavor == Flavor.QA;
}
