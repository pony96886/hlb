// ignore_for_file: no_logic_in_create_state

import 'dart:io';

import 'package:hlw/util/approute_observer.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//基类
abstract class BaseWidget extends StatefulWidget {
  const BaseWidget({this.key}) : super(key: key);
  @override
  final Key? key;

  @override
  State<StatefulWidget> createState() => cState();

  State<StatefulWidget> cState();
}

abstract class BaseWidgetState<T extends BaseWidget> extends State<T>
    with RouteAware {
  String _appTitle = "";
  String _backIcon = "51_nav_back";
  Color _bgColor = StyleTheme.bgColor;
  Color _navColor = StyleTheme.navColor;
  Color _lineColor = Colors.transparent;
  bool _navBack = false;
  bool _isOverscroll = false;
  BuildContext? _mContext;
  Widget? _rightW;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // 这个跑起来要报错 先注释了
    ModalRoute<dynamic>? route = ModalRoute.of<dynamic>(context);
    if (route != null) {
      //路由订阅
      AppRouteObserver().routeObserver.subscribe(this, route);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onCreate();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build 统一布局基础页面
    _mContext = context;

    if (kIsWeb) {
      return Scaffold(
        backgroundColor: _bgColor,
        body: Stack(children: [
          backGroundView(),
          Column(
            children: [appbar(), Expanded(child: pageBody(context))],
          )
        ]),
      );
    } else if (Platform.isAndroid) {
      return Scaffold(
        primary: false,
        appBar: PreferredSize(child: Container(), preferredSize: Size.zero),
        backgroundColor: _bgColor,
        body: SafeArea(
            child: Stack(children: [
          backGroundView(),
          Column(
            children: [appbar(), Expanded(child: pageBody(context))],
          ),
        ])),
      );
    } else if (Platform.isIOS) {
      return Scaffold(
        backgroundColor: _bgColor,
        body: Stack(children: [
          backGroundView(),
          Column(
            children: [appbar(), Expanded(child: pageBody(context))],
          )
        ]),
      );
    } else {
      return Scaffold(
        backgroundColor: _bgColor,
        body: Stack(children: [
          backGroundView(),
          Column(
            children: [appbar(), Expanded(child: pageBody(context))],
          )
        ]),
      );
    }
  }

  @override
  void dispose() {
    /// 取消路由订阅
    AppRouteObserver().routeObserver.unsubscribe(this);
    beforeDispose();
    super.dispose();
    onDestroy();
  }

  //页面初始化
  void onCreate();
  //页面布局
  Widget pageBody(BuildContext context);
  //页面销毁
  void onDestroy();
  //初始化之前的操作
  void beforeInit() {}
  //销毁之前的操作
  void beforeDispose() {}
  /*
    销毁页面
   */
  void finish() {
    Utils.splitPopView(context);
  }

  Widget backGroundView() {
    return Container();
  }

  /*
   *  公用的AppBar的title
   */
  void setAppTitle({
    String title = "",
    String backIcon = "51_nav_back",
    Color navColor = Colors.transparent,
    Color bgColor = const Color.fromRGBO(255, 255, 255, 1),
    Widget? rightW,
    Color lineColor = const Color.fromRGBO(245, 245, 245, 1),
  }) {
    _appTitle = title;
    _backIcon = backIcon;
    _rightW = rightW;
    _navColor = navColor;
    _bgColor = bgColor;
    _lineColor = lineColor;
    setState(() {});
  }

  /*
   * 继承该基类的公用的AppBar 
   * 1.有标题默认正常标题栏；
   * 2.无标题为空，可以根据自身组件写标题组件或则调用appbar重写标题
   */
  Widget appbar() {
    return _navBack
        ? Column(
            key: ValueKey(_navBack),
            children: [
              Container(
                height: StyleTheme.topHeight,
                color: _navColor,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: StyleTheme.margin),
                height: StyleTheme.navHegiht,
                decoration: BoxDecoration(
                  color: _navColor,
                  border:
                      Border(bottom: BorderSide(color: _lineColor, width: 1.w)),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Row(
                        children: [
                          Container(
                            color: Colors.transparent,
                            child: GestureDetector(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                width: 27.w,
                                height: 40.w,
                                child: LocalPNG(
                                  name: _backIcon,
                                  width: 17.w,
                                  height: 17.w,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                finish();
                              },
                            ),
                          ),
                          Expanded(
                              child: Text(_appTitle,
                                  style: StyleTheme.nav_title_font,
                                  textAlign: TextAlign.left)),
                          SizedBox(width: 10.w),
                          _rightW ?? SizedBox(width: 20.w, height: 20.w)
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        : Container();
  }

  // Called when the current route has been pushed.
  // 当前的页面被push显示到用户面前 viewWillAppear.
  @override
  void didPush() {
    if (Navigator.canPop(context)) {
      _navBack = true;
      setState(() {});
    }
  }

  /// Called when the current route has been popped off.
  /// 当前的页面被pop viewWillDisappear.
  @override
  void didPop() {}

  /// Called when the top route has been popped off, and the current route
  /// shows up.
  /// 上面的页面被pop后当前页面被显示时 viewWillAppear.
  @override
  void didPopNext() {}

  /// Called when a new route has been pushed, and the current route is no
  /// longer visible.
  /// 从当前页面push到另一个页面 viewWillDisappear.
  @override
  void didPushNext() {}
}
