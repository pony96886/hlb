import 'package:hlw/base/request_api.dart';
import 'package:hlw/model/config_model.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/netimage_tool.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:provider/provider.dart';

import '../base/base_store.dart';
import '../base/gen_custom_nav.dart';
import '../util/easy_pull_refresh.dart';
import '../util/local_png.dart';
import '../util/pageviewmixin.dart';
import '../widget/search_bar_widget.dart';

class WelfarePage extends StatefulWidget {
  const WelfarePage({Key? key, this.isShow = false}) : super(key: key);
  final bool isShow;

  @override
  State<WelfarePage> createState() => _WelfarePageState();
}

class _WelfarePageState extends State<WelfarePage> {
  bool isHud = true;
  bool netError = false;
  List banners = [];
  List categories = [];

  void getData() {
    reqAppCategory().then((value) {
      if (value?.data == null || value?.status != 1) {
        netError = true;
        setState(() {});
        return;
      }
      banners = List.from(value?.data["banner"]);
      categories = List.from(value?.data["categories"]);
      isHud = false;
      setState(() {});
    });
  }

  //banner
  Widget bannerWidget() {
    return banners.isEmpty
        ? Container()
        : Column(children: [
      Utils.bannerSwiper(
        width: ScreenWidth,
        whRate: 150 / 350,
        data: banners,
      ),
      SizedBox(height: 18.w),
    ]);
  }

  @override
  void didUpdateWidget(covariant WelfarePage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.isShow && isHud) {
      getData();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(children: [
          Utils.createNav(
            right: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Utils.navTo(context, "/homesearchpage");
              },
              child: Container(
                alignment: Alignment.centerRight,
                width: 40.w,
                height: 40.w,
                child: LocalPNG(
                  name: "hl_label_search",
                  width: 14.w,
                  height: 14.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            title: Utils.txt('flmfl'),
          ),
          Expanded(
            child: netError
                ? LoadStatus.netErrorWork(onTap: () {
              netError = false;
              getData();
            })
                : isHud
                ? LoadStatus.showLoading(mounted)
                : Column(
              children: [
                bannerWidget(),
                Expanded(
                    child: GenCustomNav(
                        tabPadding: 15,
                        titles: categories
                            .map((e) => e["name"].toString())
                            .toList(),
                        pages: categories
                            .map((e) => WelfareRecApps(
                          id: e["id"],
                          isRec: e["name"] == Utils.txt('tj'),
                        ))
                            .toList()))
              ],
            ),
          ),
        ]),
        // BuoyantAdsBackgroundWidget()
      ],
    );
  }
}

//推荐APP
class WelfareRecApps extends StatefulWidget {
  WelfareRecApps({Key? key, this.id = 0, this.isRec = false}) : super(key: key);
  final int id;
  final bool isRec;

  @override
  State<WelfareRecApps> createState() => _WelfareRecAppsState();
}

class _WelfareRecAppsState extends State<WelfareRecApps> {
  List apps = [];
  bool netError = false;
  bool isHud = true;
  bool noMore = false;
  int page = 1;
  String last_ix = "";

  Future<bool> getData() {
    return reqApps(id: widget.id, page: page, last_ix: last_ix).then((value) {
      if (value?.data == null || value?.status != 1) {
        netError = true;
        if (mounted) setState(() {});
        return false;
      }
      last_ix = value?.data["last_ix"];
      List tp = List.from(value?.data["list"] ?? []);
      if (page == 1) {
        noMore = false;
        apps = tp;
      } else if (tp.isNotEmpty) {
        apps.addAll(tp);
      } else {
        noMore = true;
      }
      isHud = false;
      if (mounted) setState(() {});
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
  Widget build(BuildContext context) {
    return netError
        ? LoadStatus.netErrorWork(onTap: () {
      netError = false;
      getData();
    })
        : isHud
        ? Container()
        : apps.isEmpty
        ? LoadStatus.noData()
        : EasyPullRefresh(
      onRefresh: () {
        page = 1;
        return getData();
      },
      onLoading: () {
        page++;
        return getData();
      },
      child: widget.isRec
          ? ListView.builder(
        shrinkWrap: true,
        itemCount: apps.length,
        padding: EdgeInsets.symmetric(
            horizontal: StyleTheme.margin),
        itemBuilder: (context, index) {
          dynamic e = apps[index];
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Utils.openURL(e["url"]);
            },
            child: Column(
              children: [
                SizedBox(height: 17.w),
                Row(
                  children: [
                    SizedBox(
                      height: 60.w,
                      width: 60.w,
                      child: NetImageTool(
                        url: Utils.getPICURL(e),
                        radius: BorderRadius.all(
                            Radius.circular(2.w)),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            e["name"],
                            style: StyleTheme
                                .font_white_255_20,
                          ),
                          SizedBox(height: 1.w),
                          Text(
                            Utils.renderFixedNumber(
                                e["clicked"]) +
                                Utils.txt('cxiaz'),
                            style:
                            StyleTheme.font_gray_153_12,
                          ),
                          SizedBox(height: 1.w),
                          Text(
                            e["intro"],
                            style:
                            StyleTheme.font_black_31_12,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 13.w),
                    Container(
                      height: 26.w,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w),
                      decoration: BoxDecoration(
                          color: StyleTheme.yellow255Color,
                          borderRadius: BorderRadius.all(
                              Radius.circular(13.w))),
                      alignment: Alignment.center,
                      child: Text(
                        Utils.txt('xiazi'),
                        style:
                        StyleTheme.font_white_255_17,
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 17.w),
                  color: StyleTheme.white10,
                  height: index == apps.length - 1
                      ? 0.w
                      : 0.5.w,
                )
              ],
            ),
          );
        },
      )
          : GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
            horizontal: StyleTheme.margin, vertical: 17.w),
        mainAxisSpacing: 20.w,
        crossAxisSpacing: 20.w,
        childAspectRatio: 72 / 124,
        children: apps.map((e) {
          return GestureDetector(
            onTap: () {
              Utils.openURL(e["url"]);
            },
            child: Column(
              children: [
                SizedBox(
                  height: 60.w,
                  width: 60.w,
                  child: NetImageTool(
                    url: Utils.getPICURL(e),
                    radius: BorderRadius.all(
                        Radius.circular(2.w)),
                  ),
                ),
                SizedBox(height: 8.w),
                Text(
                  e["name"],
                  style: StyleTheme.font_white_255_20,
                ),
                SizedBox(height: 8.w),
                Container(
                  height: 26.w,
                  decoration: BoxDecoration(
                      color: StyleTheme.yellow255Color,
                      borderRadius: BorderRadius.all(
                          Radius.circular(13.w))),
                  alignment: Alignment.center,
                  child: Text(
                    Utils.txt('xiazi'),
                    style: StyleTheme.font_white_255_17,
                  ),
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
