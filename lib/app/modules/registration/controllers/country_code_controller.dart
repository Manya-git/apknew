import 'package:get/get.dart';

import '../../../models/location_model.dart';
import '../../../services/auth_api.dart';
import '../../../services/get_current_location.dart';
import '../../../widgets/country_picker_dialog.dart';

class CountryCodeController extends GetxController {

  var countries = <LocationModel>[].obs;
  var unfilteredCountries = <LocationModel>[].obs;
  var currentCountryCode = LocationModel(name: "", dialCode: "", logo: "").obs;

  @override
  onInit() {
    getCurrentCountryCode();
    getCountryCodes();
    super.onInit();
  }

  Future<void> getCurrentCountryCode() async {
    var code = await CurrentLocation.getCountryCode();
    currentCountryCode.value = code;
  }

  Future<void> getCountryCodes() async {
    var codes = await AuthAPI.fetchCountryCodes();
    countries.assignAll(codes.where((element) => element.dialCode.toString().isNotEmpty));
    unfilteredCountries.assignAll(codes.where((element) => element.dialCode.toString().isNotEmpty));
  }

  void selectCountryCode(LocationModel code) {
    currentCountryCode.value = code;
    Get.back();
  }

  void searchCountry(String val) {
    countries.value = unfilteredCountries.where((element) => element.name.toString().toLowerCase().contains(val.trim().toLowerCase())).toList();
  }

  void openCountryPicker() {
    Get.dialog(CountryPickerDialog(
      countries: countries,
      onTap: (LocationModel code) => selectCountryCode(code),
      onChanged: (val) => searchCountry(val),
    )).whenComplete(() async {
      await Future.delayed(const Duration(seconds: 1));
      countries.value = unfilteredCountries;
    });
  }

}
