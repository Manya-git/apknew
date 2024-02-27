import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/destination/controllers/destination_controller.dart';
import 'package:ride_mobile/app/utils/keys.dart';

import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/font_utils.dart';

class DestinationSearchField extends StatefulWidget {
  const DestinationSearchField({Key? key}) : super(key: key);

  @override
  State<DestinationSearchField> createState() => _DestinationSearchFieldState();
}

class _DestinationSearchFieldState extends State<DestinationSearchField> with WidgetsBindingObserver {
  DestinationController controller = Get.put(DestinationController());

  @override
  Widget build(BuildContext context) {
    Get.put(DestinationController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Search by Country",
          style: FontUtils.SF.copyWith(
              fontSize: Dimens.currentSize(context, 12, 14, 16), color: Colors.white, fontWeight: FontWeight.w400),
        ),
        const SizedBox(
          height: 7,
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: Dimens.currentSize(context, 50, 50, 70),
          decoration: BoxDecoration(
            color: AppColors.kSearchBarColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            shape: BoxShape.rectangle,
          ),
          child: TextFormField(
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.left,
            key: DestinationPageKeys.searchFieldKey,
            cursorColor: FontColors.white71,
            controller: controller.searchController,
            maxLines: 1,
            onChanged: (val) => controller.search(),
            style: FontUtils.SF.copyWith(
                fontSize: Dimens.currentSize(context, 14, 16, 18), color: Colors.white, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              constraints: const BoxConstraints(),
              isCollapsed: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              border: InputBorder.none,
              suffixIcon: null,
              prefixIcon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.5),
                  child: Icon(
                    CupertinoIcons.search,
                    color: AppColors.bgButtonColor,
                    size: 22,
                  )),
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: "Search",
              hintStyle: FontUtils.SF.copyWith(
                  fontSize: Dimens.currentSize(context, 14, 16, 18),
                  color: FontColors.kHintColor,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ],
    );
  }
}
