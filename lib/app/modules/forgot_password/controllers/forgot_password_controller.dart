import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/services/auth_api.dart';

import '../../../utils/appString.dart';
import '../../../utils/snackbar_utils.dart';
import '../../../utils/string_utils.dart';
import '../../reset_password/views/reset_password_view.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController inputCodeController = TextEditingController();

  var isLoading = false.obs;
  var isLoadingOTP = false.obs;
  var isMailSent = false.obs;
  var errorMessage = "".obs;
  var reponceMessage = "".obs;
  var formKeys = GlobalKey<FormState>();

  @override
  void onClose() {
    emailController.dispose();
  }

  void validateForgotPassword() {
    if (emailController.text.trim().isEmpty) {
      errorMessage.value = AppString().please_enter_an_email_address(Get.context!);
    } else if (!EmailValidator.validate(emailController.text)) {
      errorMessage.value = AppString().please_enter_a_valid_email_address(Get.context!);
    } else {
      sendForgotPasswordEmail();
    }
  }

  void sendForgotPasswordEmail() async {
    isLoading.value = true;
    var response = await AuthAPI.forgotPassword(emailController.text);
    if (response.statusCode == 200) {
      isMailSent.value = true;
      errorMessage.value = "";
      reponceMessage.value = AppString().we_sent_otp_on_email(Get.context!);
    } else {
      errorMessage.value = StringUtils.getResponseMessage(response.body);
      isLoading.value = false;
    }
    isLoading.value = false;
  }

  void verifyEmail(String email) async {
    if (inputCodeController.text.length < 6) {
      SnackBarUtils.showSnackBar("Please enter the verification code", 1);
    } else {
      isLoadingOTP.value = true;
      var response = await AuthAPI.verifyCodeToResetPassword(inputCodeController.text, email);
      if (response.statusCode == 200) {
        Get.to(() => ResetPasswordView(
              email: email,
              code: inputCodeController.text,
            ));
      } else {
        SnackBarUtils.showSnackBar(StringUtils.getResponseMessage(response.body), 2);
      }
      isLoadingOTP.value = false;
    }
  }

  void resendCode(String email) async {
    inputCodeController.clear();
    SnackBarUtils.showSnackBar("Verification code resent successfully", 0);
    await AuthAPI.forgotPassword(email);
  }
}
