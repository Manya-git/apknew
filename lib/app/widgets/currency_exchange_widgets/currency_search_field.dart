import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/currency/controllers/currency_controller.dart';
import 'package:ride_mobile/app/utils/keys.dart';

import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/font_utils.dart';

class CurrencySearchField extends StatefulWidget {
  const CurrencySearchField({Key? key}) : super(key: key);

  @override
  State<CurrencySearchField> createState() => _CurrencySearchFieldState();
}

class _CurrencySearchFieldState extends State<CurrencySearchField> with WidgetsBindingObserver {
  CurrencyController controller = Get.put(CurrencyController());

  @override
  Widget build(BuildContext context) {
    Get.put(CurrencyController());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Search Currency",
            style: FontUtils.SF.copyWith(
                fontSize: Dimens.currentSize(context, 12, 14, 16), color: Colors.white, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 7,
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: Dimens.currentSize(context, 45, 50, 70),
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
              onChanged: (val) => controller.searchCurrency(),
              style: FontUtils.SF.copyWith(
                  fontSize: Dimens.currentSize(context, 14, 16, 18), color: Colors.white, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                constraints: const BoxConstraints(),
                // contentPadding: EdgeInsets.zero,
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
                    fontSize: Dimens.currentSize(context, 12, 14, 16),
                    color: FontColors.kHintColor,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
