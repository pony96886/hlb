import 'package:hlw/model/imchat_model.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class UserModel {
  UserModel(
      {this.uid,
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
        this.fans_count,
        this.new_user,
        this.share,
        this.nickname,
        this.chat,
        this.point,
        this.broker_auth,
        this.girl_auth,
        this.unread_reply,
        this.comment_unread,
        this.topic_comment_unread,
        this.medal_list,
        this.vip_str,
        this.signData,
        this.email,
        this.navigation});

  String? email;
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
  int? fans_count;
  bool? new_user;
  int? unread_reply;
  int? comment_unread;
  int? topic_comment_unread;

  ShareModel? share;
  ActivityModel? navigation;
  List<MedalListModel>? medal_list;

  String? vip_str;

  dynamic signData;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    email: json["email"] ?? "",
    vip_str: json["vip_str"] ?? "",
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
    comment_unread: json['comment_unread'] ?? 0,
    topic_comment_unread: json['topic_comment_unread'] ?? 0,
    income_total: json['income_total'] ?? 0,
    post_count: json['post_count'] ?? 0,
    topic_count: json['topic_count'] ?? 0,
    follow_count: json['follow_count'] ?? 0,
    tags: json['tags'] ?? "",
    fans_count: json['fans_count'] ?? 0,
    new_user: json['new_user'] ?? false,
    share:
    json['share'] == null ? null : ShareModel.fromJson(json['share']),
    navigation: json['navigation'] == null
        ? null
        : ActivityModel.fromJson(json['navigation']),
    chat: json["chat"] == null ? null : ImChatModel.fromJson(json["chat"]),
    medal_list: json['medal_list'] == null
        ? []
        : List<MedalListModel>.from(
        json['medal_list'].map((x) => MedalListModel.fromJson(x))),
    signData: json['signData'] ?? null,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    "email": email,
    "vip_str": vip_str,
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
    "comment_unread": comment_unread,
    "topic_comment_unread": topic_comment_unread,
    "income_total": income_total,
    "income_money": income_money,
    "post_count": post_count,
    "topic_count": topic_count,
    "follow_count": follow_count,
    "tags": tags,
    "fans_count": fans_count,
    "new_user": new_user,
    "share": share?.toJson(),
    "chat": chat?.toJson(),
    "medal_list": medal_list?.map((e) => e.toJson()).toList(),
    "signData": signData,
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

@JsonSerializable(explicitToJson: true)
class MedalListModel {
  MedalListModel({
    this.id,
    this.aff,
    this.mid,
    this.is_wear,
    this.created_at,
    this.name,
    this.img_url,
    this.desc,
    this.img_url_full,
    this.is_wear_str,
  });

  int? id;
  int? aff;
  int? mid;
  int? is_wear;
  String? created_at;
  String? name;
  String? img_url;
  String? desc;
  String? img_url_full;
  String? is_wear_str;

  factory MedalListModel.fromJson(Map<String, dynamic> json) => MedalListModel(
    id: json['id'] ?? 0,
    aff: json['aff'] ?? 0,
    mid: json['mid'] ?? 0,
    is_wear: json['is_wear'] ?? "",
    created_at: json['created_at'] ?? "",
    name: json['name'] ?? "",
    img_url: json['img_url'] ?? "",
    desc: json['desc'] ?? "",
    img_url_full: json['img_url_full'] ?? "",
    is_wear_str: json['is_wear_str'] ?? "",
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    "id": id,
    "aff": aff,
    "mid": mid,
    "is_wear": is_wear,
    "created_at": created_at,
    "name": name,
    "img_url": img_url,
    "desc": desc,
    "img_url_full": img_url_full,
    "is_wear_str": is_wear_str,
  };
}
