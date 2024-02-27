import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/account/controllers/account_controller.dart';
import 'package:ride_mobile/app/modules/payment/controllers/payment_controller.dart';

import '../../../models/location_model.dart';
import '../../../models/plan_model.dart';
import '../../../services/user/current_user.dart';
import '../../../utils/appString.dart';
import '../../../utils/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/font_utils.dart';
import '../../../utils/keys.dart';
import '../../../utils/loading_indicators.dart';
import '../../../utils/plan_utils.dart';
import '../../../utils/string_utils.dart';
import '../../../widgets/buttons/back_button.dart';
import '../../../widgets/buttons/primary_action_button.dart';
import '../../../widgets/loader_view.dart';
import '../../../widgets/registration_widgets/registration_text_field.dart';

class OrderSummary extends StatefulWidget {
  final PlanModel plan;
  final LocationModel? location;
  final bool isFromHome;
  final bool isFromDrawer;

  const OrderSummary(
      {Key? key, required this.plan, required this.isFromHome, required this.isFromDrawer, this.location})
      : super(key: key);

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  PaymentController paymentController = Get.put(PaymentController());
  AccountController controller = Get.put(AccountController());

  @override
  void initState() {
    super.initState();
    controller.getRewardPoints();
    paymentController.isApplyedForReward.value = false;
    paymentController.isApplyedForCoupon.value = false;
    paymentController.rewardpointController.clear();
    paymentController.couponController.clear();
    paymentController.remainingRedeemCashValue.value = controller.rewardPointResponse.value.cashValue!;
    paymentController.isRewardPointApplyError.value = "";
    paymentController.isCouponCodeApplyError.value = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBGColor,
      body: SizedBox(
        height: Dimens.height(100, context),
        width: Dimens.width(100, context),
        child: Stack(
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: Dimens.getStatusBarHeight(context)),
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
                          AppString().orderSummary(context),
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
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _planSummary(),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CurrentUser().configResponse.data!.rewardPointsEnabled!
                                  ? Column(
                                      children: [
                                        _rewardPointUse(),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                              const Divider(color: Color.fromRGBO(245, 245, 245, 1), thickness: 0.1),
                              CurrentUser().configResponse.data!.couponCodesMasterEnabled!
                                  ? Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        _couponCode(),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                              const SizedBox(
                                height: 20,
                              ),
                              _payableAmount(),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Obx(() => paymentController.isByNowLoading.value ? const LoaderView() : const SizedBox.shrink()),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        decoration: BoxDecoration(
            color: AppColors.bottomNavigationBG,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Text(
                paymentController.isApplyedForReward.value || paymentController.isApplyedForCoupon.value
                    ? "${StringUtils.getCurrencySymbol(widget.plan.currency!)}${paymentController.redeemResponse.value.finalPayableAmount!.toPrecision(2)}"
                    : widget.plan.priceBundle != null && widget.plan.priceBundle != 0.0
                        ? StringUtils.getCurrencySymbol(widget.plan.currency!) +
                            "${widget.plan.priceBundle!.toPrecision(2)}"
                        : widget.plan.price != null && widget.plan.price != 0.0
                            ? StringUtils.getCurrencySymbol(widget.plan.currency!) +
                                "${widget.plan.price!.toPrecision(2)}"
                            : "",
                textAlign: TextAlign.left,
                style: FontUtils.SF.copyWith(
                    fontSize: Dimens.currentSize(context, 24, 26, 30),
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              width: 140,
              child: Obx(
                () => ActionButton(
                  label: AppString().pay(context),
                  onTap: () => paymentController.onTapBuyNow(widget.plan, widget.isFromHome, widget.isFromDrawer),
                  isLoading: paymentController.isByNowLoading.value,
                  key: RegistrationPageKeys.registerButtonKey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _planSummary() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      width: Dimens.width(100, context),
      decoration: BoxDecoration(color: AppColors.kRectangleColor, borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppString().plan_details(context),
              style: FontUtils.SF.copyWith(
                  fontSize: Dimens.currentSize(context, 10, 12, 14),
                  color: AppColors.planDetails,
                  fontWeight: FontWeight.w400)),
          const SizedBox(
            height: 5,
          ),
          Flexible(
            child: Text(widget.plan.name!,
                // maxLines: 3,
                style: FontUtils.SF.copyWith(
                    fontSize: Dimens.currentSize(context, 14, 16, 18),
                    color: Colors.white,
                    fontWeight: FontWeight.w500)),
          ),
          const SizedBox(
            height: 5,
          ),
          Text("${PlanUtils.totalData(widget.plan)} for ${PlanUtils.getValidity(widget.plan.validity!)}",
              style: FontUtils.SF.copyWith(
                  fontSize: Dimens.currentSize(context, 12, 14, 16), color: Colors.white, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }

  Widget _rewardPointUse() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              AppString().useRewardPoints(context),
              textAlign: TextAlign.left,
              style: FontUtils.SF.copyWith(
                  fontSize: Dimens.currentSize(context, 12, 14, 16), color: Colors.white, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            SvgPicture.asset(Assets.reward_icon),
            const SizedBox(
              width: 10,
            ),
            Obx(
              () => Text(
                paymentController.isApplyedForReward.value
                    ? "${paymentController.redeemResponse.value.remainingRewardPoints} (${StringUtils.getCurrencySymbol(paymentController.redeemResponse.value.rewardPointsValueCurrency!)}${paymentController.remainingRedeemCashValue.value})"
                    : "${controller.rewardPointResponse.value.rewardPoints} (${StringUtils.getCurrencySymbol(controller.rewardPointResponse.value.currency!)}${controller.rewardPointResponse.value.cashValue})",
                style: FontUtils.SF.copyWith(
                    fontSize: Dimens.currentSize(context, 14, 16, 18),
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Obx(
                () => RegistrationTextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    key: RegistrationPageKeys.emailAddressKey,
                    hintText: AppString().hint_rewardPoints(context),
                    suffixIcon: paymentController.isApplyedForReward.value
                        ? Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SvgPicture.asset(
                              Assets.applyed,
                            ),
                          )
                        : null,
                    onTap: () {
                      if (paymentController.isApplyedForReward.value) {
                        paymentController.isApplyedForReward.value = false;
                      }
                    },
                    showPassword: false,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SvgPicture.asset(
                        Assets.reward_icon,
                      ),
                    ),
                    readOnly: paymentController.isApplyedForReward.value,
                    textInputType: TextInputType.number,
                    textCapitalization: TextCapitalization.none,
                    controller: paymentController.rewardpointController),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Obx(
              () => !paymentController.isApplyedForReward.value
                  ? Container(
                      height: Dimens.currentSize(context, 40, 45, 55),
                      width: Dimens.currentSize(context, 80, 90, 100),
                      color: Colors.transparent,
                      child: _applyButton(0, context))
                  : const SizedBox.shrink(),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Obx(() => paymentController.isRewardPointApplyError.value != ""
            ? Text(
                paymentController.isRewardPointApplyError.value,
                textAlign: TextAlign.left,
                style: FontUtils.SF.copyWith(
                    fontSize: Dimens.currentSize(context, 12, 14, 16), color: Colors.red, fontWeight: FontWeight.w500),
              )
            : const SizedBox.shrink()),
      ],
    );
  }

  Widget _couponCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppString().useCouponCode(context),
          textAlign: TextAlign.left,
          style: FontUtils.SF.copyWith(
              fontSize: Dimens.currentSize(context, 12, 14, 16), color: Colors.white, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Obx(
                () => RegistrationTextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    hintText: AppString().hint_couponCode(context),
                    suffixIcon: paymentController.isApplyedForCoupon.value
                        ? Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SvgPicture.asset(
                              Assets.applyed,
                            ),
                          )
                        : null,
                    showSuffix: false,
                    showPassword: false,
                    onTap: () {
                      if (paymentController.isApplyedForCoupon.value) {
                        paymentController.isApplyedForCoupon.value = false;
                      }
                    },
                    readOnly: paymentController.isApplyedForCoupon.value,
                    textCapitalization: TextCapitalization.none,
                    controller: paymentController.couponController),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Obx(
              () => !paymentController.isApplyedForCoupon.value
                  ? Container(
                      height: Dimens.currentSize(context, 40, 45, 55),
                      width: Dimens.currentSize(context, 80, 90, 100),
                      color: Colors.transparent,
                      child: _applyButton(1, context))
                  : const SizedBox.shrink(),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Obx(() => paymentController.isCouponCodeApplyError.value != ""
            ? Text(
                paymentController.isCouponCodeApplyError.value,
                textAlign: TextAlign.left,
                style: FontUtils.SF.copyWith(
                    fontSize: Dimens.currentSize(context, 12, 14, 16),
                    color: paymentController.isCouponCodeApplyError.value.contains("Discount Availed")
                        ? Colors.white
                        : Colors.red,
                    fontWeight: FontWeight.w500),
              )
            : const SizedBox.shrink()),
      ],
    );
  }

  Widget _payableAmount() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      width: Dimens.width(100, context),
      decoration: BoxDecoration(color: AppColors.kRectangleColor, borderRadius: BorderRadius.circular(16)),
      child: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _billItem(Assets.plan_price, AppString().planPrice(context),
                "${StringUtils.getCurrencySymbol(widget.plan.currency!)}${widget.plan.price!.toPrecision(2)}"),
            const Divider(color: Color.fromRGBO(245, 245, 245, 1), thickness: 0.1),
            CurrentUser().configResponse.data!.rewardPointsEnabled! && paymentController.isApplyedForReward.value
                ? Column(
                    children: [
                      _billItem(
                          Assets.reward_icon,
                          AppString().reward_points(context) +
                              " ${paymentController.redeemResponse.value.remainingRewardPoints}(${StringUtils.getCurrencySymbol(paymentController.redeemResponse.value.rewardPointsValueCurrency!)}${paymentController.redeemResponse.value.rewardPointsValue})",
                          "-${StringUtils.getCurrencySymbol(paymentController.redeemResponse.value.currency!)}${paymentController.redeemResponse.value.rewardPointsValue}"),
                      const Divider(color: Color.fromRGBO(245, 245, 245, 1), thickness: 0.1),
                    ],
                  )
                : const SizedBox.shrink(),
            CurrentUser().configResponse.data!.couponCodesMasterEnabled! && paymentController.isApplyedForCoupon.value
                ? Column(
                    children: [
                      _billItem(
                          Assets.coupon_code,
                          AppString().coupon_code(context) +
                              " ${paymentController.redeemResponse.value.couponCodeToRedeem}",
                          "-${StringUtils.getCurrencySymbol(paymentController.redeemResponse.value.couponCodeValueCurrency!)}${paymentController.redeemResponse.value.couponCodeValue}"),
                      const Divider(color: Color.fromRGBO(245, 245, 245, 1), thickness: 0.1),
                    ],
                  )
                : const SizedBox.shrink(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppString().amount_payable(context),
                  textAlign: TextAlign.left,
                  style: FontUtils.SF.copyWith(
                      fontSize: Dimens.currentSize(context, 16, 18, 20),
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  paymentController.isApplyedForReward.value || paymentController.isApplyedForCoupon.value
                      ? "${StringUtils.getCurrencySymbol(paymentController.redeemResponse.value.currency!)}${paymentController.redeemResponse.value.finalPayableAmount!.toPrecision(2)}"
                      : widget.plan.priceBundle != null && widget.plan.priceBundle != 0.0
                          ? StringUtils.getCurrencySymbol(widget.plan.currency!) +
                              "${widget.plan.priceBundle!.toPrecision(2)}"
                          : widget.plan.price != null && widget.plan.price != 0.0
                              ? StringUtils.getCurrencySymbol(widget.plan.currency!) +
                                  "${widget.plan.price!.toPrecision(2)}"
                              : "",
                  textAlign: TextAlign.left,
                  style: FontUtils.SF.copyWith(
                      fontSize: Dimens.currentSize(context, 24, 26, 28),
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _billItem(String icon, String title, String amount) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                icon,
                height: 18,
                width: 18,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                title,
                textAlign: TextAlign.left,
                style: FontUtils.SF.copyWith(
                    fontSize: Dimens.currentSize(context, 12, 14, 18),
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Text(
            amount,
            textAlign: TextAlign.left,
            style: FontUtils.SF.copyWith(
                fontSize: Dimens.currentSize(context, 12, 16, 18), color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _applyButton(int flag, BuildContext context) {
    return ElevatedButton(
      onPressed: paymentController.isApplyReward.value || paymentController.isApplyCoupon.value
          ? null
          : () {
              if (flag == 0) {
                if (paymentController.rewardpointController.text != "") {
                  int enterdPoints = int.parse(paymentController.rewardpointController.text);
                  if (enterdPoints > 0) {
                    // int minPoints = CurrentUser().configResponse.data!.rewardPointsMinRedeem!;
                    // int maxPoints = CurrentUser().configResponse.data!.rewardPointsMaxRedeem!;
                    // if (enterdPoints > controller.rewardPointResponse.value.rewardPoints!) {
                    //   SnackBarUtils.showSnackBar("You can't have enough points for redeem!", 2);
                    // } else if (enterdPoints < minPoints) {
                    //   paymentController.isRewardPointApplyError.value =
                    //       "You need minimum ${minPoints} reward points to redeem it";
                    // } else if (enterdPoints > maxPoints) {
                    //   paymentController.isRewardPointApplyError.value =
                    //       "You can use maximum ${maxPoints} reward points to redeem it";
                    // } else {
                    paymentController.isRewardPointApplyError.value = "";
                    paymentController.applyRewardPoints(widget.plan.stripeProductId!, controller);
                    // }
                  } else {
                    paymentController.isRewardPointApplyError.value = "You need minimum 1 reward points to redeem it!";
                  }
                } else {
                  paymentController.isRewardPointApplyError.value = "Please enter reward points value!";
                  // SnackBarUtils.showSnackBar("Please enter reward points value!", 2);
                }
              } else {
                if (paymentController.couponController.text != "") {
                  paymentController.applyCouponCode(widget.plan.stripeProductId!);
                } else {
                  paymentController.isCouponCodeApplyError.value = "Please enter coupon code!";
                }
              }
            },
      style: ButtonStyle(
        shape: MaterialStateProperty.resolveWith<OutlinedBorder>((states) {
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          );
        }),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return AppColors.navigation_icon_bg;
            } else if (states.contains(MaterialState.disabled)) {
              return AppColors.navigation_icon_bg;
            }
            return AppColors.navigation_icon_bg;
          },
        ),
      ),
      child: flag == 0
          ? paymentController.isApplyReward.value
              ? LoadingIndicators.circularIndicator(22, 2.5, Colors.white)
              : Text(
                  AppString().apply(context),
                  style: FontUtils.SF.copyWith(
                      fontSize: Dimens.currentSize(context, 14, 16, 18),
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                )
          : paymentController.isApplyCoupon.value
              ? LoadingIndicators.circularIndicator(22, 2.5, Colors.white)
              : Text(
                  AppString().apply(context),
                  style: FontUtils.SF.copyWith(
                      fontSize: Dimens.currentSize(context, 14, 16, 18),
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
    );
  }
}
