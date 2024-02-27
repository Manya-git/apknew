import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/registration/controllers/country_code_controller.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';
import 'package:ride_mobile/app/utils/keys.dart';

import '../utils/colors.dart';

class MobileNumberIcon extends GetView<CountryCodeController> {
  const MobileNumberIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CountryCodeController());
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                padding: const EdgeInsets.only(left: 10),
                child: InkWell(
                  key: RegistrationPageKeys.countryCodePickerKey,
                  onTap: () => controller.openCountryPicker(),
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Obx(
                          () => Text(
                            controller.currentCountryCode.value.dialCode!,
                            style: FontUtils.SF.copyWith(fontSize: 16, color: Colors.white),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_sharp,
                          color: FontColors.white71,
                          size: 22,
                        ),
                        Container(
                          height: 25,
                          width: 1.25,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ));
  }
}

class CountryCodePickerRegistration extends GetView<CountryCodeController> {
  const CountryCodePickerRegistration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CountryCodeController());
    return PopupMenuButton<int>(
        //offset:  Offset(60, Dimens.height(20, context)),
        //key: controller.countryPickerKey,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        elevation: 10,
        child: Container(
          color: Colors.transparent,
          child: Row(
            children: [
              Obx(
                () => Text(
                  controller.currentCountryCode.value.dialCode!,
                  style: FontUtils.SF.copyWith(fontSize: 15, color: FontColors.kBlackColor90),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_sharp,
                color: FontColors.kBlackColor65,
                size: 22,
              ),
              Container(
                height: 25,
                width: 1.25,
                color: FontColors.kBlackColor65,
              ),
            ],
          ),
        ),
        onSelected: (item) {},
        itemBuilder: (context) {
          return controller.countries
              .asMap()
              .map((i, country) => MapEntry(
                  i,
                  PopupMenuItem(
                      onTap: () => controller.selectCountryCode(country),
                      value: i,
                      child: SizedBox(
                        width: 175,
                        child: Text(
                          country.logo! + "   " + country.dialCode!.toString() + "  " + country.name!,
                          style: FontUtils.SF,
                        ),
                      ))))
              .values
              .toList();
        });
  }
}
