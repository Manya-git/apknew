import 'package:get/get.dart';

import '../modules/currency/bindings/currency_binding.dart';
import '../modules/currency/views/currency_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/reward_point/bindings/reward_point_binding.dart';
import '../modules/reward_point/views/reward_point_view.dart';
import '../modules/support/bindings/support_binding.dart';
import '../modules/support/views/contact_us_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    // GetPage(
    //   name: _Paths.ACCOUNT,
    //   page: () => AccountView(),
    //   binding: AccountBinding(),
    // ),
    GetPage(
      name: _Paths.SUPPORT,
      page: () => SupportView(
        isFromHome: false,
      ),
      binding: SupportBinding(),
    ),
    // GetPage(
    //   name: _Paths.PROFILE,
    //   page: () => EditProfileView(),
    //   binding: ProfileBinding(),
    // ),
    // GetPage(
    //   name: _Paths.REWARD_POINT,
    //   page: () => const RewardPointView(),
    //   binding: RewardPointBinding(),
    // ),
    GetPage(
      name: _Paths.CURRENCY,
      page: () => const CurrencyView(),
      binding: CurrencyBinding(),
    ),
    GetPage(
      name: _Paths.REWARD_POINT,
      page: () => const RewardPointView(),
      binding: RewardPointBinding(),
    ),
  ];
}
