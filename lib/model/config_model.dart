import 'package:hlw/model/ads_model.dart';
import 'package:hlw/model/alert_ads_model.dart';
import 'package:hlw/model/bconf_model.dart';
import 'package:hlw/model/help_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'general_ads_model.dart';
import 'version_model.dart';

@JsonSerializable(explicitToJson: true)
class ConfigModel {
  ConfigModel({
    this.timestamp,
    this.help,
    this.config,
    this.notice,
    this.versionMsg,
    this.ads,
    this.pop_ads,
    this.popup_apps,
    this.floating_ads,
  });
  int? timestamp;
  List<HelpModel>? help;
  BconfModel? config;
  AlertAdsModel? notice;
  List<AlertAdsModel>? pop_ads;
  VersionModel? versionMsg;
  AdsModel? ads;
  List? popup_apps;
  List<dynamic>? floating_ads = [];

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
    timestamp: json['timestamp'] ?? 0,
    help: json['help'] == null
        ? []
        : List<HelpModel>.from(
        json['help'].map((x) => HelpModel.fromJson(x))),
    config:
    json['config'] == null ? null : BconfModel.fromJson(json['config']),
    notice: json['notice'] == null
        ? null
        : AlertAdsModel.fromJson(json['notice']),
    versionMsg: json['versionMsg'] == null
        ? null
        : VersionModel.fromJson(json['versionMsg']),
    ads: json['ads'] == null ? null : AdsModel.fromJson(json['ads']),
    pop_ads: json['pop_ads'] == null
        ? []
        : List<AlertAdsModel>.from(
        json['pop_ads'].map((x) => AlertAdsModel.fromJson(x))),
    popup_apps:
    json['popup_apps'] == null ? [] : List.from(json['popup_apps']),
    floating_ads:
    json['floating_ads'] == null ? [] : List.from(json['floating_ads']),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    "timestamp": timestamp,
    "help": help?.map((e) => e.toJson()),
    "config": config?.toJson(),
    "notice": notice?.toJson(),
    "versionMsg": versionMsg?.toJson(),
    "ads": ads?.toJson(),
    "pop_ads": pop_ads?.map((e) => e.toJson()),
    "popup_apps": popup_apps?.map((e) => e.toJson()),
    "floating_ads": floating_ads?.map((e) => e.toJson()),
  };
}
