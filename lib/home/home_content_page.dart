// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:hlw/base/request_api.dart';
import 'package:hlw/util/easy_pull_refresh.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';

import 'post_item_widget.dart';

class HomeContentPage extends StatefulWidget {
  final int id;
  final dynamic banners;
  const HomeContentPage({
    super.key,
    this.id = 0,
    this.banners,
  });

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
    banners = widget.banners;
    getData();
  }

  Future<bool> getData() {
    return reqHomeCategoryList(id: widget.id, page: page).then((value) {
      if (value?.data == null) {
        netError = true;
        if (mounted) setState(() {});
        return false;
      }
      List tmp = value?.data["article"]["list"] ?? [];
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
      if (mounted) setState(() {});
      return noMore;
    });
  }

  @override
  void didUpdateWidget(covariant HomeContentPage oldWidget) {
    if (oldWidget.banners != widget.banners) {
      setState(() {
        banners = widget.banners;
      });
    }
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
      return Column(
        children: [
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
        ],
      );
    });
  }

  Widget _buildContainerWidget() {
    return ListView(children: [
      _buildBannerWidget(),
      _buildGridViewWidget(),
    ]);
  }

  Widget _buildBannerWidget() {
    return Visibility(
      visible: banners.isNotEmpty,
      child: Utils.bannerScaleExtSwiper(
        data: banners,
        itemWidth: 710.w, // 图片宽
        itemHeight: 240.w, // 图片高(240) + 23 + 10
        viewportFraction: 0.777, // （710 + 5）/ 920 // 1040 - 120
        scale: 1,
        spacing: 5.w,
        lineWidth: 20.w,
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
      crossAxisCount: 2,
      mainAxisSpacing: 5.w,
      crossAxisSpacing: 40.w,
      childAspectRatio: 440 / 260,
      children: tps.map((e) {
        return PostItemWidget(e, style: 2);
      }).toList(),
    );
  }
}
