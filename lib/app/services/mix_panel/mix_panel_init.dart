import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mixpanel_analytics/mixpanel_analytics.dart';
import 'package:ride_mobile/app/services/user/current_user.dart';
import 'package:ride_mobile/app/utils/string_utils.dart';

import '../../models/device_info_model.dart';

class MixPanelAnalyticsManager {
  static String clientToken = "238a1ffb4b0010624cdda5af6f2490dd";
  static String serviceToken = "6f7d25608b9caff6040e2fa464b9ec59";

  static String token = serviceToken;

  void initializingMixPanel() async {
    DeviceInfo deviceInfo;

    // DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    // PackageInfo packageInfo = await PackageInfo.fromPlatform();

    /// getting device details as per OS
    if (Platform.isIOS) {
      // IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      // deviceInfo = DeviceInfo(
      //   deviceIdentifier: iosDeviceInfo.identifierForVendor,
      //   os: '${iosDeviceInfo.systemName} ${iosDeviceInfo.systemVersion}',
      //   device: '${iosDeviceInfo.name}',
      //   platform: "iOS",
      //   // appVersion: packageInfo.version,
      // );
    } else {
      // AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      // deviceInfo = DeviceInfo(
      //   deviceIdentifier: androidDeviceInfo.id,
      //   os: 'Android ${androidDeviceInfo.version.release} ${androidDeviceInfo.version.sdkInt}',
      //   device: '${androidDeviceInfo.manufacturer}',
      //   platform: 'Android',
      //   // appVersion: packageInfo.version,
      // );
    }

    /// setting deviceInfo to the MixPanelAnalyticsManager
    // MixPanelAnalyticsManager.instance.deviceInfo = deviceInfo;

    /// initializing MixPanelAnalyticsManager
    MixPanelAnalyticsManager.init(
      mixpanelToken: token,
      // deviceInfo: deviceInfo,
    );
  }

  static MixPanelAnalyticsManager? _instance;
  static final _user$ = StreamController<String>.broadcast();
  MixpanelAnalytics? _mixpanelAnalytics;
  DeviceInfo? _deviceInfo;
  String? _mixpanelToken;

  // factory instance to setup MixPanelAnalyticsManager
  factory MixPanelAnalyticsManager.init({String? mixpanelToken}) {
    /// skipping initialization for FlutterWeb and forequiredr Test mode.
    if (kIsWeb || !Platform.environment.containsKey('FLUTTER_TEST')) {
      // _instance ??= MixPanelAnalyticsManager._(mixpanelToken!, deviceInfo!);
    }
    return MixPanelAnalyticsManager();
  }

  /// creating a dummy object for the cases when the instance has not been created
  /// this way instance can't be null
  MixPanelAnalyticsManager();

  /// Private init method for implementing singleton class
  MixPanelAnalyticsManager._(this._mixpanelToken, this._deviceInfo) {
    _mixpanelAnalytics = MixpanelAnalytics.batch(
      /// [token] is the Mixpanel token associated with your  project.

      token: token,

      /// [userId$] is a stream which contains the value of the userId that will be used to identify the events for a user.

      userId$: _user$.stream,

      /// [uploadInterval] is the interval used to batch the events.

      uploadInterval: const Duration(seconds: 30),

      /// [shouldAnonymize] will anonymize the sensitive information (userId) sent to mixpanel.

      shouldAnonymize: false,

      /// [shaFn] function used to anonymize the data.

      shaFn: (value) => value,

      /// [verbose] true will provide a detailed error cause in case the request is not successful.

      verbose: !kReleaseMode,

      /// Mixpanel will use the ip address of the incoming request
      useIp: true,
    );

    /// adding user Identifier as deviceIdentifier which will be unique.
    _user$.add(_deviceInfo!.deviceIdentifier!);
  }

  static MixPanelAnalyticsManager get instance {
    return _instance ?? MixPanelAnalyticsManager();
  }

  /// converting [DeviceInfo] into map
  Map<String, String> get metaData {
    return {
      'deviceIdentifier': _deviceInfo!.deviceIdentifier!,
      'os': _deviceInfo!.os!,
      'device': _deviceInfo!.device!,
      // 'appVersion': _deviceInfo!.appVersion!,
      'platform': _deviceInfo!.platform!,
    };
  }

  /// setter function to update DeviceInfo
  set deviceInfo(DeviceInfo value) {
    _deviceInfo = value;
  }

  /// function for initializing user in mixpanel
  void sendUserProperties(String name) async {
    if (name.isNotEmpty && _instance != null && _mixpanelAnalytics != null) {
      await _mixpanelAnalytics!.engage(
        operation: MixpanelUpdateOperations.$set,
        value: {
          '\$name': name,
          'Device ID': metaData['deviceIdentifier'],
          'OS': metaData['os'],
          'Device': metaData['device'],
          'Platform': metaData['platform'],
          'App Version': metaData['appVersion'],
        },
      );
    }
  }

  /// function for sending event in mixpanel
  void sendEvent({
    required String eventName,
    required Map<String, Object> properties,
  }) async {
    StringUtils.debugPrintMode(eventName);
    if (_instance != null && _mixpanelAnalytics != null) {
      /// adding all DeviceInfo properties to existing properties
      properties.addAll(
        {
          // 'Device ID': metaData['deviceIdentifier']!,
          'OS': metaData['os']!,
          'Device': metaData['device']!,
          // 'App Version': metaData['appVersion']!,
          'Platform': metaData['platform']!,
          "User ID": CurrentUser().currentUser.id ?? "null",
          "Email": CurrentUser().currentUser.email ?? "null",
        },
      );
      await _mixpanelAnalytics!
          .track(
        event: eventName,
        properties: properties,
      )
          .then((value) {
        StringUtils.debugPrintMode("event sent " + value.toString());
        StringUtils.debugPrintMode(properties.toString());
      });
    }
  }
}
