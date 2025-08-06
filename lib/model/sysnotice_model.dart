import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class SysNoticeModel {
  SysNoticeModel({
    this.systemNoticeCount = 0,
    this.feedCount = 0,
    this.systemNotice,
    this.feed,
  });

  int systemNoticeCount;
  int feedCount;
  NoticeFeedModel? systemNotice;
  NoticeFeedModel? feed;

  factory SysNoticeModel.fromJson(Map<String, dynamic> json) => SysNoticeModel(
        systemNoticeCount: json["systemNoticeCount"] ?? 0,
        feedCount: json["feedCount"] ?? 0,
        systemNotice: json["systemNotice"] == null
            ? null
            : NoticeFeedModel.fromJson(json["systemNotice"]),
        feed: json["feed"] == null
            ? null
            : NoticeFeedModel.fromJson(json["feed"]),
      );

  Map<String, dynamic> toJson() => {
        "systemNoticeCount": systemNoticeCount,
        "feedCount": feedCount,
        "systemNotice": systemNotice?.toJson(),
        "feed": feed?.toJson(),
      };
}

@JsonSerializable(explicitToJson: true)
class NoticeFeedModel {
  NoticeFeedModel({
    this.id = 0,
    this.uuid,
    this.userIp,
    this.question,
    this.messageType = 0,
    this.helpType,
    this.image1,
    this.status = 0,
    this.isRead = 0,
    this.evaluation = 0,
    this.createdAt,
    this.updatedAt,
    this.isReplay = 0,
  });

  int id;
  String? uuid;
  String? userIp;
  String? question;
  int messageType;
  dynamic helpType;
  String? image1;
  int status;
  int isRead;
  int evaluation;
  String? createdAt;
  String? updatedAt;
  int isReplay;

  factory NoticeFeedModel.fromJson(Map<String, dynamic> json) =>
      NoticeFeedModel(
        id: json["id"],
        uuid: json["uuid"],
        userIp: json["user_ip"],
        question: json["question"],
        messageType: json["message_type"],
        helpType: json["help_type"],
        image1: json["image_1"],
        status: json["status"],
        isRead: json["is_read"],
        evaluation: json["evaluation"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        isReplay: json["is_replay"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "user_ip": userIp,
        "question": question,
        "message_type": messageType,
        "help_type": helpType,
        "image_1": image1,
        "status": status,
        "is_read": isRead,
        "evaluation": evaluation,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "is_replay": isReplay,
      };
}
