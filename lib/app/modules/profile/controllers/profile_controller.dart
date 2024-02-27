import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/registration/controllers/country_code_controller.dart';
import 'package:ride_mobile/app/services/account_api.dart';
import 'package:ride_mobile/app/services/auth_api.dart';
import 'package:ride_mobile/app/services/user/current_user.dart';
import 'package:ride_mobile/app/utils/snackbar_utils.dart';
import 'package:ride_mobile/app/utils/string_utils.dart';

import '../../../utils/validation_utils.dart';

class ProfileController extends GetxController {
  //TODO: Implement ProfileController

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController currencyController = TextEditingController();

  var isUpdating = false.obs;
  var isLoading = false.obs;
  var hidePassword = true.obs;

  void hideShowPassword() {
    hidePassword.value = !hidePassword.value;
  }

  @override
  void onInit() {
    setData();
    setCountryCode();
    super.onInit();
  }

  @override
  void onClose() {}

  void setCountryCode() async {
    CountryCodeController countryCodeController = Get.put(CountryCodeController());
    if (CurrentUser().currentUser.countryCode!.isNotEmpty) {
      countryCodeController.currentCountryCode.value.dialCode = CurrentUser().currentUser.countryCode!;
    }
  }

  void setData() {
    firstNameController.text = CurrentUser().currentUser.firstName! + " " + CurrentUser().currentUser.lastName!;
    lastNameController.text = CurrentUser().currentUser.lastName!;
    mobileNumberController.text = CurrentUser().currentUser.mobile!;
    emailController.text = CurrentUser().currentUser.email!;
    passwordController.text = "********";
  }

  Future<void> getUser() async {
    isLoading.value = true;
    await AuthAPI.fetchUserInfo(CurrentUser().currentUser.token!);
    isLoading.value = false;
  }

  void validateUpdate() {
    if (firstNameController.text.isEmpty || mobileNumberController.text.isEmpty) {
      SnackBarUtils.showSnackBar("All fields must be filled in", 1);
    } else if (!ValidationUtils.isValidMobile(mobileNumberController.text.trim())) {
      SnackBarUtils.showSnackBar("Please enter valid mobile number!", 1);
    } else if (!firstNameController.text.contains(" ")) {
      SnackBarUtils.showSnackBar("Please enter full name", 1);
    } else {
      updateUser();
    }
  }

  void updateUser() async {
    CountryCodeController controller = Get.put(CountryCodeController());
    var countryCode = controller.currentCountryCode.value.dialCode.toString();
    isUpdating.value = true;
    StringUtils.debugPrintMode(countryCode);
    var temp = firstNameController.text.split(" ");
    var fname = temp[0];
    var lname = temp[1];
    var body = {
      "firstName": fname,
      "lastName": lname,
      "mobile": mobileNumberController.text,
      "countryCode": countryCode,
    };
    var res = await AccountAPI.updateUser(body);
    if (res.statusCode == 200) {
      await getUser();
      isUpdating.value = false;
      Get.back();
      // SnackBarUtils.showSnackBar(StringUtils.getResponseMessage("Data Updated Successfully!"), 0);
      SnackBarUtils.showSnackBar("Data Updated Successfully!", 0);
      // wait for 5 seconds and then go back to previous screen.
    } else {
      SnackBarUtils.showSnackBar(StringUtils.getResponseMessage(res.body), 2);
      isUpdating.value = false;
    }
  }

  // void validateUpdate() {
  //   if (firstNameController.text.isEmpty || lastNameController.text.isEmpty || mobileNumberController.text.isEmpty) {
  //     SnackBarUtils.showSnackBar("All fields must be filled in", 1);
  //   } else {
  //     updateUser();
  //   }
  // }
  //
  // void updateUser() async {
  //   CountryCodeController controller = Get.put(CountryCodeController());
  //   var countryCode = controller.currentCountryCode.value.dialCode.toString();
  //   isUpdating.value = true;
  //   StringUtils.debugPrintMode(countryCode);
  //   var body = {
  //     "firstName": firstNameController.text,
  //     "lastName": lastNameController.text,
  //     "mobile": mobileNumberController.text,
  //     "countryCode": countryCode,
  //   };
  //   var res = await AccountAPI.updateUser(body);
  //   if (res.statusCode == 200) {
  //     await getUser();
  //     isUpdating.value = false;
  //     Get.back();
  //     // SnackBarUtils.showSnackBar(StringUtils.getResponseMessage("Data Updated Successfully!"), 0);
  //     SnackBarUtils.showSnackBar("Data Updated Successfully!", 0);
  //     // wait for 5 seconds and then go back to previous screen
  //   } else {
  //     // SnackBarUtils.showSnackBar(StringUtils.getResponseMessage(res.body), 2);
  //     isUpdating.value = false;
  //   }
  // }
}
