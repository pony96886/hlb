import 'package:hlw/base/request_api.dart';
import 'package:hlw/util/easy_pull_refresh.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';

class LabelPage extends StatefulWidget {
  LabelPage({Key? key, this.isShow = false}) : super(key: key);
  final bool isShow;

  @override
  State<LabelPage> createState() => _LabelPageState();
}

class _LabelPageState extends State<LabelPage> {
  bool isHud = true;
  bool netError = false;
  List popular = [];
  List all = [];
  int page = 1;
  bool noMore = false;

  Future<bool> getData() {
    return reqLabelList(page: page).then((value) {
      if (value?.data == null) {
        netError = true;
        setState(() {});
        return false;
      }
      List tp = List.from(value?.data["all"]);
      if (page == 1) {
        noMore = false;
        popular = List.from(value?.data["popular"]);
        all = tp;
      } else if (tp.isNotEmpty) {
        all.addAll(tp);
      } else {
        noMore = true;
      }
      isHud = false;
      setState(() {});
      return noMore;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  void didUpdateWidget(covariant LabelPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.isShow && isHud) {
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Utils.navModuleUI(context),
        Expanded(
          child: netError
              ? LoadStatus.netErrorWork(onTap: () {
                  netError = false;
                  getData();
                })
              : isHud
                  ? LoadStatus.showLoading(mounted)
                  : EasyPullRefresh(
                      onRefresh: () {
                        page = 1;
                        return getData();
                      },
                      onLoading: () {
                        page++;
                        return getData();
                      },
                      child: SingleChildScrollView(
                        padding: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.w),
                            RichText(
                                text: TextSpan(children: [
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 6.w),
                                  child: LocalPNG(
                                    name: "51_label_hot",
                                    width: 16.w,
                                    height: 16.w,
                                  ),
                                ),
                              ),
                              TextSpan(
                                  text: Utils.txt('rmbq'),
                                  style: StyleTheme.font_black_31_15_bold)
                            ])),
                            SizedBox(height: 20.w),
                            popular.isEmpty
                                ? LoadStatus.noData()
                                : Wrap(
                                    alignment: WrapAlignment.start,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    runSpacing: StyleTheme.margin,
                                    spacing: StyleTheme.margin,
                                    children: popular
                                        .map((e) => GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () {
                                              Utils.navTo(context,
                                                  "/homelabelpage/${e["mid"]}/${Uri.encodeComponent(e["name"])}");
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.w),
                                              height: 30.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15.w),
                                                color: StyleTheme.gray244Color,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    e["name"],
                                                    style: StyleTheme
                                                        .font_gray_77_13,
                                                  )
                                                ],
                                              ),
                                            )))
                                        .toList(),
                                  ),
                            SizedBox(height: 50.w),
                            RichText(
                                text: TextSpan(children: [
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 6.w),
                                  child: LocalPNG(
                                    name: "51_label_all",
                                    width: 16.w,
                                    height: 16.w,
                                  ),
                                ),
                              ),
                              TextSpan(
                                  text: Utils.txt('qbbq'),
                                  style: StyleTheme.font_black_31_15_bold)
                            ])),
                            SizedBox(height: 20.w),
                            all.isEmpty
                                ? LoadStatus.noData()
                                : Wrap(
                                    alignment: WrapAlignment.start,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    runSpacing: StyleTheme.margin,
                                    spacing: StyleTheme.margin,
                                    children: all
                                        .map((e) => GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () {
                                              Utils.navTo(context,
                                                  "/homelabelpage/${e["mid"]}/${Uri.encodeComponent(e["name"])}");
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.w),
                                              height: 30.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15.w),
                                                color: StyleTheme.gray244Color,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${e["name"]}",
                                                    style: StyleTheme
                                                        .font_gray_77_13,
                                                  )
                                                ],
                                              ),
                                            )))
                                        .toList(),
                                  ),
                            SizedBox(height: 50.w),
                          ],
                        ),
                      ),
                      sliverChild: SliverList(
                          delegate: SliverChildListDelegate.fixed([
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.w),
                            RichText(
                                text: TextSpan(children: [
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 6.w),
                                  child: LocalPNG(
                                    name: "51_label_hot",
                                    width: 16.w,
                                    height: 16.w,
                                  ),
                                ),
                              ),
                              TextSpan(
                                  text: Utils.txt('rmbq'),
                                  style: StyleTheme.font_black_31_15_bold)
                            ])),
                            SizedBox(height: 20.w)
                          ],
                        ),
                        popular.isEmpty
                            ? LoadStatus.noData()
                            : Wrap(
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                runSpacing: StyleTheme.margin,
                                spacing: StyleTheme.margin,
                                children: popular
                                    .map((e) => GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          Utils.navTo(context,
                                              "/homelabelpage/${e["mid"]}/${Uri.encodeComponent(e["name"])}");
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.w),
                                          height: 30.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.w),
                                            color: StyleTheme.gray244Color,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                e["name"],
                                                style:
                                                    StyleTheme.font_gray_77_13,
                                              )
                                            ],
                                          ),
                                        )))
                                    .toList(),
                              ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 50.w),
                            RichText(
                                text: TextSpan(children: [
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 6.w),
                                  child: LocalPNG(
                                    name: "51_label_all",
                                    width: 16.w,
                                    height: 16.w,
                                  ),
                                ),
                              ),
                              TextSpan(
                                  text: Utils.txt('qbbq'),
                                  style: StyleTheme.font_black_31_15_bold)
                            ])),
                            SizedBox(height: 20.w),
                          ],
                        ),
                        all.isEmpty
                            ? LoadStatus.noData()
                            : Wrap(
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                runSpacing: StyleTheme.margin,
                                spacing: StyleTheme.margin,
                                children: all
                                    .map((e) => GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          Utils.navTo(context,
                                              "/homelabelpage/${e["mid"]}/${Uri.encodeComponent(e["name"])}");
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.w),
                                          height: 30.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.w),
                                            color: StyleTheme.gray244Color,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${e["name"]}",
                                                style:
                                                    StyleTheme.font_gray_77_13,
                                              )
                                            ],
                                          ),
                                        )))
                                    .toList(),
                              ),
                        SizedBox(height: 50.w),
                      ])),
                    ),
        )
      ],
    );
  }
}

