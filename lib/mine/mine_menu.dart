import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hlw/mine/mine_collect_page.dart';
import 'package:hlw/model/config_model.dart';
import 'package:hlw/util/app_global.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/utils.dart';
import 'package:provider/provider.dart';

import '../base/base_store.dart';
import '../base/request_api.dart';
import '../model/user_model.dart';
import '../util/desktop_extension.dart';
import '../util/eventbus_class.dart';
import '../util/netimage_tool.dart';
import '../util/style_theme.dart';

class MineMenu extends StatefulWidget {
  final void Function(String)? onTap;

  /// -> split view state
  final BuildContext? sContext;

  const MineMenu({super.key, this.sContext, this.onTap});

  @override
  State createState() => _MineMenuState();
}

class _MineMenuState extends State<MineMenu> {
  dynamic data;
  ConfigModel? config;
  bool netError = false, isHud = true;

  @override
  void initState() {
    config = Provider.of<BaseStore>(context, listen: false).config;
    super.initState();
    if (AppGlobal.userMenu == null) _getData();
  }

  void _getData() {
    // reqUserMeun(context).then((value) {
    //   if (value?.status == 1) {
    //     isHud = false;
    //     netError = false;
    //   } else {
    //     netError = true;
    //   }
    //   if (mounted) setState(() {});
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<BaseStore>(context, listen: false).user;
    Widget current = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 15.w),
        _UserInfoWidget(user: userModel),
        SizedBox(height: 5.w),
        const _VipCoinsWidget(),
        SizedBox(height: 15.w),
        const _MidWidget(),
        SizedBox(height: 15.w),
        const _ListButtonWidget(),
        Divider(
          height: 1.w,
          color: StyleTheme.white10,
        ),
        //退出登录
        GestureDetector(
          onTap: () {
            //退出登录
            Utils.startGif(tip: Utils.txt('tuichz'));
            reqClearCached().then((_) {
              AppGlobal.apiToken = '';
              AppGlobal.appBox?.delete('hlw_token');
              reqUserInfo(context).then((_) {
                Utils.closeGif();
                UtilEventbus().fire(EventbusClass({"login": "login"}));
                Navigator.pop(context);
                // UtilEventbus().fire(EventbusClass({"name": "rightBanner"}));
              });
            });
          },
          child: SizedBox(
            height: 78.w,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LocalPNG(name: 'hlw_mine_out_login', width: 28.w, height: 28.w),
                SizedBox(width: 15.w),
                Text('退出登录', style: StyleTheme.font_white_255_17),
              ],
            ),
          ),
        )
      ],
    );

    current = ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        child: current,
      ),
    );

    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 13.w),
      decoration: BoxDecoration(
        color: StyleTheme.gray51Color,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8.w),
        ],
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
      ),
      clipBehavior: Clip.hardEdge,
      width: 440.w,
      child: current,
    );
  }
}

class _UserInfoWidget extends StatelessWidget {
  final UserModel? user;

  const _UserInfoWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(13.w),
      child: InkWell(
        onTap: () {
          Utils.navTo(context, "/minesetpage");
          // UtilEventbus().fire(EventbusClass({"login": "login"})); // 收起菜單
        },
        child: Row(children: [
          SizedBox(
            height: 54.w,
            width: 54.w,
            child: NetImageTool(
              radius: BorderRadius.circular(27.w),
              url: user?.thumb ?? "",
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.nickname ?? "",
                    style: StyleTheme.font_white_255_22_bold,
                    maxLines: 1,
                  ),
                  SizedBox(height: 0.w),
                  Text(
                    "ID: ${user?.uid}",
                    style: StyleTheme.font_gray_204_16,
                    maxLines: 1,
                  ),
                ]),
          ),
          LocalPNG(
            name: 'hlw_mine_set',
            width: 28.w,
            height: 28.w,
          ),
          SizedBox(width: 10.w),
        ]),
      ),
    );
  }
}

