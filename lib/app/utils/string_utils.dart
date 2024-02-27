import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class StringUtils {
  static String getResponseMessage(String message) {
    try {
      return jsonDecode(message)['message'];
    } on FormatException catch (e) {
      return "Something went wrong";
    }
  }

  static String getCurrencySymbol(String currencyCode) {
    String name = currencyCode.toUpperCase();
    var format = NumberFormat.simpleCurrency(locale: Platform.localeName, name: name);
    return format.currencySymbol.toUpperCase();
  }

  static void debugPrintMode(var message) {
    if (kDebugMode) {
      print(message);
    }
  }

  static String TC1 = "1. VALIDITY OF GENERAL TERMS AND CONDITIONS";
  static String TC2 = "2. DESCRIPTION OF SERVICES";
  static String TC3 = "3. START, DURATION, AND TERMINATION OF THE CONTRACT";
  static String TC4 = "4. CHARGES AND PAYMENT";
  static String TC5 = "5. DELIVERY";
  static String TC6 = "6. REFUND / CANCELLATION / MODIFICATION POLICY";
  static String TC7 = "7. LIABILITY AND WARRANTY";

  static String TC11 =
      "The following terms and conditions shall apply to all services rendered by Glowing Bud LLC, hereafter referred to as Glowing Bud, in connection with offering digital solutions for Telecoms and eSIM domain. The following terms and conditions are provided on the website www.glowingbud.com Glowing Bud may accept variant clauses only in the case of an explicit written agreement.";

  static String TC21 =
      "2.1. eSIM Subscription : Glowing Bud provides services to verify, activate and renew eSIM subscription. The customer registers and buys its eSIM’s subscription on www.glowingbud.com  website or App. Our payments are operated by Apple Pay (https://www.apple.com/apple-pay/) and Stripe (https://stripe.com) with an alias of your credit card (virtual Credit Card Imprint).";
  static String TC22 =
      "2.2. REGISTRATION FOR USING : Glowing Bud SERVICESThe customer must accept the general terms and conditions to use Glowing Bud services. The client gives directly, or by the intermediary of the service provider (Hotel, Travel Agency…), on the web browser under  www.glowingbud.com   the following information: First Name Last Name Address (billing address) Email address.";
  static String TC23 =
      "2.3. Glowing Bud ENGAGEMENTS : Glowing Bud shall use reasonable endeavors to provide Customer quality of service. However, Glowing Bud does not guarantee that the service will not be interrupted, furnished on due time, safe or fault-free.";
  static String TC24 =
      "2.4. CUSTOMER ENGAGEMENTS : In using the Equipment or Services provided by Glowing Bud, the Customer must not engage in any action: that is abusive, illegal, or fraudulent; that causes the Network to be impaired or damaged; When the Customer is in breach of its obligations under this Sec. 2.4, Glowing Bud may suspend the Customer’s use of the Service. Glowing Bud will notify the Customer as soon as reasonably practicable of the suspension. During any period of suspension, the Customer shall continue to pay all Charges due under this Agreement in respect of the suspended Services. ";
  static String TC25 =
      "2.5. DEVICE COMPATIBILITY : It is the customer's responsibility to ensure that the device is eSIM compatible and network-unlocked. By checking “I have an eSIM compatible and network-unlocked device” for proceeding with the purchase, the customer is held responsible for this information. As device compatibility may depend on the carrier and country of origin, the customer must check the list of eSIM compatible devices provided at the checkout. The eSIM compatibility list is not exhaustive, meaning that there might be newly announced eSIM compatible devices that have not yet been added.";

  static String TC31 =
      "The service contract between Glowing Bud and the customer starts upon completing an order at GLowing Bud’s website https://www.glowingbud.com/ or via app. The Activation of the eSIM and acknowledgment of the Activation Policy is the Customer’s responsibility. The contract will be terminated if the customer does not have an active data package or has deleted the eSIM from the device.";

  static String TC41 =
      "4.1. PAYMENT CONDITIONS : The payment of Glowing Bud services is made by Credit Card, and Apple Pay. The currency of payment is US Dollars (\$). The credit card transaction will be processed and secured by Glowing Bud providers Apple Pay  (https://www.apple.com/apple-pay/)and Stripe (https://stripe.com).";
  static String TC42 =
      "4.2. CHARGES FOR USE : 4.2.1. Glowing Bud states all Charges inclusive of VAT, unless specified otherwise.\n4.2.2. The customer shall not be entitled to set off any of its claims against the claims of Glowing Bud, except where the customer’s claims are undisputed or have been confirmed by final court judgment.";

  static String TC51 =
      "The customer will immediately see the purchased eSIM under the “Managed plans ” tab on the website and/or the app. The customer will receive a confirmation email after the purchase. All the information for installing the eSIM will be available only on the user’s Glowing Bud’s account.";

  static String TC61 =
      "6.1. REFUNDS AND CANCELLATION : 6.1.1. POLICIES AND GUIDELINES\n6.1.2. A refund request can be made within thirty (30) days from the date of purchase when the activation is no longer possible following extensive troubleshooting.\n6.1.3. If the eSIM is already in use and an issue arises that originates from Glowing Bud that cannot be resolved within a timely manner, a refund can be issued for the remaining data.\n6.1.4. Cooperation of the customer to resolve the issue promptly is extremely necessary as otherwise, the refund may not be granted.\n6.1.5. Each data package has its own validity period. No refunds of any form will be offered for the remaining data when the validity period expires.\n6.1.6. Compensation: No refunds or remuneration of any kind will be issued due to charges from alternate phones, alternate SIM cards, hotel phones, or other charges that are not directly linked to the customer’s Glowing Bud eSIM account. (See section 7. LIABILITY AND WARRANTY in our Terms and Conditions)\n6.1.7. Fraudulent purchases: Airalo reserves the right to refuse any form of refund if there is any evidence of abuse, violation of our terms and conditions, or any fraudulent activities that are connected with using Airalo products and services.\n6.1.7.1.Unauthorized purchases: The case will be subject to investigation and approval before processing any refund. Airalo reserves the right to suspend any account associated with any form of fraudulent activity.\n6.1.8. Accidental purchases: Once customers install the eSIM, it will be considered as used. No refunds of any form will be offered.\n6.1.9. Incorrect charges: If the customer reasonably and in good faith disputes an invoice or part of it, the Customer shall notify Airalo of such dispute within 12 days of receipt of the invoice, providing details of why the invoiced amount is incorrect and, if possible, how much the customer considers is due. (See details in section 4.2 CHARGES FOR USE under Terms and Conditions)\n6.1.10. Other Reasons: If the refund request is not within the above, we will investigate the request on a case-by-case basis. If the refund is approved, a processing fee may apply. The maximum refund of credit a customer can apply for must be equal to or less than the total amount they paid.\n6.1.11. REFUND PROCESSTo request a refund, contact Glowing Bud support team via the Contact Us page or send a message to support@glowingbud.com Please be aware that our refund policy above will apply. Depending on the nature of the issue, customers will be asked for further information to support their refund request such as screenshots of the device settings for technical issues or details of why the invoiced amount is incorrect and, if possible, how much the customer considers is due, etc. Please refer to section 6.1.2 in this same document for refunds related to technical issues. Customers will have the option to credit back through their original payment method (credit card or Apple Pay) : 6.2. MODIFICATIONThe eSIM data packages from Glowing Bud are offered as-is and no further modifications or customization can be made based on individual requests once purchased.";

  static String TC71 =
      "Glowing Bud is not responsible for detriments arising as a result, that the proposed service is not or not constantly available. Glowing Bud provides no guarantee of constant availability of the network service. For any requests, please write an email to support@glowingbud.com";
}
