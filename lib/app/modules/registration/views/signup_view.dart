import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/models/location_model.dart';
import 'package:ride_mobile/app/models/plan_model.dart';
import 'package:ride_mobile/app/utils/dimensions.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';
import 'package:ride_mobile/app/utils/keys.dart';
import 'package:ride_mobile/app/utils/status_bar_utils.dart';
import 'package:ride_mobile/app/widgets/registration_widgets/policy_and_terms_button.dart';
import 'package:ride_mobile/app/widgets/registration_widgets/registration_text_field.dart';

import '../../../services/user/current_user.dart';
import '../../../utils/appString.dart';
import '../../../utils/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/validation_utils.dart';
import '../../../widgets/auth_widgets/auth_background_image.dart';
import '../../../widgets/auth_widgets/auth_title_widget.dart';
import '../../../widgets/auth_widgets/blurred_container.dart';
import '../../../widgets/buttons/primary_action_button.dart';
import '../../../widgets/loader_view.dart';
import '../../../widgets/logo_white.dart';
import '../../../widgets/registration_widgets/mobile_number_text_field.dart';
import '../../account/views/privacy_policy_view.dart';
import '../controllers/registration_controller.dart';

class SignUpView extends StatefulWidget {
  final PlanModel? plan;
  final LocationModel? location;

  const SignUpView({
    Key? key,
    this.plan,
    this.location,
  }) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  RegistrationController controller = Get.put(RegistrationController());

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