class _VipCoinsWidget extends StatelessWidget {
  const _VipCoinsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
          children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: StyleTheme.gradient45,
              borderRadius: BorderRadius.all(Radius.circular(5.w)),
            ),
            height: 80.w,
            padding: EdgeInsets.symmetric(horizontal: 13.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('会员特权', style: StyleTheme.font_white_255_17),
                Row(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          gradient: StyleTheme.gradientLinarYellow,
                          borderRadius: BorderRadius.all(Radius.circular(5.w)),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Text('开通', style: StyleTheme.font_brown_103_18_bold)),
                    const Spacer(),
                    LocalPNG(name: 'hlw_mine_vip', width: 36.w, height: 36.w),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 20.w),
            Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: StyleTheme.gradient45,
              borderRadius: BorderRadius.all(Radius.circular(5.w)),
            ),
            height: 80.w,
            padding: EdgeInsets.symmetric(horizontal: 13.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text('金币充值', style: StyleTheme.font_white_255_17),
                    Text('(余额:0)', style: StyleTheme.font_white_255_15),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          gradient: StyleTheme.gradientLinarYellow,
                          borderRadius: BorderRadius.all(Radius.circular(5.w)),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Text('开通', style: StyleTheme.font_brown_103_18_bold)),
                    const Spacer(),
                    LocalPNG(name: 'hlw_coin_icon', width: 36.w, height: 36.w),
                  ],
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}

//立即领取，投稿，求瓜文章
class _MidWidget extends StatelessWidget {
  const _MidWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        margin: EdgeInsets.symmetric(horizontal: 15.w),
        height: 62.w,
        color: StyleTheme.white10,
      ),
      SizedBox(height: 10.w),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 15.w),
        height: 62.w,
        color: StyleTheme.white10,
      )
    ]);
  }
}

class _ListButtonWidget extends StatelessWidget {
  const _ListButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            //我的主页
            Utils.navTo(context, '/');
          },
          child: Row(
            children: [
              LocalPNG(name: 'hlw_mine_center', width: 32.w, height: 32.w),
              SizedBox(width: 15.w),
              Text('我的主页', style: StyleTheme.font_white_255_17),
              const Spacer(),
              LocalPNG(name: '51_mine_arrow', width: 18.w, height: 20.w, color: Colors.grey),
            ],
          ),
        ),
        SizedBox(height: 10.w),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            //我的勋章
            Utils.navTo(context, '/');
          },
          child: Row(
            children: [
              LocalPNG(name: 'hlw_mine_xz', width: 32.w, height: 32.w),
              SizedBox(width: 15.w),
              Text('我的勋章', style: StyleTheme.font_white_255_17),
              const Spacer(),
              LocalPNG(name: '51_mine_arrow', width: 18.w, height: 20.w, color: Colors.grey),
            ],
          ),
        ),
        SizedBox(height: 15.w),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            //评论回复
            Utils.navTo(context, '/minerepliedcomments_page');
          },
          child: Row(
            children: [
              LocalPNG(name: 'hlw_mine_pl', width: 32.w, height: 32.w),
              SizedBox(width: 15.w),
              Text('评论回复', style: StyleTheme.font_white_255_17),
              const Spacer(),
              LocalPNG(name: '51_mine_arrow', width: 18.w, height: 20.w, color: Colors.grey),
            ],
          ),
        ),
        SizedBox(height: 15.w),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            //我的悬赏
            Utils.navTo(context, '/minecontributionpage');
          },
          child: Row(
            children: [
              LocalPNG(name: 'hlw_mine_xs', width: 32.w, height: 32.w),
              SizedBox(width: 15.w),
              Text('我的悬赏', style: StyleTheme.font_white_255_17),
              const Spacer(),
              LocalPNG(name: '51_mine_arrow', width: 18.w, height: 20.w, color: Colors.grey),
            ],
          ),
        ),
        SizedBox(height: 15.w),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            //我的收藏
            Utils.navTo(context, '/minecollectpage');
          },
          child: Row(
            children: [
              LocalPNG(name: 'hlw_mine_sc', width: 32.w, height: 32.w),
              SizedBox(width: 15.w),
              Text('我的收藏', style: StyleTheme.font_white_255_17),
              const Spacer(),
              LocalPNG(name: '51_mine_arrow', width: 18.w, height: 20.w, color: Colors.grey),
            ],
          ),
        ),
        SizedBox(height: 15.w),
      ]),
    );
  }
}