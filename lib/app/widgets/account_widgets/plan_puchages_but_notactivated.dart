import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../modules/account/controllers/account_controller.dart';
import '../../modules/payment/views/installation_options_view.dart';
import '../../utils/appString.dart';
import '../../utils/assets.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/font_utils.dart';
import '../../utils/keys.dart';
import '../../utils/snackbar_utils.dart';
import '../auth_widgets/auth_action_button.dart';
import 'account_action_card.dart';

class ActivatePlanAfterIntallation extends GetView<AccountController> {
  const ActivatePlanAfterIntallation({Key? key}) : super(key: key);

  Widget _spacer() {
    return const SizedBox(height: 20);
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AccountController());
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 25, top: 5),
      decoration: BoxDecoration(
        color: AppColors.kRectangleColor,
        borderRadius: BorderRadius.circular(35),
      ),
      child: Column(
        children: [
          _planDetails(context),
          _spacer(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 0),
            child: AccountActionCard(
                title: AppString().installation_details(context),
                icon: "",
                onPressed: () => controller.currentPlans[0].iccid != null || controller.currentPlans[0].iccid != ""
                    ? Get.to(() => InstallationOptionsView(isFromHome: true, iccid: controller.currentPlans[0].iccid!))
                    : {
                        SnackBarUtils.showSnackBar("Can't found iccid, please connect to admin", 2),
                      }),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 0),
            child: AuthActionButton(
                key: LandingPageKeys.shopForPlanButtonKey,
                label: AppString().activate_now(context),
                bgColor: AppColors.bgButtonColor,
                hasBorder: false,
                fontColor: Colors.white,
                isLoading: false,
                hasArrow: true,
                onTap: () {
                  controller.openESIMErrorDialog(controller.currentPlans[0], "active");
                }),
          ),
        ],
      ),
    );
  }
}

Widget _planDetails(BuildContext context) {
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppString().plan_status(context),
                        style: FontUtils.SF.copyWith(
                            fontSize: Dimens.currentSize(context, 14, 16, 18),
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        AppString().not_active(context),
                        style: FontUtils.SF.copyWith(
                            fontSize: Dimens.currentSize(context, 14, 16, 18),
                            color: Colors.red,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppString().not_have_active_plan(context),
                    style: FontUtils.SF.copyWith(
                        fontSize: Dimens.currentSize(context, 12, 14, 16),
                        height: 1.5,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              )),
          Expanded(
              flex: 1,
              child: Stack(
                children: [
                  SizedBox(
                    height: 110,
                    width: 110,
                    child: CircularPercentIndicator(
                      radius: 50.0,
                      lineWidth: 8.0,
                      backgroundWidth: 3,
                      animation: true,
                      animationDuration: 0,
                      percent: 0.0,
                      animateFromLastPercent: false,
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: AppColors.kProgressInActiveStrock,
                      linearGradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.lnProgress2, AppColors.lnProgress1],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(Assets.no_plans, height: 24, width: 24, fit: BoxFit.contain),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            AppString().no_plans(context),
                            style: FontUtils.SF.copyWith(fontSize: 12, color: FontColors.kDataTxtColor, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    ],
  );
}
