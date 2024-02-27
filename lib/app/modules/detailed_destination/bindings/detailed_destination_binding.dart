import 'package:get/get.dart';

import '../controllers/detailed_destination_controller.dart';

class DetailedDestinationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailedDestinationController>(
      () => DetailedDestinationController(),
    );
  }
}
