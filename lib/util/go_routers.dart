import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:hlw/base/empty_page.dart';
import 'package:hlw/base/normal_web.dart';
import 'package:hlw/base/startup_page.dart';
import 'package:hlw/home/home_content_detail_page.dart';
import 'package:hlw/home/home_editor_page.dart';
import 'package:hlw/home/home_invite_friends.dart';
import 'package:hlw/home/home_page.dart';
import 'package:hlw/home/home_player_page.dart';
import 'package:hlw/home/home_preview_view_page.dart';
import 'package:hlw/home/home_search_page.dart';
import 'package:hlw/mine/mine_collect_page.dart';
import 'package:hlw/mine/mine_groups_page.dart';
import 'package:hlw/mine/mine_login_page.dart';
import 'package:hlw/mine/mine_norquestion_page.dart';
import 'package:hlw/mine/mine_replied_comments_page.dart';
import 'package:hlw/mine/mine_service_page.dart';
import 'package:hlw/mine/mine_set_page.dart';
import 'package:hlw/mine/mine_share_page.dart';
import 'package:hlw/mine/mine_update_page.dart';
import 'package:hlw/util/approute_observer.dart';
import 'package:hlw/util/utils.dart';
import 'package:go_router/go_router.dart';

import '../mine/mine_withdrawal_now_account.dart';

class GoRouters {
  //初始化
  static GoRouter init() {
    //二级页面
    final List<GoRoute> childTwoRouters = [
      GoRoute(
        path: 'web/:url',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            barrierDismissible: true,
            child: NormalWeb(url: state.params['url']),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    ScaleTransition(scale: animation, child: child)),
      ),
      //播放页
      GoRoute(
        path: 'homeplayerpage/:cover/:url',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            barrierDismissible: true,
            child: HomePlayerPage(
                cover: state.params['cover'], url: state.params['url']),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    ScaleTransition(scale: animation, child: child)),
      ),
      //图片预览
      GoRoute(
        path: 'homepreviewviewpage/:url',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            barrierDismissible: true,
            child: HomePreviewViewPage(
              url: state.params['url'] ?? "",
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    ScaleTransition(scale: animation, child: child)),
      ),
      //详情
      GoRoute(
        path: 'homecontentdetailpage/:cid',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            barrierDismissible: true,
            child: HomeContentDetailPage(cid: state.params['cid'] ?? "0"),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    ScaleTransition(scale: animation, child: child)),
      ),
      //更新文本信息
      GoRoute(
        path: 'mineupdatepage/:type/:title',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            barrierDismissible: true,
            child: MineUpdatePage(
              type: state.params['type'],
              title: state.params['title'],
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    ScaleTransition(scale: animation, child: child)),
      ),
      //常见问题
      GoRoute(
        path: 'minenorquestionpage',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            barrierDismissible: true,
            child: MineNorquestionPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    ScaleTransition(scale: animation, child: child)),
      ),
      //邀請好友
      GoRoute(
        path: 'homeinvitefriends',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            barrierDismissible: true,
            child: HomePreviewViewPage(
              url: state.params['url'] ?? "",
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    ScaleTransition(scale: animation, child: child)),
        builder: (context, state) => HomeInviteFriends(),
      ),
      //選擇帳號
      GoRoute(
        path: 'minewithdrawalnowaccount',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            barrierDismissible: true,
            child: MineWithdrawalNowAccount(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    ScaleTransition(scale: animation, child: child)),
      ),
    ];

    //一级页面
    final List<GoRoute> childOneRouters = [
      GoRoute(
        path: 'home',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            barrierDismissible: true,
            child: const HomePage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    ScaleTransition(scale: animation, child: child)),
      ),
      //WEB页面
      GoRoute(
        path: 'web/:url',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            barrierDismissible: true,
            child: NormalWeb(url: state.params['url']),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    ScaleTransition(scale: animation, child: child)),
        routes: childTwoRouters,
      ),
      //搜索页面
      GoRoute(
          path: 'homesearchpage',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              barrierDismissible: true,
              child: HomeSearchPage(tag: state.params['tag'] ?? ''),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      ScaleTransition(scale: animation, child: child)),
          routes: childTwoRouters),
      //详情
      GoRoute(
        path: 'homecontentdetailpage/:cid',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            barrierDismissible: true,
            child: HomeContentDetailPage(cid: state.params['cid'] ?? "0"),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    ScaleTransition(scale: animation, child: child)),
        routes: childTwoRouters,
      ),
      //登录页
      GoRoute(
        path: 'mineloginpage/:login',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            barrierDismissible: true,
            child: MineLoginPage(login: state.params['login'] ?? "false"),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    ScaleTransition(scale: animation, child: child)),
        routes: childTwoRouters,
      ),
      //个人设置
      GoRoute(
        path: 'minesetpage',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            barrierDismissible: true,
            child: MineSetPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    ScaleTransition(scale: animation, child: child)),
        routes: childTwoRouters,
      ),
      GoRoute(
        path: 'minesharepage',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            barrierDismissible: true,
            child: MineSharePage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    ScaleTransition(scale: animation, child: child)),
        routes: childTwoRouters,
      ),
      //车友群
      GoRoute(
          path: 'minegroupspage',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              barrierDismissible: true,
              child: HomePreviewViewPage(
                url: state.params['url'] ?? "",
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      ScaleTransition(scale: animation, child: child)),
          builder: (context, state) => MineGroupsPage()),
      //评论回复
      GoRoute(
        path: 'minerepliedcomments_page',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            barrierDismissible: true,
            child: MineRepliedCommentsPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    ScaleTransition(scale: animation, child: child)),
        routes: childTwoRouters,
      ),
      //在线客服
      GoRoute(
        path: 'mineservicepage',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            barrierDismissible: true,
            child: MineServicePage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    ScaleTransition(scale: animation, child: child)),
        routes: childTwoRouters,
      ),
      //我的收藏
      GoRoute(
        path: 'minecollectpage',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            barrierDismissible: true,
            child: MineCollectPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    ScaleTransition(scale: animation, child: child)),
        routes: childTwoRouters,
      ),
      //发帖
      GoRoute(
        path: 'homeeditorpage',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            barrierDismissible: true,
            child: HomeEditorPage(
              id: state.params['id'] ?? "",
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    ScaleTransition(scale: animation, child: child)),
        routes: childTwoRouters,
      ),
    ];

    GoRouter.setUrlPathStrategy(UrlPathStrategy.path);
    return GoRouter(
      debugLogDiagnostics: true,
      routerNeglect: true,
      initialLocation: "/",
      routes: [
        //根目录
        GoRoute(
          path: '/',
          builder: (context, state) => const StartupPage(),
          routes: childOneRouters + childTwoRouters,
        ),
      ],
      errorBuilder: (context, state) => EmptyPage(),
      observers: [
        BotToastNavigatorObserver(),
        AppRouteObserver().routeObserver
      ],
      redirect: (state) {
        Utils.log(state.location);
        return null;
      },
    );
  }
}
