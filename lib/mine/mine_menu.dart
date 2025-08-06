import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    reqUserMeun(context).then((value) {
      if (value?.status == 1) {
        isHud = false;
        netError = false;
      } else {
        netError = true;
      }
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<BaseStore>(context, listen: false).user;
    final _isData = userModel?.username?.isEmpty == true;
    Widget current = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: _isData ? 24.w : 15.w),
        _isData ? _buildNotLoginInWidget() : _buildUserInfoWidget(userModel),
        SizedBox(height: _isData ? 24.w : 15.w),
        Divider(
          height: 1.w,
          color: StyleTheme.gray238Color,
        ),
        _buildScrollWidget(_isData),
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
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8.w),
        ],
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
      ),
      clipBehavior: Clip.hardEdge,
      width: 300.w,
      child: current,
    );
  }

  Widget _buildNotLoginInWidget() {
    return const _NotLoginWidget();
  }

  Widget _buildUserInfoWidget(UserModel? user) {
    return _UserInfoWidget(user: user);
  }

  Widget _buildScrollWidget(bool isData) {
    if (AppGlobal.userMenu is! Map) return const SizedBox();
    return _ScrollWidget(isData: isData);
  }

}

class _NotLoginWidget extends StatelessWidget {
  const _NotLoginWidget({Key? key}) : super(key: key);

  Widget _buildWidget(BuildContext context, String path, Color backgroundColor, String text, TextStyle style) {
    return GestureDetector(
      onTap: () => Utils.navTo(context, path),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 17.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(36.w),
        ),
        child: Text(
          Utils.txt(text),
          style: style,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 20.w),
          _buildWidget(context, "/mineloginpage/true", StyleTheme.black34Color, 'dneglu', StyleTheme.font_white_255_14),
          SizedBox(width: 10.w),
          _buildWidget(context, "/mineloginpage", StyleTheme.gray225Color45, 'zuche', StyleTheme.font_black_51_14),
        ]);
  }
}

class _UserInfoWidget extends StatelessWidget {
  final UserModel? user;
  const _UserInfoWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        onTap: () {
          Utils.navTo(context, "/minesetpage");
          // UtilEventbus().fire(EventbusClass({"login": "login"})); // 收起菜單
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              SizedBox(width: 20.w),
              SizedBox(
                height: 54.w,
                width: 54.w,
                child: NetImageTool(
                  radius: BorderRadius.circular(27.w),
                  url: user?.thumb ?? "",
                ),
              ),
              Expanded(child: Container()),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: StyleTheme.gray204Color,
                    width: 1.w,
                  ),
                  borderRadius: BorderRadius.circular(18.w),
                ),
                padding: EdgeInsets.symmetric(vertical: 6.w, horizontal: 10.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LocalPNG(
                      name: 'hlw_mine_setting',
                      width: 20.w,
                      height: 20.w,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      '设置',
                      style: StyleTheme.font_gray_187_15,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
            ]),
            SizedBox(height: 8.w),
            Row(children: [
              SizedBox(width: 20.w),
              Expanded(
                child: Text(
                  user?.nickname ?? "",
                  style: StyleTheme.font_black_34_17_bold,
                  maxLines: 1,
                ),
              ),
              SizedBox(width: 10.w),
            ]),
          ],
        ),
      ),
    );
  }
}

class _ScrollWidget extends StatelessWidget {
  final bool isData;
  const _ScrollWidget({Key? key, required this.isData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      _GroupWidget(
        text: '求瓜投稿',
        style: isData
            ? StyleTheme.font_gray_102_12
            : StyleTheme.font_gray_153_12,
        items: AppGlobal.userMenu['regular_menu'],
      ),
      AppGlobal.userMenu['regular_menu'] is List &&
          (AppGlobal.userMenu['regular_menu'] as List).isNotEmpty
          ? Divider(
        height: 1.w,
        color: StyleTheme.gray238Color,
      )
          : const SizedBox(),
      _GroupWidget(
        text: '更多选项',
        style: isData
            ? StyleTheme.font_black_34_12
            : StyleTheme.font_gray_153_12,
        items: AppGlobal.userMenu['more_menu'],
      ),
    ]);
  }
}

class _GroupWidget extends StatelessWidget {
  final String text;
  final TextStyle style;
  final List? items;
  const _GroupWidget({Key? key, required this.text, required this.style, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12.w),
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Text(text, style: style),
            ),
            Visibility(
              visible: items != null && items?.isNotEmpty == true,
                child: Column(
                  children: [
                    SizedBox(height: 8.w),
                    _OperationListWidget(text: text, style: style, items: items!),
                    SizedBox(height: 15.w),
                  ],
                )
            ),
          ],
    );
  }
}

