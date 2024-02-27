import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/models/location_model.dart';
import 'package:ride_mobile/app/models/plan_model.dart';
import 'package:ride_mobile/app/modules/payment/controllers/payment_controller.dart';
import 'package:ride_mobile/app/modules/registration/views/registration_view.dart';
import 'package:ride_mobile/app/services/user/current_user.dart';
import 'package:ride_mobile/app/services/user/local%20preferences.dart';
import 'package:ride_mobile/app/utils/assets.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';
import 'package:ride_mobile/app/utils/plan_utils.dart';
import 'package:ride_mobile/app/utils/string_utils.dart';

import '../../../modules/payment/views/payment_details_view.dart';
import '../../../utils/appString.dart';
import '../../../utils/dimensions.dart';

class PlanCard extends StatelessWidget {
  final PlanModel plan;
  final int index;
  final LocationModel location;
  final bool isFromHome;
  final bool isFromDrawer;
  final PaymentController paymentController;

  const PlanCard(
      {Key? key,
      required this.plan,
      required this.index,
      required this.location,
      required this.isFromHome,
      required this.isFromDrawer,
      required this.paymentController})
      : super(key: key);

  static Widget _actionButton(
      String label, Color fontColor, Color bgColor, bool hasBorder, VoidCallback onTap, BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 35,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            shape: BoxShape.rectangle,
          ),
          child: Center(
            child: Text(
              label,
              style: FontUtils.SF.copyWith(
                  fontSize: Dimens.currentSize(context, 12, 14, 16), color: fontColor, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  void checkIfUserIsRegistered() async {
    var isLoggedIn = await LocalPreferences.isUserLoggedIn();
    if (isLoggedIn) {
      CurrentUser().currentUser.productId = plan.stripeProductId!;
      Get.to(() => PaymentDetailsView(
            isFromDrawer: isFromDrawer,
            isFromHome: isFromHome,
            plan: plan,
            location: location,
          ));
    } else {
      StringUtils.debugPrintMode("registering user");
      CurrentUser().currentUser.productId = plan.stripeProductId!;
      Get.to(() => RegistrationView(
            plan: plan,
            location: location,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: AppColors.kBGPlanItem,
              shape: BoxShape.rectangle,
              image: const DecorationImage(image: AssetImage(Assets.bg_img_plna_item), fit: BoxFit.fill)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          plan.name!.toUpperCase(),
                          style: FontUtils.SF.copyWith(
                              fontSize: Dimens.currentSize(context, 12, 14, 16),
                              color: AppColors.kPlanName,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${PlanUtils.totalData(plan)} - Valid for ${PlanUtils.getValidity(plan.validity!)}",
                              style: FontUtils.SF.copyWith(
                                  fontSize: Dimens.currentSize(context, 12, 14, 16),
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringUtils.getCurrencySymbol(plan.currency!),
                        style: FontUtils.SF.copyWith(
                            fontSize: Dimens.currentSize(context, 12, 14, 16),
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        "${plan.priceBundle!.toPrecision(2)}",
                        style: FontUtils.SF.copyWith(
                            fontSize: Dimens.currentSize(context, 30, 32, 34),
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      plan.productCategory!,
                      style: FontUtils.SF.copyWith(
                          fontSize: Dimens.currentSize(context, 10, 12, 14),
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          _actionButton(AppString().learnMore(context), Colors.white, AppColors.kLearnMoreButton, true,
                              () => plan != null ? checkIfUserIsRegistered() : null, context),
                          const SizedBox(
                            width: 10,
                          ),
                          _actionButton(AppString().buyNow(context), Colors.white, AppColors.kButtonColor, false,
                              () => plan != null ? checkIfUserIsRegistered() : null, context),
                        ],
                      )),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget bottomSheetView(BuildContext context, PlanModel plan) {
  //   return SizedBox(
  //     height: 300,
  //     child: Container(
  //       margin: EdgeInsets.symmetric(horizontal: 20),
  //       padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
  //       decoration: BoxDecoration(
  //           color: AppColors.kRectangleColor,
  //           borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(20), topRight: Radius.circular(20))),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Expanded(
  //                 child: Text(
  //                   plan.name! +
  //                       "-\$" +
  //                       "${plan.priceBundle!.toDouble().toStringAsFixed(2)}",
  //                   style: FontUtils.SF.copyWith(
  //                       fontSize: 18,
  //                       color: Colors.white,
  //                       fontWeight: FontWeight.w700),
  //                 ),
  //               ),
  //               InkWell(
  //                   onTap: () => Navigator.pop(context),
  //                   child: Icon(Icons.close, color: Colors.grey, size: 24))
  //             ],
  //           ),
  //           SizedBox(
  //             height: 10,
  //           ),
  //           Container(
  //             padding: EdgeInsets.symmetric(vertical: 10),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 dataItem("Data", plan.data!, "Total Data",
  //                     "${PlanUtils.totalData(plan)}"),
  //                 dataItem("SMS", "100", "Countries", plan.country!),
  //                 dataItem("Voice", "Unlimited", "Validity",
  //                     "${PlanUtils.getValidity(plan.validity!)}"),
  //               ],
  //             ),
  //           ),
  //           SizedBox(
  //             height: 10,
  //           ),
  //           Obx(
  //             () => PrimaryActionButton(
  //                 label: "Buy Now",
  //                 onTap: () => checkIfUserIsRegistered(),
  //                 isLoading: paymentController.isByNowLoading.value),
  //           ),
  //           // InkWell(
  //           //   onTap: () => checkIfUserIsRegistered(),
  //           //   child: Container(
  //           //     height: 45,
  //           //     decoration: BoxDecoration(
  //           //       color: AppColors.kButtonColor,
  //           //       borderRadius: const BorderRadius.all(Radius.circular(25)),
  //           //       shape: BoxShape.rectangle,
  //           //     ),
  //           //     child: Center(
  //           //       child: Text("Buy Now", style: FontUtils.SF.copyWith(fontSize: 15, color: Colors.white),
  //           //       ),
  //           //     ),
  //           //   ),
  //           // ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget dataItem(String title, String info, String title2, String info2) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(vertical: 5),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               title,
  //               style: FontUtils.SF.copyWith(
  //                   fontSize: 16,
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.w700),
  //             ),
  //             SizedBox(
  //               height: 8,
  //             ),
  //             Text(
  //               info,
  //               style: FontUtils.SF.copyWith(
  //                   fontSize: 16,
  //                   color: Colors.grey,
  //                   fontWeight: FontWeight.w700),
  //             ),
  //           ],
  //         ),
  //         SizedBox(
  //           height: 20,
  //         ),
  //         Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               title2,
  //               style: FontUtils.SF.copyWith(
  //                   fontSize: 16,
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.w700),
  //             ),
  //             SizedBox(
  //               height: 8,
  //             ),
  //             Text(
  //               info2,
  //               style: FontUtils.SF.copyWith(
  //                   fontSize: 16,
  //                   color: Colors.grey,
  //                   fontWeight: FontWeight.w700),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
