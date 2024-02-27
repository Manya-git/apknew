import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/destination/controllers/destination_controller.dart';
import 'package:ride_mobile/app/services/mix_panel/events.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';
import 'package:ride_mobile/app/utils/keys.dart';

import '../../modules/detailed_destination/views/detailed_destination_view.dart';
import '../../utils/loading_indicators.dart';
import '../../utils/no_result_found_card.dart';

class PopularZones extends GetView<DestinationController> {
  final bool isFromHome;
  final bool isFromDrawer;
  const PopularZones({Key? key, required this.isFromHome, required this.isFromDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(DestinationController());
    return Entry.opacity(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Popular Zones",
            style: FontUtils.SF.copyWith(fontSize: 15, color: Colors.white),
          ),
          const SizedBox(
            height: 7,
          ),
          Obx(
            () => MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: SizedBox(
                child: controller.isLoadingZone.value
                    ? Center(
                        child: SizedBox(
                            height: 200, child: LoadingIndicators.circularIndicator(25, 2.5, AppColors.kOrangeColor)))
                    : SizedBox(
                        child: controller.popularZones.isEmpty
                            ? const NoResultFoundCard(message: "No results found")
                            : ListView.separated(
                                key: DestinationPageKeys.popularZonesListKey,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: controller.popularZones.length,
                                itemBuilder: (context, index) {
                                  var zone = controller.popularZones[index];
                                  return Container(
                                    height: 55,
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                        color: FontColors.kOrangeColor80,
                                        width: 1,
                                      ),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(() => DetailedDestinationView(
                                              isFromDrawer: isFromDrawer,
                                              isFromHome: isFromHome,
                                              location: zone,
                                            ));
                                        MixPanelEvents.clickedOnZoneEvent(zone);
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Image.network(zone.logo!, height: 22, width: 22),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Text(
                                                zone.name!,
                                                style: FontUtils.SF
                                                    .copyWith(fontSize: 15, color: FontColors.kOrangeColor90),
                                              ),
                                            ],
                                          ),
                                          Icon(
                                            Icons.keyboard_arrow_right_outlined,
                                            color: FontColors.kOrangeColor90,
                                            size: 24,
                                          )
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
          ),
        ],
      ),
    );
  }
}
