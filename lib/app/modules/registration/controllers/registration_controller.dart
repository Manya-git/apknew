import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/models/location_model.dart';
import 'package:ride_mobile/app/models/plan_model.dart';
import 'package:ride_mobile/app/modules/email_verification/views/email_verification_view.dart';
import 'package:ride_mobile/app/services/auth_api.dart';
import 'package:ride_mobile/app/services/mix_panel/events.dart';
import 'package:ride_mobile/app/services/user/current_user.dart';
import 'package:ride_mobile/app/utils/string_utils.dart';

import '../../../utils/appString.dart';
import '../../../utils/assets.dart';
import '../../../utils/snackbar_utils.dart';
import 'country_code_controller.dart';

class RegistrationController extends GetxController {
  var titleMessage = AppString().welcome_sign_in(Get.context!).obs;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController referalController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();
  final GlobalKey<PopupMenuButtonState<int>> countryPickerKey = GlobalKey();

  var isLoading = false.obs;
  var privacyPolicyAccepted = false.obs;
  var eSIMAccepted = false.obs;
  var termsAccepted = false.obs;
  var hidePassword = true.obs;
  var hideRepeatPassword = true.obs;

  @override
  void onInit() {
    autoFill();
    super.onInit();
  }

  @override
  void onClose() {}

  void autoFill() {
    if (kDebugMode) {
      firstNameController.text = "Manish";
      lastNameController.text = "Patel";
      emailController.text = "manish0@mailinator.com";
      mobileNumberController.text = "9999999999";
      passwordController.text = "Demo@12345";
      repeatPasswordController.text = "Demo@12345";
      referalController.text = "";
      eSIMAccepted.value = true;
      privacyPolicyAccepted.value = true;
      termsAccepted.value = true;
    }
  }

  void acceptPrivacyPolicy() {
    privacyPolicyAccepted.value = !privacyPolicyAccepted.value;
  }

  void accepteSIM() {
    eSIMAccepted.value = !eSIMAccepted.value;
  }

  void acceptTerms() {
    termsAccepted.value = !termsAccepted.value;
  }

  void hideShowPassword() {
    hidePassword.value = !hidePassword.value;
  }

  void hideShowRepeatPassword() {
    hideRepeatPassword.value = !hideRepeatPassword.value;
  }

  void registerUser(PlanModel? plan, LocationModel? location) async {
    CountryCodeController countryCodeController = Get.put(CountryCodeController());
    var code = countryCodeController.currentCountryCode.value.dialCode.toString();

    isLoading.value = true;
    var params = {
      "firstName": firstNameController.text,
      "lastName": lastNameController.text,
      "email": emailController.text.toLowerCase(),
      "password": passwordController.text,
      "mobile": mobileNumberController.text,
      "customerId": Assets.GB_ID,
      "countryCode": code,
      "displayName": firstNameController.text + " " + lastNameController.text,
      "referrerReferralCode": referalController.text,
    };

    var response = await AuthAPI.registerUser(params);

    if (response.statusCode == 200) {
      String msg = jsonDecode(response.body)["message"];
      if (msg.contains("OTP")) {
        isLoading.value = false;
        Get.to(() => EmailVerificationView(
              token: "",
              password: passwordController.text,
              location: location,
              email: emailController.text,
              plan: plan,
              fromLogin: false,
            ));
        SnackBarUtils.showSnackBar(StringUtils.getResponseMessage(response.body), 0);
      } else {
        var token = jsonDecode(response.body)["token"];
        await AuthAPI.fetchUserInfo(token);
        MixPanelEvents.registrationEvent();
        CurrentUser().currentUser.token = token;
        isLoading.value = false;
        Get.to(() => EmailVerificationView(
              token: token,
              password: passwordController.text,
              location: location,
              email: emailController.text,
              plan: plan,
              fromLogin: false,
            ));
      }
    } else {
      isLoading.value = false;
      var isVerificationPending = jsonDecode(response.body)["verificationPending"] ?? false;
      if (isVerificationPending) {
        SnackBarUtils.showSnackBar("User already exists, please verify the user!", 2);
        Get.to(() => EmailVerificationView(
              token: "",
              password: passwordController.text,
              location: location,
              email: emailController.text,
              plan: plan,
              fromLogin: false,
            ));
      } else {
        SnackBarUtils.showSnackBar(StringUtils.getResponseMessage(response.body), 2);
      }
    }
  }

  void validateRegistration(PlanModel? plan, LocationModel? location) {
    if (firstNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        mobileNumberController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        repeatPasswordController.text.trim().isEmpty) {
      SnackBarUtils.showSnackBar("All fields must be filled in", 1);
    } else if (!EmailValidator.validate(emailController.text)) {
      SnackBarUtils.showSnackBar("Invalid Email Address", 1);
    } else if (passwordController.text.length < 8 || repeatPasswordController.text.length < 8) {
      SnackBarUtils.showSnackBar("Password should contain minimum 8 characters", 1);
    } else if (passwordController.text.trim() != repeatPasswordController.text.trim()) {
      SnackBarUtils.showSnackBar("Passwords do not match", 1);
    } else if (!termsAccepted.value) {
      SnackBarUtils.showSnackBar("Please accept the Terms & Conditions", 1);
    } else if (!privacyPolicyAccepted.value) {
      SnackBarUtils.showSnackBar("Please accept the Privacy Policy", 1);
    } else {
      registerUser(plan, location);
    }
  }
}
