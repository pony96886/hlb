import 'dart:async';

import 'package:hlw/base/base_widget.dart';
import 'package:hlw/base/gen_custom_nav.dart';
import 'package:hlw/base/request_api.dart';
import 'package:hlw/util/easy_pull_refresh.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/pageviewmixin.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:hlw/widget/search_bar_widget.dart';

class MineContributionPage extends BaseWidget {
  MineContributionPage({Key? key}) : super(key: key);

  @override
  State cState() => _MineContributionPageState();
}

class _MineContributionPageState extends BaseWidgetState<MineContributionPage> {
  @override
  Widget appbar() => Container();

  @override
  void onCreate() {}

  @override
  void onDestroy() {}

  @override
  Widget pageBody(BuildContext context) {
    final List<String> titles = [
      Utils.txt('yfb'),
      Utils.txt('tgdhd'),
      Utils.txt('dsh'),
      Utils.txt('bjj')
    ];
    final List<Widget> pages = [
      PageViewMixin(child: const ContributionChildPage(state: 1)),
      PageViewMixin(child: const ContributionChildPage(state: 2)),
      PageViewMixin(child: const ContributionChildPage(state: 3)),
      PageViewMixin(child: const ContributionChildPage(state: 4)),
    ];
    return Stack(
      children: [
        Positioned(
          top: 77.w,
          bottom: 0,
          left: 60.w,
          right: 60.w,
          child: GenCustomNav(
            titles: titles,
            pages: pages,
          ),
        ),
        const SearchBarWidget(isBackBtn: true, backTitle: '我的投稿'),
      ],
    );
  }
}

/// 1已发布 2通过(待回调) 3待审核 4被拒绝
class ContributionChildPage extends StatefulWidget {
  final int state;
  const ContributionChildPage({Key? key, this.state = 0}) : super(key: key);

  @override
  State createState() => _ContributionChildPageState();
}

class _ContributionChildPageState extends State<ContributionChildPage> {
  bool isHud = true;
  bool netError = false;
  bool noMore = false;
  int page = 1;
  List tps = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<bool> _getData() {
    return reqPostRecord(page: page, state: widget.state).then((value) {
      if (value?.data == null) {
        netError = true;
        if (mounted) setState(() {});
        return false;
      }
      List tp = List.from(value?.data ?? []);
      if (page == 1) {
        noMore = false;
        tps = tp.where((element) => element['state'] == widget.state).toList();
      } else if (page > 1 && tp.isNotEmpty) {
        tps.addAll(tp);
        tps = Utils.listMapNoDuplicate(tps);
        tps = tps.where((element) => element['state'] == widget.state).toList();
      } else {
        noMore = true;
      }
      isHud = false;
      if (mounted) setState(() {});
      return noMore;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return netError
        ? LoadStatus.netErrorWork(onTap: () {
            netError = false;
            _getData();
          })
        : isHud
            ? LoadStatus.showLoading(mounted)
            : tps.isEmpty
                ? LoadStatus.noData()
                : _buildContainerWidget();
  }

  Widget _buildContainerWidget() {
    final _isFour = widget.state == 4; // 被拒绝
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: StyleTheme.margin, vertical: 20.w),
      child: EasyPullRefresh(
        onRefresh: () {
          page = 1;
          return _getData();
        },
        onLoading: () {
          page++;
          return _getData();
        },
        sameChild: GridView.count(
            controller: _scrollController,
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            cacheExtent: ScreenHeight * 3,
            semanticChildCount: tps.length,
            shrinkWrap: true,
            crossAxisCount: _isFour ? 1 : 2,
            mainAxisSpacing: _isFour ? 0 : 5.w,
            crossAxisSpacing: _isFour ? 0 : 40.w,
            childAspectRatio: _isFour ? 920 / 268 : 440 / 260,
            scrollDirection: Axis.vertical,
            children: tps
                .map((e) => Utils.newsModuleUI(
                      context,
                      e,
                      style: _isFour ? 1 : 2,
                      state: widget.state,
                    ))
                .toList()),
      ),
    );
  }
}
