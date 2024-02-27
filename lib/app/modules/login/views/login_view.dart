import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/models/plan_model.dart';
import 'package:ride_mobile/app/modules/forgot_password/views/forgot_password_view.dart';
import 'package:ride_mobile/app/modules/registration/views/signup_view.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';
import 'package:ride_mobile/app/utils/keys.dart';
import 'package:ride_mobile/app/utils/validation_utils.dart';
import 'package:ride_mobile/app/widgets/auth_widgets/auth_title_widget.dart';
import 'package:ride_mobile/app/widgets/auth_widgets/blurred_container.dart';
import 'package:ride_mobile/app/widgets/auth_widgets/custom_prefix_icon.dart';
import 'package:ride_mobile/app/widgets/auth_widgets/login_textfield.dart';

import '../../../models/location_model.dart';
import '../../../utils/appString.dart';
import '../../../utils/assets.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/auth_widgets/auth_action_button.dart';
import '../../../widgets/auth_widgets/auth_background_image.dart';
import '../../../widgets/loader_view.dart';
import '../../../widgets/logo_white.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatefulWidget {
  final PlanModel? planModel;
  final LocationModel? location;

  LoginView({Key? key, this.planModel, this.location}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var formKey = GlobalKey<FormState>();

  LoginController controller = Get.put(LoginController());

  Widget _suffixIconWidget(IconData icon, BuildContext context) {
    return Container(
        key: const Key("show_password"),
        child: IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            constraints: const BoxConstraints(),
            onPressed: () => controller.hideShowPassword(),
            icon: Obx(() => Icon(
                  !controller.hidePassword.value ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill,
                  color: AppColors.kIconColor,
                  size: Dimens.currentSize(context, 23, 25, 25),
                ))));
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
                              const SizedBox(height: 35),
                              Obx(
                                () => Text(
                                  controller.titleMessage.value,
                                  style: FontUtils.TTFirsNeueTrial.copyWith(
                                      fontSize: Dimens.currentSize(context, 20, 24, 24),
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
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
                                        padding: const EdgeInsets.symmetric(horizontal: 25),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            AuthTitleWidget(title: AppString().sign_in(context)),
                                            Obx(() => controller.errorMessage.value.isEmpty
                                                ? Container(
                                                    padding: const EdgeInsets.only(top: 7),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          AppString().signin_to_your_account(context),
                                                          style: FontUtils.TTFirsNeueTrial.copyWith(
                                                              fontSize: 15,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500),
                                                          textAlign: TextAlign.left,
                                                        ),
                                                      ],
                                                    ))
                                                : Container(
                                                    padding: const EdgeInsets.only(top: 7),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          controller.errorMessage.value,
                                                          style: FontUtils.TTFirsNeueTrial.copyWith(
                                                              fontSize: 15,
                                                              color: Colors.red,
                                                              fontWeight: FontWeight.w500),
                                                          textAlign: TextAlign.left,
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        controller.isPending.value
                                                            ? const VerifyEmailButton()
                                                            : const SizedBox.shrink()
                                                      ],
                                                    ))),
                                          ],
                                        )),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 25),
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppString().email(context),
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
                                            key: LoginPageKeys.emailFieldKey,
                                            hintText: "name@company.com",
                                            prefixIcon: const CustomPrefixIcon(icon: Icons.email_outlined),
                                            suffixIcon: null,
                                            showSuffix: false,
                                            showPassword: false,
                                            validation: (value) => ValidationUtils.validateEmail(value),
                                            controller: controller.emailController),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          AppString().password(context),
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
                                            key: LoginPageKeys.passwordFieldKey,
                                            hintText: AppString().must_be_8_charachters(context),
                                            prefixIcon: const CustomPrefixIcon(icon: Icons.lock_open),
                                            suffixIcon: _suffixIconWidget(Icons.remove_red_eye_outlined, context),
                                            showSuffix: false,
                                            showPassword: controller.hidePassword.value,
                                            validation: (value) => ValidationUtils.validatePassword(value),
                                            controller: controller.passwordController)),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        InkWell(
                                            onTap: () => Get.to(() => const ForgotPasswordView()),
                                            child: Obx(() => Text(AppString().forgot_password(context),
                                                style: controller.errorMessage == ""
                                                    ? FontUtils.SF.copyWith(
                                                        fontSize: Dimens.currentSize(context, 12, 14, 16),
                                                        color: AppColors.bgButtonColor,
                                                        fontWeight: FontWeight.w500)
                                                    : FontUtils.SF.copyWith(
                                                        fontSize: Dimens.currentSize(context, 12, 14, 16),
                                                        color: Colors.red,
                                                        fontWeight: FontWeight.w500,
                                                        decoration: TextDecoration.underline,
                                                      )))),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 25),
                                  child: Obx(
                                    () => AuthActionButton(
                                        key: LoginPageKeys.loginButtonKey,
                                        label: AppString().sign_in(context),
                                        bgColor: AppColors.bgButtonColor,
                                        hasBorder: false,
                                        hasArrow: true,
                                        fontColor: Colors.white,
                                        isLoading: controller.isLoading.value,
                                        onTap: () {
                                          if (formKey.currentState!.validate()) {
                                            formKey.currentState!.save();
                                            controller.login(context, widget.planModel, widget.location);
                                          }
                                        }),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 25),
                                  child: InkWell(
                                    onTap: () => {controller.errorMessage.value = "", Get.to(() => const SignUpView())},
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        style: FontUtils.SF.copyWith(
                                            fontSize: Dimens.currentSize(context, 12, 14, 16), color: Colors.white),
                                        children: [
                                          TextSpan(text: AppString().dont_have_account(context) + " "),
                                          TextSpan(
                                              text: AppString().sign_up(context),
                                              style: FontUtils.SF.copyWith(
                                                  fontSize: Dimens.currentSize(context, 12, 14, 16),
                                                  color: AppColors.navigation_icon_bg,
                                                  fontWeight: FontWeight.w700)),
                                        ],
                                      ),
                                    ),
                                  ),
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

class VerifyEmailButton extends GetView<LoginController> {
  const VerifyEmailButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
    return AuthActionButton(
        key: LoginPageKeys.loginButtonKey,
        label: AppString().verify_your_email(context),
        bgColor: AppColors.bgButtonColor,
        hasBorder: false,
        hasArrow: true,
        fontColor: Colors.white,
        isLoading: controller.isLoading.value,
        onTap: () {
          controller.sendVerificationEmail();
        });
  }
}
