import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/account/controllers/account_controller.dart';
import 'package:ride_mobile/app/modules/currency/views/edit_currency_view.dart';
import 'package:ride_mobile/app/modules/profile/views/change_password_view.dart';
import 'package:ride_mobile/app/services/user/current_user.dart';
import 'package:ride_mobile/app/widgets/buttons/primary_action_button.dart';

import '../../../utils/appString.dart';
import '../../../utils/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/font_utils.dart';
import '../../../utils/keys.dart';
import '../../../utils/padding_utils.dart';
import '../../../utils/string_utils.dart';
import '../../../utils/validation_utils.dart';
import '../../../widgets/auth_widgets/custom_prefix_icon.dart';
import '../../../widgets/buttons/back_button.dart';
import '../../../widgets/loader_view.dart';
import '../../../widgets/registration_widgets/mobile_number_text_field.dart';
import '../../../widgets/registration_widgets/registration_text_field.dart';
import '../controllers/profile_controller.dart';

class EditProfileView extends StatefulWidget {
  final String? currencyName;
  final String? currencySymbol;

  const EditProfileView({Key? key, this.currencyName, this.currencySymbol}) : super(key: key);

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  ProfileController controller = Get.put(ProfileController());

  @override
  void initState() {
    controller.setData();
    controller.setCountryCode();
    super.initState();
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

  Widget titleView(String title) {
    return Text(
      title,
      style: FontUtils.SF.copyWith(
          fontSize: Dimens.currentSize(context, 12, 14, 16), color: Colors.white, fontWeight: FontWeight.w500),
      textAlign: TextAlign.left,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
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
                        AppString().account_settings(context),
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
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizingUtils.kCommonSpacing, vertical: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleView(AppString().full_name(context)),
                        _spacer(),
                        RegistrationTextField(
                            inputFormatters: const [],
                            hintText: AppString().full_name(context),
                            suffixIcon: null,
                            showSuffix: false,
                            showPassword: false,
                            textCapitalization: TextCapitalization.words,
                            controller: controller.firstNameController),
                        _spacerMax(),
                        titleView(AppString().email_id(context)),
                        _spacer(),
                        RegistrationTextField(
                            inputFormatters: const [],
                            hintText: AppString().email_id(context),
                            // prefixIcon: const CustomPrefixIcon(icon: CupertinoIcons.person),
                            suffixIcon: null,
                            readOnly: true,
                            showSuffix: false,
                            showPassword: false,
                            textCapitalization: TextCapitalization.words,
                            controller: controller.emailController),
                        _spacerMax(),
                        titleView(AppString().mobile_number(context)),
                        _spacer(),
                        MobileNumberTextField(
                          controller: controller.mobileNumberController,
                          validation: (value) => ValidationUtils.isValidateMobile(value, ""),
                        ),
                        CurrentUser().configResponse.data!.currencyConversionMasterEnabled!
                            ? Column(
                                children: [
                                  _spacerMax(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      titleView(AppString().currency(context)),
                                      InkWell(
                                          onTap: () {
                                            Get.to(() => EditCurrrencyView(
                                                  currencyName: widget.currencyName!,
                                                  currencySymbol: widget.currencySymbol!,
                                                ));
                                          },
                                          child: Text(
                                            AppString().currency_change(context),
                                            style: FontUtils.SF.copyWith(
                                                fontSize: Dimens.currentSize(context, 12, 14, 16),
                                                color: AppColors.bgButtonColor,
                                                fontWeight: FontWeight.w500,
                                                decoration: TextDecoration.underline),
                                            textAlign: TextAlign.left,
                                          )),
                                    ],
                                  ),
                                  _spacer(),
                                  RegistrationTextField(
                                      inputFormatters: const [],
                                      hintText: StringUtils.getCurrencySymbol(widget.currencySymbol!) +
                                          " " +
                                          widget.currencyName!,
                                      suffixIcon: null,
                                      showSuffix: false,
                                      readOnly: true,
                                      textCapitalization: TextCapitalization.none,
                                      showPassword: false,
                                      controller: controller.currencyController),
                                ],
                              )
                            : const SizedBox.shrink(),
                        _spacerMax(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            titleView(AppString().password(context)),
                            InkWell(
                                onTap: () => Get.to(() => ChangePasswordView()),
                                child: Text(
                                  AppString().password_change(context),
                                  style: FontUtils.SF.copyWith(
                                      fontSize: Dimens.currentSize(context, 12, 14, 16),
                                      color: AppColors.bgButtonColor,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline),
                                  textAlign: TextAlign.left,
                                )),
                          ],
                        ),
                        _spacer(),
                        RegistrationTextField(
                            inputFormatters: [],
                            key: RegistrationPageKeys.passwordKey,
                            hintText: AppString().password(context),
                            suffixIcon: null,
                            showSuffix: true,
                            readOnly: true,
                            textCapitalization: TextCapitalization.none,
                            showPassword: controller.hidePassword.value,
                            controller: controller.passwordController),
                        _spacerMax(),
                        const SizedBox(
                          height: 40,
                        ),
                        Container(
                          child: Column(
                            children: [
                              Obx(
                                () => PrimaryActionButton(
                                    label: AppString().save_changes(context),
                                    onTap: () => !controller.isUpdating.value ? controller.validateUpdate() : null,
                                    isLoading: controller.isUpdating.value),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              PrimaryActionButton(
                                  label: AppString().cancel(context),
                                  onTap: () => Get.back(),
                                  isDisable: true,
                                  isLoading: controller.isUpdating.value)
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
          Obx(() => controller.isLoading.value ? const LoaderView() : const SizedBox.shrink()),
          // const ArrowedBackButton(),
        ],
      ),
    );
  }
}

class EmailStaticItem extends StatelessWidget {
  const EmailStaticItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        shape: BoxShape.rectangle,
        color: Colors.grey.shade300,
        border: Border.all(
          color: AppColors.kOrangeColor,
          width: 0.75,
        ),
      ),
      child: Row(
        children: [
          const CustomPrefixIcon(icon: CupertinoIcons.mail),
          Container(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              CurrentUser().currentUser.email!,
              style: FontUtils.SF.copyWith(
                  fontSize: Dimens.currentSize(context, 12, 14, 16),
                  color: FontColors.kBlackColor,
                  fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}

class PasswordStaticItem extends StatelessWidget {
  const PasswordStaticItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimens.currentSize(context, 50, 60, 70),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        shape: BoxShape.rectangle,
        border: Border.all(
          color: AppColors.kBorderColor,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                child: Text(
                  "**********",
                  style: FontUtils.SF.copyWith(
                      fontSize: Dimens.currentSize(context, 12, 14, 16),
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          TextButton(
              onPressed: () => Get.to(() => ChangePasswordView()),
              child: Container(
                height: 60,
                padding: const EdgeInsets.only(top: 5, right: 10),
                child: Center(
                  child: Text(
                    AppString().change(context),
                    style: FontUtils.SF.copyWith(color: AppColors.kOrangeColor),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

class CardStaticItem extends GetView<AccountController> {
  const CardStaticItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AccountController());
    return Container(
      constraints: const BoxConstraints(minHeight: 50, maxHeight: 50),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        shape: BoxShape.rectangle,
        border: Border.all(
          color: AppColors.kBorderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CustomPrefixIcon(icon: CupertinoIcons.creditcard),
              Container(
                padding: const EdgeInsets.only(left: 15),
                child: Obx(
                  () => Text(
                    controller.defaultCard.value.isEmpty ? "None" : controller.defaultCard.value,
                    style: FontUtils.SF
                        .copyWith(fontSize: controller.defaultCard.value.isEmpty ? 16 : 16, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
