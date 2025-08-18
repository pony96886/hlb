import 'dart:async';
import 'dart:convert' as convert;
import 'dart:math' as math;
import 'package:hlw/base/base_main_view.dart';
import 'package:hlw/base/base_widget.dart';
import 'package:hlw/base/input_container.dart';
import 'package:hlw/base/request_api.dart';
import 'package:hlw/base/update_sysalert.dart';
import 'package:hlw/home/home_comments_page.dart';
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

class HomeContentDetailPage extends BaseWidget {
  HomeContentDetailPage({Key? key, this.cid = "0"}) : super(key: key);
  final String cid;

  @override
  State cState() => _HomeContentDetailPageState();
}

class _HomeContentDetailPageState
    extends BaseWidgetState<HomeContentDetailPage> {
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

  ScrollController controller = ScrollController();
  StreamSubscription? _streamSubscription;

  @override
  Widget appbar() => Container();

  @override
  void onCreate() {
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
            showActivity(GeneralAdsModel.fromJson(data["notice"]));
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
  void showActivity(GeneralAdsModel? ad) {
    if (ad == null) return;
    UpdateSysAlert.showAvtivetysAlert(
      ad: ad,
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
    focusNode.dispose();
    controller.dispose();
    _streamSubscription?.cancel();
  }

  @override
  Widget pageBody(BuildContext context) {
    return Column(children: [
      const SearchBarWidget(),
      Expanded(
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 30.w),
          GestureDetector(
            onTap: () => Utils.splitPopView(context),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.all(5.w),
              // color: Colors.orange,
              width: 40.w,
              height: 40.w,
              alignment: Alignment.center,
              child: const LocalPNG(
                name: '51_nav_back_w',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Expanded(
            flex: 985,
            child: _buildLeftWidget(),
          ),
          SizedBox(width: 30.w),
          Expanded(
            flex: 500,
            child: _buildRightWidget(),
          ),
          SizedBox(width: 30.w),
        ]),
      ),
    ]);

    return BaseMainView(
      paddingTop: 94.w,
      dataDetail: data,
      dataArticle: dataArticle,
      banners: banners,
      cid: widget.cid,
      isBackBtn: true,
      leftWidget: SizedBox(
        height: ScreenHeight - 94.w,
        width: 640.w,
        child: netError
            ? LoadStatus.netErrorWork(onTap: () {
                netError = false;
                getData();
              })
            : isHud
                ? LoadStatus.showLoading(mounted)
                : data == null
                    ? LoadStatus.noData()
                    : Stack(children: [
                        Positioned(
                            top: 0,
                            bottom: 60.w,
                            left: 0,
                            right: 0,
                            child: EasyPullRefresh(
                              child: _CheckCommentsBar(data: data),
                              onRefresh: () {
                                page = 1;
                                return getData();
                              },
                              onLoading: () {
                                page++;
                                return getReviewData();
                              },
                              sameChild: ListView(
                                addRepaintBoundaries: false,
                                addAutomaticKeepAlives: false,
                                cacheExtent: ScreenHeight * 5,
                                scrollDirection: Axis.vertical,
                                controller: controller,
                                children: [
                                  Text(
                                    Utils.convertEmojiAndHtml(
                                        "${data["title"] ?? ""}"),
                                    style: StyleTheme.font_black_31_30_semi,
                                    maxLines: 3,
                                  ),
                                  netErrorTag || dataTag.isEmpty
                                      ? Container()
                                      : _TagsCategoriesWidget(
                                          key: ValueKey(dataTag),
                                          data: data,
                                          tags: dataTag,
                                          // categories: data['plates'],
                                        ),
                                  SizedBox(height: 30.w),
                                  Text(
                                    "${Utils.txt('fbsj')}•${DateUtil.formatDateStr(data["created_at"] ?? " 2023-06-05 20:11:55", format: "yyyy年MM月dd日")}",
                                    style: StyleTheme.font_gray_153_15,
                                  ),
                                  SizedBox(height: 20.w),
                                  Divider(
                                    height: 1.w,
                                    color: StyleTheme.gray238Color,
                                  ),
                                  //网页内容
                                  _HtmlWidget(data: data, picMap: picMap),
                                  Container(
                                    margin: EdgeInsets.only(top: 20.w),
                                    color: StyleTheme.gray238Color,
                                    height: 1.w,
                                  ),
                                  SizedBox(height: 15.w),
                                  Text(
                                    Utils.txt('plly') +
                                        " ${data["comment_ct"]}",
                                    style: StyleTheme.font_black_34_30,
                                  ),
                                  SizedBox(height: 15.w),
                                  isHud
                                      ? Column(children: [
                                          LoadStatus.showLoading(mounted),
                                          SizedBox(height: 30.w),
                                        ])
                                      : comments.isEmpty
                                          ? Column(children: [
                                              LoadStatus.noData(),
                                              SizedBox(height: 30.w),
                                            ])
                                          : ListView.builder(
                                              addRepaintBoundaries: true,
                                              addAutomaticKeepAlives: true,
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: comments.length,
                                              itemBuilder: (context, index) {
                                                return HomeCommentsPage(
                                                  data: comments[index],
                                                  replyCall: (dp, cmid) {
                                                    if (dp.isNotEmpty) {
                                                      isReplay = true;
                                                      tip = dp;
                                                      commid = cmid;
                                                      focusNode.requestFocus();
                                                      if (mounted)
                                                        setState(() {});
                                                    } else {
                                                      resetXcfocusNode();
                                                    }
                                                  },
                                                  resetCall: () {
                                                    resetXcfocusNode();
                                                  },
                                                );
                                              }),
                                ],
                              ),
                            )),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: 55.w,
                            width: double.infinity,
                            child: InputContainer(
                              width: double.infinity,
                              focusNode: focusNode,
                              hintText: '快留下您的评论',
                              childPrefix: RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: tip[0],
                                    style: StyleTheme.font_black_0_15),
                                TextSpan(
                                    text: tip[1],
                                    style: StyleTheme.font_gray_153_15),
                              ])),
                              onEditingCompleteText: (value) {
                                if (isReplay) {
                                  inputTxt(2, commid, value);
                                  isReplay = false;
                                  tip = [Utils.txt("wyddxf") + '：', ""];
                                  getData();
                                } else {
                                  inputTxt(1, widget.cid, value);
                                }
                              },
                              onOutEventComplete: () {
                                resetXcfocusNode();
                              },
                              isCollect: data["is_favorite"] == 1,
                              // onCollectEventComplete: () {
                              //   postCollectData();
                              // },
                              child: Container(),
                            ),
                          ),
                        )
                      ]),
      ),
    );
  }

  Widget _buildLeftWidget() {
    if (netError) {
      return LoadStatus.netErrorWork(onTap: () {
        netError = false;
        getData();
      });
    }
    if (isHud) return LoadStatus.showLoading(mounted);
    if (data == null) return LoadStatus.noData();
    return SingleChildScrollView(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            "${data["title"] ?? ""}",
            style: StyleTheme.font_white_255_28_medium,
          ),
        ),
        SizedBox(height: 20.w),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            '作者',
            style: StyleTheme.font_gray_153_18,
          ),
          Text(
            DateUtil.formatDateStr(data["created_at"] ?? " 2023-06-05 20:11:55",
                format: "yyyy年MM月dd日"),
            style: StyleTheme.font_gray_153_18,
          ),
        ]),
        SizedBox(height: 28.w),
        //网页内容
        _HtmlWidget(data: data, picMap: picMap),
        SizedBox(height: 40.w),
      ]),
    );
  }

  Widget _buildRightWidget() {
    return Column(children: [
      SizedBox(
        width: double.infinity,
        child: Text(
          '热门推荐',
          style: StyleTheme.font_orange_244_28_medium,
        ),
      ),
      Expanded(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: 10,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 15.w),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.w),
                    color: const Color(0x0BFFFFFF),
                  ),
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'data',
                        style: StyleTheme.font_white_255_22_bold,
                      ),
                      SizedBox(height: 5.w),
                      Text(
                        'data',
                        style: StyleTheme.font_gray_209_18,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      )
    ]);
  }
}