class _OperationListWidget extends StatefulWidget {
  final String text;
  final TextStyle style;
  final List items;
  const _OperationListWidget({Key? key, required this.text, required this.style, required this.items}) : super(key: key);

  @override
  State createState() => _OperationListWidgetState();
}

class _OperationListWidgetState extends State<_OperationListWidget> {

  List<String> list = [], listTitle = [];
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    for (int i = 0; i < widget.items.length; i++) {
      list.add('');
      listTitle.add(widget.items[i]['title']);
    }
    _eventBus();
    super.initState();
  }

  _eventBus() {
    _streamSubscription = UtilEventbus().on<EventbusClass>().listen((event) {
      String selected = '';
      if (event.arg["Menu"] != null) {
        selected = event.arg["Menu"];
        if (!listTitle.contains(selected)) {
          for (int i = 0; i < listTitle.length; i++) {
            setState(() {
              list[i] = '';
            });
          }
        } else {
          for (int i = 0; i < listTitle.length; i++) {
            setState(() {
              list[i] = listTitle[i] == selected ? selected : '';
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 280 / 40,
        crossAxisCount: 1,
        mainAxisSpacing: 5.w,
      ),
      itemBuilder: (_, idx) => _OperationItemWidget(item: widget.items[idx], selected: list[idx])
    );
  }
}

class _OperationItemWidget extends StatelessWidget {
  final dynamic item;
  final String selected;
  const _OperationItemWidget({Key? key, required this.item, required this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item is! Map) return const SizedBox();
    String icon = '';
    String path = '';
    switch (item['title']) {
      case '我要求瓜':
        icon = 'hlw_mine_find';
        path = item['route'];
        break;
      case '我要投稿':
        icon = 'hlw_mine_contribute';
        path = item['route'];
        break;
      case '我的投稿':
        icon = 'hlw_mine_contribute_my';
        path = '/minecontributionpage';
        break;
      case '稿费收益':
        icon = 'hlw_mine_income';
        path = '/minecontributionincomepage';
        break;
      case '我的收藏':
        icon = 'hlw_mine_collect';
        path = '/minecollectpage';
        break;
      case '黑料回家路':
        icon = 'hlw_mine_road';
        path = item['route'];
        break;
      case '加入我们':
        icon = 'hlw_mine_join';
        path = item['route'];
        break;
      case '常见问题':
        icon = 'hlw_mine_problems';
        path = item['route'];
        break;
      case '商务合作':
        icon = 'hlw_mine_business';
        path = item['route'];
        break;
      case '分享活动规则':
        icon = 'hlw_mine_rule';
        path = item['route'];
        break;
      case '分享领现金红包':
        icon = 'hlw_mine_red_bag';
        path = item['route'];
        break;
      default:
    }
    Widget current = Row(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(width: 15.w),
      icon.isEmpty
          ? SizedBox(width: 22.w, height: 22.w)
          : LocalPNG(name: icon, width: 22.w, height: 22.w),
      SizedBox(width: 10.w),
      Text(item['title'], style: StyleTheme.font_black_34_16),
    ]);
    current = Container(
      padding: EdgeInsets.symmetric(vertical: 10.w),
      alignment: Alignment.centerLeft,
      color: selected == item['title'] ? StyleTheme.gray241Color : Colors.white,
      child: current,
    );
    current = InkWell(
      onTap: () {
        if (selected != item['title']) {
          UtilEventbus().fire(EventbusClass({"Menu": item['title']}));
        }
        if (item['title'] == '分享领现金红包') {
          Clipboard.setData(ClipboardData(text: path));
          Utils.showText(Utils.txt('fzcg') + '');
          return; // 返回
        }
        // if (['我的投稿', '稿费收益', '我的收藏'].contains(item['title'])) {
        //   Utils.navTo(context, path);
        // } else {
        //   if (path.isNotEmpty) Platform.isMacOS ? Utils.openWebViewMacos(PresentationStyle.sheet, path) : Utils.navTo(context, '/web/$path');
        // }
        ['我的投稿', '稿费收益', '我的收藏'].contains(item['title'])
            ? Utils.navTo(context, path)
            : path.isNotEmpty == true ? Utils.openURL(path) : Utils.showText(Utils.txt('cccwl') + '');
        // UtilEventbus().fire(EventbusClass({"login": "login"})); 收起菜單
      },
      child: current,
    );
    return Ink(child: current);
  }
}