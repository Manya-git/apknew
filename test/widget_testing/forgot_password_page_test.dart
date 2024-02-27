import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ride_mobile/app/modules/forgot_password/views/forgot_password_view.dart';
import 'package:ride_mobile/app/modules/login/views/login_view.dart';
import 'package:ride_mobile/app/utils/keys.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route {}

main() {
  setUpAll(() {
    registerFallbackValue(FakeRoute());
  });

  const String email = "studenta@mailinator.com";

  final emailTextFormField = find.descendant(
    of: find.byKey(ForgotPasswordKeys.emailFieldKey),
    matching: find.byType(EditableText),
  );

  final mockObserver = MockNavigatorObserver();

  Widget createWidgetForTesting({required Widget child}) {
    return MediaQuery(
        data: const MediaQueryData(),
        child: GetMaterialApp(
          home: child,
          navigatorObservers: [mockObserver],
        ));
  }

  testWidgets("check if background image is rendered", (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: const ForgotPasswordView()));
    expect(find.byKey(CommonKeys.authBgImageKey), findsOneWidget);
  });

  testWidgets("check if go back button is rendered", (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: const ForgotPasswordView()));
    expect(find.byKey(CommonKeys.goBackButtonKey), findsOneWidget);
  });

  testWidgets("check if email textfield is rendered", (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: const ForgotPasswordView()));
    expect(find.byKey(ForgotPasswordKeys.emailFieldKey), findsOneWidget);
  });

  testWidgets("check if submit button is rendered", (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: const ForgotPasswordView()));
    expect(find.byKey(ForgotPasswordKeys.submitButtonKey), findsOneWidget);
  });

  testWidgets("check if go back to login screen text button is rendered", (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: const ForgotPasswordView()));
    expect(find.byKey(ForgotPasswordKeys.backToLoginTextButtonKey), findsOneWidget);
  });

  testWidgets("check if verification code is sent and the user is redirected to code verification screen",
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: const ForgotPasswordView()));
    await tester.enterText(emailTextFormField, email);
    expect(find.byKey(ForgotPasswordKeys.submitButtonKey), findsOneWidget);
    await tester.tap(find.byKey(ForgotPasswordKeys.submitButtonKey));
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
    expect(find.byType(ForgotPasswordView), findsNothing);
  });

  testWidgets("check if clicking on go back to login screen text button goes back to login page",
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: LoginView()));
    await tester.tap(find.byKey(LoginPageKeys.forgotPasswordTextButtonKey));
    await tester.pumpAndSettle();
    expect(find.byType(ForgotPasswordView), findsOneWidget);
    await tester.tap(find.byKey(ForgotPasswordKeys.backToLoginTextButtonKey));
    await tester.pumpAndSettle();
    expect(find.byType(LoginView), findsOneWidget);
  });
}
