import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/models/plan_model.dart';
import 'package:ride_mobile/app/modules/account/controllers/account_controller.dart';
import 'package:ride_mobile/app/utils/appString.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/dimensions.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';
import 'package:ride_mobile/app/utils/plan_utils.dart';

import '../../modules/account/views/plan_details.dart';
import '../../modules/payment/views/installation_options_view.dart';
import '../../utils/assets.dart';
import '../../utils/loading_indicators.dart';

class PlanActivationStatusCard extends GetView<AccountController> {
  final PlanModel plan;
  final String page;

  const PlanActivationStatusCard({Key? key, required this.plan, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AccountController());
    return Obx(
      () => Container(
        width: Dimens.width(100, context),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            color: AppColors.kBGPlanItem,
            shape: BoxShape.rectangle,
            image: const DecorationImage(image: AssetImage(Assets.bg_img_plna_item), fit: BoxFit.fill)),
        child: SizedBox(
            child: plan.isActive!.value && (plan.status == "expired" || plan.status == "refunded")
                ? ExpirePlanView(
                    plan: plan,
                  )
                : UpcomingPlanView(
                    page: page,
                    plan: plan,
                  )),
      ),
    );
  }
}

class ExpirePlanView extends GetView<AccountController> {
  final PlanModel plan;
  const ExpirePlanView({Key? key, required this.plan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AccountController());
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Row(
                  children: [
                    Text(
                      AppString().plan_status(context),
                      style: FontUtils.SF.copyWith(
                          fontSize: Dimens.currentSize(context, 14, 16, 18),
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      AppString().expired(context) + " ",
                      style: FontUtils.SF.copyWith(
                          fontSize: Dimens.currentSize(context, 14, 16, 18),
                          color: Colors.grey,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        plan.productCategory!,
                        style: FontUtils.SF.copyWith(
                            fontSize: Dimens.currentSize(context, 14, 16, 18),
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                        onTap: () => Get.to(PlanDetails(
                              flag: 2,
                              planModel: plan,
                            )),
                        child: SvgPicture.asset(Assets.plan_info, width: 16, height: 16)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${PlanUtils.totalData(plan)} for ${PlanUtils.getValidity(plan.validity!)}",
                      style: FontUtils.SF.copyWith(
                          fontSize: Dimens.currentSize(context, 12, 14, 16),
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      plan.name!.toUpperCase(),
                      style: FontUtils.SF.copyWith(
                          fontSize: Dimens.currentSize(context, 12, 14, 16),
                          color: AppColors.kPlanName,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              _actionButton(AppString().buy_again(context), Colors.white, AppColors.kButtonColor, false,
                  () => controller.getLatestplan(plan), context),
            ],
          ),
          // widget.plan.status == "refunded"
          //     ? Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           const SizedBox(
          //             height: 15,
          //           ),
          //           const Divider(
          //             height: 1,
          //             thickness: 0.5,
          //             color: Colors.grey,
          //           ),
          //           const SizedBox(
          //             height: 10,
          //           ),
          //           Container(
          //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          //             decoration: BoxDecoration(color: AppColors.kButtonColor, borderRadius: BorderRadius.circular(10)),
          //             child: Text(
          //               AppString().refund_successful(context),
          //               style: FontUtils.SF.copyWith(
          //                 fontSize: Dimens.currentSize(context, 12, 14, 16),
          //                 color: Colors.white,
          //               ),
          //             ),
          //           ),
          //         ],
          //       )
          //     : const SizedBox.shrink(),
          const SizedBox(
            height: 5,
          ),
          Divider(color: Colors.grey.withOpacity(0.5), thickness: 0.5),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "ICCID : ",
                style: FontUtils.SF.copyWith(
                    fontSize: Dimens.currentSize(context, 14, 16, 18),
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                plan.iccid!,
                style: FontUtils.SF.copyWith(
                    fontSize: Dimens.currentSize(context, 14, 16, 18),
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _actionButton(
      String label, Color fontColor, Color bgColor, bool hasBorder, VoidCallback onTap, BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 120,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          shape: BoxShape.rectangle,
        ),
        child: Center(
          child: Text(
            label,
            style: FontUtils.SF.copyWith(fontSize: Dimens.currentSize(context, 12, 14, 16), color: fontColor),
          ),
        ),
      ),
    );
  }
}

class UpcomingPlanView extends GetView<AccountController> {
  final PlanModel plan;
  final String page;

  const UpcomingPlanView({Key? key, required this.plan, required this.page}) : super(key: key);

  static Widget _actionButton(String label, Color fontColor, Color bgColor, bool hasBorder, bool isLoading,
      VoidCallback onTap, BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 40,
        width: 120,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          shape: BoxShape.rectangle,
        ),
        child: Center(
          child: isLoading
              ? LoadingIndicators.circularIndicator(22, 2.5, Colors.white)
              : Text(
                  label,
                  style: FontUtils.SF.copyWith(
                      fontSize: Dimens.currentSize(context, 12, 14, 16), color: fontColor, fontWeight: FontWeight.w500),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AccountController());
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Row(
                  children: [
                    Text(
                      AppString().plan_status(context),
                      style: FontUtils.SF.copyWith(
                          fontSize: Dimens.currentSize(context, 14, 16, 18),
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      AppString().inactive(context),
                      style: FontUtils.SF.copyWith(
                          fontSize: Dimens.currentSize(context, 14, 16, 18),
                          color: Colors.red,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        plan.productCategory!,
                        maxLines: 2,
                        style: FontUtils.SF.copyWith(
                            fontSize: Dimens.currentSize(context, 12, 14, 16),
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                        onTap: () => Get.to(PlanDetails(
                              flag: 1,
                              planModel: plan,
                            )),
                        child: SvgPicture.asset(Assets.plan_info, width: 16, height: 16))
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${PlanUtils.totalData(plan)} for ${PlanUtils.getValidity(plan.validity!)}",
                      style: FontUtils.SF.copyWith(
                          fontSize: Dimens.currentSize(context, 12, 14, 16),
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      plan.name!.toUpperCase(),
                      style: FontUtils.SF.copyWith(
                          fontSize: Dimens.currentSize(context, 12, 14, 16),
                          color: AppColors.kPlanName,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Obx(
                  () => _actionButton(AppString().activate_now(context), Colors.white, AppColors.kButtonColor, false,
                      plan.isActivating!.value, () => controller.openESIMErrorDialog(plan, page), context),
                ),
              ),
            ],
          ),
        ),
        // controller.openESIMErrorDialog(plan, page),
        const SizedBox(
          height: 15,
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Text(
            "* This plan will automatically activate on the ${PlanUtils.getPlanPurchaseDateInfo(plan.purchaseDate!)} after the expiry of your current active plan. You can manually activate this plan now.",
            style: FontUtils.SF.copyWith(
                fontSize: Dimens.currentSize(context, 12, 14, 16), color: Colors.white, fontWeight: FontWeight.w400),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              Divider(color: Colors.grey.withOpacity(0.5), thickness: 0.5),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "ICCID :",
                    style: FontUtils.SF.copyWith(
                        fontSize: Dimens.currentSize(context, 14, 16, 18),
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    plan.iccid!,
                    style: FontUtils.SF.copyWith(
                        fontSize: Dimens.currentSize(context, 14, 16, 18),
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        const Divider(
          height: 1,
          thickness: 0.5,
          color: Colors.grey,
        ),
        const SizedBox(
          height: 15,
        ),
        InkWell(
          onTap: () => Get.to(() => InstallationOptionsView(
                isFromHome: true,
                iccid: plan.iccid!,
              )),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Row(
              children: [
                Text(
                  AppString().installation_details(context).toUpperCase(),
                  style: FontUtils.SF.copyWith(
                      fontSize: Dimens.currentSize(context, 12, 14, 16),
                      color: AppColors.bgButtonColor,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  width: 10,
                ),
                SvgPicture.asset(Assets.arrow_outward, color: Colors.white, width: 10, height: 10),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
