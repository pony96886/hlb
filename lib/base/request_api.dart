import 'package:hlw/base/base_store.dart';
import 'package:hlw/model/config_model.dart';
import 'package:hlw/model/response_model.dart';
import 'package:hlw/model/sysnotice_model.dart';
import 'package:hlw/model/user_model.dart';
import 'package:hlw/util/app_global.dart';
import 'package:hlw/util/network_http.dart';
import 'package:hlw/util/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 线路检测 - 上传失效地址
Future<ResponseModel<dynamic>?> reqReportLine({List? list}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post(
        '/api/home/domainCheckReport',
        data: {"list": list});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 获取全局config接口
Future<ResponseModel<ConfigModel>?> reqConfig(BuildContext context) async {
  try {
    // Response<dynamic> res = await NetworkHttp.post('/api/index/config');
    Response<dynamic> res =
        await NetworkHttp.post('/api/home/config');
    Utils.log(res.data);
    ResponseModel<ConfigModel> tp = ResponseModel<ConfigModel>.fromJson(
        res.data, (json) => ConfigModel.fromJson(json));
    if (tp.data != null) {
      //存储基础数据
      Provider.of<BaseStore>(context, listen: false).setConfig(tp.data!);
      AppGlobal.imgBaseUrl = tp.data?.config?.img_base ?? "";
      AppGlobal.uploadImgKey = tp.data?.config?.upload_img_key ?? "";
      AppGlobal.uploadImgUrl = tp.data?.config?.img_upload_url ?? "";
      AppGlobal.uploadMp4Key = tp.data?.config?.upload_mp4_key ?? "";
      AppGlobal.uploadMp4Url = tp.data?.config?.mp4_upload_url ?? "";
    }
    return tp;
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 获取用户信息数据
Future<ResponseModel<UserModel>?> reqUserInfo(BuildContext context) async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/user/userInfo');
    Utils.log(res.data);
    ResponseModel<UserModel> tp = ResponseModel<UserModel>.fromJson(
        res.data, (json) => UserModel.fromJson(json));
    if (tp.data != null) {
      //存储用户数据
      Provider.of<BaseStore>(context, listen: false).setUser(tp.data!);
      AppGlobal.vipLevel = tp.data?.vip_level ?? 0;
    }
    return tp;
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

// Future<ResponseModel<dynamic>?> reqUserMeun(BuildContext context) async {
//   try {
//     Response<dynamic> res = await NetworkHttp.post('/api/index/getClientMenu');
//     Utils.log(res.data);
//     // ResponseModel<UserModel> tp = ResponseModel<UserModel>.fromJson(
//     //     res.data, (json) => UserModel.fromJson(json));
//     // if (tp.data != null) {
//     //   //存储用户数据
//     //   Provider.of<BaseStore>(context, listen: false).setUser(tp.data!);
//     //   AppGlobal.vipLevel = tp.data?.vip_level ?? 0;
//     // }
//     // return tp;
//     return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
//   } catch (e) {
//     Utils.log(e);
//     return null;
//   }
// }

/// 联系官方
Future<ResponseModel<dynamic>?> reqContactList() async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/home/getContactList');
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 广告接口
Future<ResponseModel<dynamic>?> reqAds({required int position_id}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/index/getClientAds',
        data: {"position_id": position_id});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// Ad点击统计
Future<ResponseModel<dynamic>?> reqAdClickCount({int? id, int? type}) async {
  try {
    if (id == null || type == null) throw Exception('id or type not null');
    Response<dynamic> res =
        await NetworkHttp.post('/api/index/clientClickReport', data: {
      'id': id,
      'type': type,
    });
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

///
/// 首页
///

/// 看片-分类
Future<ResponseModel<dynamic>?> reqVideoCategory() async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/videos/list_category');
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 看片分类列表
Future<ResponseModel<dynamic>?> reqVideoCategoryList(
    {int id = 0, String sort = '', int page = 1, int pageSize = 20}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/videos/list_contents',
        data: {"id": id, 'sort': sort, "page": page, 'limit': pageSize});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 首页黑料-分类列表
Future<ResponseModel<dynamic>?> reqHomeCategoryList(
    {int id = 0, int page = 1, int pageSize = 18}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/contents/list_contents',
        data: {"mid": id, "page": page, 'limit': pageSize});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 内容-详情页面
Future<ResponseModel<dynamic>?> reqDetailContent({String cid = "0"}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/index/pcDetail',
        data: {"article_id": cid});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 内容-详情页评论
Future<ResponseModel<dynamic>?> reqDetailComment({
  int type = 1,
  String id = "0",
  int page = 1,
  String last_ix = "0",
}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/index/comments', data: {
      "type": type,
      "id": id,
      "page": page,
      "last_ix": last_ix,
    });
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 內容-上下篇
Future<ResponseModel<dynamic>?> reqDetailArticle({
  String cid = "0",
}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post(
        '/api/index/getArticlePrevNext',
        data: {"id": cid});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 内容-收藏
Future<ResponseModel<dynamic>?> reqCollectContent({String cid = "0"}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post(
        '/api/index/triggerMyFavorite',
        data: {"cid": cid});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 内容-详情页发表评论
Future<ResponseModel<dynamic>?> reqReplayComment({
  int type = 0,
  String id = '0',
  String content = "",
}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/index/comment', data: {
      "type": type,
      "id": id,
      "content": content,
    });
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 内容-标签
Future<ResponseModel<dynamic>?> reqArticleTag({
  String id = '0',
}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/index/getArticleTag', data: {"id": id});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 發佈標籤
Future<ResponseModel<dynamic>?> reqReleaseTags() async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/index/getArticleTagList');
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 预览文章
Future<ResponseModel<dynamic>?> reqPreviewContent({
  String? article_id,
  String title = '',
  String thumb = '',
  String content = '',
  String tags = '',
}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/index/getPreviewArticle', data: {
      'article_id': article_id,
      'title': title,
      'thumb': thumb,
      'content': content,
      'tag': tags,
    });
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    return null;
  }
}

/// 发布文章
Future<ResponseModel<dynamic>?> reqPostContent({
  String? article_id,
  String title = '',
  String thumb = '',
  String content = '',
  String tags = '',
}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/index/addArticle', data: {
      'article_id': article_id,
      'title': title,
      'thumb': thumb,
      'content': content,
      'tag': tags,
    });
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    return null;
  }
}

