import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/models/location_model.dart';
import 'package:ride_mobile/app/models/plan_model.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';
import 'package:ride_mobile/app/widgets/buttons/back_button.dart';

import '../../../utils/appString.dart';
import '../../../utils/assets.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/keys.dart';
import '../../../widgets/auth_widgets/resend_code_button.dart';
import '../../../widgets/auth_widgets/verification_code_field.dart';
import '../../../widgets/buttons/primary_action_button.dart';
import '../../../widgets/loader_view.dart';
import '../controllers/email_verification_controller.dart';

class EmailVerificationView extends GetView<EmailVerificationController> {
  final String email;
  final PlanModel? plan;
  final LocationModel? location;
  final String password;
  final String token;
  final bool fromLogin;

  const EmailVerificationView(
      {Key? key,
      required this.email,
      this.plan,
      this.location,
      required this.password,
      required this.fromLogin,
      required this.token})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(EmailVerificationController());
    return Scaffold(
      backgroundColor: AppColors.homeBGColor,
      body: SizedBox(
        height: Dimens.height(100, context),
        width: Dimens.width(100, context),
        child: Stack(
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: (60),
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
                          AppString().enter_verification_code(context),
                          textAlign: TextAlign.left,
                          style: FontUtils.TTFirsNeueTrial.copyWith(
                              fontSize: Dimens.currentSize(context, 18, 20, 22),
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Obx(
                          () => SizedBox(
                            child: !controller.isCodeValid.value
                                ? CodeResendTextButton(onTap: () => controller.resendCode(email))
                                : Text(AppString().enter_digit_email(context),
                                    style: FontUtils.TTFirsNeueTrial.copyWith(
                                        fontSize: Dimens.currentSize(context, 12, 14, 16),
                                        color: Colors.white,
                                        height: Dimens.lineHeight())),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: VerificationCodeField(
                            width: 45,
                            textColor: Colors.white,
                            controller: controller.inputCodeController,
                            key: CodeVerificationKeys.codeVerificationInputKey,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ResendCodeButton(
                          color: Colors.white,
                          onTap: () => controller.resendCode(email),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Obx(() => PrimaryActionButton(
                        label: AppString().submit(context),
                        onTap: () => controller.verifyEmail(email, password, plan, location, fromLogin),
                        isLoading: controller.isLoading.value))),
                const SizedBox(height: 50),
              ],
            ),
            Obx(() => controller.isLoading.value ? const LoaderView() : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}

class CodeResendTextButton extends GetView<EmailVerificationController> {
  // final String email;
  final VoidCallback onTap;

  const CodeResendTextButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(EmailVerificationController());
    return InkWell(
      onTap: onTap,
      child: RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          style: FontUtils.TTFirsNeueTrial.copyWith(fontSize: 15, color: Colors.red),
          children: [
            TextSpan(text: AppString().enter_verification_error(context)),
            TextSpan(
              text: AppString().resend_code(context),
              style: FontUtils.TTFirsNeueTrial.copyWith(
                  fontSize: 15, color: AppColors.bgButtonColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
