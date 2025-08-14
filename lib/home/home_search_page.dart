import 'dart:async';

import 'package:hlw/base/base_widget.dart';
import 'package:hlw/base/request_api.dart';
import 'package:hlw/util/app_global.dart';
import 'package:hlw/util/easy_pull_refresh.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:provider/provider.dart';

import '../base/base_store.dart';
import '../mine/mine_menu.dart';
import '../util/eventbus_class.dart';
import '../util/netimage_tool.dart';

class HomeSearchPage extends BaseWidget {
  final String tag;
  const HomeSearchPage({Key? key, this.tag = ''}) : super(key: key);

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _HomeSearchPageState();
  }
}

class _HomeSearchPageState extends BaseWidgetState<HomeSearchPage>
    with TickerProviderStateMixin {
  bool isStartSearch = false; //开始搜索标识
  bool isHud = true;
  bool isSearch = false;
  bool _isOpen = false;
  bool noMore = false;
  bool netError = false;
  String prevText = "";
  String recordKey = "search_record";
  List records = [];
  List hots = [];
  List banners = [];
  List tps = [];
  int page = 1;
  late AnimationController _controller;
  late Animation<double> _animation;
  StreamSubscription? _streamSubscription;
  TextEditingController textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget appbar() => Container();

  @override
  void onCreate() {
    // TODO: implement onCreate
    textController.text = widget.tag;
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _eventBus();
    records = AppGlobal.appBox?.get(recordKey) ?? [];
    unSearchData();
  }

  /// 操作列表
  Widget _buildMenuBarWidget() {
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
    menu = FadeTransition(opacity: _animation, child: menu);
    return Visibility(visible: _isOpen, child: menu);
  }

  void onVisibleMenuAction() {
    _isOpen = !_isOpen;
    _controller.reset();
    _isOpen ? _controller.forward() : _controller.reverse();
    setState(() {});
  }

  _eventBus() {
    _streamSubscription = UtilEventbus().on<EventbusClass>().listen((event) {
      if (event.arg["login"] != null && event.arg["login"] == 'login') {
        _controller.reset();
        _controller.reverse();
        setState(() {
          _isOpen = false;
        });
      }
    });
  }

  //搜索动作
  void searchInfo() {
    Utils.unFocusNode(context);
    Utils.log("${textController.text}---$prevText");
    if (textController.text.isEmpty) return;
    if (prevText == textController.text) return;

    isHud = true;
    noMore = false;
    netError = false;
    isStartSearch = true; //开始搜索才刷新子页面数据，否则不刷新
    page = 1;
    searchData(isShow: true);

    prevText = textController.text;
    if (!records.contains(textController.text)) {
      records.add(textController.text);
      AppGlobal.appBox?.put(recordKey, records);
    }
    isSearch = true;
    setState(() {});
    //延迟赋值
    Future.delayed(const Duration(milliseconds: 500), () {
      isStartSearch = false;
    });
  }

  //热搜词+广告
  Future<bool> unSearchData() async{
    reqPopularSearch(limit: 20).then((value) {
      if (value?.data == null) {
        netError = true;
        setState(() {});
        return;
      }
      if (value?.status == 1) {
        hots = List.from(value?.data["hot"]);
        banners = List.from(value?.data["ad"]);
      }
      isHud = false;
      setState(() {});
    });
    return false;
  }

  //搜索数据
  Future<bool> searchData({bool isShow = false}) {
    if (page == 1) {
      bool flag = textController.text.isNotEmpty && isStartSearch;
      if (!flag) return Future(() => false);
    }

    // if (isShow) Utils.startGif(tip: Utils.txt('jzz'));
    return reqSearchList(
      word: textController.text,
      page: page,
    ).then((value) {
      // if (isShow) Utils.closeGif();
      final List tmp = List.from(value?.data["list"]);
      if (value?.status == 1) {
        if (page == 1) {
          noMore = false;
          tps = tmp;
        } else if (page > 1 && tmp.isNotEmpty) {
          tps.addAll(tmp);
          tps = Utils.listMapNoDuplicate(tps);
        } else {
          noMore = true;
        }
        isHud = false;
        setState(() {});
        return noMore;
      } else {
        Utils.showText(value?.msg ?? "");
        return false;
      }
    });
  }

  _clickSearchBar() {
    setState(() {
      noMore = false;
      netError = false;
      isSearch = false;
      isStartSearch = false;
      prevText = "";
      textController.text = "";
      page = 1;
      tps = [];
    });
    unSearchData();
  }

  //搜索页面
  Widget isSearchWidget() {
    return _SearchWidget(
        tps: tps, scrollController: _scrollController,
        onRefresh: () {
          page = 1;
          return searchData();
        },
        onLoading: () {
          page++;
          return searchData();
        }
    );
  }

  //没有搜索页面
  Widget isNoSearchWidget() {
    return _UnSearchWidget(
      banners: banners, hots: hots, records: records, scrollController: _scrollController,
      clearRecords: () {
        records.clear();
        AppGlobal.appBox?.put(recordKey, records);
        setState(() {});
      },
      tapTags: (dynamic e) {
        textController.text = e;
        searchInfo();
      },
      onRefresh: unSearchData,
    );
  }

  @override
  void didUpdateWidget(covariant HomeSearchPage oldWidget) {
    if (widget.tag.isNotEmpty && widget.tag != oldWidget.tag) {
      searchInfo();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
    _controller.dispose();
    _streamSubscription?.cancel();
    textController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    return Stack(
      children: [
        Column(
          children: [
            //导航栏
            _SearchBar(
              isHud: isHud,
              isSearch: isSearch,
              textController: textController,
              searchInfo: searchInfo,
              onVisibleMenuAction: onVisibleMenuAction,
              clickSearchBar: widget.tag.isEmpty ? _clickSearchBar : Navigator.of(context).pop,
            ),
            Divider(
              color: StyleTheme.gray238Color,
              height: 1.w,
            ),
            SizedBox(height: isSearch ? 30.w : 50.w),
            //内容页面
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Utils.unFocusNode(context);
                },
                child: netError
                    ? LoadStatus.netErrorWork(onTap: () {
                      netError = false;
                      searchInfo();
                    })
                    : isHud
                    ? LoadStatus.showLoading(mounted)
                    : isSearch || widget.tag.isNotEmpty
                    ? tps.isEmpty
                    ? LoadStatus.noData()
                    : isSearchWidget()
                    : isNoSearchWidget()
              ),
            )
          ],
        ),
        _buildMenuBarWidget(),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  final bool isHud, isSearch;
  final TextEditingController textController;
  final Function() searchInfo, onVisibleMenuAction;
  final Function clickSearchBar;
  const _SearchBar(
      {Key? key,
      required this.isHud,
      required this.isSearch,
      required this.textController,
      required this.searchInfo,
      required this.onVisibleMenuAction,
      required this.clickSearchBar})
      : super(key: key);

  /// 用户头像
  Widget _buildUsrHeaderWidget(BuildContext context) {
    var user = Provider.of<BaseStore>(context, listen: false).user;
    Widget current;
    if (user?.username?.isEmpty == true) {
      current = LocalPNG(
        name: 'hlw_mine_head',
        width: 36.w,
        height: 36.w,
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
    return Ink(child: current);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.w,
      padding: EdgeInsets.symmetric(horizontal: 60.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Utils.splitPopView(context),
            child: LocalPNG(
              name: "hlw_arrow_left",
              width: 20.w,
              height: 20.w,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 146.w),
          Container(
            width: 500.w,
            height: 36.w,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
                color: StyleTheme.gray247Color,
                border: Border.all(color: StyleTheme.gray238Color, width: 1.w),
                borderRadius: BorderRadius.all(Radius.circular(17.w))),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                LocalPNG(
                  name: "hlw_top_search",
                  width: 20.w,
                  height: 20.w,
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: TextField(
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    controller: textController,
                    style: StyleTheme.font_black_31_14,
                    textInputAction: TextInputAction.search,
                    cursorColor: StyleTheme.black31Color,
                    enabled: !isHud, //加载完才让输入
                    onSubmitted: (value) {
                      searchInfo();
                    },
                    onChanged: (value) {
                      if (value.isEmpty) clickSearchBar();
                    },
                    decoration: InputDecoration(
                      hintText: Utils.txt('srsgjz'),
                      hintStyle: StyleTheme.font_gray_170_16_medium,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: BorderSide(
                              color: Colors.transparent, width: 0.5.w)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: BorderSide(
                              color: Colors.transparent, width: 0.5.w)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: BorderSide(
                              color: Colors.transparent, width: 0.5.w)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: BorderSide(
                              color: Colors.transparent, width: 0.5.w)),
                    ),
                  ),
                ),
                Offstage(
                  offstage: textController.text.isEmpty,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => clickSearchBar(),
                    child: Padding(
                      padding: EdgeInsets.only(left: 3.w),
                      child: SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: Icon(
                          Icons.cancel,
                          color: Colors.grey,
                          size: 20.w,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(width: 20.w),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              searchInfo();
            },
            child: Container(
              height: 36.w,
              width: 70.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: StyleTheme.orange255Color,
                  borderRadius: BorderRadius.all(Radius.circular(17.w))),
              child: Text(Utils.txt('sosuo'),
                  style: isSearch
                      ? StyleTheme.font_white_255_16
                      : StyleTheme.font_black_34_16_medium),
            ),
          ),
          Expanded(child: Container()),
          _buildUsrHeaderWidget(context),
        ],
      ),
    );
  }
}