  @override
  void dispose() {
    StatusBarUtils.resetStatusBar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
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
              Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.only(top: 120, left: 25),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LogoWhite(height: Dimens.height(5, context), width: Dimens.width(0, context)),
                              const SizedBox(height: 37),
                              Obx(
                                () => Text(
                                  controller.titleMessage.value,
                                  style: FontUtils.TTFirsNeueTrial.copyWith(
                                      fontSize: Dimens.currentSize(context, 20, 24, 24),
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: BlurredContainer(
                          height: Dimens.height(100, context),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      child: Form(
                                        key: formKey,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            AuthTitleWidget(title: AppString().sign_up(context)),
                                            Container(
                                                height: 60,
                                                padding: const EdgeInsets.only(top: 7),
                                                child: Text(
                                                  // "Create an account",
                                                  AppString().create_account(context),
                                                  style: FontUtils.SF.copyWith(
                                                      fontSize: Dimens.currentSize(context, 12, 14, 16),
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500),
                                                  textAlign: TextAlign.left,
                                                )),
                                            Text(
                                              AppString().first_name(context),
                                              style: FontUtils.SF.copyWith(
                                                  fontSize: Dimens.currentSize(context, 12, 14, 16),
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.left,
                                            ),
                                            _spacer(),
                                            RegistrationTextField(
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                                ],
                                                key: RegistrationPageKeys.firstNameKey,
                                                hintText: AppString().first_name(context),
                                                validation: (value) => ValidationUtils.requiredField(
                                                    value, AppString().first_name_is(context)),
                                                suffixIcon: null,
                                                showSuffix: false,
                                                showPassword: false,
                                                textCapitalization: TextCapitalization.words,
                                                controller: controller.firstNameController),
                                            _spacerMax(),
                                            Text(
                                              AppString().last_name(context),
                                              style: FontUtils.SF.copyWith(
                                                  fontSize: Dimens.currentSize(context, 12, 14, 16),
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.left,
                                            ),
                                            _spacer(),
                                            RegistrationTextField(
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                                ],
                                                key: RegistrationPageKeys.lastNameKey,
                                                hintText: AppString().last_name(context),
                                                validation: (value) => ValidationUtils.requiredField(
                                                    value, AppString().last_name_is(context)),
                                                suffixIcon: null,
                                                showSuffix: false,
                                                showPassword: false,
                                                textCapitalization: TextCapitalization.words,
                                                controller: controller.lastNameController),
                                            _spacerMax(),
                                            Text(
                                              AppString().email(context),
                                              style: FontUtils.SF.copyWith(
                                                  fontSize: Dimens.currentSize(context, 12, 14, 16),
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.left,
                                            ),
                                            _spacer(),
                                            RegistrationTextField(
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                                ],
                                                key: RegistrationPageKeys.emailAddressKey,
                                                hintText: AppString().email_address(context),
                                                validation: (value) => ValidationUtils.validateEmail(value),
                                                suffixIcon: null,
                                                showSuffix: false,
                                                showPassword: false,
                                                textCapitalization: TextCapitalization.none,
                                                controller: controller.emailController),
                                            _spacerMax(),
                                            Text(
                                              AppString().mobile_number(context),
                                              style: FontUtils.SF.copyWith(
                                                  fontSize: Dimens.currentSize(context, 12, 14, 16),
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.left,
                                            ),
                                            _spacer(),
                                            MobileNumberTextField(
                                              key: RegistrationPageKeys.mobileNumberKey,
                                              controller: controller.mobileNumberController,
                                              validation: (value) => ValidationUtils.isValidateMobile(value, ""),
                                            ),
                                            _spacerMax(),
                                            Text(
                                              AppString().create_password(context),
                                              style: FontUtils.SF.copyWith(
                                                  fontSize: Dimens.currentSize(context, 12, 14, 16),
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.left,
                                            ),
                                            _spacer(),
                                            Obx(
                                              () => RegistrationTextField(
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                                  ],
                                                  key: RegistrationPageKeys.passwordKey,
                                                  hintText: AppString().must_be_8_charachters(context),
                                                  suffixIcon: _suffixIconWidget(
                                                      controller.hidePassword,
                                                      () => controller.hideShowPassword(),
                                                      RegistrationPageKeys.showPasswordKey,
                                                      context),
                                                  showSuffix: true,
                                                  validation: (value) => ValidationUtils.validatePassword(value),
                                                  textCapitalization: TextCapitalization.none,
                                                  showPassword: controller.hidePassword.value,
                                                  controller: controller.passwordController),
                                            ),
                                            _spacerMax(),
                                            Text(
                                              AppString().re_enter_password(context),
                                              style: FontUtils.SF.copyWith(
                                                  fontSize: Dimens.currentSize(context, 12, 14, 16),
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.left,
                                            ),
                                            _spacer(),
                                            Obx(
                                              () => RegistrationTextField(
                                                  inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                                                  key: RegistrationPageKeys.repeatPasswordKey,
                                                  textCapitalization: TextCapitalization.none,
                                                  hintText: AppString().must_be_8_charachters(context),
                                                  suffixIcon: _suffixIconWidget(
                                                      controller.hideRepeatPassword,
                                                      () => controller.hideShowRepeatPassword(),
                                                      RegistrationPageKeys.showRepeatPasswordKey,
                                                      context),
                                                  showSuffix: true,
                                                  validation: (value) => ValidationUtils.validatePassword(value),
                                                  showPassword: controller.hideRepeatPassword.value,
                                                  controller: controller.repeatPasswordController),
                                            ),
                                            _spacerMax(),
                                            CurrentUser().configResponse.data!.rewardPointsEnabled!
                                                ? Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        AppString().referral_code(context),
                                                        style: FontUtils.SF.copyWith(
                                                            fontSize: Dimens.currentSize(context, 12, 14, 16),
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w500),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                      _spacer(),
                                                      RegistrationTextField(
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                                          ],
                                                          key: RegistrationPageKeys.referal_codeKey,
                                                          hintText: AppString().enter_referral_code(context),
                                                          suffixIcon: null,
                                                          showSuffix: false,
                                                          showPassword: false,
                                                          textCapitalization: TextCapitalization.none,
                                                          controller: controller.referalController),
                                                    ],
                                                  )
                                                : const SizedBox.shrink(),
                                            _spacer(),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Obx(
                                                  () => PolicyAndTermsButton(
                                                    radioButtonKey: RegistrationPageKeys.privacyPolicyRadioButtonKey,
                                                    textButtonKey: RegistrationPageKeys.privacyPolicyTextButtonKey,
                                                    label: AppString().i_agree_mybud(context),
                                                    title: AppString().privacy_policy(context),
                                                    isAccepted: controller.privacyPolicyAccepted.value,
                                                    onTap: () => Get.to(() => const PrivacyPolicyView(
                                                          flag: 0,
                                                        )),
                                                    onTapIcon: () => controller.acceptPrivacyPolicy(),
                                                  ),
                                                ),
                                                Obx(
                                                  () => PolicyAndTermsButton(
                                                    radioButtonKey: RegistrationPageKeys.termsRadioButtonKey,
                                                    textButtonKey: RegistrationPageKeys.termsTextButtonKey,
                                                    label: AppString().i_agree_mybud(context),
                                                    isAccepted: controller.termsAccepted.value,
                                                    title: AppString().terms_and_condition(context),
                                                    onTap: () => Get.to(() => const PrivacyPolicyView(
                                                          flag: 1,
                                                        )),
                                                    onTapIcon: () => controller.acceptTerms(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Obx(() => ActionButton(
                                                  label: AppString().sign_up(context),
                                                  onTap: () => {
                                                    if (formKey.currentState!.validate())
                                                      {
                                                        formKey.currentState!.save(),
                                                        controller.validateRegistration(widget.plan, widget.location)
                                                      }
                                                  },
                                                  isLoading: controller.isLoading.value,
                                                  key: RegistrationPageKeys.registerButtonKey,
                                                )),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            InkWell(
                                              onTap: () => Get.back(),
                                              child: RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  style: FontUtils.SF.copyWith(
                                                      fontSize: Dimens.currentSize(context, 12, 14, 16),
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500),
                                                  children: [
                                                    TextSpan(text: AppString().alreadyhaveanaccount(context) + " "),
                                                    TextSpan(
                                                        text: AppString().sign_in(context),
                                                        style: FontUtils.SF.copyWith(
                                                            fontSize: Dimens.currentSize(context, 12, 14, 16),
                                                            color: AppColors.navigation_icon_bg,
                                                            fontWeight: FontWeight.w500)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              Obx(() => controller.isLoading.value ? const LoaderView() : const SizedBox.shrink()),
            ],
          ),
        ));
  }
}
