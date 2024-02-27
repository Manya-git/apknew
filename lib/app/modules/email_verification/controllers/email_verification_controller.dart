import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/models/location_model.dart';
import 'package:ride_mobile/app/models/plan_model.dart';
import 'package:ride_mobile/app/modules/currency/views/currency_view.dart';
import 'package:ride_mobile/app/services/auth_api.dart';
import 'package:ride_mobile/app/utils/string_utils.dart';

import '../../../services/user/current_user.dart';
import '../../../services/user/local preferences.dart';
import '../../../utils/snackbar_utils.dart';
import '../../home/views/home_view.dart';
import '../../payment/views/payment_details_view.dart';

class EmailVerificationController extends GetxController {
  TextEditingController inputCodeController = TextEditingController();

  var isLoading = false.obs;
  var isCodeValid = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {}

  void verifyEmail(String email, String password, PlanModel? plan, LocationModel? location, bool fromLogin) async {
    if (inputCodeController.text.length < 6) {
      SnackBarUtils.showSnackBar("Please enter the verification code", 1);
    } else {
      isLoading.value = true;
      var response = await AuthAPI.verifyCode(inputCodeController.text, email);
      if (response.statusCode == 200) {
        await LocalPreferences.setUserEmail(email);
        await LocalPreferences.setUserPassword(password);
        var res = jsonDecode(response.body)["tokenResponse"];
        var token = res['token'];
        await AuthAPI.fetchUserInfo(token);
        isCodeValid.value = true;
        isLoading.value = false;
        if (CurrentUser().configResponse.data!.currencyConversionMasterEnabled!) {
          if (fromLogin) {
            Get.to(() => const CurrencyView(from: "view"));
          } else {
            Get.back();
            plan != null
                ? Get.to(CurrencyView(from: "browse plan", location: location, plan: plan))
                : Get.to(const CurrencyView(from: "view"));
          }
        } else {
          if (fromLogin) {
            Get.offAll(() => const HomeView());
          } else if (plan != null) {
            Get.to(() => PaymentDetailsView(
                  isFromDrawer: false,
                  isFromHome: false,
                  location: location,
                  plan: plan,
                ));
          } else {
            Get.offAll(() => const HomeView());
          }
        }
      } else {
        SnackBarUtils.showSnackBar(StringUtils.getResponseMessage(response.body), 2);
        isCodeValid.value = false;
      }
      isLoading.value = false;
    }
  }

  void resendCode(String email) async {
    StringUtils.debugPrintMode("clearing code");
    inputCodeController.clear();
    isLoading.value = true;
    var response = await AuthAPI.resendVerificationCode(email);
    if (response.statusCode == 200) {
      isLoading.value = false;
      SnackBarUtils.showSnackBar("Verification code resent successfully", 0);
    } else {
      isLoading.value = false;
      SnackBarUtils.showSnackBar(StringUtils.getResponseMessage(response.body), 2);
    }
  }
}
