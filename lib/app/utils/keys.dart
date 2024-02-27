import 'package:flutter/material.dart';

class CommonKeys {
  static const Key rideMobileLogoKey = Key("ride_mobile_logo");
  static const Key gbMobileLogoWhiteKey = Key("gb_mobile_logo_white");
  static const Key authBgImageKey = Key("auth_background_image");
  static const Key goBackButtonKey = Key("go_back_button");
  static const Key blurredContainerKey = Key("blurred_container");
  static const Key circularLoadingIndicatorKey = Key("circular_loading_indicator");
  static const Key countriesDialogListKey = Key("countries_dialog_list");
}

class LandingPageKeys {
  static const Key shopForPlanButtonKey = Key("shop_for_plan");
  static const Key loginTextButtonKey = Key("login_text_button");
}

class LoginPageKeys {
  static const Key emailFieldKey = Key("email_field_login");
  static const Key passwordFieldKey = Key("password_field_login");
  static const Key loginButtonKey = Key("login_button");
  static const Key forgotPasswordTextButtonKey = Key("forgot_password_text_button");
}

class ForgotPasswordKeys {
  static const Key emailFieldKey = Key("email_field_forgot_password");
  static const Key passwordFieldKey = Key("password_field_forgot_password");
  static const Key submitButtonKey = Key("submit_button_forgot_password");
  static const Key backToLoginTextButtonKey = Key("back_to_login_text_button");
}

class CodeVerificationKeys {
  static const Key submitButtonKey = Key("submit_button_code_verification");
  static const Key resetTextButtonKey = Key("reset_text_button_code_verification");
  static const Key codeVerificationInputKey = Key("code_verification_input");
}

class DestinationPageKeys {
  static const Key destinationHeaderImageKey = Key("destination_header_image");
  static const Key segmentControlKey = Key("segment_control");
  static const Key currentLocationWidgetKey = Key("current_location_widget");
  static const Key searchFieldKey = Key("destination_search");
  static const Key popularDestinationsListKey = Key("popular_destinations_list");
  static const Key popularZonesListKey = Key("popular_zones_list");
}

class RegistrationPageKeys {
  static const String path = "registration";
  static const Key firstNameKey = Key("${path}_first_name");
  static const Key lastNameKey = Key("${path}_last_name");
  static const Key emailAddressKey = Key("${path}_email_address");
  static const Key referal_codeKey = Key("${path}_referal_code");
  static const Key mobileNumberKey = Key("${path}_mobile_number");
  static const Key passwordKey = Key("${path}_password");

  static const Key repeatPasswordKey = Key("${path}_repeat_password");
  static const Key registerButtonKey = Key("${path}_register_button");
  static const Key privacyPolicyRadioButtonKey = Key("${path}_privacy_policy_radio_button");
  static const Key termsRadioButtonKey = Key("${path}_terms_radio_button");
  static const Key privacyPolicyTextButtonKey = Key("${path}_privacy_policy_text_button");
  static const Key termsTextButtonKey = Key("${path}_terms_text_button");
  static const Key countryCodePickerKey = Key("${path}_country_code_picker");
  static const Key showPasswordKey = Key("${path}_show_password");
  static const Key showRepeatPasswordKey = Key("${path}_show_repeat_password");
}

class HomeKeys {
  var bottomNavigatorKey = GlobalKey<State<BottomNavigationBar>>();

  // static const Key showRepeatPasswordKey = Key("${path}_show_repeat_password");
}
