import 'package:http/http.dart' as http;
import 'package:ride_mobile/app/models/plan_model.dart';
import 'package:ride_mobile/app/services/user/current_user.dart';
import 'package:ride_mobile/app/utils/string_utils.dart';

import '../models/location_model.dart';
import '../utils/assets.dart';
import 'basic_api.dart';

class DestinationAPI {
  static Future<List<LocationModel>> fetchDestinations() async {
    var url = Uri.parse("${BasicAPI.baseURL}countries?customerId=${Assets.GB_ID}");
    StringUtils.debugPrintMode(url);
    var response = await http.get(url);
    StringUtils.debugPrintMode(response.body);
    if (response.statusCode == 200) {
      List<LocationModel> destinations = locationModelFromJson(response.body, true);
      return destinations;
    } else {
      return <LocationModel>[];
    }
  }

  static Future<List<LocationModel>> fetchZones() async {
    var url = Uri.parse("${BasicAPI.baseURL}zones");
    StringUtils.debugPrintMode(url);
    var response = await http.get(url);
    StringUtils.debugPrintMode(response.body);
    if (response.statusCode == 200) {
      List<LocationModel> zones = locationModelFromJson(response.body, false);
      return zones;
    } else {
      return <LocationModel>[];
    }
  }

  static Future<List<PlanModel>> fetchPlans(
      String selectedCountry, String selectedZone, bool isCountry, bool isZone) async {
    var url = isCountry
        ? Uri.parse(
            "${BasicAPI.baseURL}plans?isCountry=$isCountry&countrySelected=$selectedCountry&customerId=${Assets.GB_ID}")
        : Uri.parse("${BasicAPI.baseURL}plans?isZone=$isZone&zoneSelected=$selectedZone");
    StringUtils.debugPrintMode(url);
    var response;
    if (CurrentUser().currentUser.token != null && CurrentUser().currentUser.token != "") {
      response = await http.get(url, headers: {
        'Authorization': 'Bearer ${CurrentUser().currentUser.token.toString()}',
        'Content-Type': 'application/json'
      });
    } else {
      response = await http.get(url);
    }
    StringUtils.debugPrintMode(response.body);
    if (response.statusCode == 200) {
      List<PlanModel> products = productModelFromJson(response.body);
      StringUtils.debugPrintMode(products.length);
      return products;
    } else {
      return <PlanModel>[];
    }
  }

  static Future<List<PlanModel>> fetchSinglePlans(String productId, String country) async {
    if (country == "") {
      country = "United States";
    }
    var url = Uri.parse("${BasicAPI.baseURL}plans/${productId}?country=${country}");
    StringUtils.debugPrintMode(url);
    var response;
    if (CurrentUser().currentUser.token != null && CurrentUser().currentUser.token != "") {
      response = await http.get(url, headers: {
        'Authorization': 'Bearer ${CurrentUser().currentUser.token.toString()}',
        'Content-Type': 'application/json'
      });
    } else {
      response = await http.get(url);
    }
    StringUtils.debugPrintMode(response.body);
    if (response.statusCode == 200) {
      List<PlanModel> products = productModelFromJson(response.body);
      return products;
    } else {
      return <PlanModel>[];
    }
  }
}