typedef SliverHeaderBuilder = Widget Function(
    BuildContext context, double shrinkOffset, bool overlapsContent);

class SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  // child 为 header
  SliverHeaderDelegate({
    required this.maxHeight,
    this.minHeight = 0,
    required Widget child,
  })  : builder = ((a, b, c) => child),
        assert(minHeight <= maxHeight && minHeight >= 0);

  //最大和最小高度相同
  SliverHeaderDelegate.fixedHeight({
    required double height,
    required Widget child,
  })  : builder = ((a, b, c) => child),
        maxHeight = height,
        minHeight = height;

  //需要自定义builder时使用
  SliverHeaderDelegate.builder({
    required this.maxHeight,
    this.minHeight = 0,
    required this.builder,
  });

  final double maxHeight;
  final double minHeight;
  final SliverHeaderBuilder builder;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    Widget child = builder(context, shrinkOffset, overlapsContent);
    //测试代码：如果在调试模式，且子组件设置了key，则打印日志
    assert(() {
      if (child.key != null) {
        print('${child.key}: shrink: $shrinkOffset，overlaps:$overlapsContent');
      }
      return true;
    }());
    // 让 header 尽可能充满限制的空间；宽度为 Viewport 宽度，
    // 高度随着用户滑动在[minHeight,maxHeight]之间变化。
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverHeaderDelegate old) {
    return old.maxExtent != maxExtent || old.minExtent != minExtent;
  }
}
