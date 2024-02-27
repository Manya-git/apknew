import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/destination/views/destination_view.dart';
import 'package:ride_mobile/app/modules/login/views/login_view.dart';
import 'package:ride_mobile/app/utils/keys.dart';

main() {
  const String email = "studenta@mailinator.com";
  const String password = "Mahi@1234567";

  final emailTextFormField = find.descendant(
    of: find.byKey(LoginPageKeys.emailFieldKey),
    matching: find.byType(EditableText),
  );

  final passwordTextFormField = find.descendant(
    of: find.byKey(LoginPageKeys.passwordFieldKey),
    matching: find.byType(EditableText),
  );

  Widget createWidgetForTesting({required Widget child}) {
    return MediaQuery(
        data: const MediaQueryData(),
        child: GetMaterialApp(
          home: child,
        ));
  }

  testWidgets("check if background image is rendered", (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: LoginView()));
    expect(find.byKey(CommonKeys.authBgImageKey), findsOneWidget);
  });

  testWidgets("check if go back button is rendered", (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: LoginView()));
    expect(find.byKey(CommonKeys.goBackButtonKey), findsOneWidget);
  });

  testWidgets("check if email textfield is rendered", (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: LoginView()));
    expect(find.byKey(LoginPageKeys.emailFieldKey), findsOneWidget);
  });

  testWidgets("check if password textfield is rendered", (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: LoginView()));
    expect(find.byKey(LoginPageKeys.passwordFieldKey), findsOneWidget);
  });

  testWidgets("check if the password in password textfield is not visible when rendered", (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: LoginView()));
    final input = tester.widget<EditableText>(passwordTextFormField);
    expect(input.obscureText, isTrue);
  });

  testWidgets("check if the password in password textfield is visible when eye button is tapped",
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: LoginView()));
    await tester.tap(find.byKey(
      const Key("show_password"),
    ));
    await tester.pump();
    final input = tester.widget<EditableText>(passwordTextFormField);
    expect(input.obscureText, isFalse);
  });

  testWidgets("check if login button is rendered", (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: LoginView()));
    expect(find.byKey(LoginPageKeys.loginButtonKey), findsOneWidget);
  });

  testWidgets("check if loading indicator is displayed when login button is clicked", (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(createWidgetForTesting(child: LoginView()));
      await tester.enterText(emailTextFormField, email);
      await tester.enterText(passwordTextFormField, password);
      await tester.tap(find.byKey(LoginPageKeys.loginButtonKey));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  testWidgets("check if login is successful when login button is clicked and user gets navigated to destination page",
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: LoginView()));
    await tester.enterText(emailTextFormField, email);
    await tester.enterText(passwordTextFormField, password);
    await tester.tap(find.byKey(LoginPageKeys.loginButtonKey));
    await tester.pumpAndSettle();
    expect(find.byType(DestinationView), findsOneWidget);
  });

  testWidgets("check if forgot password text button is rendered", (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: LoginView()));
    expect(find.byKey(LoginPageKeys.forgotPasswordTextButtonKey), findsOneWidget);
  });
}
