import 'dart:async';

import 'package:hlw/base/base_widget.dart';
import 'package:hlw/base/request_api.dart';
import 'package:hlw/util/easy_pull_refresh.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';

import '../widget/search_bar_widget.dart';

class MineCollectPage extends BaseWidget {
  MineCollectPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _MineCollectPageState();
  }
}

class _MineCollectPageState extends BaseWidgetState<MineCollectPage> {
  int page = 1;
  bool noMore = false;
  bool networkErr = false;
  bool isHud = true;
  String lastIx = "";
  List _dataList = [];

  @override
  Widget appbar() {
    // TODO: implement appbar
    return Container();
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
    getData();
  }

  Future<bool> getData() async {
    return reqCollectList(page: page, lastIx: lastIx).then((value) {
      if (value?.data == null) {
        networkErr = true;
        if (mounted) setState(() {});
        return false;
      }
      List tp = List.from(value?.data["list"]);
      lastIx = value?.data["last_ix"] ?? "";
      if (page == 1) {
        noMore = false;
        _dataList = tp;
      } else if (page > 1 && tp.isNotEmpty) {
        _dataList.addAll(tp);
        _dataList = Utils.listMapNoDuplicate(_dataList);
      } else {
        noMore = true;
      }
      isHud = false;
      if (mounted) setState(() {});
      return noMore;
    });
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    return Stack(
      children: [
        Positioned(
          top: 94.w,
          bottom: 0.w,
          left: 60.w,
          right: 60.w,
          child: networkErr
              ? LoadStatus.netErrorWork(onTap: () {
            networkErr = false;
            getData();
          })
              : isHud
              ? LoadStatus.showLoading(mounted)
              : _dataList.isEmpty
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
            sameChild: GridView.count(
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                cacheExtent: ScreenHeight * 3,
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 5.w,
                crossAxisSpacing: 40.w,
                childAspectRatio: 440 / 260,
                scrollDirection: Axis.vertical,
                children: _dataList
                    .map((e) => Utils.newsModuleUI(context, e, style: 2))
                    .toList()
            ),
          ),
        ),
        const SearchBarWidget(isBackBtn : true, backTitle: '我的收藏'),
      ],
    );
  }
}
