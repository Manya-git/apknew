import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/utils/appString.dart';

import '../../../utils/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/font_utils.dart';
import '../../../utils/keys.dart';
import '../../../utils/string_utils.dart';
import '../../../widgets/auth_widgets/blurred_container.dart';
import '../../../widgets/buttons/primary_action_button.dart';
import '../../../widgets/registration_widgets/policy_and_terms_button.dart';
import '../../registration/controllers/registration_controller.dart';

class PrivacyPolicyView extends StatefulWidget {
  final int? flag;
  const PrivacyPolicyView({Key? key, this.flag}) : super(key: key);

  @override
  _PrivacyPolicyViewState createState() => _PrivacyPolicyViewState();
}

class _PrivacyPolicyViewState extends State<PrivacyPolicyView> {
  final RegistrationController _registrationController = Get.put(RegistrationController());

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
              const SizedBox(
                height: 60,
              ),
              Flexible(
                child: BlurredContainer(
                  height: Dimens.height(100, context),
                  child: Container(
                    height: Dimens.height(100, context),
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                widget.flag == 0
                                    ? AppString().privacy_policy(context)
                                    : AppString().terms_and_condition(context),
                                textAlign: TextAlign.left,
                                style: FontUtils.TTFirsNeueTrial.copyWith(
                                    fontSize: Dimens.currentSize(context, 18, 20, 22),
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                  size: 26,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: termsAndConditionView(),
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
      bottomNavigationBar: widget.flag == 1
          ? Container(
              height: 150,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  Obx(
                    () => PolicyAndTermsButton(
                      radioButtonKey: RegistrationPageKeys.termsRadioButtonKey,
                      textButtonKey: RegistrationPageKeys.termsTextButtonKey,
                      label: AppString().i_agree_mybud(context),
                      isAccepted: _registrationController.termsAccepted.value,
                      title: AppString().terms_and_condition(context),
                      onTap: () => {},
                      onTapIcon: () => _registrationController.acceptTerms(),
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  ActionButton(
                    label: AppString().submit(context),
                    onTap: () => Get.back(),
                    isLoading: false,
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _headLineText(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        text,
        style: FontUtils.SF.copyWith(
            color: Colors.white70, fontSize: Dimens.currentSize(context, 14, 16, 18), fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _lineText(String text) {
    return Text(
      text,
      style: FontUtils.SF.copyWith(
          color: Colors.white54, fontSize: Dimens.currentSize(context, 12, 14, 16), fontWeight: FontWeight.w500),
    );
  }

  Widget termsAndConditionView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headLineText(StringUtils.TC1),
        _lineText(StringUtils.TC11),
        _headLineText(StringUtils.TC2),
        _lineText(StringUtils.TC21),
        _lineText(StringUtils.TC22),
        _lineText(StringUtils.TC23),
        _lineText(StringUtils.TC24),
        _lineText(StringUtils.TC25),
        _headLineText(StringUtils.TC3),
        _lineText(StringUtils.TC31),
        _headLineText(StringUtils.TC4),
        _lineText(StringUtils.TC41),
        _lineText(StringUtils.TC42),
        _headLineText(StringUtils.TC5),
        _lineText(StringUtils.TC51),
        _headLineText(StringUtils.TC6),
        _lineText(StringUtils.TC61),
        _headLineText(StringUtils.TC7),
        _lineText(StringUtils.TC71),
      ],
    );
  }
}
