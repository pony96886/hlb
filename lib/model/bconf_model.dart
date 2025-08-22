// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class BconfModel {
  BconfModel({
    this.img_upload_url,
    this.mp4_upload_url,
    this.mobile_mp4_upload_url,
    this.upload_img_key,
    this.upload_mp4_key,
    this.office_site,
    this.official_group,
    this.lines_url,
    this.tips_share_text,
    this.solution,
    this.proxy_join_num,
    this.img_base,
    this.github_url,
    this.custom_create_price,
    this.custom_custom_price,
    this.girl_unlock_price,
    this.forever_www,
    this.enable_share,
    this.play_tip,
    this.multipart_url,
    this.multipart_key,
    this.multipart_complete_url,
    this.pwa_download_url,
    this.title,
    this.keywords,
    this.description,
    this.medal_rules,
    this.sign_in_rules,
    this.login_tips,
    this.nav_id,
    this.aw_id,
    this.sort_video,
    this.sort_second_video,
    this.feedback_reason,
    this.check_xf,
  });

  String? img_upload_url;
  String? mp4_upload_url;
  String? mobile_mp4_upload_url;
  String? upload_img_key;
  String? upload_mp4_key;
  String? office_site;
  String? official_group;
  List<String>? lines_url;
  String? tips_share_text;
  String? forever_www;
  String? solution;
  int? proxy_join_num;
  String? img_base;
  String? github_url;
  int? custom_create_price;
  int? custom_custom_price;
  int? girl_unlock_price;
  int? enable_share;
  String? play_tip;
  String? multipart_url;
  String? multipart_key;
  String? multipart_complete_url;
  String? pwa_download_url;

  //seo设置 针对web
  String? title;
  String? keywords;
  String? description;
  String? medal_rules;
  String? sign_in_rules;
  String? login_tips;

  int? nav_id;
  int? aw_id;
  List<dynamic>? sort_video;
  List<dynamic>? sort_second_video;

  List<String>? feedback_reason;
  String? check_xf;

  factory BconfModel.fromJson(Map<String, dynamic> json) => BconfModel(
    img_upload_url: json['img_upload_url'] ?? "",
    mp4_upload_url: json['mp4_upload_url'] ?? "",
    mobile_mp4_upload_url: json['mobile_mp4_upload_url'] ?? "",
    upload_img_key: json['upload_img_key'] ?? "",
    upload_mp4_key: json['upload_mp4_key'] ?? "",
    office_site: json['office_site'] ?? "",
    official_group: json['official_group'] ?? "",
    forever_www: json['forever_www'] ?? "",
    lines_url: json['lines_url'] == null
        ? []
        : List<String>.from(json['lines_url'].map((x) => x)),
    tips_share_text: json['tips_share_text'] ?? "",
    solution: json['solution'] ?? "",
    proxy_join_num: json['proxy_join_num'] ?? 0,
    img_base: json['img_base'] ?? "",
    github_url: json['github_url'] ?? "",
    custom_create_price: json["custom_create_price"] ?? 0,
    custom_custom_price: json["custom_custom_price"] ?? 0,
    girl_unlock_price: json["girl_unlock_price"] ?? 0,
    enable_share: json["enable_share"] ?? 0,
    play_tip: json["play_tip"] ?? "",
    multipart_url: json['multipart_url'] ?? "",
    multipart_key: json['multipart_key'] ?? "",
    multipart_complete_url: json['multipart_complete_url'] ?? "",
    pwa_download_url: json['pwa_download_url'] ?? "",
    title: json["title"] ?? "",
    keywords: json["keywords"] ?? "",
    description: json["description"] ?? "",
    medal_rules: json["medal_rules"] ?? "",
    sign_in_rules: json["sign_in_rules"] ?? "",
    login_tips: json["login_tips"] ?? "",
    nav_id: json['nav_id'] ?? 1,
    aw_id: json['aw_id'] ?? 1,
    sort_video: json["sort_video"] == null
        ? []
        : List<dynamic>.from(json["sort_video"].map((x) => x)),
    sort_second_video: json["sort_second_video"] == null
        ? []
        : List<dynamic>.from(json["sort_second_video"].map((x) => x)),
    feedback_reason: json['feedback_reason'] == null
        ? []
        : List<String>.from(json['feedback_reason'].map((x) => x)),
    check_xf: json["check_xf"] ?? "",
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    "img_upload_url": img_upload_url,
    "mp4_upload_url": mp4_upload_url,
    "mobile_mp4_upload_url": mobile_mp4_upload_url,
    "upload_img_key": upload_img_key,
    "upload_mp4_key": upload_mp4_key,
    "forever_www": forever_www,
    "office_site": office_site,
    "official_group": official_group,
    "lines_url": lines_url?.map((e) => e),
    "tips_share_text": tips_share_text,
    "solution": solution,
    "proxy_join_num": proxy_join_num,
    "img_base": img_base,
    "github_url": github_url,
    "custom_create_price": custom_create_price,
    "custom_custom_price": custom_custom_price,
    "girl_unlock_price": girl_unlock_price,
    "enable_share": enable_share,
    "play_tip": play_tip,
    "multipart_url": multipart_url,
    "multipart_key": multipart_key,
    "multipart_complete_url": multipart_complete_url,
    "pwa_download_url": pwa_download_url,
    "title": title,
    "keywords": keywords,
    "description": description,
    "medal_rules": medal_rules,
    "sign_in_rules": sign_in_rules,
    "login_tips": login_tips,
    "nav_id": nav_id,
    "aw_id": aw_id,
    "sort_video": sort_video == null
        ? []
        : List<dynamic>.from(sort_video!.map((x) => x)),
    "sort_second_video": sort_video == null
        ? []
        : List<dynamic>.from(sort_second_video!.map((x) => x)),
    "feedback_reason": feedback_reason?.map((e) => e),
    "check_xf": check_xf,
  };
}
