import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/models/location_model.dart';
import 'package:ride_mobile/app/services/destination_api.dart';
import 'package:ride_mobile/app/services/get_current_location.dart';

import '../../../services/auth_api.dart';
import '../../../services/user/local preferences.dart';

class DestinationController extends GetxController {
  var currentSegment = 0.obs;
  TextEditingController searchController = TextEditingController();
  var popularDestinations = <LocationModel>[].obs;
  var popularZones = <LocationModel>[].obs;
  var destinations = <LocationModel>[].obs;
  var zones = <LocationModel>[].obs;
  var isLoadingDestination = false.obs;
  var isLoadingZone = false.obs;
  var currentLocation = LocationModel(name: "", dialCode: "").obs;

  void searchByDestination() {
    if (searchController.text.trim().isEmpty) {
      popularDestinations.value = destinations.where((element) => element.isPopular!).toList();
    } else {
      popularDestinations.value = destinations
          .where(
              (element) => element.name.toString().toLowerCase().contains(searchController.text.trim().toLowerCase()))
          .toList();
    }
  }

  void searchByZone() {
    if (currentSegment.value == 1) {
      if (searchController.text.trim().isEmpty) {
        popularZones.value = zones.where((element) => element.isPopular!).toList();
      } else {
        popularZones.value = zones
            .where(
                (element) => element.name.toString().toLowerCase().contains(searchController.text.trim().toLowerCase()))
            .toList();
      }
    }
  }

  void search() {
    if (currentSegment.value == 0) {
      searchByDestination();
    } else {
      searchByZone();
    }
  }

  @override
  void onInit() {
    setData();
    getCurrentLocation();
    getUser();
    super.onInit();
  }

  @override
  void onClose() {}

  void setData() {
    getDestinations();
    // getZones();
  }

  void getCurrentLocation() async {
    LocationModel country = await CurrentLocation.getCountryCode();
    currentLocation.value = country;
  }

  void getDestinations() async {
    isLoadingDestination.value = true;
    var data = await DestinationAPI.fetchDestinations();
    popularDestinations.assignAll(data.where((element) => element.isPopular!));
    destinations.assignAll(data);
    isLoadingDestination.value = false;
  }

  void getZones() async {
    isLoadingZone.value = true;
    var data = await DestinationAPI.fetchZones();
    popularZones.assignAll(data.where((element) => element.isPopular!));
    zones.assignAll(data);
    isLoadingZone.value = false;
  }

  void getUser() async {
    String email = await LocalPreferences.getUserEmail();
    String password = await LocalPreferences.getUserPassword();
    if (email.isNotEmpty && password.isNotEmpty) {
      await AuthAPI.loginUser(email, password);
    }
  }
}
