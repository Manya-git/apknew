import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/models/currency_model.dart';
import 'package:ride_mobile/app/modules/home/views/home_view.dart';
import 'package:ride_mobile/app/services/currency_api.dart';

import '../../../models/location_model.dart';
import '../../../models/plan_model.dart';
import '../../../services/destination_api.dart';
import '../../../services/user/current_user.dart';
import '../../payment/views/payment_details_view.dart';
import '../views/changes_success_view.dart';

class CurrencyController extends GetxController {
  TextEditingController searchController = TextEditingController();
  var isLoadingCurrency = false.obs;
  var currency = CurrencyModel().obs;
  var isUpdating = false.obs;

  // this is to store only currency lists
  var currencyList = <CurrencyList>[].obs;
  // var popularDestinations = <LocationModel>[].obs;

  // currency selected
  var selectedIndex;

  @override
  void onInit() {
    if (CurrentUser().configResponse.data!.currencyConversionMasterEnabled!) {
      getCurrencyLists();
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void getCurrencyLists() async {
    isLoadingCurrency.value = true;
    var data = await CurrencyAPI.fetchCurrency(CurrentUser().currentUser.token!);
    currencyList.assignAll(data.currencyList!);
    currency.value = data;
    isLoadingCurrency.value = false;
  }

  void searchCurrency() {
    if (searchController.text.trim().isEmpty) {
      currencyList.assignAll(currency.value.currencyList!);
      print("***" + currencyList.length.toString());
    } else {
      currencyList.value = currency.value.currencyList!
          .where((element) =>
              element.currencyName.toString().toLowerCase().contains(searchController.text.trim().toLowerCase()))
          .toList();
      print(currencyList.length);
    }
  }

  updateSelectedIndex(index) {
    selectedIndex = index;
    update();
  }

  void updateCurrency(currency, currencyName, from, {PlanModel? plan, LocationModel? location}) async {
    isUpdating.value = true;
    var body = {"currency": currency, "currency_name": currencyName};
    var res = await CurrencyAPI.updateCurrency(body);
    if (res.statusCode == 200) {
      isUpdating.value = false;
      if (from == "view") {
        Get.offAll(() => const HomeView());
      } else if (from == "browse plan") {
        var products = await DestinationAPI.fetchSinglePlans(plan!.productId!, plan.country!);
        if (products.isNotEmpty) {
          Get.to(() => PaymentDetailsView(
                isFromDrawer: false,
                isFromHome: false,
                location: location,
                plan: products[0],
              ));
        }
      } else {
        Get.offAll(() => CurrencyChangeSuccessView());
      }
    } else {
      isUpdating.value = false;
    }
  }
}
