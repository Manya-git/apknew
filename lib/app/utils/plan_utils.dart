import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ride_mobile/app/models/data_usage_model.dart';
import 'package:ride_mobile/app/models/plan_model.dart';
import 'package:ride_mobile/app/utils/string_utils.dart';

class PlanUtils {
  static String getPlan(PlanModel plan) {
    if (plan.stripeProductId!.isEmpty) {
      return "You haven't purchased a plan yet";
    } else {
      // split data by space
      var data = plan.data!.split(" ")[0];
      var length = data.length;
      // if length is greater than 4, then set the data to the first 4 characters
      if (length > 4) {
        data = data.substring(0, 4);
      }
      return "${plan.country!} ${totalData(plan)} - Valid for ${PlanUtils.getValidity(plan.validity!)}";
    }
  }

  static String getPlanPurchaseDate(DateTime purchaseDate) {
    // return the purchase date in the format of "dd MMM yyyy" and the time in the format of "hh:mm a"
    return DateFormat("dd MMM yyyy").format(purchaseDate.toLocal());
  }

  static String getPlanPurchaseDateInfo(DateTime purchaseDate) {
    // return the purchase date in the format of "dd MMM yyyy" and the time in the format of "hh:mm a"
    return DateFormat("dd MMM, yyyy").format(purchaseDate.toLocal());
  }

  static String getPlanExpiredAtDate(DateTime purchaseDate) {
    // return the purchase date in the format of "dd MMM yyyy" and the time in the format of "hh:mm a"
    return "${DateFormat("dd MMM yyyy").format(purchaseDate.toLocal())} at ${DateFormat("hh:mm a").format(purchaseDate.toLocal())}";
    return DateFormat('dd MMM yyyy').format(purchaseDate.toLocal());
  }

  static String getPlanExpiryDate(DateTime purchaseDate) {
    return DateFormat('dd MMM yyyy').format(purchaseDate.toLocal().add(const Duration(days: 90)));
  }

  static String getTotalData(DataUsageModel dataUsage) {
    StringUtils.debugPrintMode(dataUsage.totalData.toString());
    if (dataUsage.totalData == 0) {
      return "0 GB";
    } else {
      var totalData = dataUsage.totalData! / 1024;
      // if totalGb is less than 1, then return in MB.
      if (totalData < 1) {
        return "${dataUsage.totalData} MB";
      } else {
        var gb = "";
        dataUsage.totalData! > 999 || dataUsage.totalData! == 1
            ? gb = totalData.toInt().toString()
            : gb = totalData.toDouble().toStringAsFixed(2);
        return "$gb GB";
      }
    }
  }

  RxDouble getDataUsedPercentage(DataUsageModel dataUsage) {
    if (dataUsage.totalData == null || dataUsage.totalData == 0) {
      return 0.0.obs;
    } else {
      var percentage = (dataUsage.usedData! / dataUsage.totalData!) * 100;
      var intPercentage = percentage.toInt();
      var finalPercentage = intPercentage / 100;
      return finalPercentage.obs;
    }
  }

  static String getExpiryDate(DataUsageModel dataUsage) {
    if (dataUsage.endDate == null) {
      return "Unknown";
    } else {
      var x = DateTime.fromMillisecondsSinceEpoch(dataUsage.endDate! * 1000);
      var date = x.toLocal();
      // var date = dataUsage.endDate!.toLocal();
      // var date = DateTime.now().toLocal();
      // check if the difference between the current date and the expiry date is less than 1 day.
      if (date.difference(DateTime.now()).inDays < 1 && dataUsage.totalData! < 1024) {
        // calculate the difference between the current date and the expiry date in minutes and convert to hours.
        var hours = date.difference(DateTime.now()).inMinutes / 60;
        // round the hours to the integer value less than the hours.
        var roundedHours = hours.floor();
        // StringUtils.debugPrintMode("hours: $roundedHours");
        if (roundedHours < 1) {
          return "${date.difference(DateTime.now()).inMinutes} mins";
        } else {
          // return in hours and minutes.
          var minutes = date.difference(DateTime.now()).inMinutes % 60;
          return "$roundedHours hrs $minutes mins";
        }
      } else {
        return DateFormat('dd MMM yyyy').format(date);
      }
    }
  }

  static String getValidity(var validity) {
    var validityString = "";
    // if validity is less than 1 convert it to hours and round it off
    if (validity < 1) {
      var hours = validity * 24;
      var roundedHours = hours.round();
      validityString = roundedHours.toString();
      // if validity is less than 1 set validityString to hour else hours
      int.parse(validityString) < 2 ? validityString += " Hour" : validityString += " Hours";
    } else {
      validityString = validity.toString();
    }
    var suffix = "";
    // if validity is less than  1, set the suffix to hours and if validity is equal to 1, set the suffix to day else set the suffix to days
    validity < 1
        ? suffix = ""
        : validity == 1
            ? suffix = "Day"
            : suffix = "Days";
    return "$validityString" " " + suffix;
  }

  static String totalData(PlanModel plan) {
    var data = plan.data!.split(" ")[0];
    var dataUnit = plan.data!.split(" ")[1];
    // if data is less than 1, convert it to MB and round it off and set the data to the rounded value
    if (double.parse(data) < 1) {
      var mb = double.parse(data) * 1024;
      var roundedMb = mb.round();
      data = roundedMb.toString();
      // set the data unit to MB
      dataUnit = "MB";
    }
    var length = data.length;
    // if length is greater than 4, then set the data to the first 4 characters
    if (length > 4) {
      data = data.substring(0, 4);
    }
    return data + " " + dataUnit;
  }
}