/// 稿费-投稿记录
Future<ResponseModel<dynamic>?> reqPostRecord(
    {int page = 1, int state = 0}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/index/getMyArticle',
        data: {'page': page, 'state': state});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 稿费-提现记录
Future<ResponseModel<dynamic>?> reqWithdrawalRecord({int page = 1}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post(
        '/api/withdraw/list_withdraw',
        data: {"page": page});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 用户余额
Future<ResponseModel<dynamic>?> reqUserOver() async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/index/getBalance');
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 稿费-收益记录
Future<ResponseModel<dynamic>?> reqPostContentIncome({int page = 1}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/index/getBalanceList',
        data: {"page": page});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

//内容-列表
Future<ResponseModel<dynamic>?> reqCollectList(
    {int page = 1, String lastIx = ""}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/index/myFavorite', data: {
      "page": page,
      "lastIx": lastIx,
    });
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

//内容-详情页回复列表
Future<ResponseModel<dynamic>?> reqReplayList({
  String cid = "0",
  String coid = "0",
  int page = 1,
}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/contents/list_reply_comments', data: {
      "cid": cid,
      "coid": coid,
      "page": page,
    });
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

//标签内容页面
Future<ResponseModel<dynamic>?> reqLabelContent({
  String mid = "0",
  int page = 1,
}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/contents/list_contents_tag', data: {
      "mid": mid,
      "page": page,
    });
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

