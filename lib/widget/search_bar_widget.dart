import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../base/base_store.dart';
import '../mine/mine_menu.dart';
import '../util/desktop_extension.dart';
import '../util/eventbus_class.dart';
import '../util/local_png.dart';
import '../util/netimage_tool.dart';
import '../util/style_theme.dart';
import '../util/utils.dart';

class SearchBarWidget extends StatefulWidget {
  final bool showHead, isBackBtn;
  final String backTitle;
  final Widget? detailWidget;

  const SearchBarWidget({
    super.key,
    this.showHead = true,
    this.isBackBtn = false,
    this.backTitle = "",
    this.detailWidget,
  });

  @override
  State createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget>
    with TickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _eventBus();
    super.initState();
  }

  _eventBus() {
    _streamSubscription = UtilEventbus().on<EventbusClass>().listen((event) {
      // Utils.log('SearchBar isOpen:${event.arg["login"]}');
      if (event.arg["login"] != null && event.arg["login"] == 'login') {
        _controller.reset();
        _controller.reverse();
        setState(() {
          _isOpen = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _streamSubscription?.cancel();
    super.dispose();
  }

  void onVisibleMenuAction() {
    _isOpen = !_isOpen;
    _controller.reset();
    _isOpen ? _controller.forward() : _controller.reverse();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      _TopBarWidget(
        detailWidget: widget.detailWidget,
        isBackBtn: widget.isBackBtn,
        backTitle: widget.backTitle,
        showHead: widget.showHead,
        onVisibleMenuAction: onVisibleMenuAction,
      ),
      _MenuBarWidget(
        onVisibleMenuAction: onVisibleMenuAction,
        animation: _animation,
        isOpen: _isOpen,
      ),
    ]);
  }
}

/// 顶部条
class _TopBarWidget extends StatelessWidget {
  final Widget? detailWidget;
  final bool isBackBtn, showHead;
  final String backTitle;
  final void Function() onVisibleMenuAction;

  const _TopBarWidget({
    this.detailWidget,
    required this.isBackBtn,
    required this.backTitle,
    required this.showHead,
    required this.onVisibleMenuAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: StyleTheme.bgColor,
      height: 90.w,
      child: Row(children: [
        SizedBox(width: 30.w),
        _ActionBarWidget(
          detailWidget: detailWidget,
          isBackBtn: isBackBtn,
        ),
        const Expanded(child: SizedBox()),
        GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            height: 50.w,
            width: 56.w,
            child: const LocalPNG(
              name: 'hlw_top_refresh',
              fit: BoxFit.contain,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            height: 50.w,
            width: 56.w,
            child: const LocalPNG(
              name: 'hlw_top_problem',
              fit: BoxFit.contain,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            height: 50.w,
            width: 56.w,
            child: const LocalPNG(
              name: 'hlw_top_setting',
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        _UserHeaderWidget(
          showHead: showHead,
          onVisibleMenuAction: onVisibleMenuAction,
        ),
        SizedBox(width: 30.w),
      ]),
    );
  }
}

/// 操作列表
class _MenuBarWidget extends StatelessWidget {
  final void Function() onVisibleMenuAction;
  final Animation<double> animation;
  final bool isOpen;

  const _MenuBarWidget({
    required this.onVisibleMenuAction,
    required this.animation,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    Widget menu = Container(
      padding: EdgeInsets.fromLTRB(0, 60.w, 60.w, 0),
      alignment: Alignment.topRight,
      child: const MineMenu(),
    );
    menu = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onVisibleMenuAction,
      child: menu,
    );
    menu = FadeTransition(opacity: animation, child: menu);
    return Visibility(visible: isOpen, child: menu);
  }
}

/// 1.返回按钮
class _PopBarItemWidget extends StatelessWidget {
  final bool isBackBtn;
  final String backTitle;

  const _PopBarItemWidget({
    required this.isBackBtn,
    required this.backTitle,
  });

  @override
  Widget build(BuildContext context) {
    if (!isBackBtn) return SizedBox(width: 225.w);
    Widget current = GestureDetector(
      onTap: () {
        Utils.splitPopView(context);
      },
      child: Row(children: [
        LocalPNG(name: "hlw_arrow_left", width: 20.w, height: 20.w),
        SizedBox(width: 20.w),
        Text(backTitle, style: StyleTheme.font_black_34_15),
      ]),
    );
    return current;
  }
}

/// 2.搜索按钮
class _ActionBarWidget extends StatelessWidget {
  final Widget? detailWidget;
  final bool isBackBtn;

  const _ActionBarWidget({
    required this.detailWidget,
    required this.isBackBtn,
  });

  @override
  Widget build(BuildContext context) {
    /// 自定义
    if (detailWidget != null) return detailWidget!;

    /// 子页面
    if (isBackBtn) return const SizedBox();

    return GestureDetector(
      onTap: () {
        // Utils.navTo(context, "/homesearchpage/");
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: 600.w,
        height: 50.w,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(216, 216, 216, .2),
          borderRadius: BorderRadius.circular(36.w),
        ),
        alignment: Alignment.centerLeft,
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          LocalPNG(
            name: "hlw_top_search",
            width: 24.w,
            height: 24.w,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              style: StyleTheme.font_white_20,
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: Utils.txt('ssngxqd'),
                hintStyle: StyleTheme.font_gray_153_20,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            "搜索",
            style: StyleTheme.font_orange_244_20,
          ),
        ]),
      ),
    );
  }
}

/// 3.用户头像
class _UserHeaderWidget extends StatelessWidget {
  final bool showHead;
  final void Function() onVisibleMenuAction;

  const _UserHeaderWidget({
    required this.showHead,
    required this.onVisibleMenuAction,
  });

  @override
  Widget build(BuildContext context) {
    if (!showHead) return SizedBox(width: 225.w);
    var user = Provider.of<BaseStore>(context, listen: false).user;
    Widget current;
    if (user?.username?.isEmpty == true) {
      current = LocalPNG(
        name: 'hlw_mine_head',
        width: 40.w,
        height: 40.w,
      );
    } else {
      current = NetImageTool(
        radius: BorderRadius.circular(18.w),
        url: user?.thumb ?? "",
      );
      current = SizedBox(
        width: 36.w,
        height: 36.w,
        child: current,
      );
    }
    current = InkWell(onTap: onVisibleMenuAction, child: current);
    return Row(
      children: [Ink(child: current)],
    );
  }
}