class _SearchWidget extends StatelessWidget {
  final List tps;
  final ScrollController scrollController;
  final Future<bool> Function() onRefresh, onLoading;
  const _SearchWidget({Key? key, required this.tps, required this.scrollController, required this.onRefresh, required this.onLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenHeight - StyleTheme.navHegiht - 10.w,
      width: ScreenWidth,
      padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 60.w),
      child: EasyPullRefresh(
        onRefresh: onRefresh,
        onLoading: onLoading,
        sameChild: GridView.count(
            controller: scrollController,
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            cacheExtent: ScreenHeight * 3,
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 5.w,
            crossAxisSpacing: 40.w,
            childAspectRatio: 440 / 260,
            scrollDirection: Axis.vertical,
            children: tps
                .map((e) => Utils.newsModuleUI(context, e, style: 2))
                .toList()),
      ),
    );
  }
}

class _UnSearchWidget extends StatelessWidget {
  final List banners, hots, records;
  final ScrollController scrollController;
  final Function clearRecords, tapTags;
  final Future<bool> Function() onRefresh;
  const _UnSearchWidget({Key? key, required this.banners, required this.hots, required this.records, required this.scrollController, required this.clearRecords,
    required this.tapTags, required this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasyPullRefresh(
      onRefresh: onRefresh,
      sameChild: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 60.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Utils.txt('ssls'), style: StyleTheme.font_black_0_30),
                  GestureDetector(
                    onTap: () => clearRecords(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LocalPNG(
                          name: 'hlw_close_black',
                          width: 16.w,
                          height: 16.w,
                        ),
                        SizedBox(width: 5.w),
                        Text(Utils.txt('qcjl'),
                            style: StyleTheme.font_black_0_15),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.w),
              Container(
                padding: EdgeInsets.only(
                  top: StyleTheme.margin,
                  bottom: 10.w,
                ),
                child: records.isEmpty
                    ? Center(
                  child: Text(
                    '没有匹配到"${Utils.txt('zwssjl')}"的内容',
                    style: StyleTheme.font_black_34_17,
                  ),
                )
                    : Wrap(
                  spacing: 10.w,
                  runSpacing: 15.w,
                  children: records.map((e) {
                    return GestureDetector(
                      onTap: () => tapTags(e),
                      child: Container(
                        decoration: BoxDecoration(
                            color: StyleTheme.gray246Color,
                            borderRadius: BorderRadius.circular(10.w)),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.w, horizontal: 20.w),
                        child: Text(
                          e,
                          style: StyleTheme.font_black_34_16,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 50.w),
              Divider(
                color: StyleTheme.gray238Color,
                height: 10.w,
              ),
              SizedBox(height: 30.w),
              Visibility(
                visible: banners.isNotEmpty,
                  child: Container(
                    key: ValueKey(banners),
                    height: 240.w,
                    padding: EdgeInsets.zero,
                    child: Utils.bannerScaleExtSwiper(
                      data: banners,
                      itemWidth: 710.w,
                      itemHeight: 240.w, // 240 + 23 + 10
                      viewportFraction: 0.67, // 710 / 1040
                      scale: 1,
                      spacing: 5.w,
                      lineWidth: 20.w,
                    ),
                  ),
              ),
              Text(Utils.txt('rmtj'), style: StyleTheme.font_black_0_30),
              SizedBox(height: 10.w),
              hots.isEmpty
                  ? LoadStatus.noData()
                  : Container(
                padding: EdgeInsets.only(
                  top: StyleTheme.margin,
                  bottom: 10.w,
                ),
                child: Wrap(
                  spacing: 10.w,
                  runSpacing: 15.w,
                  children: hots.map((e) {
                    return GestureDetector(
                      onTap: () => tapTags(e["word"].toString()),
                      child: Container(
                        decoration: BoxDecoration(
                            color: StyleTheme.gray246Color,
                            borderRadius:
                            BorderRadius.circular(10.w)),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.w, horizontal: 20.w),
                        child: Text(
                          e["word"] ?? "",
                          style: StyleTheme.font_black_34_16,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 50.w),
            ],
          ),
        ),
      ),
    );
  }
}