import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';

import '../models/location_model.dart';

class CurrentLocation {
  static Future<LocationModel> getCountryCode() async {
    WidgetsFlutterBinding.ensureInitialized();
    await CountryCodes.init();
    final CountryDetails details = CountryCodes.detailsForLocale();
    var country = LocationModel(
      name: details.localizedName,
      dialCode: details.dialCode,
    );
    return country;
  }
}
