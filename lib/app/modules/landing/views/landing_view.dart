import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/login/views/login_view.dart';
import 'package:ride_mobile/app/utils/appString.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/dimensions.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';
import 'package:ride_mobile/app/utils/keys.dart';
import 'package:ride_mobile/app/utils/padding_utils.dart';
import 'package:ride_mobile/app/widgets/auth_widgets/auth_action_button.dart';
import 'package:ride_mobile/app/widgets/auth_widgets/auth_background_image.dart';
import 'package:ride_mobile/app/widgets/auth_widgets/trailing_rich_text_widget.dart';

import '../../../services/mix_panel/events.dart';
import '../../../utils/assets.dart';
import '../../../widgets/logo_white.dart';
import '../../destination/views/destination_view.dart';
import '../controllers/landing_controller.dart';

class LandingView extends GetView<LandingController> {
  const LandingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LandingController());
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.mainBGColor,
        body: Stack(
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
                height: Dimens.height(100, context), width: Dimens.width(100, context), image: Assets.authBgImage),
            Container(
              margin: const EdgeInsets.only(bottom: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(
                            horizontal: AuthPaddingUtils.hPadding,
                            vertical: 0,
                          ) +
                          const EdgeInsets.only(top: 50),
                      child: const SizedBox.shrink()),
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 15, top: 25, right: 15),
                        padding: const EdgeInsets.all(30),
                        height: Dimens.currentSize(context, 280, 310, 375),
                        width: Dimens.width(100, context),
                        decoration:
                            BoxDecoration(color: AppColors.primaryBlackColor, borderRadius: BorderRadius.circular(60)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LogoWhite(height: Dimens.height(5, context), width: Dimens.width(35, context)),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  AppString().eSIMonthego(context),
                                  maxLines: 1,
                                  style: FontUtils.TTFirsNeueTrial.copyWith(
                                      fontSize: Dimens.currentSize(context, 28, 34, 38),
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  AppString().stayconnected(context),
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  style: FontUtils.TTFirsNeueTrial.copyWith(
                                      fontSize: Dimens.currentSize(context, 28, 34, 38),
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: AuthPaddingUtils.authButtonBottomMargin * 1,
                                ),
                                AuthActionButton(
                                    key: LandingPageKeys.shopForPlanButtonKey,
                                    label: AppString().browsePlans(context),
                                    bgColor: AppColors.bgButtonColor,
                                    hasBorder: false,
                                    fontColor: Colors.white,
                                    isLoading: false,
                                    hasArrow: true,
                                    onTap: () {
                                      MixPanelEvents.shopForPlanEvent();
                                      Get.to(() => const DestinationView(
                                            isFromHome: false,
                                            isFromDrawer: false,
                                          ));
                                    }),
                                const SizedBox(
                                  height: 10,
                                ),
                                TrailingRichTextWidget(
                                  key: LandingPageKeys.loginTextButtonKey,
                                  leftLabel: AppString().alreadyhaveanaccount(context),
                                  rightLabel: " " + AppString().sign_in(context) + ".",
                                  onTap: () => Get.to(() => LoginView()),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 40,
                        child: SvgPicture.asset(
                          Assets.start_bronge,
                          height: 45,
                          width: 45,
                          fit: BoxFit.cover,
                          key: CommonKeys.gbMobileLogoWhiteKey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
