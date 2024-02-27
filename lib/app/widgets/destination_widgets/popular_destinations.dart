import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/destination/controllers/destination_controller.dart';
import 'package:ride_mobile/app/modules/detailed_destination/views/detailed_destination_view.dart';
import 'package:ride_mobile/app/services/mix_panel/events.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/dimensions.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';
import 'package:ride_mobile/app/utils/keys.dart';
import 'package:ride_mobile/app/utils/no_result_found_card.dart';
import 'package:ride_mobile/app/widgets/loader_view.dart';

import '../../utils/appString.dart';

class PopularDestinations extends GetView<DestinationController> {
  final bool isFromHome;
  final bool isFromDrawer;

  const PopularDestinations({Key? key, required this.isFromHome, required this.isFromDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(DestinationController());
    return Entry.opacity(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppString().popular_destinations(context),
            style: FontUtils.SF.copyWith(
                fontSize: Dimens.currentSize(context, 12, 14, 16), color: Colors.white, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 7,
          ),
          Obx(
            () => MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: controller.isLoadingDestination.value
                  ? const Center(child: SizedBox(height: 200, child: LoaderView()))
                  : SizedBox(
                      height: Dimens.height(isFromHome ? 45 : 55, context),
                      child: controller.popularDestinations.isEmpty
                          ? NoResultFoundCard(message: AppString().no_result_found(context))
                          : ListView.separated(
                              shrinkWrap: false,
                              key: DestinationPageKeys.popularDestinationsListKey,
                              // physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.popularDestinations.length,
                              itemBuilder: (context, index) {
                                var location = controller.popularDestinations[index];
                                return Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: AppColors.kSearchBarColor,
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => DetailedDestinationView(
                                            isFromDrawer: isFromDrawer,
                                            isFromHome: isFromHome,
                                            location: location,
                                          ),
                                        ),
                                      );
                                      MixPanelEvents.clickedOnCountryEvent(location);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              location.logo.toString(),
                                              style: FontUtils.SF.copyWith(fontSize: 26, color: FontColors.white71),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            SizedBox(
                                              width: Dimens.width(55, context),
                                              child: Text(
                                                location.name.toString(),
                                                style: FontUtils.SF.copyWith(
                                                    fontSize: Dimens.currentSize(context, 16, 18, 20),
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return const SizedBox(
                                  height: 15,
                                );
                              },
                            ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
