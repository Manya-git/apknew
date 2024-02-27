import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/profile/controllers/change_password_controller.dart';
import 'package:ride_mobile/app/utils/appString.dart';

import '../../../utils/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/font_utils.dart';
import '../../../utils/keys.dart';
import '../../../utils/padding_utils.dart';
import '../../../utils/snackbar_utils.dart';
import '../../../utils/validation_utils.dart';
import '../../../widgets/buttons/back_button.dart';
import '../../../widgets/buttons/primary_action_button.dart';
import '../../../widgets/registration_widgets/registration_text_field.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  ChangePasswordView({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();

  Widget _suffixIconWidget(RxBool hidePassword, VoidCallback onTap, Key key, BuildContext context) {
    return IconButton(
        key: key,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        constraints: const BoxConstraints(),
        onPressed: onTap,
        icon: Obx(() => Icon(
              !hidePassword.value ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill,
              color: AppColors.kIconColor,
              size: Dimens.currentSize(context, 20, 23, 23),
            )));
  }

  Widget _spacer() {
    return const SizedBox(
      height: 4,
    );
  }

  Widget _spacerMax() {
    return const SizedBox(
      height: 15,
    );
  }

  Widget titleView(String title, BuildContext context) {
    return Text(
      title,
      style: FontUtils.SF.copyWith(
          fontSize: Dimens.currentSize(context, 12, 14, 16), color: Colors.white, fontWeight: FontWeight.w500),
      textAlign: TextAlign.left,
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ChangePasswordController());
    return Scaffold(
      backgroundColor: AppColors.homeBGColor,
      body: Stack(
        children: [
          Image.asset(
            Assets.shop_bg,
            fit: BoxFit.fill,
            height: Dimens.height(100, context),
            width: Dimens.width(100, context),
            alignment: Alignment.topLeft,
            key: DestinationPageKeys.destinationHeaderImageKey,
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: Dimens.getStatusBarHeight(context),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ArrowedBackButton(),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        AppString().password_change(context),
                        textAlign: TextAlign.left,
                        style: FontUtils.TTFirsNeueTrial.copyWith(
                            fontSize: Dimens.currentSize(context, 18, 20, 22),
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizingUtils.kCommonSpacing, vertical: 30),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                            key: formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                titleView(AppString().current_password(context), context),
                                _spacer(),
                                Obx(() => RegistrationTextField(
                                        inputFormatters: [
                                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                        ],
                                        hintText: AppString().current_password(context),
                                        suffixIcon: _suffixIconWidget(controller.hideOldPassword,
                                            () => controller.toggleOldPassword(), const Key(""), context),
                                        showSuffix: true,
                                        validation: (value) => ValidationUtils.validatePassword(value),
                                        textCapitalization: TextCapitalization.none,
                                        showPassword: controller.hideOldPassword.value,
                                        controller: controller.oldPasswordController)),
                                _spacerMax(),
                                titleView(AppString().new_password(context), context),
                                _spacer(),
                                Obx(() => RegistrationTextField(
                                        inputFormatters: [
                                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                        ],
                                        hintText: AppString().new_password(context),
                                        suffixIcon: _suffixIconWidget(controller.hideNewPassword,
                                            () => controller.toggleNewPassword(), const Key(""), context),
                                        showSuffix: true,
                                        validation: (value) => ValidationUtils.validatePassword(value),
                                        textCapitalization: TextCapitalization.none,
                                        showPassword: controller.hideNewPassword.value,
                                        controller: controller.newPasswordController)),
                                _spacerMax(),
                                titleView(AppString().re_enter_new_password(context), context),
                                _spacer(),
                                Obx(() => RegistrationTextField(
                                        inputFormatters: [
                                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                        ],
                                        hintText: AppString().re_enter_new_password(context),
                                        suffixIcon: _suffixIconWidget(controller.hideConfirmPassword,
                                            () => controller.toggleConfirmPassword(), const Key(""), context),
                                        showSuffix: true,
                                        validation: (value) => ValidationUtils.validatePassword(value),
                                        textCapitalization: TextCapitalization.none,
                                        showPassword: controller.hideConfirmPassword.value,
                                        controller: controller.confirmPasswordController)),
                              ],
                            )),
                        const SizedBox(
                          height: 280,
                        ),
                        Container(
                          child: Column(
                            children: [
                              Obx(() => PrimaryActionButton(
                                  label: AppString().save_changes(context),
                                  onTap: () {
                                    if (formKey.currentState!.validate()) {
                                      formKey.currentState!.save();
                                      if (controller.newPasswordController.text.trim() !=
                                          controller.confirmPasswordController.text.trim()) {
                                        SnackBarUtils.showSnackBar("Passwords do not match", 1);
                                      } else {
                                        !controller.isSaving.value ? controller.changePassword() : null;
                                      }
                                    }
                                  },
                                  isLoading: controller.isSaving.value)),
                              const SizedBox(
                                height: 15,
                              ),
                              PrimaryActionButton(
                                  label: AppString().cancel(context),
                                  onTap: () => Get.back(),
                                  isDisable: true,
                                  isLoading: controller.isSaving.value),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
