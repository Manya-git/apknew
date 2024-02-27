import 'package:get/get.dart';

import '../controllers/reward_point_controller.dart';

class RewardPointBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RewardPointController>(
      () => RewardPointController(),
    );
  }
}
