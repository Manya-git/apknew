// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:get/get.dart';
// import 'package:ride_mobile/app/modules/destination/controllers/destination_controller.dart';
// import 'package:ride_mobile/app/modules/destination/views/destination_view.dart';
// import 'package:ride_mobile/app/utils/keys.dart';
//
// main() {
//   late DestinationController controller;
//
//   final searchField = find.descendant(
//     of: find.byKey(DestinationPageKeys.searchFieldKey),
//     matching: find.byType(EditableText),
//   );
//
//   setUpAll(() async {
//     controller = Get.put(DestinationController());
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
//
//
//
//   testWidgets("check if destination header background image is rendered", (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetForTesting(child: const DestinationView()));
//     expect(find.byKey(DestinationPageKeys.destinationHeaderImageKey), findsOneWidget);
//   });
//
//   testWidgets("check if segment control widget is rendered which switched between country and zone", (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetForTesting(child: const DestinationView()));
//     expect(find.byKey(DestinationPageKeys.segmentControlKey), findsOneWidget);
//   });
//
//   testWidgets("check if current location widget is rendered", (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetForTesting(child: const DestinationView()));
//     expect(find.byKey(DestinationPageKeys.currentLocationWidgetKey), findsOneWidget);
//   });
//
//   testWidgets("check if destination search text field is rendered", (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetForTesting(child: const DestinationView()));
//     expect(find.byKey(DestinationPageKeys.searchFieldKey), findsOneWidget);
//   });
//
//   testWidgets("check if popular destinations list widget is rendered when the current segment value is 0",
//       (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetForTesting(child: const DestinationView()));
//     controller.changeGroupValue(0);
//     await tester.pump(const Duration(seconds: 1));
//     expect(find.byKey(DestinationPageKeys.popularDestinationsListKey), findsOneWidget);
//   });
//
//   testWidgets("check if popular zones list widget is rendered when the current segment value is 1", (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetForTesting(child: const DestinationView()));
//     controller.changeGroupValue(1);
//     await tester.pump(const Duration(seconds: 1));
//     expect(find.byKey(DestinationPageKeys.popularZonesListKey), findsOneWidget);
//   });
//
//   testWidgets("search for a destination in popular destinations list", (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetForTesting(child: const DestinationView()));
//     controller.changeGroupValue(0);
//     await tester.pump(const Duration(seconds: 1));
//     expect(find.byKey(DestinationPageKeys.popularDestinationsListKey), findsOneWidget);
//     await tester.enterText(searchField, "ger");
//     await tester.pump(const Duration(seconds: 1));
//     controller.search();
//     await tester.pump(const Duration(seconds: 1));
//     expect(find.byKey(DestinationPageKeys.popularDestinationsListKey), findsOneWidget);
//     expect(find.textContaining("Germany"), findsWidgets);
//   });
//
//   testWidgets("search for a zone in popular zones list", (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetForTesting(child: const DestinationView()));
//     controller.changeGroupValue(1);
//     await tester.pump(const Duration(seconds: 1));
//     expect(find.byKey(DestinationPageKeys.popularZonesListKey), findsOneWidget);
//     await tester.enterText(searchField, "eur");
//     await tester.pump(const Duration(seconds: 1));
//     controller.search();
//     await tester.pump(const Duration(seconds: 1));
//     expect(find.byKey(DestinationPageKeys.popularZonesListKey), findsOneWidget);
//     expect(find.textContaining("Europe"), findsWidgets);
//   });
// }
