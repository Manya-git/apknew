// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:get/get.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:ride_mobile/app/models/country_codes_model.dart';
// import 'package:ride_mobile/app/models/destination_model.dart';
// import 'package:ride_mobile/app/modules/email_verification/views/email_verification_view.dart';
// import 'package:ride_mobile/app/modules/registration/controllers/registration_controller.dart';
// import 'package:ride_mobile/app/modules/registration/views/registration_view.dart';
// import 'package:ride_mobile/app/modules/registration/views/terms_and_policy_view.dart';
// import 'package:ride_mobile/app/utils/keys.dart';
//
// main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//   TestWidgetsFlutterBinding.ensureInitialized();
//
//   const Key firstNameKey = RegistrationPageKeys.firstNameKey;
//   const Key lastNameKey = RegistrationPageKeys.lastNameKey;
//   const Key emailKey = RegistrationPageKeys.emailAddressKey;
//   const Key passwordKey = RegistrationPageKeys.passwordKey;
//   const Key repeatPasswordKey = RegistrationPageKeys.repeatPasswordKey;
//   const Key phoneNumberKey = RegistrationPageKeys.mobileNumberKey;
//   const Key registerButtonKey = RegistrationPageKeys.registerButtonKey;
//   const Key countryCodeKey = RegistrationPageKeys.countryCodePickerKey;
//   const Key privacyPolicyKey = RegistrationPageKeys.privacyPolicyRadioButtonKey;
//   const Key termsKey = RegistrationPageKeys.termsRadioButtonKey;
//   const Key privacyPolicyTextKey = RegistrationPageKeys.privacyPolicyTextButtonKey;
//   const Key termsTextKey = RegistrationPageKeys.termsTextButtonKey;
//   const Key countryCodePickerListKey = CommonKeys.countriesDialogListKey;
//
//   late RegistrationController controller;
//
//   final passwordField = find.descendant(
//     of: find.byKey(passwordKey),
//     matching: find.byType(EditableText),
//   );
//
//   final confirmPasswordField = find.descendant(
//     of: find.byKey(repeatPasswordKey),
//     matching: find.byType(EditableText),
//   );
//
//   setUpAll(() async {
//     TestWidgetsFlutterBinding.ensureInitialized();
//     HttpOverrides.global = null;
//     controller = Get.put(RegistrationController());
//     controller.currentCountryCode.value = DestinationModel(
//       dialCode: "+91",
//       code: "IN",
//       name: "India",
//     );
//     await controller.getCountryCodes();
//
//   });
//
//   Widget createWidgetForTesting({required Widget child}) {
//     return MediaQuery(
//         data: const MediaQueryData(),
//         child: GetMaterialApp(
//           home: child,
//         ));
//   }
//
//   // check if firstName, lastName, email, password, confirmPassword, phoneNumber text fields are rendered
//   testWidgets("check if firstName, lastName, email, password, confirmPassword, phoneNumber text fields are rendered",
//       (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetForTesting(child: const RegistrationView()));
//     expect(find.byKey(firstNameKey), findsOneWidget);
//     expect(find.byKey(lastNameKey), findsOneWidget);
//     expect(find.byKey(emailKey), findsOneWidget);
//     expect(find.byKey(passwordKey), findsOneWidget);
//     expect(find.byKey(repeatPasswordKey), findsOneWidget);
//     expect(find.byKey(phoneNumberKey), findsOneWidget);
//   });
//
//   // check if country code picker is rendered
//   testWidgets("check if country code picker is rendered", (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetForTesting(child: const RegistrationView()));
//     expect(find.byKey(countryCodeKey), findsOneWidget);
//   });
//
//   // check if terms and conditions and privacy policy radio buttons are rendered
//   testWidgets("check if terms and conditions and privacy policy radio buttons are rendered", (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetForTesting(child: const RegistrationView()));
//     expect(find.byKey(privacyPolicyKey), findsOneWidget);
//     expect(find.byKey(termsKey), findsOneWidget);
//   });
//
//   // check if register button is rendered
//   testWidgets("check if register button is rendered", (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetForTesting(child: const RegistrationView()));
//     expect(find.byKey(registerButtonKey), findsOneWidget);
//   });
//
//   // check if terms and conditions and privacy policy text buttons are rendered
//   testWidgets("check if terms and conditions and privacy policy text buttons are rendered", (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetForTesting(child: const RegistrationView()));
//     expect(find.byKey(privacyPolicyTextKey), findsOneWidget);
//     expect(find.byKey(termsTextKey), findsOneWidget);
//   });
//
//   // open country code picker and check if country code picker list key is rendered
//   testWidgets("open country code picker and check if countries list widget is rendered", (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetForTesting(child: const RegistrationView()));
//     await tester.tap(find.byKey(countryCodeKey));
//     await tester.pump();
//     expect(find.byKey(countryCodePickerListKey), findsOneWidget);
//   });
//
//   // check if password field and confirm password field are obscureText
//
//   testWidgets("check if password field and confirm password field are obscureText", (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetForTesting(child: const RegistrationView()));
//     expect(tester.widget<EditableText>(passwordField).obscureText, true);
//     expect(tester.widget<EditableText>(confirmPasswordField).obscureText, true);
//   });
//
//   testWidgets("taping on the eye button to check if password field and repeat password field are not obscure anymore",
//       (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetForTesting(child: const RegistrationView()));
//     await tester.tap(find.byKey(RegistrationPageKeys.showPasswordKey));
//     await tester.pump();
//     await tester.tap(find.byKey(RegistrationPageKeys.showRepeatPasswordKey));
//     await tester.pump();
//     expect(tester.widget<EditableText>(passwordField).obscureText, false);
//     expect(tester.widget<EditableText>(confirmPasswordField).obscureText, false);
//   });
//
//   // tap on privacy policy and terms and conditions radio buttons and check if they are selected
//   // testWidgets("tap on privacy policy and terms and conditions radio buttons and check if they are selected",
//   //     (WidgetTester tester) async {
//   //   await tester.pumpWidget(createWidgetForTesting(child: const RegistrationView()));
//   //   await tester.tap(find.byKey(RegistrationPageKeys.privacyPolicyRadioButtonKey));
//   //   await tester.pump();
//   //   await tester.tap(find.byKey(RegistrationPageKeys.termsRadioButtonKey));
//   //   await tester.pump();
//   //   expect(find.byIcon(CupertinoIcons.check_mark_circled_solid), findsNWidgets(2));
//   //   await tester.tap(find.byKey(RegistrationPageKeys.privacyPolicyRadioButtonKey));
//   //   await tester.pump();
//   //   await tester.tap(find.byKey(RegistrationPageKeys.termsRadioButtonKey));
//   //   await tester.pump();
//   // });
//
//   // tap on privacy policy text button and check if it it redirects to privacy policy page and accept b
//
//   testWidgets("tap on privacy policy text button and check if it it redirects to privacy policy page",
//       (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetForTesting(child: const RegistrationView()));
//     await tester.tap(find.byKey(RegistrationPageKeys.privacyPolicyTextButtonKey));
//     for (int i = 0; i < 2; i++) {
//       await tester.pump(const Duration(seconds: 1));
//     }
//     expect(find.byType(TermsAndPolicyView), findsWidgets);
//     expect(find.textContaining("Accept"), findsOneWidget);
//   });
//
//   // tap on terms and conditions text button and check if it it redirects to terms and conditions page and accept button is rendered
//   testWidgets("tap on terms and conditions text button and check if it it redirects to terms and conditions page",
//       (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetForTesting(child: const RegistrationView()));
//     await tester.tap(find.byKey(RegistrationPageKeys.termsTextButtonKey));
//     for (int i = 0; i < 2; i++) {
//       await tester.pump(const Duration(seconds: 1));
//     }
//     expect(find.byType(TermsAndPolicyView), findsWidgets);
//     expect(find.textContaining("Accept"), findsOneWidget);
//   });
//
//   // fill all the fields, accept terms and conditions and privacy policy and click on register button and check if it redirects to email verification page
//   testWidgets(
//       "fill all the fields, accept terms and conditions and privacy policy and click on register button and check if it redirects to email verification page",
//       (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetForTesting(child: const RegistrationView()));
//     await tester.enterText(find.byKey(firstNameKey), "firstName");
//     await tester.pump();
//     await tester.enterText(find.byKey(lastNameKey), "lastName");
//     await tester.pump();
//     await tester.enterText(find.byKey(emailKey), "ali262883@gmail.com");
//     await tester.pump();
//     await tester.enterText(find.byKey(passwordKey), "12345678");
//     await tester.pump();
//     await tester.enterText(find.byKey(repeatPasswordKey), "12345678");
//     await tester.pump();
//     await tester.enterText(find.byKey(phoneNumberKey), "9899899988");
//     await tester.pump();
//     await SystemChannels.textInput.invokeMethod('TextInput.hide');
//     await tester.pump();
//     await tester.tap(find.byKey(RegistrationPageKeys.privacyPolicyRadioButtonKey));
//     await tester.pump();
//     await tester.tap(find.byKey(RegistrationPageKeys.termsRadioButtonKey));
//     await tester.pump();
//     await tester.tap(find.byKey(registerButtonKey));
//     for (int i = 0; i < 5; i++) {
//       await tester.pump(const Duration(seconds: 1));
//     }
//     expect(find.byType(EmailVerificationView), findsOneWidget);
//   });
// }
