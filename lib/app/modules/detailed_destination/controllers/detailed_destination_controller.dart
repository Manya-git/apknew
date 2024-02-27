import 'package:get/get.dart';
import 'package:ride_mobile/app/models/plan_model.dart';
import 'package:ride_mobile/app/services/destination_api.dart';

class DetailedDestinationController extends GetxController {
  var isLoading = false.obs;
  var plans = <PlanModel>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void getPlans(String country, String zone, bool isCountry, bool isZone) async {
    isLoading.value = true;
    if (plans.isNotEmpty) {
      plans.clear();
    }
    var products = await DestinationAPI.fetchPlans(country, zone, isCountry, isZone);
    plans.assignAll(products);
    isLoading.value = false;
  }
}
