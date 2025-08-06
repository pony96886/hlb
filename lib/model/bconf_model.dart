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
      };
}
