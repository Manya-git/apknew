import 'dart:convert';

DataUsageModel dataUsageModelFromJson(String str) => DataUsageModel.fromJson(json.decode(str));

class DataUsageModel {
  DataUsageModel({
    this.totalData,
    this.usedData,
    this.remainData,
    this.endDate,
  });

  int? totalData;
  int? usedData;
  int? remainData;
  // DateTime? endDate;
  int? endDate;

  factory DataUsageModel.fromJson(Map<String, dynamic> json) => DataUsageModel(
        totalData: json["total_data_size_in_MB"] ?? 0,
        usedData: json["used_data_size_in_MB"] ?? 0,
        remainData: json["remaining_data_in_MB"] ?? 0,
        endDate: json["end_date"] ?? 0,
        // endDate: DateTime.parse(json["end_date"]??DateTime.now()),
      );
}

List<DataUsageModelAll> dataUsageModelAllFromJson(String str) =>
    List<DataUsageModelAll>.from(json.decode(str).map((x) => DataUsageModelAll.fromJson(x)));

String dataUsageModelAllToJson(List<DataUsageModelAll> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DataUsageModelAll {
  int? totalDataSizeInMb;
  int? usedDataSizeInMb;
  int? remainingDataInMb;
  int? endDate;
  String? subscriptionId;

  DataUsageModelAll({
    this.totalDataSizeInMb,
    this.usedDataSizeInMb,
    this.remainingDataInMb,
    this.endDate,
    this.subscriptionId,
  });

  factory DataUsageModelAll.fromJson(Map<String, dynamic> json) => DataUsageModelAll(
        totalDataSizeInMb: json["total_data_size_in_MB"] ?? 0,
        usedDataSizeInMb: json["used_data_size_in_MB"] ?? 0,
        remainingDataInMb: json["remaining_data_in_MB"] ?? 0,
        endDate: json["end_date"] ?? 0,
        subscriptionId: json["subscriptionId"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "total_data_size_in_MB": totalDataSizeInMb,
        "used_data_size_in_MB": usedDataSizeInMb,
        "remaining_data_in_MB": remainingDataInMb,
        "end_date": endDate,
        "subscriptionId": subscriptionId,
      };
}
