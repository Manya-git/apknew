import 'package:get/get.dart';

import '../controllers/landing_controller.dart';

class StartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LandingController>(
      () => LandingController(),
    );
  }
}
