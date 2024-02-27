import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/utils/keys.dart';

main() {
  Widget createWidgetForTesting({required Widget child}) {
    return MediaQuery(
        data: const MediaQueryData(),
        child: GetMaterialApp(
          home: child,
        ));
  }

  final codeField = find.descendant(
    of: find.byKey(CodeVerificationKeys.codeVerificationInputKey),
    matching: find.byType(AnimatedContainer),
  );
}
