import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/utils/appString.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';
import 'package:ride_mobile/app/utils/keys.dart';
import 'package:ride_mobile/app/utils/padding_utils.dart';
import 'package:ride_mobile/app/widgets/auth_widgets/blurred_container.dart';

import '../../../utils/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/auth_widgets/auth_action_button.dart';
import '../../../widgets/auth_widgets/auth_background_image.dart';
import '../../../widgets/auth_widgets/auth_title_widget.dart';
import '../../../widgets/auth_widgets/custom_prefix_icon.dart';
import '../../../widgets/auth_widgets/login_textfield.dart';
import '../../../widgets/auth_widgets/verification_code_field.dart';
import '../../../widgets/logo_white.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ForgotPasswordController());
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: SizedBox(
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
                                AppString().now_would_be_perfect_time_open_mail(context),
                                style: FontUtils.TTFirsNeueTrial.copyWith(
                                    fontSize: Dimens.currentSize(context, 18, 20, 24),
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        )),
                    Flexible(
                      flex: 2,
                      child: BlurredContainer(
                          height: Dimens.height(100, context),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AuthTitleWidget(title: AppString().reset_your_password(context)),
                                      Obx(() => controller.errorMessage.value.isEmpty
                                          ? Container(
                                              height: 60,
                                              padding: const EdgeInsets.only(top: 5),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    AppString().enter_details_reset_password(context),
                                                    style: FontUtils.TTFirsNeueTrial.copyWith(
                                                        fontSize: Dimens.currentSize(context, 12, 14, 16),
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w500),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ],
                                              ))
                                          : Container(
                                              height: 60,
                                              padding: const EdgeInsets.only(top: 5),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    controller.errorMessage.value,
                                                    style: FontUtils.TTFirsNeueTrial.copyWith(
                                                        fontSize: Dimens.currentSize(context, 12, 14, 16),
                                                        color: Colors.red,
                                                        fontWeight: FontWeight.w500),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ],
                                              ))),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Form(
                                    key: controller.formKeys,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppString().enter_your_email(context),
                                          style: FontUtils.SF.copyWith(
                                              fontSize: Dimens.currentSize(context, 12, 14, 16),
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.left,
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        AuthTextField(
                                            key: ForgotPasswordKeys.emailFieldKey,
                                            hintText: "name@company.com",
                                            prefixIcon: const CustomPrefixIcon(icon: Icons.email_outlined),
                                            suffixIcon: null,
                                            showSuffix: false,
                                            showPassword: false,
                                            controller: controller.emailController),
                                        const SizedBox(
                                          height: AuthPaddingUtils.authButtonBottomMargin,
                                        ),
                                        Obx(
                                          () => AuthActionButton(
                                              key: ForgotPasswordKeys.submitButtonKey,
                                              label: AppString().request_otp(context),
                                              bgColor: AppColors.bgButtonColor,
                                              hasBorder: false,
                                              fontColor: Colors.white,
                                              hasArrow: false,
                                              isLoading: controller.isLoading.value,
                                              onTap: () {
                                                controller.validateForgotPassword();
                                              }),
                                        ),
                                        const SizedBox(
                                          height: AuthPaddingUtils.authButtonBottomMargin,
                                        ),
                                        Obx(
                                          () => controller.reponceMessage.value.isNotEmpty
                                              ? Text(
                                                  controller.reponceMessage.value,
                                                  style: FontUtils.SF.copyWith(
                                                      fontSize: Dimens.currentSize(context, 12, 14, 16),
                                                      color: Colors.green,
                                                      fontWeight: FontWeight.w400),
                                                )
                                              : const SizedBox.shrink(),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          AppString().enter_the_otp(context),
                                          style: FontUtils.SF.copyWith(
                                              fontSize: Dimens.currentSize(context, 12, 14, 16),
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.left,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        VerificationCodeField(
                                          width: 40,
                                          textColor: Colors.white,
                                          controller: controller.inputCodeController,
                                          key: CodeVerificationKeys.codeVerificationInputKey,
                                        ),
                                        InkWell(
                                          onTap: () => controller.resendCode(controller.emailController.text),
                                          child: Text(
                                            AppString().resend_otp(context),
                                            style: FontUtils.SF.copyWith(
                                                fontSize: Dimens.currentSize(context, 12, 14, 16),
                                                color: AppColors.bgButtonColor,
                                                fontWeight: FontWeight.w500,
                                                decoration: TextDecoration.underline),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Obx(
                                          () => AuthActionButton(
                                              key: CodeVerificationKeys.submitButtonKey,
                                              label: AppString().submit(context),
                                              bgColor: controller.isMailSent.value
                                                  ? AppColors.bgButtonColor
                                                  : AppColors.bgButtonUnSelectedColor,
                                              hasBorder: false,
                                              hasArrow: false,
                                              fontColor: Colors.white,
                                              isLoading: controller.isLoadingOTP.value,
                                              onTap: () => controller.verifyEmail(controller.emailController.text)),
                                        ),
                                      ],
                                    ),
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
          ),
        ));
  }
}
