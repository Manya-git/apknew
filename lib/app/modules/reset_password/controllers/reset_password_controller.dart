import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/landing/views/landing_view.dart';
import 'package:ride_mobile/app/modules/login/views/login_view.dart';
import 'package:ride_mobile/app/utils/colors.dart';

import '../../../services/auth_api.dart';
import '../../../utils/appString.dart';
import '../../../utils/snackbar_utils.dart';
import '../../../utils/string_utils.dart';

class ResetPasswordController extends GetxController {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  var hideNewPassword = true.obs;
  var hideConfirmPassword = true.obs;
  var newPasswordStatus = "".obs;
  var confirmPasswordStatus = "".obs;
  var isLoading = false.obs;
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    newPasswordController.addListener(_newPasswordChangeListuner);
    confirmPasswordController.addListener(_confirmPasswordListuner);
  }

  void _newPasswordChangeListuner() {
    if (newPasswordController.text.isNotEmpty && newPasswordController.text.length < 4) {
      count.value = newPasswordController.text.length;
      newPasswordStatus.value = AppString().weak(Get.context!);
    } else if (newPasswordController.text.length >= 4 && newPasswordController.text.length < 8) {
      count.value = newPasswordController.text.length;
      newPasswordStatus.value = AppString().fair(Get.context!);
    } else if (newPasswordController.text.length >= 8) {
      count.value = newPasswordController.text.length;
      newPasswordStatus.value = AppString().strong(Get.context!);
    }
  }

  void _confirmPasswordListuner() {
    if (newPasswordController.text.trim() == confirmPasswordController.text.trim()) {
      confirmPasswordStatus.value = AppString().password_match(Get.context!);
    } else {
      confirmPasswordStatus.value = "";
    }
  }

  Color getStatusColor() {
    if (newPasswordController.text.isNotEmpty && newPasswordController.text.length < 4) {
      return Colors.red;
    } else if (newPasswordController.text.length >= 4 && newPasswordController.text.length < 8) {
      return Colors.yellow;
    } else if (newPasswordController.text.length >= 8) {
      return Colors.green;
    }
    return AppColors.kIconColor;
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void onClose() {}

  void increment() => count.value++;

  void hideShowNewPassword() {
    hideNewPassword.value = !hideNewPassword.value;
  }

  void hideShowConfirmPassword() {
    hideConfirmPassword.value = !hideConfirmPassword.value;
  }

  void validateResetPassword(String code) {
    if (newPasswordController.text.isEmpty) {
      SnackBarUtils.showSnackBar("Please enter new password", 2);
      return;
    }
    if (confirmPasswordController.text.isEmpty) {
      SnackBarUtils.showSnackBar("Please enter confirm password", 2);
      return;
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      SnackBarUtils.showSnackBar("Passwords do not match each other", 2);
      return;
    }
    resetPassword(code);
  }

  void resetPassword(String code) async {
    isLoading.value = true;
    var response = await AuthAPI.resetPassword(code, newPasswordController.text, confirmPasswordController.text);
    if (response.statusCode == 200) {
      isLoading.value = false;
      SnackBarUtils.showSnackBar(StringUtils.getResponseMessage(response.body), 0);
      await Future.delayed(const Duration(seconds: 1));
      Get.offAll(() => const LandingView());
      Get.to(() => LoginView());
    } else {
      SnackBarUtils.showSnackBar(StringUtils.getResponseMessage(response.body), 2);
      isLoading.value = false;
    }
  }
}
