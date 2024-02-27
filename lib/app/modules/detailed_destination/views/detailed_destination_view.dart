import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/models/location_model.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/no_result_found_card.dart';
import 'package:ride_mobile/app/widgets/destination_widgets/plans/plan_card.dart';

import '../../../utils/appString.dart';
import '../../../utils/assets.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/font_utils.dart';
import '../../../utils/keys.dart';
import '../../../widgets/auth_widgets/blurred_container.dart';
import '../../../widgets/buttons/back_button.dart';
import '../../../widgets/loader_view.dart';
import '../../payment/controllers/payment_controller.dart';
import '../controllers/detailed_destination_controller.dart';

class DetailedDestinationView extends StatefulWidget {
  final LocationModel location;
  final bool isFromHome;
  final bool isFromDrawer;

  const DetailedDestinationView(
      {Key? key, required this.location, required this.isFromHome, required this.isFromDrawer})
      : super(key: key);

  @override
  State<DetailedDestinationView> createState() => _DetailedDestinationViewState();
}

class _DetailedDestinationViewState extends State<DetailedDestinationView> {
  DetailedDestinationController controller = Get.put(DetailedDestinationController());
  PaymentController paymentController = PaymentController();

  @override
  void initState() {
    super.initState();
    controller.getPlans(widget.location.name!, widget.location.name!, widget.location.fromDestination!,
        widget.location.fromDestination!);
  }

  @override
  Widget build(BuildContext context) {
    Get.put(DetailedDestinationController());
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Scaffold(
            backgroundColor: AppColors.homeBGColor,
            body: SizedBox(
              height: Dimens.height(100, context),
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
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: Dimens.getStatusBarHeight(context),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: ArrowedBackButton(),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: Dimens.width(100, context),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 5),
                                        Text(
                                          AppString().plans_title(context) + widget.location.name!,
                                          textAlign: TextAlign.left,
                                          style: FontUtils.TTFirsNeueTrial.copyWith(
                                              fontSize: Dimens.currentSize(context, 18, 20, 22),
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 15),
                                        Text(
                                          AppString().choose_plan_use(context) +
                                              widget.location.name! +
                                              AppString().choose_plan_use2(context),
                                          textAlign: TextAlign.left,
                                          style: FontUtils.TTFirsNeueTrial.copyWith(
                                              fontSize: Dimens.currentSize(context, 12, 14, 16),
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              shadows: [FontUtils.lightGreyShadow]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: BlurredContainer(
                          height: Dimens.height(100, context),
                          child: Entry.scale(
                            duration: const Duration(milliseconds: 300),
                            child: Obx(
                              () => SizedBox(
                                child: controller.isLoading.value
                                    ? const LoaderView()
                                    : SizedBox(
                                        child: controller.plans.isEmpty
                                            ? SizedBox(
                                                height: Dimens.height(100, context) - 300,
                                                child: NoResultFoundCard(message: AppString().no_result_found(context)))
                                            : MediaQuery.removePadding(
                                                context: context,
                                                removeTop: true,
                                                removeBottom: true,
                                                child: ListView.separated(
                                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                                  shrinkWrap: true,
                                                  itemCount: controller.plans.length,
                                                  itemBuilder: (context, index) {
                                                    return PlanCard(
                                                      isFromDrawer: widget.isFromDrawer,
                                                      isFromHome: widget.isFromHome,
                                                      location: widget.location,
                                                      plan: controller.plans[index],
                                                      paymentController: paymentController,
                                                      index: index,
                                                    );
                                                  },
                                                  separatorBuilder: (BuildContext context, int index) {
                                                    return const SizedBox(
                                                      height: 30,
                                                    );
                                                  },
                                                ),
                                              ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }
}
