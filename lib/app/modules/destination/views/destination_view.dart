import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/utils/dimensions.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';

import '../../../utils/appString.dart';
import '../../../utils/assets.dart';
import '../../../utils/keys.dart';
import '../../../widgets/buttons/back_button.dart';
import '../../../widgets/destination_widgets/destination_background_image.dart';
import '../../../widgets/destination_widgets/destination_search_field.dart';
import '../../../widgets/destination_widgets/popular_destinations.dart';
import '../../../widgets/destination_widgets/popular_zones.dart';
import '../controllers/destination_controller.dart';

class DestinationView extends StatefulWidget {
  final bool isFromHome;
  final bool isFromDrawer;

  const DestinationView({Key? key, required this.isFromHome, required this.isFromDrawer}) : super(key: key);

  static Widget _spacer() {
    return const SizedBox(height: 20);
  }

  @override
  State<DestinationView> createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {
  DestinationController controller = Get.put(DestinationController());
  final GlobalKey<ScaffoldState> key = GlobalKey();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // drawer: const DrawerMenu(),
        key: key,
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
                SizedBox(
                  height: 200,
                  child: DestinationBackgroundImage(
                    child: Container(
                      margin: EdgeInsets.only(top: Dimens.getStatusBarHeight(context)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ArrowedBackButton(
                              isFromHome: widget.isFromHome,
                            ),
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
                                        AppString().choose_your_destination(context),
                                        textAlign: TextAlign.left,
                                        style: FontUtils.TTFirsNeueTrial.copyWith(
                                            fontSize: Dimens.currentSize(context, 18, 20, 22),
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 7),
                                      Text(
                                        AppString().select_country(context),
                                        textAlign: TextAlign.left,
                                        style: FontUtils.TTFirsNeueTrial.copyWith(
                                            fontSize: Dimens.currentSize(context, 12, 14, 16),
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            height: Dimens.lineHeight(),
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
                  ),
                ),
                Expanded(
                  child: Container(
                    width: Dimens.width(100, context),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const DestinationSearchField(),
                            DestinationView._spacer(),
                            Obx(
                              () => SizedBox(
                                child: controller.currentSegment.value == 0
                                    ? PopularDestinations(
                                        isFromDrawer: widget.isFromDrawer,
                                        isFromHome: widget.isFromHome,
                                      )
                                    : PopularZones(
                                        isFromDrawer: widget.isFromDrawer,
                                        isFromHome: widget.isFromHome,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Visibility(
                //   // visible: widget.isFromHome,
                //   visible: false,
                //   child: Positioned.fill(
                //     child: Align(
                //       alignment: Alignment.topLeft,
                //       child: IconButton(
                //           padding: EdgeInsets.symmetric(
                //               horizontal: AppSizingUtils.kCommonSpacing,
                //               vertical: AppSizingUtils.kCommonSpacing + 10 + (Platform.isIOS ? 10 : 0)),
                //           onPressed: () => key.currentState!.openDrawer(),
                //           icon: const Icon(
                //             Icons.menu,
                //             size: 30,
                //             color: Colors.white,
                //           )),
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
