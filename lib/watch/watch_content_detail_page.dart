import 'dart:async';
import 'dart:convert' as convert;
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:hlw/base/base_main_view.dart';
import 'package:hlw/base/base_widget.dart';
import 'package:hlw/base/gen_custom_nav.dart';
import 'package:hlw/base/input_container.dart';
import 'package:hlw/base/request_api.dart';
import 'package:hlw/base/update_sysalert.dart';
import 'package:hlw/home/home_comments_page.dart';
import 'package:hlw/model/alert_ads_model.dart';
import 'package:hlw/model/general_ads_model.dart';
import 'package:hlw/util/easy_pull_refresh.dart';
import 'package:hlw/util/encdecrypt.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/netimage_tool.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:flutter_html/flutter_html.dart';

import '../util/eventbus_class.dart';
import '../widget/search_bar_widget.dart';

class WatchContentDetailPage extends BaseWidget {
  WatchContentDetailPage({Key? key, this.cid = "0"}) : super(key: key);
  final String cid;

  @override
  State cState() => _WatchContentDetailPageState();
}

class _WatchContentDetailPageState
    extends BaseWidgetState<WatchContentDetailPage>
    with SingleTickerProviderStateMixin {
  bool isHud = true;
  bool netError = false;
  bool netErrorTag = false;
  bool noMore = false;
  bool isReplay = false;
  String commid = "0";
  List<String> tip = [Utils.txt("wyddxf") + '：', ""];
  FocusNode focusNode = FocusNode();

  int page = 1;
  String last_ix = "0";

  dynamic data, dataArticle;
  List dataTag = [];
  List comments = [];
  List banners = [];

  Map picMap = {};

  late TabController _tabController;
  late PageController _pageController;
  int _selectIndex = 0;
  bool _isOnTab = false;

  ScrollController controller = ScrollController();
  StreamSubscription? _streamSubscription;

  @override
  Widget appbar() => Container();

  @override
  void onCreate() {
    _tabController =
        TabController(length: 2, initialIndex: _selectIndex, vsync: this);
    _pageController = PageController();
    getData();
    getDataArticle();
    getDataTag();
    _eventBus();
  }

  Future<bool> getData() {
    return reqDetailContent(cid: widget.cid).then((value) {
      if (value?.data == null) {
        netError = true;
        if (mounted) setState(() {});
        return false;
      }
      if (value?.status == 1) {
        data = value?.data["article"];
        banners = value?.data["ad"] ?? [];
        comments = value?.data["list"] ?? [];
        noMore = comments.isEmpty;
        getImgStrList(data["txt"] ?? "");
        // if (data['tags'] == null || data['tags'].length == 0) {
        //   getDataTag();
        // } else {
        //   dataTag = data['tags'];
        // }
      } else {
        Utils.showText(value?.msg ?? "", call: () {
          if (mounted) {
            Future.delayed(const Duration(milliseconds: 100), () {
              finish();
            });
          }
        });
      }
      isHud = false;
      if (mounted) setState(() {});
      return false;
    });
  }

  // 標籤
  getDataTag() {
    reqArticleTag(id: widget.cid).then((value) {
      if (value?.data == null) {
        netErrorTag = true;
        if (mounted) setState(() {});
        return false;
      }
      dataTag = value?.data;
      if (mounted) setState(() {});
    });
  }

  // 上下篇
  getDataArticle() {
    reqDetailArticle(cid: widget.cid).then((value) {
      if (value?.data == null) {
        if (mounted) setState(() {});
        return false;
      }
      dataArticle = value?.data;
      if (mounted) setState(() {});
    });
  }

  // 收藏
  postCollectData() {
    reqCollectContent(cid: widget.cid).then((value) {
      if (value?.status == 1) {
        data["is_favorite"] = data["is_favorite"] == 0 ? 1 : 0;
        if (mounted) setState(() {});
      } else {
        Utils.showText(value?.msg ?? "");
      }
    });
  }

  // 加载【更多】评论
  Future<bool> getReviewData() {
    return reqDetailComment(id: widget.cid, page: page, last_ix: last_ix)
        .then((value) {
      if (value?.data == null) {
        Utils.showText(value?.msg ?? "");
        return false;
      }
      last_ix = value?.data["last_ix"] ?? "0";
      List st = List.from(value?.data["list"]);
      if (page == 1) {
        noMore = false;
        comments = st;
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (data["notice"] != null) {
            showActivity(AlertAdsModel.fromJson(data["notice"]));
          }
        });
      } else if (page > 1 && st.isNotEmpty) {
        comments.addAll(st);
        comments = Utils.listMapNoDuplicate(comments);
      } else {
        noMore = true;
      }
      isHud = false;
      if (mounted) setState(() {});
      return noMore;
    });
  }

  // 显示弹窗
  void showActivity(AlertAdsModel? ad) {
    if (ad == null) return;
    UpdateSysAlert.showAvtivetysAlert(
      ad: AlertAdsModel(
          width: ad.show_width, height: ad.show_height, img_url: ad.thumb),
      confirm: () => Utils.openRoute(context, ad),
    );
  }

  // 发表评论
  void inputTxt(int type, String comment_id, String value) {
    if (value.isEmpty) {
      resetXcfocusNode();
      return;
    }

    Utils.startGif(tip: Utils.txt("fbioz"));
    reqReplayComment(type: type, id: comment_id, content: value).then((value) {
      Utils.closeGif();
      if (value?.status == 1) {
        Utils.showText(value?.msg ?? "");
      } else {
        Utils.showText(value?.msg ?? "");
      }
    });
  }

  void resetXcfocusNode() {
    isReplay = false;
    tip = [Utils.txt("wyddxf") + '：', ""];
    focusNode.unfocus();
    if (mounted) setState(() {});
  }

  _eventBus() {
    _streamSubscription = UtilEventbus().on<EventbusClass>().listen((event) {
      if (event.arg["GoTop"] == 'GoTop' && controller.offset > 0) {
        controller.animateTo(0,
            duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
      }
    });
  }

  //提取HTML字符串中的img列表
  void getImgStrList(String body) async {
    // var regExp = RegExp(r'(?<=(img[^>]*src="))[^"]*'); //safari 不兼容不采用
    var regImgExp = RegExp(r'(<img[^>]+src="((?:https?:)?\/\/[^"]+)"[^>]*?>)');
    List<String> images = regImgExp
        .allMatches(body)
        .map<String>((e) => e.group(0) ?? "")
        .toList();

    List<String> selects = [];
    for (var el in images) {
      var regSrcExp = RegExp(
          r'(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])?');
      selects.add(regSrcExp.stringMatch(el) ?? "");
    }
    picMap = {'resources': selects, 'index': 0};
    isHud = false;
    if (mounted) setState(() {});
  }

  @override
  void onDestroy() {
    _tabController.dispose();
    _pageController.dispose();
    focusNode.dispose();
    controller.dispose();
    _streamSubscription?.cancel();
  }

  @override
  Widget pageBody(BuildContext context) {
    return Stack(
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: _buildLeftWidget()),
          _buildRightWidget(),
        ]),
        Positioned(
            top: 64.w,
            left: 64.w,
            right: 478.w,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Utils.splitPopView(context),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.w),
                      color: StyleTheme.white10,
                    ),
                    width: 56.w,
                    height: 56.w,
                    alignment: Alignment.center,
                    child: LocalPNG(
                      name: '51_nav_back_w',
                      width: 28.w,
                      height: 28.w,
                    ),
                  ),
                ),
                SizedBox(
                  width: 16.w,
                ),
                Text(
                  "视频标题标题",
                  style: StyleTheme.font_white_255_28_600,
                  maxLines: 1,
                ),
                SizedBox(
                  width: 24.w,
                ),
              ],
            ))
      ],
    );
  }

  Widget _buildLeftWidget() {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Positioned(
              right: 26.w,
              bottom: 113.w,
              child: Column(
                children: [
                  _buildVideoRightWidget("hlw_icon_xin", "2213"),
                  _buildVideoRightWidget("icon_comment", "2213"),
                  _buildVideoRightWidget("icon_collect", "2213"),
                  _buildVideoRightWidget("hlw_icon_fx", "2213"),
                ],
              ))
        ],
      ),
    );
  }

  Widget _buildVideoRightWidget(String icon, String value) {
    return Column(
      children: [
        SizedBox(
          height: 36.w,
        ),
        LocalPNG(
          name: icon,
          width: 32.w,
          height: 32.w,
        ),
        SizedBox(
          height: 22.w,
        ),
        Text(
          value,
          style: StyleTheme.font_white_20,
        )
      ],
    );
  }

  Widget _buildRightWidget() {
    return Container(
      width: 478.w,
      color: StyleTheme.white10,
      child: Column(
        children: [
          Container(
            height: 64.w,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: StyleTheme.white10,
                  width: 1.w,
                ),
              ),
            ),
            child: Theme(
                data: ThemeData(
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent),
                child: TabBar(
                  onTap: (index) {
                    _onTabPageChange(index, isOnTab: true);
                  },
                  overlayColor:
                      const MaterialStatePropertyAll(Colors.transparent),
                  dividerColor: Colors.transparent,
                  labelStyle: StyleTheme.font_white_20,
                  unselectedLabelStyle: StyleTheme.font_gray_153_20,
                  dividerHeight: 0,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicator: CustomTabIndicator(
                    width: 34.w,
                    height: 10.w,
                    color: StyleTheme.orange255Color,
                    radius: 10.w,
                  ),
                  labelPadding: EdgeInsets.symmetric(horizontal: 12.w),
                  indicatorSize: TabBarIndicatorSize.tab,
                  physics: const BouncingScrollPhysics(),
                  tabs: [Text("视频简介"), Text("用户评论")],
                  controller: _tabController,
                )),
          ),
          Expanded(
            child: PageView(
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) {
                if (!_isOnTab) _onTabPageChange(index, isOnTab: false);
              },
              controller: _pageController,
              children: [_buildContentWiget(), _buildCommentsWidget()],
            ),
          ),
        ],
      ),
    );
  }

  dynamic defaultItemData = {
    "id": 39668,
    "title": "黑料网最新入口，黑料回家路，黑料合集每日更新，回家路合集页",
    "plates": {},
    "created_date": "2025-05-01 00:00:00",
    "is_ad": 0,
    "thumb":
        "https://new.fwvkjw.cn/upload_01/upload/20250813/2025081312034176716.png",
  };

  Widget _buildContentWiget() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 19.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "推特顶级约炮大神 一杆钢枪 专注开发清纯女大学生穿着女仆装带到酒店",
            softWrap: true,
            maxLines: null,
            overflow: TextOverflow.visible,
            style: StyleTheme.font_white_255_22_600.copyWith(height: 1.45),
          ),
          SizedBox(height: 20.w),
          Wrap(
            spacing: 20.w,
            runSpacing: 10.w,
            children: [
              "标签1",
              "标签标签",
              "很长很长的一个标签",
              "标签A",
              "标签B",
            ].map((tag) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.w),
                decoration: BoxDecoration(
                  color: StyleTheme.orange47Color,
                  borderRadius: BorderRadius.circular(4.w),
                ),
                child: Text(
                  tag,
                  style:
                      StyleTheme.font_orange_255_20_600.copyWith(height: 1.6),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20.w),
          Container(
            height: 100.w,
            margin: EdgeInsets.only(bottom: 20.w),
            decoration: BoxDecoration(
              color: StyleTheme.gray187Color,
              borderRadius: BorderRadius.circular(12.w),
            ),
          ),
          Container(
            height: 100.w,
            margin: EdgeInsets.only(bottom: 20.w),
            decoration: BoxDecoration(
              color: StyleTheme.gray187Color,
              borderRadius: BorderRadius.circular(12.w),
            ),
          ),
          Container(
            height: 100.w,
            margin: EdgeInsets.only(bottom: 40.w),
            decoration: BoxDecoration(
              color: StyleTheme.gray187Color,
              borderRadius: BorderRadius.circular(12.w),
            ),
          ),
          Text("评论留言（20）", style: StyleTheme.font_white_255_18),
          SizedBox(height: 20.w),
          GridView.count(
            padding: EdgeInsets.fromLTRB(0, 15.w, 0, 10.w),
            addRepaintBoundaries: false,
            addAutomaticKeepAlives: false,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            cacheExtent: ScreenHeight * 3,
            crossAxisCount: 1,
            mainAxisSpacing: 20.w,
            crossAxisSpacing: 20.w,
            childAspectRatio: (430 / 140),
            children: [
              defaultItemData,
              defaultItemData,
              defaultItemData,
              defaultItemData,
              defaultItemData,
            ].map((e) => Utils.newsModuleUI(context, e, style: 4)).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildCommentsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("评论留言（20）", style: StyleTheme.font_white_255_18),
              SizedBox(
                height: 20.w,
              ),
              _buildCommentItem(true, true, false),
              _buildCommentItem(true, true, true),
              _buildCommentItem(true, true, true),
              _buildCommentItem(true, true, false),
              _buildCommentItem(true, true, false),
              _buildCommentItem(true, true, true),
              _buildCommentItem(true, true, true),
              _buildCommentItem(true, true, false),
            ],
          ),
        )),
        Container(
          height: 88.w,
          color: StyleTheme.white05,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.w),
          child: Row(
            children: [
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: StyleTheme.white10,
                  borderRadius: BorderRadius.circular(56.w),
                ),
              ),
              SizedBox(
                width: 16.w,
              ),
              Expanded(
                  child: Container(
                height: 40.w,
                decoration: BoxDecoration(
                  color: StyleTheme.white10,
                  borderRadius: BorderRadius.circular(40.w),
                ),
              )),
              SizedBox(
                width: 16.w,
              ),
              GestureDetector(
                onTap: () {},
                child: LocalPNG(
                  name: "hlw_icon_appendix",
                  width: 32.w,
                  height: 32.w,
                ),
              ),
              SizedBox(
                width: 12.w,
              ),
              GestureDetector(
                onTap: () {},
                child: LocalPNG(
                  name: "icon_collect",
                  width: 32.w,
                  height: 32.w,
                ),
              ),
              SizedBox(
                width: 12.w,
              ),
              GestureDetector(
                onTap: () {},
                child: LocalPNG(
                  name: "hlw_icon_fx",
                  width: 32.w,
                  height: 32.w,
                ),
              ),
              SizedBox(
                width: 12.w,
              ),
              GestureDetector(
                onTap: () {},
                child: LocalPNG(
                  name: "hlw_icon_send",
                  width: 32.w,
                  height: 32.w,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildCommentItem(bool root, bool hasReply, bool expand) {
    return Container(
      margin: EdgeInsets.only(bottom: root ? 30.w : 0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: root ? 56.w : 40.w,
            height: root ? 56.w : 40.w,
            decoration: BoxDecoration(
              color: StyleTheme.white10,
              borderRadius: BorderRadius.circular(
                root ? 56.w : 40.w,
              ),
            ),
          ),
          SizedBox(
            width: 16.w,
          ),
          Expanded(
              child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "昵称",
                    style: StyleTheme.font_white_255_18_500,
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      LocalPNG(
                        name: "hlw_user_level_bg",
                        width: 95.w,
                        height: 28.w,
                      ),
                      Container(
                        width: 95.w,
                        margin: EdgeInsets.only(
                          left: 12.w,
                        ),
                        child: Text(
                          "社交达人",
                          textAlign: TextAlign.center,
                          style: StyleTheme.font_white_255_14,
                        ),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 12.w,
              ),
              Text(
                "曾经工作中帮过一个妹子装打印机墨水，但妹子长得一般，后面请我吃饭拒绝了。难道我不知道她想泡我吗？",
                softWrap: true,
                maxLines: null,
                overflow: TextOverflow.visible,
                style: StyleTheme.font_gray_153_18.copyWith(height: 1.78),
              ),
              SizedBox(
                height: 12.w,
              ),
              Row(
                children: [
                  Text(
                    "1小时前",
                    style: StyleTheme.font_gray_102_18,
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  Container(
                    child: Row(
                      children: [
                        LocalPNG(
                            name: "hlw_icon_comment_like",
                            width: 18.w,
                            height: 18.w),
                        SizedBox(
                          height: 4.w,
                        ),
                        Text(
                          "1879",
                          style: StyleTheme.font_gray_102_18,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  Container(
                    child: Row(
                      children: [
                        LocalPNG(
                            name: "hlw_icon_comment_comment",
                            width: 18.w,
                            height: 18.w),
                        SizedBox(
                          height: 4.w,
                        ),
                        Text(
                          "回复",
                          style: StyleTheme.font_gray_102_18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (root && hasReply && !expand)
                SizedBox(
                  height: 12.w,
                ),
              if (root && hasReply && !expand)
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Container(
                        width: 56.w,
                        height: 2.w,
                        color: StyleTheme.white10,
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                      Text(
                        style: StyleTheme.font_orange_229_18_500,
                        "展开2条回复",
                      ),
                      LocalPNG(
                        name: "hlw_icon_expand",
                        width: 18.w,
                        height: 18.w,
                      )
                    ],
                  ),
                ),
              if (root && hasReply && expand)
                SizedBox(
                  height: 22.w,
                ),
              if (root && hasReply && expand)
                Container(
                  decoration: BoxDecoration(
                    color: StyleTheme.white05,
                    borderRadius: BorderRadius.circular(8.w),
                  ),
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [_buildCommentItem(false, false, false)],
                  ),
                )
            ],
          ))
        ],
      ),
    );
  }

  void _onTabPageChange(index, {bool isOnTab = false}) {
    if (_selectIndex == index) {
      _isOnTab = false;
      return;
    }
    _selectIndex = index;
    if (!isOnTab) {
      _tabController.animateTo(_selectIndex);
      setState(() {});
    } else {
      _pageController.animateToPage(_selectIndex,
          duration: const Duration(milliseconds: 200), curve: Curves.linear);

      //等待滑动解锁
      Future.delayed(const Duration(milliseconds: 200), () {
        _isOnTab = false;
        setState(() {});
      });
    }
  }
}

class _HtmlWidget extends StatelessWidget {
  final dynamic data;
  final Map picMap;

  const _HtmlWidget({Key? key, required this.data, required this.picMap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (cx) {
      String html = data["txt"] ?? "";
      html = kIsWeb
          ? html.replaceAll("</br>", "")
          : html.replaceAll("<br>", "").replaceAll("</br>", "");
      return Html(
        shrinkWrap: true,
        data: html,
        style: {
          "*": Style(
            color: StyleTheme.gray199Color,
            lineHeight: LineHeight.rem(1.8),
            margin: Margins.zero,
          ),
          "a": Style(color: StyleTheme.blue25Color)
        },
        customRenders: {
          (_context) {
            return _context.tree.element?.localName == 'img';
          }: CustomRender.widget(widget: (_context, parsedChild) {
            String className = _context.tree.element?.attributes["class"] ?? "";
            String url = _context.tree.element?.attributes["src"] ?? "";
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (className.isNotEmpty) {
                  String? router =
                      _context.tree.element?.attributes["router"] ?? "";
                  if (Utils.unFocusNode(context)) {
                    Utils.openRoute(context, convert.jsonDecode(router));
                  }
                } else {
                  if (picMap.isEmpty) return;
                  picMap["index"] =
                      picMap["resources"].indexWhere((el) => el == url);
                  String data = EncDecrypt.encry(convert.jsonEncode(picMap));
                  if (Utils.unFocusNode(context)) {
                    Utils.navTo(context, '/homepreviewviewpage/$data');
                  }
                }
              },
              child: NetImageTool(url: url, fit: BoxFit.contain),
            );
          }),
          (_context) {
            return _context.tree.element?.localName == 'span';
          }: CustomRender.widget(widget: (_context, parsedChild) {
            String className = _context.tree.element?.attributes["class"] ?? "";
            if (className.isNotEmpty) {
              String? router =
                  _context.tree.element?.attributes["router"] ?? "";
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (Utils.unFocusNode(context)) {
                    Utils.log(router);
                    Utils.openRoute(context, convert.jsonDecode(router));
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  height: 30.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.w),
                    color: StyleTheme.gray244Color,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _context.tree.element?.text ?? "#",
                        style: StyleTheme.font_blue_30_14,
                      )
                    ],
                  ),
                ),
              );
            } else {
              return _context.buildContext.widget;
            }
          }),
          (_context) {
            return _context.tree.element?.localName == 'div';
          }: CustomRender.widget(widget: (_context, parsedChild) {
            String? play_type =
                _context.tree.element?.attributes["class"] ?? "";
            if (play_type == "dplayer") {
              String config = _context.tree.element?.attributes["config"] ?? "";
              Map? map = convert.jsonDecode(config);
              String cover = map?["video"]?["pic"] ?? "";
              String url = map?["video"]?["url"] ?? "";
              if (url.isEmpty) {
                return Text('视频播放地址错误', style: StyleTheme.font_gray_204_13);
              }
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (Utils.unFocusNode(context)) {
                    Utils.navTo(context,
                        "/homeplayerpage/${Uri.encodeComponent(cover)}/${Uri.encodeComponent(url)}");
                  }
                },
                child: SizedBox(
                  width: StyleTheme.contentWidth,
                  height: StyleTheme.contentWidth / 16 * 9,
                  child: Stack(
                    children: [
                      NetImageTool(url: cover),
                      Container(color: Colors.black12),
                      Center(
                        child: LocalPNG(
                          name: "51_play_n",
                          width: 40.w,
                          height: 40.w,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
            return Text('key错误', style: StyleTheme.font_gray_204_13);
          }),
        },
        onLinkTap: (url, context, attributes, element) {
          Utils.openURL(url ?? "");
        },
      );
    });
  }
}

class CustomTabIndicator extends Decoration {
  final double width;
  final double height;
  final Color color;
  final double radius;

  const CustomTabIndicator({
    required this.width,
    required this.height,
    required this.color,
    required this.radius,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(this, onChanged);
  }
}

class _CustomPainter extends BoxPainter {
  final CustomTabIndicator decoration;

  _CustomPainter(this.decoration, VoidCallback? onChanged) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Paint paint = Paint()
      ..color = decoration.color
      ..isAntiAlias = true;

    final double xCenter =
        offset.dx + cfg.size!.width / 2 - decoration.width / 2;
    final double yBottom =
        offset.dy + cfg.size!.height - decoration.height + 22.w;

    final Rect rect = Rect.fromLTWH(
      xCenter,
      yBottom,
      decoration.width,
      decoration.height,
    );

    final RRect rRect =
        RRect.fromRectAndRadius(rect, Radius.circular(decoration.radius));
    canvas.drawRRect(rRect, paint);
  }
}
