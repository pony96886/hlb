import 'package:hlw/model/imchat_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'general_ads_model.dart';

// @JsonSerializable(explicitToJson: true)
// class UserModel {
//   UserModel({
//     this.user,
//     this.share_text,
//     this.tips_share_text,
//     this.ad,
//     this.menu,
//     this.share,
//   });
//   UserInfoModel? user;
//   String? share_text;
//   String? tips_share_text;
//   List<GeneralAdsModel>? ad;
//   List<dynamic>? menu;
//   UserShareModel? share;
//
//   factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
//       share_text: json['share_text'] ?? "",
//       tips_share_text: json['tips_share_text'] ?? "",
//       user: json['user'] == null ? null : UserInfoModel.fromJson(json["user"]),
//       share:
//       json['share'] == null ? null : UserShareModel.fromJson(json["share"]),
//       ad: json['ad'] == null
//           ? []
//           : List<GeneralAdsModel>.from(
//           json["ad"].map((x) => GeneralAdsModel.fromJson(x))),
//       menu: json['ad'] == null ? [] : List.from(json["menu"] ?? []));
//
//   Map<String, dynamic> toJson() => <String, dynamic>{
//     "share_text": share_text,
//     "tips_share_text": tips_share_text,
//     "user": user?.toJson(),
//     "share": share?.toJson(),
//     "ad": ad?.map((e) => e),
//     "menu": menu?.map((e) => e),
//   };
// }

@JsonSerializable(explicitToJson: true)
class UserModel {
  UserModel({
    this.uid,
    this.uuid,
    this.username,
    this.created_at,
    this.updated_at,
    this.role_id,
    this.gender,
    this.regip,
    this.regdate,
    this.lastip,
    this.expired_at,
    this.lastpost,
    this.oltime,
    this.pageviews,
    this.score,
    this.aff,
    this.channel,
    this.invited_by,
    this.invited_num,
    this.ban_post,
    this.post_num,
    this.login_count,
    this.app_version,
    this.validate,
    this.thumb,
    this.coins,
    this.money,
    this.proxy_money,
    this.vip_level,
    this.auth_status,
    this.exp,
    this.chat_uid,
    this.phone,
    this.phone_prefix,
    this.free_view_cnt,
    this.income_money,
    this.lastactivity,
    this.income_total,
    this.post_count,
    this.topic_count,
    this.follow_count,
    this.tags,
    this.email,
    this.fans_count,
    this.new_user,
    this.share,
    this.nickname,
    this.chat,
    this.point,
    this.broker_auth,
    this.girl_auth,
    this.unread_reply,
    this.create_content,
    this.navigation,
  });

  ImChatModel? chat;
  int? uid;
  String? uuid;
  String? username;
  String? nickname;
  String? created_at;
  String? updated_at;
  int? role_id;
  int? gender;
  String? regip;
  String? regdate;
  String? lastip;
  String? expired_at;
  int? lastpost;
  int? oltime;
  int? pageviews;
  int? score;
  int? aff;
  String? channel;
  String? invited_by;
  int? invited_num;
  int? ban_post;
  int? post_num;
  int? login_count;
  String? app_version;
  int? validate;
  String? thumb;
  int? coins;
  int? money;
  String? proxy_money;
  int? vip_level;
  int? auth_status;
  int? broker_auth;
  int? girl_auth;
  int? exp;
  int? point;
  String? chat_uid;
  String? phone;
  String? phone_prefix;
  int? free_view_cnt;
  String? lastactivity;
  int? income_total;
  int? income_money;
  int? post_count;
  int? topic_count;
  int? follow_count;
  String? tags;
  String? email;
  int? fans_count;
  bool? new_user;
  int? unread_reply;

