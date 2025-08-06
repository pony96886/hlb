import 'package:json_annotation/json_annotation.dart';

import 'general_ads_model.dart';
import 'version_model.dart';

@JsonSerializable(explicitToJson: true)
class ConfigModel {
  ConfigModel({
    this.timestamp,
    this.adAlert,
    this.version,
    this.adStart,
    this.pc_seo_description,
    this.tips_share_text,
    this.office_site,
    this.tg_group,
    this.client_forum_bbs,
    this.client_official_tg,
    this.client_withdraw_tg,
    this.official_twitter,
    this.official_wx,
    this.source_cdn,
    this.statistics_domain,
    this.share_url,
    this.plate_tab,
    this.welfare_tab,
    this.solution,
    this.lines_url,
    this.github_url,
    this.img_base,
    this.upload_img_key,
    this.img_upload_url,
    this.upload_mp4_key,
    this.mp4_upload_url,
    this.ask,
    this.contribute,
    this.question,
    this.contact,
    this.share,
    this.pc_site_url,
    this.paymentTips,
    this.how_to_win_score,
    this.hl_bbs,
    this.hl_app,
    this.hl_read,
    this.client_withdraw_rule,
  });
  int? timestamp;
  List<dynamic>? plate_tab;
  List<dynamic>? welfare_tab;
  List<GeneralAdsModel>? adAlert;
  VersionModel? version;
  List<dynamic>? adStart;
  String? pc_seo_description;
  String? tips_share_text;
  String? office_site;
  String? tg_group;
  String? client_forum_bbs;
  String? client_official_tg;
  String? client_withdraw_tg;
  String? official_twitter;
  String? official_wx;
  String? source_cdn;
  String? statistics_domain;
  String? share_url;
  String? solution;
  List<String>? lines_url;
  String? github_url;
  String? img_base;
  String? upload_img_key;
  String? img_upload_url;
  String? upload_mp4_key;
  String? mp4_upload_url;
  int? ask;
  int? contribute;
  int? question;
  int? contact;
  int? share;
  String? pc_site_url;
  String? paymentTips;
  String? how_to_win_score;
  String? hl_bbs;
  String? hl_app;
  String? hl_read;

  String? client_withdraw_rule;

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
      ask: json['ask'] ?? 0,
      contribute: json['contribute'] ?? 0,
      question: json['question'] ?? 0,
      contact: json['contact'] ?? 0,
      share: json['share'] ?? 0,
      timestamp: json['timestamp'] ?? 0,
      adAlert: json['adAlert'] == null
          ? []
          : List<GeneralAdsModel>.from(
              json['adAlert'].map((x) => GeneralAdsModel.fromJson(x))),
      version: json['version'] == null
          ? null
          : VersionModel.fromJson(json['version']),
      adStart: json['adStart'] is List
          ? List<GeneralAdsModel>.from(
              json['adStart'].map((x) => GeneralAdsModel.fromJson(x)))
          : json['adStart'] is Map
              ? [GeneralAdsModel.fromJson(json['adStart'])]
              : [],
      plate_tab: List.from(json["plate_tab"] ?? []),
      welfare_tab: List.from(json["welfare_tab"] ?? []),
      pc_seo_description: json['pc_seo_description'] ?? "",
      tips_share_text: json['tips_share_text'] ?? "",
      office_site: json['office_site'] ?? "",
      tg_group: json['tg_group'] ?? "",
      client_forum_bbs: json['client_forum_bbs'] ?? "",
      client_official_tg: json['client_official_tg'] ?? "",
      client_withdraw_tg: json['client_withdraw_tg'] ?? "",
      official_twitter: json['official_twitter'] ?? "",
      official_wx: json['official_wx'] ?? "",
      source_cdn: json['source_cdn'] ?? "",
      statistics_domain: json['statistics_domain'] ?? "",
      share_url: json['share_url'] ?? "",
      solution: json['solution'] ?? "",
      lines_url: json['lines_url'] == null
          ? []
          : List<String>.from(json['lines_url'].map((x) => x)),
      github_url: json['github_url'] ?? "",
      img_base: json['img_base'] ?? "",
      upload_img_key: json['upload_img_key'] ?? "",
      img_upload_url: json['img_upload_url'] ?? "",
      upload_mp4_key: json['upload_mp4_key'] ?? "",
      mp4_upload_url: json['mp4_upload_url'] ?? "",
      pc_site_url: json["pc_site_url"] ?? "",
      paymentTips: json["paymentTips"] ?? "",
      how_to_win_score: json["how_to_win_score"] ?? "",
      hl_bbs: json["hl_bbs"] ?? "",
      hl_read: json["hl_read"] ?? "",
      hl_app: json["hl_app"] ?? "",
      client_withdraw_rule: json['client_withdraw_rule'] ?? '');

  Map<String, dynamic> toJson() => <String, dynamic>{
        "ask": ask,
        "contribute": contribute,
        "question": question,
        "contact": contact,
        "timestamp": timestamp,
        "adAlert": adAlert?.map((e) => e.toJson()),
        "version": version?.toJson(),
        "adStart": adStart?..map((e) => e.toJson()),
        "plate_tab": plate_tab?.map((e) => e),
        "welfare_tab": welfare_tab?.map((e) => e),
        "pc_seo_description": pc_seo_description,
        "tips_share_text": tips_share_text,
        "office_site": office_site,
        "tg_group": tg_group,
        "client_forum_bbs": client_forum_bbs,
        "client_official_tg": client_official_tg,
        "client_withdraw_tg": client_withdraw_tg,
        "official_twitter": official_twitter,
        "official_wx": official_wx,
        "source_cdn": source_cdn,
        "statistics_domain": statistics_domain,
        "share_url": share_url,
        "solution": solution,
        "lines_url": lines_url?.map((e) => e),
        "github_url": github_url,
        "img_base": img_base,
        "upload_img_key": upload_img_key,
        "img_upload_url": img_upload_url,
        "upload_mp4_key": upload_mp4_key,
        "mp4_upload_url": mp4_upload_url,
        "pc_site_url": pc_site_url,
        "paymentTips": paymentTips,
        "how_to_win_score": how_to_win_score,
        "hl_bbs": hl_bbs,
        "hl_app": hl_app,
        "hl_read": hl_read,
        'client_withdraw_rule': client_withdraw_rule,
      };
}
