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
import '../../../widgets/auth_widgets/blurred_container.dart';
import '../../../widgets/loader_view.dart';
import '../controllers/support_controller.dart';

class SupportView extends StatefulWidget {
  final bool isFromHome;

  SupportView({Key? key, required this.isFromHome}) : super(key: key);

  @override
  State<SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
  SupportController controller = SupportController();

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
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          AppString().contactus(context),
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
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    AppString().got_sometinng_in_mind(context),
                    textAlign: TextAlign.center,
                    style: FontUtils.TTFirsNeueTrial.copyWith(
                        fontSize: Dimens.currentSize(context, 18, 20, 22),
                        color: Colors.white,
                        height: 1.5,
                        fontWeight: FontWeight.w600),
                  ),
                ),
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
                              AppString().name(context),
                              style: FontUtils.SF.copyWith(
                                  fontSize: Dimens.currentSize(context, 12, 14, 16),
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            RegistrationTextField(
                                hintText: AppString().name(context),
                                suffixIcon: null,
                                showSuffix: false,
                                showPassword: false,
                                controller: controller.nameController,
                                textCapitalization: TextCapitalization.words,
                                inputFormatters: const []),
                            // _spacer(),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              AppString().email(context),
                              style: FontUtils.SF.copyWith(
                                  fontSize: Dimens.currentSize(context, 12, 14, 16),
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            RegistrationTextField(
                                hintText: AppString().email(context),
                                suffixIcon: null,
                                showSuffix: false,
                                showPassword: false,
                                controller: controller.emailController,
                                textCapitalization: TextCapitalization.none,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                ]),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppString().message(context),
                                  style: FontUtils.SF.copyWith(
                                      fontSize: Dimens.currentSize(context, 12, 14, 16),
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(height: 5),
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
                                    textInputAction: TextInputAction.done,
                                    // cursorHeight: 16,
                                    maxLines: null,
                                    obscureText: false,
                                    cursorColor: FontColors.white71,
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
                                      hintText: AppString().contact_us_msg_details(context),
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
                            const SizedBox(
                              height: 20,
                            ),
                            Obx(
                              () => PrimaryActionButton(
                                  label: AppString().send(context),
                                  onTap: () => controller.sendContactUsRequest(),
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
