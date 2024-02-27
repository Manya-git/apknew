import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/models/location_model.dart';
import 'package:ride_mobile/app/models/plan_model.dart';
import 'package:ride_mobile/app/modules/email_verification/views/email_verification_view.dart';
import 'package:ride_mobile/app/modules/home/views/home_view.dart';
import 'package:ride_mobile/app/services/auth_api.dart';
import 'package:ride_mobile/app/services/mix_panel/events.dart';
import 'package:ride_mobile/app/utils/appString.dart';
import 'package:ride_mobile/app/utils/string_utils.dart';

import '../../../services/destination_api.dart';
import '../../payment/views/payment_details_view.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var hidePassword = true.obs;
  var isLoading = false.obs;
  var errorMessage = "".obs;
  var titleMessage = AppString().welcome_sign_in(Get.context!).obs;
  var isPending = false.obs;

  @override
  void onInit() {
    autoRefill();
    super.onInit();
  }

  @override
  void onClose() {}

  void autoRefill() {
    if (kDebugMode) {
      emailController.text = "manish08@mailinator.com";
      passwordController.text = "Demo@12345";
    }
  }

  void hideShowPassword() {
    hidePassword.value = !hidePassword.value;
  }

  void login(BuildContext context, PlanModel? plan, LocationModel? location) async {
    isPending.value = false;
    errorMessage.value = "";
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
    isLoading.value = true;
    var response = await AuthAPI.loginUser(emailController.text, passwordController.text);
    if (response.statusCode == 200) {
      if (plan != null) {
        var products = await DestinationAPI.fetchSinglePlans(plan.productId!, plan.country!);
        if (products.isNotEmpty) {
          Get.to(() => PaymentDetailsView(
                isFromDrawer: false,
                isFromHome: false,
                location: location,
                plan: products[0],
              ));
        }
      } else {
        Get.offAll(() => const HomeView());
        MixPanelEvents.loginEvent();
      }
    } else {
      titleMessage.value = AppString().welcome_sign_in_error(context);
      errorMessage.value = StringUtils.getResponseMessage(response.body);
      var isVerificationPending = jsonDecode(response.body)["verficationPending"] ?? false;
      StringUtils.debugPrintMode(isVerificationPending);
      if (isVerificationPending) {
        isPending.value = true;
      }
    }
    isLoading.value = false;
  }

  void sendVerificationEmail() {
    AuthAPI.resendVerificationCode(emailController.text);
    Get.to(() => EmailVerificationView(
          email: emailController.text,
          plan: PlanModel(),
          location: LocationModel(),
          password: passwordController.text,
          token: "",
          fromLogin: true,
        ));
  }
}
