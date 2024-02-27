import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/services/profile_api.dart';
import 'package:ride_mobile/app/services/user/local%20preferences.dart';
import 'package:ride_mobile/app/utils/string_utils.dart';

import '../../../utils/snackbar_utils.dart';

class ChangePasswordController extends GetxController {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  var hideOldPassword = true.obs;
  var hideNewPassword = true.obs;
  var hideConfirmPassword = true.obs;

  var isSaving = false.obs;

  void toggleOldPassword() {
    hideOldPassword.value = !hideOldPassword.value;
  }

  void toggleNewPassword() {
    hideNewPassword.value = !hideNewPassword.value;
  }

  void toggleConfirmPassword() {
    hideConfirmPassword.value = !hideConfirmPassword.value;
  }

  void changePassword() async {
    isSaving.value = true;
    var res = await ProfileAPI.changePassword(oldPasswordController.text, newPasswordController.text, confirmPasswordController.text);
    if (res.statusCode == 200) {
      LocalPreferences.setUserPassword(newPasswordController.text);
      SnackBarUtils.showSnackBar("Password Changed Successfully", 0);
    } else {
      SnackBarUtils.showSnackBar(StringUtils.getResponseMessage(res.body), 3);
    }
    isSaving.value = false;
  }

  void validatePassword() {
    if (oldPasswordController.text.trim().isEmpty ||
        newPasswordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty) {
      SnackBarUtils.showSnackBar("All fields must be filled in", 1);
    } else if (oldPasswordController.text.length < 8 ) {
      SnackBarUtils.showSnackBar("Old Password should contain minimum 8 characters", 1);
    } else if (newPasswordController.text.length < 8) {
      SnackBarUtils.showSnackBar("New Password should contain minimum 8 characters", 1);
    } else if (confirmPasswordController.text.length < 8 ) {
      SnackBarUtils.showSnackBar("Confirm Password should contain minimum 8 characters", 1);
    } else if (newPasswordController.text.trim() != confirmPasswordController.text.trim()) {
      SnackBarUtils.showSnackBar("Passwords do not match", 1);
    } else {
     changePassword();
    }
  }
}
