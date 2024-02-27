import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/home/views/home_view.dart';
import 'package:ride_mobile/app/utils/assets.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';
import 'package:ride_mobile/app/widgets/buttons/primary_action_button.dart';

import '../../../utils/appString.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/keys.dart';
import '../../../widgets/auth_widgets/blurred_container.dart';

class CurrencyChangeSuccessView extends StatelessWidget {
  const CurrencyChangeSuccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.homeBGColor,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              Assets.shop_bg,
              fit: BoxFit.fill,
              height: Dimens.height(100, context),
              width: Dimens.width(100, context),
              alignment: Alignment.topLeft,
              key: DestinationPageKeys.destinationHeaderImageKey,
            ),
            Positioned(
              top: Dimens.height(44, context),
              child: Image.asset(
                Assets.img_desgin_color,
                fit: BoxFit.fill,
                height: 100,
                width: Dimens.width(100, context),
                alignment: Alignment.topLeft,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: Dimens.height(50, context),
                child: BlurredContainer(
                    height: Dimens.height(100, context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 70,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            AppString().change_successful(context),
                            textAlign: TextAlign.left,
                            style: FontUtils.TTFirsNeueTrial.copyWith(
                                fontSize: Dimens.currentSize(context, 18, 20, 22),
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            AppString().change_successful_details(context),
                            textAlign: TextAlign.left,
                            style: FontUtils.TTFirsNeueTrial.copyWith(
                                fontSize: Dimens.currentSize(context, 12, 14, 16),
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: PrimaryActionButton(
                              label: AppString().home(context),
                              onTap: () => Get.to(() => const HomeView()),
                              isLoading: false),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    )),
              ),
            ),
            Positioned(
              top: Dimens.height(44, context),
              child: Image.asset(
                Assets.payment_success,
                fit: BoxFit.fill,
                height: 170,
                width: 170,
                alignment: Alignment.topLeft,
              ),
            ),
          ],
        ));
  }
}
