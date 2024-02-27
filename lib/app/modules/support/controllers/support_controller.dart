import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:ride_mobile/app/services/support_api.dart';
import 'package:ride_mobile/app/utils/validation_utils.dart';

import '../../../models/support_model.dart';
import '../../../utils/snackbar_utils.dart';
import '../../registration/controllers/country_code_controller.dart';
import '../views/support_confirmation_view.dart';

class SupportController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController deviceinfoController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  var isLoading = false.obs;

  void time() {}

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

  void sendContactUsRequest() async {
    if (emailController.text.trim().isEmpty ||
        nameController.text.trim().isEmpty ||
        messageController.text.trim().isEmpty) {
      SnackBarUtils.showSnackBar("All fields must be filled in", 1);
    } else if (!EmailValidator.validate(emailController.text)) {
      SnackBarUtils.showSnackBar("Invalid Email Address", 1);
    } else {
      isLoading.value = true;
      var response = await SupportAPI.sendContactUsRequest(
          emailController.text.trim(), nameController.text.trim(), messageController.text.trim());
      if (response != null) {
        isLoading.value = false;
        Get.to(() => SupportConfirmationView(
              isFromHome: true,
              flag: 0,
            ));
      } else {
        isLoading.value = false;
      }
      // clear text fields.
      nameController.clear();
      emailController.clear();
      messageController.clear();
    }
  }

  void sendSupportRequest() async {
    if (emailController.text.trim().isEmpty ||
        nameController.text.trim().isEmpty ||
        messageController.text.trim().isEmpty ||
        numberController.text.trim().isEmpty ||
        deviceinfoController.text.trim().isEmpty) {
      SnackBarUtils.showSnackBar("All fields must be filled in", 1);
    } else if (!EmailValidator.validate(emailController.text)) {
      SnackBarUtils.showSnackBar("Invalid Email Address", 1);
    } else if (!ValidationUtils.isValidMobile(numberController.text)) {
      SnackBarUtils.showSnackBar("Invalid Mobile Number!", 1);
    } else {
      isLoading.value = true;
      CountryCodeController countryCodeController = Get.put(CountryCodeController());
      var code = countryCodeController.currentCountryCode.value.dialCode.toString();
      var response = await SupportAPI.sendSupportForm(emailController.text.trim(), nameController.text.trim(),
          messageController.text.trim(), numberController.text.trim(), deviceinfoController.text.trim(), code);
      if (response.statusCode == 200) {
        isLoading.value = false;
        SupportResponse supportResponse = supportResponseFromJson(response.body);
        SnackBarUtils.showSnackBar(
            "Your support request has been successfully posted. We will contact you soon on the provided email.", 0);
        Get.to(() => SupportConfirmationView(isFromHome: false, ticketNo: supportResponse.support.ticket, flag: 1));
        nameController.clear();
        emailController.clear();
        messageController.clear();
        numberController.clear();
        deviceinfoController.clear();
      } else {
        var msg = jsonDecode(response.body)['message'];
        SnackBarUtils.showSnackBar(msg ?? "Something went wrong!", 1);
        isLoading.value = false;
      }
    }
  }

  void goBack(bool isFromHome) {
    if (isFromHome) {
      Get.back();
      HomeController controller = Get.put(HomeController());
      controller.switchTab(0);
    } else {
      Get.back();
      Get.back();
    }
  }
}
