import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/widgets/auth_widgets/auth_title_widget.dart';
import 'package:ride_mobile/app/widgets/auth_widgets/blurred_container.dart';

import '../../../utils/appString.dart';
import '../../../utils/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/font_utils.dart';
import '../../../utils/padding_utils.dart';
import '../../../widgets/auth_widgets/auth_action_button.dart';
import '../../../widgets/auth_widgets/auth_background_image.dart';
import '../../../widgets/auth_widgets/custom_prefix_icon.dart';
import '../../../widgets/auth_widgets/login_textfield.dart';
import '../../../widgets/auth_widgets/trailing_rich_text_widget.dart';
import '../../../widgets/logo_white.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  final String? email;
  final String? code;
  const ResetPasswordView({Key? key, this.email, this.code}) : super(key: key);

  Widget _suffixIconWidget(RxBool hidePassword, VoidCallback onTap) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: onTap,
            icon: Obx(() => Icon(
                  !hidePassword.value ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill,
                  color: AppColors.kIconColor,
                  size: 25,
                ))));
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ResetPasswordController());
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          height: Dimens.height(100, context),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  Assets.bg_img_shadow,
                  width: Dimens.width(100, context),
                  fit: BoxFit.fitWidth,
                ),
              ),
              AuthBackgroundImage(
                  height: Dimens.height(100, context), width: Dimens.width(100, context), image: Assets.bg_img_login),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(top: 120, left: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LogoWhite(height: Dimens.height(5, context), width: Dimens.width(0, context)),
                          const SizedBox(height: 37),
                          Text(
                            AppString().hold_on_tight(context),
                            style: FontUtils.TTFirsNeueTrial.copyWith(
                                fontSize: Dimens.currentSize(context, 18, 20, 24),
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: BlurredContainer(
                        height: Dimens.height(100, context),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AuthTitleWidget(title: AppString().create_new_password(context)),
                                    Container(
                                        height: 60,
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Column(
                                          children: [
                                            Text(
                                              AppString().make_sure_different_password(context),
                                              style: FontUtils.TTFirsNeueTrial.copyWith(
                                                  fontSize: Dimens.currentSize(context, 12, 14, 16),
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        )),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppString().create_new_password(context),
                                          style: FontUtils.SF.copyWith(
                                              fontSize: Dimens.currentSize(context, 12, 14, 16),
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.left,
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Obx(() => AuthTextField(
                                            hintText: AppString().must_be_8_charachters(context),
                                            prefixIcon: const CustomPrefixIcon(icon: Icons.lock_open),
                                            suffixIcon: _suffixIconWidget(
                                                controller.hideNewPassword, () => controller.hideShowNewPassword()),
                                            showSuffix: false,
                                            showPassword: controller.hideNewPassword.value,
                                            controller: controller.newPasswordController)),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Obx(
                                          () => Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Expanded(
                                                child: Divider(
                                                  thickness: 4,
                                                  height: 4,
                                                  color: controller.count > 0 && controller.count < 4
                                                      ? Colors.red
                                                      : controller.count >= 4 && controller.count < 8
                                                          ? Colors.yellow
                                                          : controller.count >= 8
                                                              ? Colors.green
                                                              : AppColors.kIconColor,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Divider(
                                                  thickness: 4,
                                                  height: 4,
                                                  color: controller.count >= 4 && controller.count < 8
                                                      ? Colors.yellow
                                                      : controller.count >= 8
                                                          ? Colors.green
                                                          : AppColors.kIconColor,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Divider(
                                                  thickness: 4,
                                                  height: 4,
                                                  color: controller.count >= 6 && controller.count < 8
                                                      ? Colors.yellow
                                                      : controller.count >= 8
                                                          ? Colors.green
                                                          : AppColors.kIconColor,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Divider(
                                                  thickness: 4,
                                                  height: 4,
                                                  color: controller.count >= 8 ? Colors.green : AppColors.kIconColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Obx(
                                          () => Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              controller.newPasswordStatus.value,
                                              style: FontUtils.SF.copyWith(
                                                  fontSize: Dimens.currentSize(context, 12, 14, 16),
                                                  color: controller.getStatusColor(),
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          AppString().re_enter_password(context),
                                          style: FontUtils.SF.copyWith(
                                              fontSize: Dimens.currentSize(context, 12, 14, 16),
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.left,
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Obx(() => AuthTextField(
                                            hMargin: 30,
                                            hintText: AppString().must_be_8_charachters(context),
                                            prefixIcon: const CustomPrefixIcon(icon: Icons.lock_open),
                                            suffixIcon: _suffixIconWidget(controller.hideConfirmPassword,
                                                () => controller.hideShowConfirmPassword()),
                                            showSuffix: false,
                                            showPassword: controller.hideConfirmPassword.value,
                                            controller: controller.confirmPasswordController)),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Obx(
                                          () => Divider(
                                            thickness: 4,
                                            color: controller.confirmPasswordStatus.isNotEmpty
                                                ? Colors.green
                                                : AppColors.kIconColor,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Obx(
                                          () => Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              controller.confirmPasswordStatus.value,
                                              style: FontUtils.SF.copyWith(
                                                  fontSize: Dimens.currentSize(context, 12, 14, 16),
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                color: Colors.transparent,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Obx(
                                      () => AuthActionButton(
                                          label: AppString().sign_in(context),
                                          bgColor: AppColors.bgButtonColor,
                                          hasBorder: false,
                                          hasArrow: false,
                                          fontColor: Colors.white,
                                          isLoading: controller.isLoading.value,
                                          onTap: () => controller.validateResetPassword(code!)),
                                    ),
                                    const SizedBox(
                                      height: AuthPaddingUtils.authButtonBottomMargin,
                                    ),
                                    TrailingRichTextWidget(
                                      leftLabel: "",
                                      rightLabel: "",
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
