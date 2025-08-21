// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:hlw/base/request_api.dart';
import 'package:hlw/util/easy_pull_refresh.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';

import 'melon_item_widget.dart';

class HomeContentPage extends StatefulWidget {
  final int? layoutType; //1 list ， 2 gird
  final int id;

  const HomeContentPage(
      {super.key, this.id = 0, this.layoutType = 2});

  @override
  State createState() => _HomeContentPageState();
}

class _HomeContentPageState extends State<HomeContentPage> {
  bool isHud = true;
  bool netError = false;
  bool noMore = false;
  int page = 1;
  List tps = [];
  List banners = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<bool> getData() {
    return reqHomeCategoryList(id: widget.id, page: page).then((value) {
      if (value?.data == null) {
        netError = true;
        if (mounted) setState(() {});
        return false;
      }
      List tmp = value?.data["list"] ?? [];
      if (page == 1) {
        banners = value?.data["banner"] ?? [];
      }
      if (page == 1) {
        noMore = false;
        tps = tmp;
      } else if (page > 1 && tmp.isNotEmpty) {
        tps.addAll(tmp);
        // tps = Utils.listMapNoDuplicate(tps);
      } else {
        noMore = true;
      }
      isHud = false;
      if (mounted) setState(() {});
      return noMore;
    });
  }

  @override
  void didUpdateWidget(covariant HomeContentPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (netError) {
      return LoadStatus.netErrorWork(onTap: () {
        netError = false;
        getData();
      });
    }
    if (isHud) return LoadStatus.showLoading(mounted);
    if (tps.isEmpty) return LoadStatus.noData();
    return Builder(builder: (cx) {
      return Column(children: [
        Expanded(
          child: EasyPullRefresh(
            onRefresh: () {
              page = 1;
              return getData();
            },
            onLoading: () {
              page++;
              return getData();
            },
            sameChild: _buildContainerWidget(),
          ),
        ),
        SizedBox(height: 20.w),
      ]);
    });
  }

  Widget _buildContainerWidget() {
    return ListView(
      padding: EdgeInsets.only(left: 30.w, right: 30.w),
      children: [
        _buildBannerWidget(),
        _buildGridViewWidget(),
      ],
    );
  }

  Widget _buildBannerWidget() {
    return Visibility(
      visible: banners.isNotEmpty,
      child: Utils.bannerScaleExtSwiper(
        data: banners,
        itemWidth: 700.w,
        // 图片宽
        itemHeight: 300.w,
        // 图片高(240) + 23 + 10
        viewportFraction: 700 / 1508,
        // 1548 - 20 * 2
        scale: 1,
        spacing: 20.w,
        lineWidth: 20.w,
        autoplay: false,
      ),
    );
  }

  Widget _buildGridViewWidget() {
    return GridView.count(
            padding: EdgeInsets.fromLTRB(0, 15.w, 0, 10.w),
            addRepaintBoundaries: false,
            addAutomaticKeepAlives: false,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            cacheExtent: ScreenHeight * 3,
            crossAxisCount: widget.layoutType == 1 ? 1 : 3,
            mainAxisSpacing: 20.w,
            crossAxisSpacing: 20.w,
            childAspectRatio: widget.layoutType == 1 ? (1585 / 180) : ( 505 / 377),
            children: tps.map((e) {
              return MelonItemWidget(e, style: widget.layoutType ?? 2);
            }).toList(),
          );
  }
}