  ShareModel? share;
  ActivityModel? navigation;
  CreateContentModel? create_content;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json['uid'] ?? 0,
        uuid: json['uuid'] ?? "",
        username: json['username'] ?? "",
        nickname: json['nickname'] ?? "",
        created_at: json['created_at'] ?? "",
        role_id: json['role_id'] ?? 0,
        gender: json['gender'] ?? 0,
        regip: json['regip'] ?? "",
        regdate: json['regdate'] ?? "",
        lastip: json['lastip'] ?? "",
        expired_at: json['expired_at'] ?? "",
        lastpost: json['lastpost'] ?? 0,
        oltime: json['oltime'] ?? 0,
        pageviews: json['pageviews'] ?? 0,
        score: json['score'] ?? 0,
        aff: json['aff'] ?? 0,
        channel: json['channel'] ?? "",
        invited_by: json['invited_by'] ?? "",
        invited_num: json['invited_num'] ?? 0,
        ban_post: json['ban_post'] ?? 0,
        post_num: json['post_num'] ?? 0,
        login_count: json['login_count'] ?? 0,
        app_version: json['app_version'] ?? "",
        validate: json['validate'] ?? 0,
        thumb: json['thumb'] ?? "",
        coins: json['coins'] ?? 0,
        money: json['money'] ?? 0,
        proxy_money: json['proxy_money'] ?? "",
        vip_level: json['vip_level'] ?? 0,
        auth_status: json['auth_status'] ?? 0,
        broker_auth: json['broker_auth'] ?? 0,
        girl_auth: json['girl_auth'] ?? 0,
        exp: json['exp'] ?? 0,
        point: json['point'] ?? 0,
        chat_uid: json['chat_uid'] ?? "",
        phone: json['phone'] ?? "",
        phone_prefix: json['phone_prefix'] ?? "",
        free_view_cnt: json['free_view_cnt'] ?? 0,
        income_money: json['income_money'] ?? 0,
        lastactivity: json['lastactivity'] ?? "",
        unread_reply: json['unread_reply'] ?? 0,
        income_total: json['income_total'] ?? 0,
        post_count: json['post_count'] ?? 0,
        topic_count: json['topic_count'] ?? 0,
        follow_count: json['follow_count'] ?? 0,
        email: json['email'] ?? "",
        tags: json['tags'] ?? "",
        fans_count: json['fans_count'] ?? 0,
        new_user: json['new_user'] ?? false,
        share:
            json['share'] == null ? null : ShareModel.fromJson(json['share']),
        navigation: json['navigation'] == null
            ? null
            : ActivityModel.fromJson(json['navigation']),
        create_content: json['create_content'] == null
            ? null
            : CreateContentModel.fromJson(json['create_content']),
        chat: json["chat"] == null ? null : ImChatModel.fromJson(json["chat"]),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "uid": uid,
        "uuid": uuid,
        "username": username,
        "nickname": nickname,
        "created_at": created_at,
        "role_id": role_id,
        "gender": gender,
        "regip": regip,
        "regdate": regdate,
        "lastip": lastip,
        "expired_at": expired_at,
        "lastpost": lastpost,
        "oltime": oltime,
        "pageviews": pageviews,
        "score": score,
        "aff": aff,
        "channel": channel,
        "invited_by": invited_by,
        "invited_num": invited_num,
        "ban_post": ban_post,
        "post_num": post_num,
        "login_count": login_count,
        "app_version": app_version,
        "validate": validate,
        "thumb": thumb,
        "coins": coins,
        "money": money,
        "proxy_money": proxy_money,
        "vip_level": vip_level,
        "auth_status": auth_status,
        "broker_auth": broker_auth,
        "girl_auth": girl_auth,
        "exp": exp,
        "point": point,
        "chat_uid": chat_uid,
        "phone": phone,
        "phone_prefix": phone_prefix,
        "free_view_cnt": free_view_cnt,
        "lastactivity": lastactivity,
        "unread_reply": unread_reply,
        "income_total": income_total,
        "income_money": income_money,
        "post_count": post_count,
        "topic_count": topic_count,
        "follow_count": follow_count,
        "tags": tags,
        "email": email,
        "fans_count": fans_count,
        "new_user": new_user,
        "share": share?.toJson(),
        "chat": chat?.toJson(),
        "create_content": create_content?.toJson(),
      };
}

@JsonSerializable(explicitToJson: true)
class ShareModel {
  ShareModel({this.aff_code, this.share_url, this.share_text});
  String? aff_code;
  String? share_url;
  String? share_text;

  factory ShareModel.fromJson(Map<String, dynamic> json) => ShareModel(
        aff_code: json['aff_code'] ?? "",
        share_url: json['share_url'] ?? "",
        share_text: json['share_text'] ?? "",
      );
  Map<String, dynamic> toJson() => <String, dynamic>{
        "aff_code": aff_code,
        "share_url": share_url,
        "share_text": share_text,
      };
}

@JsonSerializable(explicitToJson: true)
class ActivityModel {
  ActivityModel({this.ad_big, this.ad1, this.ad2});

// ad_big = 奖励公告
// ad1 = 第一个
// ad2 = 第二个
  dynamic ad_big;
  dynamic ad1;
  dynamic ad2;

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
        ad_big: json['ad_big'],
        ad1: json['ad1'],
        ad2: json['ad2'],
      );
  Map<String, dynamic> toJson() => <String, dynamic>{
        "ad_big": ad_big,
        "ad1": ad1,
        "ad2": ad2,
      };
}

//是否具有权限发布文章
@JsonSerializable(explicitToJson: true)
class CreateContentModel {
  CreateContentModel({this.allow, this.msg});

  int? allow;
  String? msg;

  factory CreateContentModel.fromJson(Map<String, dynamic> json) =>
      CreateContentModel(
        allow: json['allow'] ?? 0,
        msg: json['msg'] ?? '',
      );
  Map<String, dynamic> toJson() => <String, dynamic>{
        "allow": allow,
        "msg": msg,
      };
}
