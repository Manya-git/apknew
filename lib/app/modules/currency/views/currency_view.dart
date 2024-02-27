import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/utils/appString.dart';
import 'package:ride_mobile/app/widgets/buttons/primary_action_button.dart';
import 'package:ride_mobile/app/widgets/currency_exchange_widgets/currency_search_field.dart';
import 'package:ride_mobile/app/widgets/loader_view.dart';

import '../../../models/location_model.dart';
import '../../../models/plan_model.dart';
import '../../../utils/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/font_utils.dart';
import '../../../utils/keys.dart';
import '../../../utils/string_utils.dart';
import '../../../widgets/buttons/back_button.dart';
import '../controllers/currency_controller.dart';

class CurrencyView extends GetView<CurrencyController> {
  final String? from;
  final PlanModel? plan;
  final LocationModel? location;
  const CurrencyView({
    Key? key,
    this.from,
    this.plan,
    this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CurrencyController());
    return Scaffold(
      backgroundColor: AppColors.homeBGColor,
      body: SizedBox(
        height: Dimens.height(100, context),
        width: Dimens.width(100, context),
        child: Stack(
          children: [
            Image.asset(
              Assets.shop_bg,
              fit: BoxFit.fill,
              height: Dimens.height(100, context),
              width: Dimens.width(100, context),
              alignment: Alignment.topLeft,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: Dimens.getStatusBarHeight(context),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: ArrowedBackButton(),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          AppString().choose_your_currency(context),
                          textAlign: TextAlign.left,
                          style: FontUtils.TTFirsNeueTrial.copyWith(
                              fontSize: Dimens.currentSize(context, 18, 20, 22),
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 20, top: 11, bottom: 25),
                  child: Text(
                    AppString().choose_your_currency_details(context),
                    style: FontUtils.TTFirsNeueTrial.copyWith(
                        fontSize: Dimens.currentSize(context, 12, 14, 16),
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        height: 1.7),
                  ),
                ),
                Obx(() => controller.isLoadingCurrency.value
                    ? const Center(child: SizedBox())
                    : controller.currency.value.defaultCurrency != null
                        ? DefaultCureencyCard(
                            currencyName: controller.currency.value.defaultCurrency!.currencyName.toString(),
                            currencySymbol: controller.currency.value.defaultCurrency!.currency.toString(),
                          )
                        : const SizedBox.shrink()),
                const SizedBox(
                  height: 10,
                ),
                const CurrencySearchField(),
                Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(top: 15, bottom: 7, left: 23, right: 23),
                    child: Text(AppString().choose_currency(context),
                        style: FontUtils.SF.copyWith(
                            fontSize: Dimens.currentSize(context, 12, 14, 16),
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            height: 1.5))),
                Obx(() => controller.isLoadingCurrency.value
                    ? const Center(child: SizedBox(height: 200, child: LoaderView()))
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 23),
                          child: controller.currencyList.isNotEmpty
                              ? ListView.separated(
                                  shrinkWrap: false,
                                  padding: EdgeInsets.zero,
                                  key: DestinationPageKeys.popularDestinationsListKey,
                                  // physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.currencyList.length,
                                  itemBuilder: (context, index) {
                                    return _itemCurrency(index, context);
                                  },
                                  separatorBuilder: (BuildContext context, int index) {
                                    return const SizedBox(
                                      height: 15,
                                    );
                                  },
                                )
                              : Center(
                                  child: Text(
                                    "No data found!",
                                    style: FontUtils.SF.copyWith(color: AppColors.kSubText2, fontSize: 16),
                                  ),
                                ),
                        ),
                      )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(23, 20, 23, 50),
                  child: GetBuilder<CurrencyController>(
                    init: CurrencyController(),
                    initState: (_) {},
                    builder: (_) {
                      return PrimaryActionButton(
                        label: AppString().continue_key(context),
                        onTap: () {
                          if (_.selectedIndex != null) {
                            _.updateCurrency(_.currencyList[_.selectedIndex].currency!,
                                _.currencyList[_.selectedIndex].currencyName!, from,
                                plan: plan, location: location);
                          }
                        },
                        isLoading: _.isUpdating.value,
                        isDisable: _.selectedIndex != null ? false : true,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemCurrency(int index, BuildContext context) {
    return GetBuilder<CurrencyController>(
      init: CurrencyController(),
      initState: (_) {},
      builder: (_) {
        return InkWell(
          onTap: () => _.updateSelectedIndex(index),
          child: Container(
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: _.selectedIndex == index ? AppColors.kButtonColor : AppColors.kSearchBarColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              shape: BoxShape.rectangle,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      StringUtils.getCurrencySymbol(_.currencyList[index].currency!),
                      style: FontUtils.SF
                          .copyWith(fontSize: Dimens.currentSize(context, 16, 18, 20), color: FontColors.white71),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: Dimens.width(55, context),
                      child: Text(
                        // _.currency.value.currencyList![index].currencyName!,
                        _.currencyList[index].currencyName!,
                        style: FontUtils.SF
                            .copyWith(fontSize: Dimens.currentSize(context, 16, 18, 20), color: Colors.white),
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
    );
  }
}

class DefaultCureencyCard extends StatelessWidget {
  final String currencyName;
  final String currencySymbol;

  const DefaultCureencyCard({Key? key, required this.currencyName, required this.currencySymbol}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(bottom: 7),
              child: Text(AppString().default_currency(context),
                  style: FontUtils.SF.copyWith(
                    fontSize: Dimens.currentSize(context, 12, 14, 16),
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ))),
          Container(
            width: Dimens.width(100, context),
            height: Dimens.currentSize(context, 40, 50, 60),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.kBorderColor, width: 0.5)),
            child: Row(
              children: [
                Text(StringUtils.getCurrencySymbol(currencySymbol),
                    style: FontUtils.SF.copyWith(
                        fontSize: Dimens.currentSize(context, 14, 18, 18),
                        color: Colors.white,
                        fontWeight: FontWeight.w500)),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Text(
                    currencyName,
                    maxLines: 1,
                    style: FontUtils.SF.copyWith(
                        fontSize: Dimens.currentSize(context, 16, 18, 20),
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
