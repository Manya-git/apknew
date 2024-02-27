import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/utils/appString.dart';
import 'package:ride_mobile/app/utils/assets.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/dimensions.dart';
import 'package:ride_mobile/app/widgets/buttons/primary_action_button.dart';
import 'package:ride_mobile/app/widgets/registration_widgets/registration_text_field.dart';

import '../../../utils/font_utils.dart';
import '../../../utils/keys.dart';
import '../../../utils/padding_utils.dart';
import '../../../utils/validation_utils.dart';
import '../../../widgets/auth_widgets/blurred_container.dart';
import '../../../widgets/buttons/back_button.dart';
import '../../../widgets/loader_view.dart';
import '../../../widgets/registration_widgets/mobile_number_text_field.dart';
import '../controllers/support_controller.dart';

class SupportViewNew extends StatelessWidget {
  final bool isFromHome;

  SupportViewNew({Key? key, required this.isFromHome}) : super(key: key);

  SupportController controller = new SupportController();

  Widget _spacer() {
    return const SizedBox(height: 5);
  }

  @override
  Widget build(BuildContext context) {
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
                          AppString().request_support(context),
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
                const SizedBox(height: 10),
                Flexible(
                  child: BlurredContainer(
                    height: Dimens.height(100, context),
                    child: Container(
                      height: Dimens.height(100, context),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppString().enter_your_full_name(context),
                              style: FontUtils.SF.copyWith(
                                  fontSize: Dimens.currentSize(context, 12, 14, 16),
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            RegistrationTextField(
                                hintText: AppString().full_name(context),
                                suffixIcon: null,
                                showSuffix: false,
                                showPassword: false,
                                controller: controller.nameController,
                                textCapitalization: TextCapitalization.words,
                                inputFormatters: const []),
                            _spacer(),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              AppString().enter_your_email_address(context),
                              style: FontUtils.SF.copyWith(
                                  fontSize: Dimens.currentSize(context, 12, 14, 16),
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            RegistrationTextField(
                                hintText: AppString().email_address(context),
                                suffixIcon: null,
                                showSuffix: false,
                                showPassword: false,
                                controller: controller.emailController,
                                textCapitalization: TextCapitalization.none,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                ]),
                            _spacer(),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              // "Phone number needing support",
                              AppString().phone_no_need_supports(context),
                              style: FontUtils.SF.copyWith(
                                  fontSize: Dimens.currentSize(context, 12, 14, 16),
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            MobileNumberTextField(
                              key: RegistrationPageKeys.mobileNumberKey,
                              controller: controller.numberController,
                              validation: (value) => ValidationUtils.isValidateMobile(value, ""),
                            ),
                            _spacer(),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              AppString().device_information(context),
                              style: FontUtils.SF.copyWith(
                                  fontSize: Dimens.currentSize(context, 12, 14, 16),
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            RegistrationTextField(
                                hintText: AppString().make_device(context),
                                suffixIcon: null,
                                showSuffix: false,
                                showPassword: false,
                                controller: controller.deviceinfoController,
                                textCapitalization: TextCapitalization.none,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                ]),
                            _spacer(),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppString().additional_information(context),
                                  style: FontUtils.SF.copyWith(
                                      fontSize: Dimens.currentSize(context, 12, 14, 16),
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(height: 7),
                                Container(
                                  alignment: Alignment.topLeft,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: AppColors.kBorderColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: TextFormField(
                                    textAlignVertical: TextAlignVertical.top,
                                    textAlign: TextAlign.justify,
                                    textCapitalization: TextCapitalization.sentences,
                                    cursorHeight: 16,
                                    maxLines: null,
                                    obscureText: false,
                                    cursorColor: AppColors.kOrangeColor,
                                    controller: controller.messageController,
                                    style: FontUtils.SF.copyWith(
                                        fontSize: Dimens.currentSize(context, 12, 14, 16),
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                      suffixIcon: null,
                                      prefixIcon: null,
                                      constraints: const BoxConstraints(),
                                      contentPadding: const EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 0),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: AppString().additional_information_details(context),
                                      hintMaxLines: 5,
                                      hintStyle: FontUtils.SF.copyWith(
                                          fontSize: Dimens.currentSize(context, 12, 14, 16),
                                          color: AppColors.kHintColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            _spacer(),
                            const SizedBox(
                              height: 25,
                            ),
                            Obx(
                              () => PrimaryActionButton(
                                  label: AppString().request_support(context),
                                  onTap: () => controller.sendSupportRequest(),
                                  isLoading: controller.isLoading.value),
                            ),
                            const SizedBox(
                              height: AppSizingUtils.kCommonSpacing,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Obx(() => controller.isLoading.value ? const LoaderView() : const SizedBox.shrink()),
          ],
        ));
  }
}