//首页-标签列表
Future<ResponseModel<dynamic>?> reqLabelList({int page = 1}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/contents/list_tags', data: {"page": page});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 填写邀请码
Future<ResponseModel<dynamic>?> reqInvitation({String? affCode}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/user/invitation',
        data: {'aff_code': affCode});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 兑换
Future<ResponseModel<dynamic>?> reqOnExchange({String? cdk}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/home/exchange', data: {'cdk': cdk});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/* ***** ***** ***** 用户 ***** ***** ***** */

/// 用户名注册
Future<ResponseModel<dynamic>?> reqLoginByReg({
  String username = "",
  String password = "",
}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/index/register',
        data: {'username': username, 'password': password});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 用户名登录
Future<ResponseModel<dynamic>?> reqLoginByAccount({
  String username = "",
  String password = "",
}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/index/login',
        data: {'username': username, 'password': password});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 忘记并重置 密码
Future<ResponseModel<dynamic>?> resetPwd(
    {String email = "", String code = "", String pwd = ''}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/index/forgetPassword',
        data: {'email': email, 'code': code, 'password': pwd});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 发验证码
Future<ResponseModel<dynamic>?> reqEmailCode({String email = ""}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/index/sendEmailCode',
        data: {'email': email});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 绑定邮箱
Future<ResponseModel<dynamic>?> reqBindEmail(
    {String email = "", String code = ""}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/index/bindEmail',
        data: {'email': email, 'code': code});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 验证用户名
// Future<ResponseModel<dynamic>?> reqValidateUsername({String? username}) async {
//   try {
//     Response<dynamic> res = await NetworkHttp.post(
//         '/api/account/validateUsername',
//         data: {'username': username});
//     Utils.log(res.data);
//     return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
//   } catch (e) {
//     Utils.log(e);
//     return null;
//   }
// }

/// 修改用户头像、昵称、签名
Future<ResponseModel<dynamic>?> reqUpdateUserInfo({
  String nickname = "",
  String thumb = "",
  String intro = "",
}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/index/updateUserInfo',
        data: {'nickname': nickname, 'thumb': thumb, 'intro': intro});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 清除线上缓存
Future<ResponseModel<dynamic>?> reqClearCached() async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/user/clear_cached');
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/* ***** ***** ***** 用户信息结束 ***** ***** ***** */

/// 应用分类
Future<ResponseModel<dynamic>?> reqAppCategory() async {
  try {
    Response<dynamic> res = await NetworkHttp.post("/api/app/index");
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 应用商店
Future<ResponseModel<dynamic>?> reqApps({
  int id = 0,
  int page = 1,
  int limit = 15,
  String last_ix = '',
}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post("/api/index/welfareIndex", data: {
      "id": id,
      "page": page,
      "limit": limit,
      "last_ix": last_ix,
    });
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 获取反馈列表
Future<ResponseModel<dynamic>?> reqChatList({int page = 1}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/message/feedback', data: {'page': page});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 发送反馈信息
Future<ResponseModel<dynamic>?> reqSendContent(
  String content,
  int type,
  int helpType,
) async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/message/feeding',
        data: {'content': content, 'type': type, 'helpType': helpType});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 获取消息读取状态
Future<ResponseModel<SysNoticeModel>?> reqSystemNotice(
    BuildContext context) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/message/getUnreadCount');
    Utils.log(res.data);
    ResponseModel<SysNoticeModel> tp = ResponseModel<SysNoticeModel>.fromJson(
        res.data, (json) => SysNoticeModel.fromJson(json));
    if (tp.data != null) {
      Provider.of<BaseStore>(context, listen: false).setNotice(tp.data!);
    }
    return tp;
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 获取消息列表
Future<ResponseModel<dynamic>?> reqSystemNoticeList({
  int page = 1,
  int limit = 15,
}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post(
        '/api/message/getSystemNoticeList',
        data: {'page': page, 'limit': limit});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 获取商品VIP
Future<ResponseModel<dynamic>?> reqProductOfVipOrGold({int type = 1}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/index/productList', data: {'type': type});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 扣币兑换
Future<ResponseModel<dynamic>?> reqOrderExchange({
  int product_id = 0,
}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/order/exchange',
        data: {'product_id': product_id});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 在线支付
Future<ResponseModel<dynamic>?> reqCreatePaying({
  String pay_way = "",
  String pay_type = "",
  int product_id = 0,
}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/index/createOrder', data: {
      'pay_way': pay_way,
      'pay_type': pay_type,
      'product_id': product_id,
    });
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 充值记录 ???? TODO 明天看
Future<ResponseModel<dynamic>?> reqOrderList({
  int page = 1,
  dynamic type = '1',
  int limit = 15,
}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post("/api/order/orderList", data: {
      'limit': limit,
      'page': page,
      'type': type,
    });
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 黑料网首页
Future<ResponseModel<dynamic>?> reqHome() async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/contents/list_category');
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 优选
Future<ResponseModel<dynamic>?> reqOptimal({
  String tags = "",
  int page = 1,
  int order = 0,
}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/girl/list_girl', data: {
      'tags': tags,
      'page': page,
      'order': order,
    });
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 商家
Future<ResponseModel<dynamic>?> reqBiz({int page = 1}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/broker/list', data: {'page': page});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 妹纸详情
Future<ResponseModel<dynamic>?> reqGirlDetail({String id = "0"}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/girl/detail', data: {'id': id});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 妹纸详情-评论
Future<ResponseModel<dynamic>?> reqComments({int id = 0, int page = 1}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/girl/list_comments', data: {
      'id': id,
      'page': page,
    });
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 商户的评价
Future<ResponseModel<dynamic>?> reqBrokerComments(
    {String id = "0", int page = 1}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/broker/list_comments', data: {
      'id': id,
      'page': page,
    });
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 妹纸筛选
Future<ResponseModel<dynamic>?> reqGirlFilter({Map? req, int page = 1}) async {
  try {
    req ??= {};
    req["page"] = page;
    Response<dynamic> res =
        await NetworkHttp.post('/api/girl/list_filter', data: req);
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 城市+赛选 列表
Future<ResponseModel<dynamic>?> reqCitiesAndFiltrate() async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/girl/getFilterOption');
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 商家信息
Future<ResponseModel<dynamic>?> reqBusinessInfo({
  String id = "0",
  int order = 0,
  int page = 1,
}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/broker/detail', data: {
      "id": id,
      "order": order,
      "page": page,
    });
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 搜索信息
Future<ResponseModel<dynamic>?> reqSearchList({
  String word = "",
  String last_ix = "0",
  int page = 1,
  int limit = 15,
}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/index/searchResult', data: {
      "word": word,
      "page": page,
      "last_ix": last_ix,
      "limit": limit,
    });
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 搜索帖子信息
Future<ResponseModel<dynamic>?> reqSearchPosts({
  String word = "",
  String last_ix = "0",
  int page = 1,
  int limit = 15,
}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/rider/search', data: {
      "word": word,
      "page": page,
      "last_ix": last_ix,
      "limit": limit,
    });
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 热门搜索结果
Future<ResponseModel<dynamic>?> reqPopularSearch({int limit = 50}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/index/search', data: {"limit": limit});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 定制列表
Future<ResponseModel<dynamic>?> reqPrivateList({
  int page = 1,
  int status = -1,
}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/custom/list_custom', data: {
      "page": page,
      "status": status,
    });
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 定制选项
Future<ResponseModel<dynamic>?> reqCustomDesc() async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/custom/create_option');
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 创建定制
Future<ResponseModel<dynamic>?> reqCreateCustom({
  String contact = "",
  int custom_type = 1,
  String price = "",
  String city_code = "",
  String meet_date = "",
  String descp = "",
}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/custom/create_custom', data: {
      "contact": contact,
      "custom_type": custom_type,
      "price": price,
      "city_code": city_code,
      "meet_date": meet_date,
      "descp": descp,
    });
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 定制详情
Future<ResponseModel<dynamic>?> reqCustomDetail({String id = "0"}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/custom/detail_custom', data: {"id": id});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 定制解锁
Future<ResponseModel<dynamic>?> reqCustomUnlock({String id = "0"}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/custom/unlock_custom', data: {"id": id});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 新手指南
Future<ResponseModel<dynamic>?> reqNewGuide() async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/user/guide');
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 解锁妹子
Future<ResponseModel<dynamic>?> reqUnlockGirl({
  String id = "0",
  String contact = "",
  String package = "one",
  String buycart_id = "0",
}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/girl/buy', data: {
      "id": id,
      "contact": contact,
      "package": package,
      "buycart_id": buycart_id,
    });
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 上传妹子信息选项
Future<ResponseModel<dynamic>?> reqUploadOption() async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/girl/uploadOption');
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 上传妹子信息
Future<ResponseModel<dynamic>?> reqUploadGirl({
  String title = "",
  String city = "",
  String type = "",
  String choose_service = "",
  String girl_birthday = "",
  String girl_height = "",
  String girl_tags = "",
  String girl_cup = "",
  String girl_service_type = "",
  String girl_package_one = "",
  String girl_package_two = "",
  String girl_package_over_night = "",
  String img_url = "",
  String video_url = "",
}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/girl/upload', data: {
      "title": title,
      "city": city,
      "type": type,
      "choose_service": choose_service,
      "girl_birthday": girl_birthday,
      "girl_height": girl_height,
      "girl_tags": girl_tags,
      "girl_cup": girl_cup,
      "girl_service_type": girl_service_type,
      "girl_package_one": girl_package_one,
      "girl_package_two": girl_package_two,
      "girl_package_over_night": girl_package_over_night,
      "img_url": img_url,
      "video_url": video_url,
    });
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 修改商家信息
Future<ResponseModel<dynamic>?> reqUpdateBroker({Map? params}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/broker/edit', data: params);
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 商家信息
Future<ResponseModel<dynamic>?> reqBrokerInfo() async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/broker/my_info');
    // Response<dynamic> res =
    //     await NetworkHttp.post('/api/broker/test_broker'); //测试
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 商户自己的妹子列表
Future<ResponseModel<dynamic>?> reqBrokerListGirl({
  int status = 1,
  int page = 1,
  int limit = 15,
}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/broker/list_my_girl', data: {
      "status": status,
      "page": page,
      "limit": limit,
    });
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 将妹子的信息置顶
Future<ResponseModel<dynamic>?> reqBrokerTop({int id = 1}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/broker/top', data: {"id": id});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 妹子信息上下架
Future<ResponseModel<dynamic>?> reqBrokerUpDown({
  int type = 1,
  String ids = "",
}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/broker/updown',
        data: {"type": type, "ids": ids});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 妹子信息删除
Future<ResponseModel<dynamic>?> reqBrokerDelete({String ids = ""}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/broker/delete_girl', data: {"ids": ids});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 圈子
/// 发布帖子
Future<ResponseModel<dynamic>?> circleSubmitPosts(
    {String? id, String? text, String? videoJson, String? imgJson}) async {
  try {
    Utils.log({
      'id': id,
      'text': text,
      'video': videoJson,
      'img': imgJson,
    });
    Response<dynamic> res =
        await NetworkHttp.post('/api/rider/create_post', data: {
      'id': id,
      'text': text,
      'video': videoJson,
      'img': imgJson,
    });
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 获取省份
Future<ResponseModel<List>?> circleProvincesList() async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/rider/list_provinces', data: {});
    Utils.log(res.data);
    return ResponseModel<List<dynamic>>.fromJson(
        res.data, ((json) => List<dynamic>.from(json)));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 获取圈子列表
Future<ResponseModel<dynamic>?> circleListCircles(
    {required String type,
    int? id,
    String? last_ix,
    int page = 1,
    int limit = 15}) async {
  try {
    Map data = {
      'type': type,
      'page': page,
      'limit': limit,
    };
    if (id != null) {
      data['adcode'] = id;
    }
    if (last_ix != null) {
      data['last_ix'] = last_ix;
    }

    Utils.log('$data');

    Response<dynamic> res =
        await NetworkHttp.post('/api/rider/list_circles', data: data);
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 圈子首页
Future<ResponseModel<dynamic>?> circleIndex() async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/rider/circle_index', data: {});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 圈子 获取帖子列表
Future<ResponseModel<dynamic>?> circlePosts(
    {required String type,
    int? id,
    String? last_ix,
    int page = 1,
    int limit = 15}) async {
  try {
    Map data = {
      'type': type,
      'page': page,
      'limit': limit,
    };
    if (id != null) {
      data['id'] = id;
    }
    if (last_ix != null) {
      data['last_ix'] = last_ix;
    }

    Response<dynamic> res =
        await NetworkHttp.post('/api/rider/circle_posts', data: data);
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 圈子 获取圈子详情
Future<ResponseModel<dynamic>?> circleDetail(
    {required dynamic circleID, dynamic provinceID}) async {
  try {
    // Map data = {
    //   'circle_id': id,
    //   "type":'common'
    // };

    Map data = {
      'circle_id': circleID,
    };

    if (provinceID != null) {
      data['type'] = 'province';
      data['adcode'] = provinceID;
    } else {
      data['type'] = 'common';
    }

    Response<dynamic> res =
        await NetworkHttp.post('/api/rider/circle_detail', data: data);
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 圈子 加入圈子
Future<ResponseModel<dynamic>?> circleJoinExitCircle({required int id}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/rider/join_exit_circle', data: {'id': id});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 创建圈子
Future<ResponseModel<dynamic>?> circleCreate(
    {String? id,
    required String name,
    required String intro,
    required String thumb_bg,
    required String thumb}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/rider/create_circle', data: {
      'adcode': id,
      'name': name,
      "intro": intro,
      "thumb": thumb,
      "thumb_bg": thumb_bg,
    });
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, (json) => json);
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 圈子 获取帖子详情
Future<ResponseModel<dynamic>?> circlePostsDetail(
    {required dynamic postsID}) async {
  try {
    Map data = {
      'id': postsID,
    };

    Response<dynamic> res =
        await NetworkHttp.post('/api/rider/post_detail', data: data);
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 圈子 发送评论       "type": "post", // 类型 comment|post
Future<ResponseModel<dynamic>?> circleSendComment(
    {String type = 'post', required int id, required String text}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/rider/comment',
        data: {'type': type, 'id': id, 'text': text});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 圈子 获取帖子详情 评论列表
Future<ResponseModel<dynamic>?> circlePostsDetailComments(
    {required String type,
    int? id,
    String? last_ix,
    int page = 1,
    int limit = 15}) async {
  try {
    Map data = {
      'type': type,
      'page': page,
      'limit': limit,
    };
    if (id != null) {
      data['id'] = id;
    }
    if (last_ix != null) {
      data['last_ix'] = last_ix;
    }

    Response<dynamic> res =
        await NetworkHttp.post('/api/rider/comments', data: data);
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 点赞 取消点赞      const TYPE_POST = 0; 帖子  const TYPE_COMMENT = 1; 评论
Future<ResponseModel<dynamic>?> circleLikeOrNot(
    {int type = 0, required int id}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/user/toggle_like',
        data: {'type': type, 'id': id});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 收藏 取消收藏             "type": enum(0=帖子,1=评论,2=招嫖), // 类型
Future<ResponseModel<dynamic>?> userCollectOrNot(
    {int type = 0, required int id}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/user/toggle_favorite',
        data: {'type': type, 'id': id});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 关注 取消关注
Future<ResponseModel<dynamic>?> userFollowOrNot({required int aff}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/user/toggle_follow', data: {"aff": aff});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 签到
/// 签到 主体页面数据
Future<ResponseModel<dynamic>?> mineSignList() async {
  try {
    Map data = {};

    Response<dynamic> res =
        await NetworkHttp.post('/api/sign/list', data: data);
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 签到
Future<ResponseModel<dynamic>?> mineSigninAct({required dynamic id}) async {
  try {
    Map data = {'id': id};

    Response<dynamic> res =
        await NetworkHttp.post('/api/sign/sign', data: data);
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 签到  邀请获取奖励
Future<ResponseModel<dynamic>?> mineSignGetInvitePrize(
    {required dynamic id}) async {
  try {
    Map data = {'id': id};
    Response<dynamic> res =
        await NetworkHttp.post('/api/sign/invite', data: data);
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

//签到  兑换
Future<ResponseModel<dynamic>?> mineSignExchange({required dynamic id}) async {
  try {
    Map data = {'id': id};

    Response<dynamic> res =
        await NetworkHttp.post('/api/sign/exchange', data: data);
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 代理 推广数据 | 等级信息
Future<ResponseModel<dynamic>?> getProxyDetail() async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/proxy/detail', data: {});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 代理 收益明细
Future<ResponseModel<dynamic>?> getProxyProfitList(Map reqdata) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/proxy/list', data: reqdata);
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    return null;
  }
}

/// 代理 申请代理
Future<ResponseModel<dynamic>?> applyProxyWithContact(String contact) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/proxy/apply', data: {'contact': contact});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    return null;
  }
}

/// 代理 邀请记录
Future<ResponseModel<dynamic>?> getProxyInviteRecord(Map reqdata) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/proxy/list_log', data: reqdata);
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    return null;
  }
}

/// 提现  添加银行卡
Future<ResponseModel<dynamic>?> cashAddBankCard({
  String name = '',
  String card = '',
  String type = '',
}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/index/addBankCard', data: {
      'name': name,
      'card': card,
      'bank_type': type,
    });
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    return null;
  }
}

/// 提现  银行卡列表
Future<ResponseModel<dynamic>?> cashBankCardList() async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/index/getBankCardList');
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    return null;
  }
}

/// 提现  删除银行卡
Future<ResponseModel<dynamic>?> cashDeleteBankCard(Map reqdata) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/user/del_bankcard', data: reqdata);
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    return null;
  }
}

/// 提现  申请提现
Future<ResponseModel<dynamic>?> cashApplyWithdraw(Map reqdata) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/order/withdraw', data: reqdata);
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    return null;
  }
}

/// 提现 收益 申请提现
Future<ResponseModel<dynamic>?> incomeApplyWithdraw(
    {int amount = 0, String name = '', int card = 0}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post(
      '/api/index/addWithdraw',
      data: {
        'amount': amount,
        'name': name,
        'card': card,
      },
    );
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    return null;
  }
}

/// 提现 规则
Future<ResponseModel<dynamic>?> cashWithdrawRule() async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/withdraw/index');
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    return null;
  }
}

///提现  提现列表
Future<ResponseModel<dynamic>?> cashWithdrawList(Map reqdata) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/order/listWithdraw', data: reqdata);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    return null;
  }
}

// 我的订单
Future<ResponseModel<dynamic>?> mineListMyOrders(
    {required dynamic page, String? last_ix, required dynamic status}) async {
  try {
    //    "page": "1",
    // "status": "enum(0=全部,1=待确认,2=确认待评论,3=确认已评论)"
    Map data = {'page': page, 'status': status};
    if (last_ix != null) {
      data['last_ix'] = last_ix;
    }
    Response<dynamic> res =
        await NetworkHttp.post('/api/girl/list_my_orders', data: data);
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

// 私人定制列表
Future<ResponseModel<dynamic>?> mineCustomList(
    {required dynamic page, String? last_ix, required dynamic status}) async {
  try {
    //    "page": "1",
    // "status": "enum(0=待接单，1=已接单，2=已退款)"
    Map data = {'page': page, 'status': status};
    if (last_ix != null) {
      data['last_ix'] = last_ix;
    }
    Response<dynamic> res =
        await NetworkHttp.post('/api/custom/list_custom', data: data);
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

// 用户的优惠券列表
Future<ResponseModel<dynamic>?> mineCouponList(
    {required dynamic page, String? last_ix, required dynamic filter}) async {
  try {
    Map data = {'page': page, 'filter': filter};
    if (last_ix != null) {
      data['last_ix'] = last_ix;
    }
    Response<dynamic> res =
        await NetworkHttp.post('/api/coupon/list_my_coupon', data: data);
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

// 我的收藏 小姐姐列表
Future<ResponseModel<dynamic>?> mineColletionList(
    {required dynamic page, String? last_ix, required dynamic type}) async {
  try {
    Map data = {'page': page, 'type': type};
    if (last_ix != null) {
      data['last_ix'] = last_ix;
    }
    Utils.log(data);
    Response<dynamic> res =
        await NetworkHttp.post('/api/user/list_favorites', data: data);
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

// 往期
Future<ResponseModel<dynamic>?> pastList(
    {int page = 1, String date = ''}) async {
  try {
    Response<dynamic> res = await NetworkHttp.post('/api/index/memora',
        data: {'page': page, 'date': date});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

// 往期热门
Future<ResponseModel<dynamic>?> pastHotList({required int type}) async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/index/hot', data: {'type': type});
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 用户评论列表
Future<ResponseModel<dynamic>?> mineUserCommentsList(
    {required dynamic page, String? last_ix}) async {
  try {
    Map data = {'page': page};
    // if (last_ix != null) {
    //   data['last_ix'] = last_ix;
    // }
    Utils.log(data);
    Response<dynamic> res =
        await NetworkHttp.post('/api/contents/list_my_comments', data: data);
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}

/// 用户评论列表
Future<ResponseModel<dynamic>?> mineUserResetUnreadMsg() async {
  try {
    Response<dynamic> res =
        await NetworkHttp.post('/api/message/reset_unread_msg');
    Utils.log(res.data);
    return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  } catch (e) {
    Utils.log(e);
    return null;
  }
}
