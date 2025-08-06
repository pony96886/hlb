
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class GeneralAdsModel {
  GeneralAdsModel({
    this.id,
    this.name,
    this.position,
    this.thumb,
    this.thumb_width,
    this.thumb_height,
    this.advertiser_id,
    this.status,
    this.created_at,
    this.updated_at,
    this.show_width,
    this.show_height,
    this.type,
    this.url_config,
    this.router,
    this.advertiser_name,
    this.advertiser_url,
    this.pos_tip,
  });
  int? id;
  String? name;
  int? position;
  String? thumb;
  int? thumb_width;
  int? thumb_height;
  int? advertiser_id;
  int? status;
  String? created_at;
  String? updated_at;
  int? show_width;
  int? show_height;
  int? type;
  String? url_config;
  String? router;
  String? advertiser_name;
  String? advertiser_url;
  String? pos_tip;

  factory GeneralAdsModel.fromJson(Map<String, dynamic> json) =>
      GeneralAdsModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? "",
        position: json['position'] ?? 0,
        thumb: json['thumb'] ?? "",
        thumb_width: json['thumb_width'] ?? 100,
        thumb_height: json['thumb_height'] ?? 100,
        type: json['type'] ?? 0,
        advertiser_id: json['advertiser_id'] ?? 0,
        status: json['status'] ?? 0,
        created_at: json['created_at'] ?? "",
        updated_at: json['updated_at'] ?? "",
        show_width: json['show_width'] ?? 100,
        show_height: json['show_height'] ?? 100,
        url_config: json['url_config'] ?? "",
        router: json['router'] ?? "",
        advertiser_name: json['advertiser_name'] ?? "",
        advertiser_url: json['advertiser_url'] ?? "",
        pos_tip: json['pos_tip'] ?? "",
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id,
        "name": name,
        "position": position,
        "thumb": thumb,
        "thumb_width": thumb_width,
        "thumb_height": thumb_height,
        "type": type,
        "advertiser_id": advertiser_id,
        "status": status,
        "created_at": created_at,
        "updated_at": updated_at,
        "show_width": show_width,
        "show_height": show_height,
        "url_config": url_config,
        "router": router,
        "advertiser_name": advertiser_name,
        "advertiser_url": advertiser_url,
        "pos_tip": pos_tip,
      };
}
