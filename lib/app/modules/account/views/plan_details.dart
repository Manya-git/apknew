import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:ride_mobile/app/models/plan_model.dart';
import 'package:ride_mobile/app/utils/string_utils.dart';

import '../../../utils/appString.dart';
import '../../../utils/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/font_utils.dart';
import '../../../utils/keys.dart';
import '../../../utils/loading_indicators.dart';
import '../../../widgets/auth_widgets/blurred_container.dart';
import '../../../widgets/buttons/back_button.dart';
import '../../payment/views/installation_options_view.dart';
import '../controllers/account_controller.dart';

class PlanDetails extends StatefulWidget {
  final int? flag;
  final PlanModel? planModel;

  const PlanDetails({Key? key, this.flag, this.planModel}) : super(key: key);

  @override
  State<PlanDetails> createState() => _PlanDetailsState();
}

class _PlanDetailsState extends State<PlanDetails> {
  AccountController controller = Get.put(AccountController());

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
                          AppString().plan_details(context),
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
                const SizedBox(height: 30),
                Expanded(
                  child: BlurredContainer(
                      height: Dimens.height(100, context),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            widget.flag == 0
                                ? activePlanView(widget.planModel!)
                                : widget.flag == 1
                                    ? upcomingPlanView(widget.planModel!)
                                    : expiredPlanView(widget.planModel!)
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ],
        ));
  }

  Widget activePlanView(PlanModel planModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                planModel.name!.toUpperCase() + " :",
                style: FontUtils.SF.copyWith(
                    fontSize: Dimens.currentSize(context, 12, 14, 16),
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(
                planModel.data! +
                    " " +
                    AppString().fordays(context) +
                    " " +
                    planModel.validity!.toString() +
                    " " +
                    AppString().days(context),
                style: FontUtils.SF.copyWith(
                    fontSize: Dimens.currentSize(context, 12, 14, 16),
                    color: AppColors.kIconColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppString().plan_status(context),
              style: FontUtils.SF.copyWith(
                  fontSize: Dimens.currentSize(context, 14, 16, 18), color: Colors.white, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              AppString().active(context),
              style: FontUtils.SF.copyWith(
                  fontSize: Dimens.currentSize(context, 14, 16, 18), color: Colors.green, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Text(AppString().data_balance(context),
            style: FontUtils.SF.copyWith(
                fontSize: Dimens.currentSize(context, 16, 18, 20), color: Colors.white, fontWeight: FontWeight.w500)),
        const SizedBox(
          height: 15,
        ),
        Container(
          alignment: Alignment.center,
          child: Obx(
            () => LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 40,
              lineHeight: 15.0,
              animationDuration: 1000,
              percent: controller.dataUsagePercent.value,
              animateFromLastPercent: true,
              center: Text((controller.dataUsagePercent.value * 100).toString() + "%",
                  style: FontUtils.SF.copyWith(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w700)),
              barRadius: const Radius.circular(10),
              linearGradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[AppColors.lnProgress2, AppColors.lnProgress1],
              ),
              backgroundColor: AppColors.primaryBlackColor,
              animation: true,
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Obx(() => Center(
            child: _textCard(
                "${controller.usedData.value} / ${controller.totalData.value} " + AppString().used(context),
                AppColors.kSubText))),
        const SizedBox(
          height: 15,
        ),
        Text(
          AppString().validity(context),
          style: FontUtils.SF.copyWith(
              fontSize: Dimens.currentSize(context, 14, 14, 18), color: Colors.white, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 3),
        Text(
          controller.dateFormate(planModel.expiredDate!),
          style: FontUtils.SF.copyWith(
              fontSize: Dimens.currentSize(context, 14, 14, 18),
              color: AppColors.kIconColor,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 15,
        ),
        Divider(color: Colors.grey.withOpacity(0.5), thickness: 0.5),
        planDetailsView(planModel),
      ],
    );
  }

  Widget _textCard(String label, Color color) {
    return Text(
      label,
      textAlign: TextAlign.center,
      style: FontUtils.SF
          .copyWith(fontSize: Dimens.currentSize(context, 10, 12, 14), color: color, fontWeight: FontWeight.w500),
    );
  }

  Widget upcomingPlanView(PlanModel planModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                planModel.name!.toUpperCase(),
                style: FontUtils.SF.copyWith(
                    fontSize: Dimens.currentSize(context, 12, 14, 16),
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(
                planModel.data! +
                    " " +
                    AppString().fordays(context) +
                    " " +
                    planModel.validity!.toString() +
                    " " +
                    AppString().days(context),
                style: FontUtils.SF.copyWith(
                    fontSize: Dimens.currentSize(context, 12, 14, 16),
                    color: AppColors.kIconColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  AppString().plan_status(context),
                  style: FontUtils.SF.copyWith(
                      fontSize: Dimens.currentSize(context, 14, 16, 18),
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  " " + AppString().inactive(context),
                  style: FontUtils.SF.copyWith(
                      fontSize: Dimens.currentSize(context, 14, 16, 18),
                      color: Colors.red,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Obx(
              () => _actionButton(AppString().activate_now(context), Colors.white, AppColors.kButtonColor, false,
                  planModel.isActivating!.value, () => controller.openESIMErrorDialog(planModel, "upcoming"), context),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Divider(color: Colors.grey.withOpacity(0.5), thickness: 0.5),
        InkWell(
          onTap: () => Get.to(() => InstallationOptionsView(
                isFromHome: true,
                iccid: planModel.iccid!,
              )),
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
        Divider(color: Colors.grey.withOpacity(0.5), thickness: 0.5),
        planDetailsView(planModel),
      ],
    );
  }

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

  Widget expiredPlanView(PlanModel planModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                planModel.name!.toUpperCase(),
                style: FontUtils.SF.copyWith(
                    fontSize: Dimens.currentSize(context, 12, 14, 16),
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(
                planModel.data! +
                    " " +
                    AppString().fordays(context) +
                    " " +
                    planModel.validity!.toString() +
                    " " +
                    AppString().days(context),
                style: FontUtils.SF.copyWith(
                    fontSize: Dimens.currentSize(context, 12, 14, 16),
                    color: AppColors.kIconColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppString().plan_status(context),
              style: FontUtils.SF.copyWith(
                  fontSize: Dimens.currentSize(context, 14, 16, 18), color: Colors.white, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              AppString().expired(context),
              style: FontUtils.SF.copyWith(
                  fontSize: Dimens.currentSize(context, 14, 16, 18), color: Colors.grey, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Text(AppString().data_balance(context),
            style: FontUtils.SF.copyWith(
                fontSize: Dimens.currentSize(context, 16, 18, 20), color: Colors.white, fontWeight: FontWeight.w500)),
        const SizedBox(
          height: 15,
        ),
        Container(
          alignment: Alignment.center,
          child: Obx(
            () => LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 40,
              lineHeight: 15.0,
              animationDuration: 1000,
              percent: controller.dataUsagePercent.value,
              animateFromLastPercent: true,
              center: Text((controller.dataUsagePercent.value * 100).toString() + "%",
                  style: FontUtils.SF.copyWith(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w700)),
              barRadius: const Radius.circular(10),
              linearGradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Colors.grey, Colors.grey],
              ),
              backgroundColor: AppColors.primaryBlackColor,
              animation: true,
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Obx(() => Center(
            child: _textCard(
                "${controller.usedData.value} / ${controller.totalData.value} " + AppString().used(context),
                AppColors.kSubText))),
        const SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppString().expiredOn(context),
                  style: FontUtils.SF.copyWith(
                      fontSize: Dimens.currentSize(context, 16, 18, 20),
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  controller.dateFormate(planModel.expiredDate!),
                  style: FontUtils.SF.copyWith(
                      fontSize: Dimens.currentSize(context, 14, 14, 18),
                      color: AppColors.kIconColor,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            _actionButton2(AppString().buy_again(context), Colors.white, AppColors.kButtonColor, false,
                () => planModel != null ? controller.getLatestplan(planModel) : null, context)
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Divider(color: Colors.grey.withOpacity(0.5), thickness: 0.5),
        planDetailsView(planModel),
      ],
    );
  }

  static Widget _actionButton2(
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

  Widget planDetailsView(PlanModel planModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
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
                planModel.iccid!,
                style: FontUtils.SF.copyWith(
                    fontSize: Dimens.currentSize(context, 14, 16, 18),
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Divider(color: Colors.grey.withOpacity(0.5), thickness: 0.5),
        planDetailsItem(Assets.purchase_date, AppString().purchaseDate(context),
            controller.dateTimeFormate(planModel.purchaseDate!)),
        planDetailsItem2(Assets.order_number, AppString().orderNumber(context), planModel.transactionId!),
        planDetailsItem(Assets.payment_method, AppString().paymentMethod(context), planModel.paymentMethod!),
        widget.flag != 1
            ? planDetailsItem(Assets.plan_activation_date, AppString().planActivationDate(context),
                controller.dateFormate(planModel.activationDate!))
            : const SizedBox.shrink(),
        Divider(color: Colors.grey.withOpacity(0.5), thickness: 0.5),
        planDetailsItem(
            Assets.plan_price,
            AppString().planPrice(context),
            planModel.convertedPrice!.currency != null
                ? "${StringUtils.getCurrencySymbol(planModel.convertedPrice!.currency!)} ${planModel.convertedPrice!.price!.toPrecision(2)}"
                : planModel.priceBundle != 0.0
                    ? "${StringUtils.getCurrencySymbol(planModel.currency!)} ${planModel.priceBundle!.toPrecision(2)}"
                    : planModel.price != 0.0
                        ? "${StringUtils.getCurrencySymbol(planModel.currency!)} ${planModel.price!.toPrecision(2)}"
                        : ""),
        planModel.rewardPointsRedeemed != 0
            ? planDetailsItem(
                Assets.plan_price,
                "${AppString().rewardPoints(context)}${planModel.rewardPointsRedeemed}(${StringUtils.getCurrencySymbol(planModel.currency!)}${planModel.rewardCashValueRedeemed!.toPrecision(2)})",
                "-${StringUtils.getCurrencySymbol(planModel.currency!)}${planModel.rewardCashValueRedeemed!.toPrecision(2)}")
            : const SizedBox.shrink(),
        planModel.couponAmount != 0
            ? planDetailsItem(Assets.plan_price, "${AppString().couponCode(context)}${planModel.couponCode}",
                "-${StringUtils.getCurrencySymbol(planModel.currency!)}${planModel.couponAmount!.toPrecision(2)}")
            : const SizedBox.shrink(),
        Divider(color: Colors.grey.withOpacity(0.5), thickness: 0.5),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    Assets.final_paid_amount,
                    height: 20,
                    width: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(AppString().finalPaidAmount(context),
                      style: FontUtils.SF.copyWith(
                          fontSize: Dimens.currentSize(context, 16, 16, 20),
                          color: Colors.white,
                          fontWeight: FontWeight.w500))
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text("${StringUtils.getCurrencySymbol(planModel.currency!)}${planModel.price!.toPrecision(2)}",
                    textAlign: TextAlign.start,
                    style: FontUtils.SF.copyWith(
                        fontSize: Dimens.currentSize(context, 16, 16, 20),
                        color: Colors.white,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget planDetailsItem(String icon, String lable, String data) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                icon,
                height: 18,
                width: 15,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(lable,
                  style: FontUtils.SF.copyWith(
                      fontSize: Dimens.currentSize(context, 14, 14, 18),
                      color: Colors.white,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(data,
                textAlign: TextAlign.start,
                style: FontUtils.SF.copyWith(
                    fontSize: Dimens.currentSize(context, 14, 14, 18),
                    color: AppColors.kIconColor,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget planDetailsItem2(String icon, String lable, String data) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  icon,
                  height: 18,
                  width: 15,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(lable,
                    style: FontUtils.SF.copyWith(
                        fontSize: Dimens.currentSize(context, 14, 14, 18),
                        color: Colors.white,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Expanded(
            child: Text(data,
                textAlign: TextAlign.end,
                style: FontUtils.SF.copyWith(
                    fontSize: Dimens.currentSize(context, 14, 14, 18),
                    color: AppColors.kIconColor,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
