// ignore_for_file: prefer_initializing_formals, unnecessary_brace_in_string_interps

import 'package:hlw/base/empty_page.dart';
import 'package:hlw/base/normal_web.dart';
import 'package:hlw/home/home_content_detail_page.dart';
import 'package:hlw/home/home_editor_page.dart';
import 'package:hlw/home/home_invite_friends.dart';
import 'package:hlw/home/home_player_page.dart';
import 'package:hlw/home/home_preview_view_page.dart';
import 'package:hlw/home/home_search_page.dart';
import 'package:hlw/mine/mine_collect_page.dart';
import 'package:hlw/mine/mine_contribution_income_page.dart';
import 'package:hlw/mine/mine_contribution_page.dart';
import 'package:hlw/mine/mine_groups_page.dart';
import 'package:hlw/mine/mine_login_page.dart';
import 'package:hlw/mine/mine_norquestion_page.dart';
import 'package:hlw/mine/mine_replied_comments_page.dart';
import 'package:hlw/mine/mine_service_page.dart';
import 'package:hlw/mine/mine_set_page.dart';
import 'package:hlw/mine/mine_share_page.dart';
import 'package:hlw/mine/mine_update_page.dart';
import 'package:hlw/mine/mine_withdrawal_now.dart';
import 'package:hlw/mine/mine_withdrawal_now_account.dart';
import 'package:hlw/mine/mine_withdrawal_record.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:hlw/watch/watch_content_detail_page.dart';

import '../home/home_page.dart';

class GoSplitRouters {
  //预备跳转理由处理
  static prepJumpRoute(BuildContext context, {String path = ''}) {
    Utils.log("path: $path");
    if (path.isEmpty) return;
    List<String> words = path.split('/');
    words.removeWhere((el) => el.isEmpty); //去掉空值
    String route = words.first;
    List<String> otherWords = words.sublist(1, words.length);
    //无参数直接跳转
    if (otherWords.isEmpty) {
      _selectRouteToView(context, route: route);
      return;
    }
    //参数直接跳转
    Map params = {};
    for (var index = 0; index < otherWords.length; index++) {
      params['arg${index}'] = otherWords[index];
    }
    _selectRouteToView(context, route: route, params: params);
  }

  //跳转
  static _selectRouteToView(BuildContext context,
      {String route = '', Map? params}) {
    if (route.isEmpty) return;
    switch (route) {
      case 'home': // 首頁
        Utils.splitToView(context, const HomePage());
        break;
      case 'homeinvitefriends': //邀請好友
        Utils.splitToView(context, const HomeInviteFriends());
        break;
      case 'web': //web页面
        Utils.splitToView(context, NormalWeb(url: params?['arg0'] ?? ''));
        break;
      case 'homecontentdetailpage': //详情页面
        Utils.splitToView(
            context, HomeContentDetailPage(cid: params?['arg0'] ?? '0'));
        break;
      case 'homevideocontentdetailpage': //详情页面
        Utils.splitToView(
            context, WatchContentDetailPage(cid: params?['arg0'] ?? '0'));
        break;
      case 'homeplayerpage': //播放页
        Utils.splitToView(
            context,
            HomePlayerPage(
                cover: params?['arg0'] ?? '', url: params?['arg1'] ?? ''));
        break;
      case 'homepreviewviewpage': //图片预览
        Utils.splitToView(
            context, HomePreviewViewPage(url: params?['arg0'] ?? ''));
        break;
      case 'homeeditorpage': //发帖
        Utils.splitToView(context, HomeEditorPage(id: params?['arg0'] ?? ''));
        break;
      case 'mineupdatepage': //更新文本信息
        Utils.splitToView(
            context,
            MineUpdatePage(
                type: params?['arg0'] ?? '', title: params?['arg1'] ?? ''));
        break;
      case 'minenorquestionpage': //常见问题
        Utils.splitToView(context, const MineNorquestionPage());
        break;
      case 'homesearchpage': //搜索页面
        Utils.splitToView(context, HomeSearchPage(tag: params?['arg0'] ?? ''));
        break;
      case 'mineloginpage': //登录页
        Utils.splitToView(context, MineLoginPage(login: params?['arg0'] ?? ''));
        break;
      case 'minesetpage': //个人设置
        Utils.splitToView(context, MineSetPage());
        break;
      case 'minesharepage': //分享页面
        Utils.splitToView(context, MineSharePage());
        break;
      case 'minegroupspage': //车友群
        Utils.splitToView(context, const MineGroupsPage());
        break;
      case 'minerepliedcomments_page': //评论回复
        Utils.splitToView(context, MineRepliedCommentsPage());
        break;
      case 'mineservicepage': //在线客服
        Utils.splitToView(context, MineServicePage());
        break;
      case 'minecollectpage': //我的收藏
        Utils.splitToView(context, MineCollectPage());
        break;
      case 'minecontributionpage': //我的投稿
        Utils.splitToView(context, MineContributionPage());
        break;
      case 'minecontributionincomepage': //稿费收益
        Utils.splitToView(context, MineContributionIncomePage());
        break;
      case 'minewithdrawalrecord': //提现记录
        Utils.splitToView(context, MineWithdrawalRecord());
        break;
      case 'minewithdrawalnow': //立即提现
        Utils.splitToView(context, MineWithdrawalNow());
        break;
      case 'homeeditorpage': //发布文章
        Utils.splitToView(context, const HomeEditorPage());
        break;
      case 'minewithdrawalnowaccount': //選擇帳號
        Utils.splitToView(context, MineWithdrawalNowAccount());
        break;
      default:
        Utils.splitToView(context, EmptyPage());
        break;
    }
  }
}
