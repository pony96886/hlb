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
  @override
  Widget build(BuildContext context) {
    final ConfigModel? configModel =
        Provider.of<BaseStore>(context, listen: false).config;
    return Stack(children: [
      Positioned(
        top: 64.w,
        left: 60.w,
        right: 60.w,
        bottom: 0,
        child: configModel?.welfare_tab == null
            ? Container()
            : GenCustomNav(
                isCenter: false,
                titles: configModel!.welfare_tab!
                    .map((e) => e["name"].toString())
                    .toList(),
                pages: configModel.welfare_tab!.map((e) {
                  return PageViewMixin(
                    child: WelfareRecApps(isShow: widget.isShow, id: e["id"], isRec: e["name"] == Utils.txt('tj')),
                  );
                }).toList(),
              ),
        // CustomExpandedWidget(
        //   isTabBar: false,
        //   titles: configModel?.welfare_tab!.map((e) => e["name"].toString()).toList(),
        //   pages: configModel?.welfare_tab!.map((e) => PageCacheMixin(
        //     child: WelfareRecApps(
        //         id: e["id"],
        //         isRec: e["name"] == Utils.txt('tj')),
        //   ),
        //   ).toList(),
        //   expandedWidget: netError
        //       ? LoadStatus.netErrorWork(onTap: () => netError = false)
        //       : isHud || banners.isEmpty
        //       ? LoadStatus.showLoading(mounted)
        //       : Utils.bannerScaleExtSwiper(
        //     data: banners,
        //     itemWidth: 710.w, // 图片宽
        //     itemHeight: 240.w, // 图片高(240) + 23 + 10
        //     viewportFraction: 0.6827, // 710 / 1040
        //     scale: 1,
        //     spacing: 5.w,
        //     lineWidth: 20.w,
        //   ),
        // )
      ),
      const SearchBarWidget(),
    ]);
  }
}

//推荐APP
class WelfareRecApps extends StatefulWidget {
  final int id;
  final bool isRec;
  final bool isShow;
  final dynamic data;
  const WelfareRecApps({Key? key, this.id = 0, this.isRec = false, this.isShow = false, this.data})
      : super(key: key);

  @override
  State<WelfareRecApps> createState() => _WelfareRecAppsState();
}

