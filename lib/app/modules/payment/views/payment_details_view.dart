import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/models/location_model.dart';
import 'package:ride_mobile/app/models/plan_model.dart';
import 'package:ride_mobile/app/modules/home/views/home_view.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';
import 'package:ride_mobile/app/utils/plan_utils.dart';
import 'package:ride_mobile/app/widgets/buttons/primary_action_button.dart';

import '../../../services/user/current_user.dart';
import '../../../services/user/local preferences.dart';
import '../../../utils/appString.dart';
import '../../../utils/assets.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/keys.dart';
import '../../../utils/string_utils.dart';
import '../../../widgets/loader_view.dart';
import '../../registration/views/registration_view.dart';
import '../controllers/payment_controller.dart';
import 'order_summary.dart';

class PaymentDetailsView extends StatefulWidget {
  final PlanModel plan;
  final LocationModel? location;
  final bool isFromHome;
  final bool isFromDrawer;

  const PaymentDetailsView(
      {Key? key, required this.plan, required this.isFromHome, required this.isFromDrawer, this.location})
      : super(key: key);

  @override
  State<PaymentDetailsView> createState() => _PaymentDetailsViewState();
}

class _PaymentDetailsViewState extends State<PaymentDetailsView> {
  PaymentController controller = Get.put(PaymentController());

  @override
  void initState() {
    super.initState();
  }

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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: Dimens.getStatusBarHeight(context),
                  ),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          key: CommonKeys.goBackButtonKey,
                          onTap: () => widget.isFromHome ? Get.back() : Get.offAll(const HomeView()),
                          child: SvgPicture.asset(
                            Assets.back_arrow,
                            color: Colors.white,
                            height: 40,
                            width: 40,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 50),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          AppString().plan_details(context),
                          textAlign: TextAlign.left,
                          style: FontUtils.TTFirsNeueTrial.copyWith(
                              fontSize: Dimens.currentSize(context, 18, 20, 22),
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.plan.name!,
                            style: FontUtils.SF.copyWith(
                                fontSize: Dimens.currentSize(context, 16, 18, 20),
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.plan.priceBundle != null && widget.plan.priceBundle != 0.0
                                ? StringUtils.getCurrencySymbol(widget.plan.currency!) +
                                    "${widget.plan.priceBundle!.toPrecision(2)}"
                                : widget.plan.price != null && widget.plan.price != 0.0
                                    ? StringUtils.getCurrencySymbol(widget.plan.currency!) +
                                        "${widget.plan.price!.toPrecision(2)}"
                                    : "",
                            style: FontUtils.SF.copyWith(
                                fontSize: Dimens.currentSize(context, 38, 40, 42),
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white38,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            dataItem(
                                "Data", widget.plan.data!, "Total Data", PlanUtils.totalData(widget.plan), context),
                            dataItem(
                                "SMS",
                                "100",
                                "Countries",
                                widget.plan.country == null || widget.plan.country == ""
                                    ? widget.location != null
                                        ? widget.location!.name.toString()
                                        : ""
                                    : widget.plan.country.toString(),
                                context),
                            dataItem("Voice", "Unlimited", "Validity", PlanUtils.getValidity(widget.plan.validity!),
                                context),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Obx(
                        () => PrimaryActionButton(
                            label: AppString().buy_now(context),
                            onTap: () => checkIfUserIsRegistered(),
                            isLoading: controller.isByNowLoading.value),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Obx(() => controller.isByNowLoading.value ? const LoaderView() : const SizedBox.shrink()),
          ],
        ));
  }

  Widget dataItem(String title, String info, String title2, String info2, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title2,
                style: FontUtils.SF.copyWith(
                    fontSize: Dimens.currentSize(context, 12, 14, 16),
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 5,
              ),
              title2 != "Countries"
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        info2,
                        style: FontUtils.SF.copyWith(
                            fontSize: Dimens.currentSize(context, 14, 16, 18),
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  : Row(
                      children: [
                        Text(
                          widget.location != null ? widget.location!.logo.toString() : widget.plan.flag!,
                          style: FontUtils.SF.copyWith(fontSize: 20, color: FontColors.white71),
                        ),
                        Text(
                          info2,
                          style: FontUtils.SF.copyWith(
                              fontSize: Dimens.currentSize(context, 14, 16, 18),
                              color: Colors.grey,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
            ],
          ),
        ],
      ),
    );
  }

  void checkIfUserIsRegistered() async {
    var isLoggedIn = await LocalPreferences.isUserLoggedIn();
    if (isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderSummary(
            plan: widget.plan,
            isFromHome: widget.isFromHome,
            isFromDrawer: widget.isFromDrawer,
          ),
        ),
      );
      // controller.onTapBuyNow(widget.plan, widget.isFromHome, widget.isFromDrawer);
    } else {
      StringUtils.debugPrintMode("registering user");
      CurrentUser().currentUser.productId = widget.plan.stripeProductId!;
      Get.to(() => RegistrationView(
            plan: widget.plan,
            location: widget.location,
          ));
    }
  }
}
