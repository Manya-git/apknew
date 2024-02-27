import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:ride_mobile/app/modules/account/controllers/account_controller.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';

import '../../utils/appString.dart';
import '../../utils/assets.dart';
import '../../utils/dimensions.dart';

class NoAnyPlanPuchanged extends GetView<AccountController> {
  const NoAnyPlanPuchanged({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AccountController());
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 15),
      decoration: BoxDecoration(
        color: AppColors.kRectangleColor,
        borderRadius: BorderRadius.circular(35),
      ),
      child: Column(
        children: [
          _planDetails(context),
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
                            fontWeight: FontWeight.w500),
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
                        fontSize: Dimens.currentSize(context, 10, 12, 14),
                        height: 1.6,
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
                            style: FontUtils.SF.copyWith(
                              fontSize: Dimens.currentSize(context, 8, 10, 12),
                              color: FontColors.white71,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    ],
  );
}
