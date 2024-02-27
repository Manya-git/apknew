import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/no_result_found_card.dart';
import 'package:ride_mobile/app/widgets/auth_widgets/custom_prefix_icon.dart';

import '../models/location_model.dart';
import '../utils/font_utils.dart';
import '../utils/keys.dart';

class CountryPickerDialog extends StatelessWidget {
  final RxList<LocationModel> countries;
  final Function onTap;
  final Function onChanged;

  const CountryPickerDialog({Key? key, required this.countries, required this.onTap, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0) + const EdgeInsets.only(top: 20, bottom: 5),
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            alignment: Alignment.center,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              shape: BoxShape.rectangle,
              border: Border.all(
                color: AppColors.kOrangeColor,
                width: 0.75,
              ),
            ),
            child: TextFormField(
              onChanged: (val) => onChanged(val),
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.left,
              textCapitalization: TextCapitalization.words,
              cursorHeight: 16,
              cursorColor: AppColors.kOrangeColor,
              style: FontUtils.SF.copyWith(fontSize: 15, color: FontColors.kOrangeColor90),
              decoration: InputDecoration(
                constraints: const BoxConstraints(),
                contentPadding: const EdgeInsets.only(
                  top: 5,
                ),
                border: InputBorder.none,
                prefixIcon: const CustomPrefixIcon(icon: CupertinoIcons.search),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: "Search for a country...",
                hintStyle: FontUtils.SF.copyWith(fontSize: 15, color: FontColors.kBlackColor65),
              ),
            ),
          ),
          Obx(
            () => Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: SizedBox(
                  child: countries.isEmpty
                      ? const NoResultFoundCard(message: "No countries found")
                      : ListView.builder(
                          key: CommonKeys.countriesDialogListKey,
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          itemCount: countries.length,
                          itemBuilder: (context, index) {
                            var country = countries[index];
                            return InkWell(
                              onTap: () => onTap(country),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12.5),
                                child: Text(
                                  country.logo! + "   " + country.dialCode!.toString() + "  " + country.name!,
                                  style: FontUtils.SF.copyWith(color: FontColors.kBlackColor80, fontSize: 16),
                                ),
                              ),
                            );
                          }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
