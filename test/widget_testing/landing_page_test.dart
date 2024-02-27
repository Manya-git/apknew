import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:ride_mobile/app/modules/destination/views/destination_view.dart';
import 'package:ride_mobile/app/modules/landing/views/landing_view.dart';
import 'package:ride_mobile/app/modules/login/views/login_view.dart';
import 'package:ride_mobile/app/utils/keys.dart';

void main() {
  Widget createWidgetForTesting({required Widget child}) {
    return MediaQuery(data: const MediaQueryData(), child: GetMaterialApp(home: child));
  }

  testWidgets("check if background image is rendered", (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: LandingView()));
    expect(find.byKey(CommonKeys.authBgImageKey), findsOneWidget);
  });

  testWidgets("check if GB Mobile logo is rendered", (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: LandingView()));
    expect(find.byKey(CommonKeys.rideMobileLogoKey), findsOneWidget);
  });

  testWidgets("check if title is rendered", (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: LandingView()));
    expect(find.byKey(const Key("landing_title")), findsOneWidget);
  });

  testWidgets("check if shop for a plan button is rendered", (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: LandingView()));
    expect(find.byKey(LandingPageKeys.shopForPlanButtonKey), findsOneWidget);
  });

  testWidgets("check if login text button is rendered", (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: LandingView()));
    expect(
        find.byKey(
          LandingPageKeys.loginTextButtonKey,
        ),
        findsOneWidget);
  });

  testWidgets("check if clicking on login text button navigates to login page", (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: LandingView()));
    await tester.tap(find.byKey(
      LandingPageKeys.loginTextButtonKey,
    ));
    await tester.pumpAndSettle();
    expect(find.byType(LoginView), findsOneWidget);
    expect(find.byType(LandingView), findsNothing);
  });

  testWidgets("check if clicking on shop for a plan button navigates to destination page", (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: LandingView()));
    await tester.tap(find.byKey(LandingPageKeys.shopForPlanButtonKey));
    await tester.pumpAndSettle();
    expect(find.byType(DestinationView), findsOneWidget);
    expect(find.byType(LandingView), findsNothing);
  });
}