class _CheckCommentsBar extends StatelessWidget {
  final dynamic data;
  const _CheckCommentsBar({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 44.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: StyleTheme.gray247Color,
          borderRadius: BorderRadius.circular((5.w)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '查看全部${data["comment_ct"]}条评论',
              style: StyleTheme.font_black_34_16_medium,
            ),
            SizedBox(width: 5.w),
            Transform.rotate(
              angle: math.pi,
              child: LocalPNG(
                name: "51_nav_back",
                width: 11.w,
                height: 11.w,
              ),
            ),
          ],
        ));
  }
}

class _TagsCategoriesWidget extends StatelessWidget {
  final dynamic data;
  final List tags;
  // final Map categories;
  const _TagsCategoriesWidget({
    Key? key,
    required this.data,
    required this.tags,
    // required this.categories
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List mix = tags.entries.toList() + categories.entries.toList();
    return Padding(
      padding: EdgeInsets.only(top: 10.w),
      child: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        runSpacing: StyleTheme.margin,
        spacing: StyleTheme.margin,
        children: tags.map((x) {
          // MapEntry e = mix[x];
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (Utils.unFocusNode(context)) {
                Utils.navTo(context, "/homesearchpage/${x['name']}");
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              height: 20.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.w),
                color: x['count'] > 20
                    ? StyleTheme.red252Color
                    : StyleTheme.gray244Color,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    x['name'],
                    style: x['count'] > 20
                        ? StyleTheme.font_red_74_13
                        : StyleTheme.font_gray_119_13,
                  )
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
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
