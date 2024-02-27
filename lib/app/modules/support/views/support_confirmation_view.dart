import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/support/controllers/support_controller.dart';
import 'package:ride_mobile/app/utils/appString.dart';
import 'package:ride_mobile/app/utils/assets.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/dimensions.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';
import 'package:ride_mobile/app/widgets/bottom_centered_curved_container.dart';
import 'package:ride_mobile/app/widgets/buttons/back_button.dart';
import 'package:ride_mobile/app/widgets/buttons/primary_action_button.dart';

import '../../../utils/keys.dart';

class SupportConfirmationView extends GetView<SupportController> {
  final bool isFromHome;
  final String? ticketNo;
  final int? flag;
  const SupportConfirmationView({Key? key, required this.isFromHome, this.ticketNo = "0", this.flag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SupportController());
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
            flag == 0 ? _contactSuccessView(context) : _supportSuccessView(context),
          ],
        ));
  }

  Widget _supportSuccessView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 150,
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            AppString().thankyou_inquiry(context),
            style: FontUtils.TTFirsNeueTrial.copyWith(
                fontSize: Dimens.currentSize(context, 18, 20, 22), color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Image.asset(
          Assets.support_done,
          fit: BoxFit.contain,
          height: 100,
          width: 100,
          alignment: Alignment.topLeft,
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
          alignment: Alignment.center,
          child: Text(
            AppString().support_success1(context) + " $ticketNo. " + AppString().support_success2(context),
            textAlign: TextAlign.center,
            style: FontUtils.SF.copyWith(
                fontSize: Dimens.currentSize(context, 14, 16, 18),
                color: Colors.white,
                fontWeight: FontWeight.w500,
                height: 1.5),
          ),
        ),
        const SizedBox(
          height: 35,
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          child: PrimaryActionButton(
              label: AppString().home(context), onTap: () => controller.goBack(isFromHome), isLoading: false),
        )
      ],
    );
  }

  Widget _contactSuccessView(BuildContext context) {
    return Column(
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
                  AppString().contact_us(context),
                  textAlign: TextAlign.left,
                  style: FontUtils.TTFirsNeueTrial.copyWith(
                      fontSize: Dimens.currentSize(context, 18, 20, 22),
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: ArrowedBackButton(),
              )
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Image.asset(
              Assets.support_done,
              fit: BoxFit.contain,
              height: 120,
              width: 120,
              alignment: Alignment.topLeft,
            ),
          ),
        ),
        BottomCenteredCurvedContainer(
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        AppString().thankyou_inquiry(context),
                        style: FontUtils.TTFirsNeueTrial.copyWith(
                            fontSize: Dimens.currentSize(context, 18, 20, 22),
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      AppString().contact_success(context),
                      textAlign: TextAlign.center,
                      style: FontUtils.TTFirsNeueTrial.copyWith(
                          fontSize: Dimens.currentSize(context, 14, 16, 18),
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          height: 1.5),
                    ),
                  ],
                ),
                PrimaryActionButton(
                    label: AppString().home(context), onTap: () => controller.goBack(isFromHome), isLoading: false)
              ],
            )),
      ],
    );
  }
}
