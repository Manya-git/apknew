import 'package:ride_mobile/app/models/location_model.dart';
import 'package:ride_mobile/app/models/plan_model.dart';
import 'mix_panel_init.dart';

class MixPanelEvents {

  static void shopForPlanEvent() {
    MixPanelAnalyticsManager.instance.sendEvent(
      eventName: 'shop for plan',
      properties: {
        'screen_called_from': 'Landing',
      },
    );
  }

  static void clickedOnCountryEvent(LocationModel location) {
    MixPanelAnalyticsManager.instance.sendEvent(
      eventName: 'clicked on a country',
      properties: {
        'screen_called_from': 'DestinationScreen',
        'country_name': location.name!,
        'country_dialCode': location.dialCode!,
        'is_country_popular': location.isPopular!,
        "country_flag": location.logo!,
        "country_shortcode": location.code!,
      },
    );
  }

  static void clickedOnZoneEvent(LocationModel location) {
    MixPanelAnalyticsManager.instance.sendEvent(
      eventName: 'clicked on a zone',
      properties: {
        'screen_called_from': 'DestinationScreen',
        'zone_name': location.name!,
        'is_zone_popular': location.isPopular!,
      },
    );
  }

  static void loginEvent() {
    MixPanelAnalyticsManager.instance.sendEvent(
      eventName: 'login',
      properties: {
        'api_endpoint': '/auth/signin',
        'status': 200,
        'screen_called_from': 'LoginScreen',
      },
    );
  }

  static void logoutEvent() {
    MixPanelAnalyticsManager.instance.sendEvent(
      eventName: 'logout',
      properties: {
        'status': 200,
        'screen_called_from': 'AccountScreen',
      },
    );
  }

  static void registrationEvent() {
    MixPanelAnalyticsManager.instance.sendEvent(
      eventName: 'registration',
      properties: {
        'api_endpoint': '/auth/signup',
        'status': 200,
        'screen_called_from': 'RegistrationScreen',
      },
    );
  }

  static void supportTicketEvent(String name, String email, String message) {
    MixPanelAnalyticsManager.instance.sendEvent(
      eventName: 'support',
      properties: {
        'api_endpoint': '/support-request',
        'status': 200,
        'screen_called_from': 'SupportScreen',
        'name': name,
        'email': email,
        'message': message,
      },
    );
  }

  static void paymentSuccessfulEvent(PlanModel plan) {
    MixPanelAnalyticsManager.instance.sendEvent(
      eventName: 'payment successful',
      properties: {
        'api_endpoint': '/create-user-session',
        'status': 200,
        'screen_called_from': 'PaymentScreen',
        'product_id': plan.stripeProductId!
      },
    );
  }

  static void iccidGeneratedEvent(String iccid) {
    MixPanelAnalyticsManager.instance.sendEvent(
      eventName: 'iccid generated',
      properties: {
        'api_endpoint': '/activation/get-iccid',
        'status': 200,
        'screen_called_from': 'InstallationScreen',
        'iccid': iccid
      },
    );
  }

  static void iccidGenerationFailedEvent(String iccid) {
    MixPanelAnalyticsManager.instance.sendEvent(
      eventName: 'iccid generation failed',
      properties: {
        'api_endpoint': '/activation/get-iccid',
        'status': 400,
        'screen_called_from': 'InstallationScreen',
        'iccid': iccid.isEmpty  ? 'null' : iccid
      },
    );
  }

  static void activationStringGeneratedEvent(String activationString) {
    MixPanelAnalyticsManager.instance.sendEvent(
      eventName: 'activation string generated',
      properties: {
        'api_endpoint': '/activation/get-activation-code',
        'status': 200,
        'screen_called_from': 'InstallationScreen',
        'activation_string': activationString
      },
    );
  }

}