class _WelfareRecAppsState extends State<WelfareRecApps> {
  List apps = [], apps2 = [], banners = [], banners2 = [];
  bool netError1 = false, netError2 = false, netError3 = false;
  bool isHud1 = true, isHud2 = true, isHud3 = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataAll();
  }

  Future<bool> getDataAll() async {
    getDataBanners();
    // getDataAds();
    getData();
    return false;
  }

  getData() {
    reqApps(id: widget.id, page: 1, last_ix: "").then((value) {
      if (value?.data == null) {
        netError1 = true;
        if (mounted) setState(() {});
        return false;
      }
      List tp = List.from(value?.data["product"]);
      if (value?.status == 1) {
        apps = tp;
        if (apps.length > 9) {
          apps = apps.getRange(0, 9).toList();
          apps2 = tp.getRange(9, tp.length).toList();
        }
      } else {
        Utils.showText('${value?.msg}', call: () {});
      }
      isHud1 = false;
      if (mounted) setState(() {});
    });
  }

  getDataAds() {
    reqAds(position_id: 8).then((value) {
      if (value?.data == null) {
        netError2 = true;
        if (mounted) setState(() {});
        return;
      }
      if (value?.status == 1) {
        banners = List.from(value?.data["ad_list"]);
      }
      isHud2 = false;
      if (mounted) setState(() {});
    });
  }

  getDataBanners() {
    reqAds(position_id: 2).then((value) {
      if (value?.data == null) {
        netError3 = true;
        if (mounted) setState(() {});
        return;
      }
      if (value?.status == 1) {
        banners2 = List.from(value?.data["ad_list"]);
      }
      isHud3 = false;
      if (mounted) setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant WelfareRecApps oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (apps.isEmpty &&
        oldWidget.isShow == false &&
        widget.isShow == true) {
      getDataAll();
    }
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EasyPullRefresh(
      onRefresh: () {
        return getDataAll();
      },
      sameChild: ListView(
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        cacheExtent: ScreenHeight * 3,
        children: [
          Visibility(
              visible: !netError3 && banners2.isNotEmpty,
              child: Column(
                children: [
                  Utils.bannerScaleExtSwiper(
                    data: banners2,
                    itemWidth: 710.w, // 图片宽
                    itemHeight: 240.w, // 图片高(240) + 23 + 10
                    viewportFraction: 0.777, // （710 + 5）/ 920（1040 - 120）
                    scale: 1,
                    spacing: 5.w,
                    lineWidth: 20.w,
                  ),
                  SizedBox(height: 30.w),
                ],
              )
          ),
          netError1
              ? LoadStatus.netErrorWork(onTap: () {
                  netError1 = false;
                  getData();
                })
              : isHud1
                  ? LoadStatus.showLoading(mounted)
                  : apps.isEmpty || apps.first['name'] == null
                      ? LoadStatus.noData(text: '此功能尚未开放')
                      : SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            spacing: 25.w,
                            runSpacing: 25.w,
                            children: apps
                                .asMap()
                                .keys
                                .map((index) => _AppGridWidget(e: apps[index]))
                                .toList(),
                          ),
                        ),
          SizedBox(height: 30.w),
          // Visibility(
          //   visible: !netError2 && banners.isNotEmpty,
          //   child: SizedBox(
          //   height: 240.w,
          //   child: Utils.bannerScaleExtSwiper(
          //     data: banners,
          //     itemWidth: 710.w,
          //     itemHeight: 240.w, // 240 + 23 + 10
          //     viewportFraction: 0.777, // （710 + 5）/ 920（1040 - 120）
          //     scale: 1,
          //     spacing: 5.w,
          //     lineWidth: 20.w,
          //     ),
          //   )
          // ),
          // SizedBox(height: 30.w),
          Visibility(
            visible: apps2.isNotEmpty,
              child: SizedBox(
                key: ValueKey(apps2),
                width: double.infinity,
                child: Wrap(
                  spacing: 25.w,
                  runSpacing: 25.w,
                  children: apps2
                      .asMap()
                      .keys
                      .map((index) => _AppGridWidget(e: apps2[index]))
                      .toList(),
                ),
              ),
          ),
        ],
      ),
    );
  }
}

class _AppGridWidget extends StatelessWidget {
  final dynamic e;
  const _AppGridWidget({Key? key, required this.e}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: 290.w,
      height: 122.w,
      child: GestureDetector(
        onTap: () {
          //上报点击量
          // reqAdClickCount(id: e['report_id'], type: e['report_type']);
          if (e['url'] != null && e['url'].isNotEmpty) Utils.openURL(e["url"]);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 64.w,
              width: 64.w,
              child: NetImageTool(
                url: Utils.getPICURL(e),
                radius: BorderRadius.all(Radius.circular(2.w)),
              ),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24.w,
                    child: Text(
                      e["name"] ?? '',
                      style: StyleTheme.font_black_0_17,
                    ),
                  ),
                  SizedBox(height: 1.w),
                  Text(
                    e["intro"] ?? '',
                    style: StyleTheme.font_gray_153_13,
                    maxLines: 3,
                    softWrap: false,
                  ),
                  // SizedBox(height: 15.w),
                  Expanded(child: Container()),
                  LocalPNG(
                    key: ValueKey(e),
                    name: 'hlw_btn_download',
                    height: 25.w,
                    width: 55.w,
                  ),
                  SizedBox(height: 20.w),
                  Divider(
                    height: 1.w,
                    color: StyleTheme.gray233Color,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
