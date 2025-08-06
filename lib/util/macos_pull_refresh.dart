// ignore_for_file: use_key_in_widget_constructors

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'style_theme.dart';
import 'utils.dart';

// ignore: must_be_immutable
class MacosPullRefresh extends StatefulWidget {
  const MacosPullRefresh({
    Key? key,
    this.child,
    this.onRefresh,
    this.onLoading,
    this.controller,
  }) : super(key: key);
  final Widget? child;
  final ScrollController? controller;
  final Future<bool> Function()? onRefresh;
  final Future<bool> Function()? onLoading;

  @override
  _MacosPullRefreshState createState() => _MacosPullRefreshState();
}

class _MacosPullRefreshState extends State<MacosPullRefresh> {
  late RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      scrollController: widget.controller,
      enablePullDown: widget.onRefresh != null,
      enablePullUp: widget.onLoading != null,
      header: const GifOfHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget child;
          if (mode == LoadStatus.idle) {
            child = Text(
              Utils.txt('zlyd'),
              style: StyleTheme.font_white_255_14,
            );
          } else if (mode == LoadStatus.loading) {
            child = const CupertinoActivityIndicator(color: Colors.white);
          } else if (mode == LoadStatus.failed) {
            child = Text(
              Utils.txt('zzsb'),
              style: StyleTheme.font_white_255_14,
            );
          } else if (mode == LoadStatus.canLoading) {
            child = Text(
              Utils.txt('ssjz'),
              style: StyleTheme.font_white_255_14,
            );
          } else {
            child = Text(
              Utils.txt('wydx'),
              style: StyleTheme.font_white_255_14,
            );
          }
          return Center(
            child: Container(
              height: 40.w,
              width: 120.w,
              alignment: Alignment.center,
              constraints: BoxConstraints(minWidth: 120.w),
              decoration: BoxDecoration(
                color: StyleTheme.gray102Color,
                borderRadius: BorderRadius.circular(20.w),
              ),
              child: child,
            ),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: widget.onRefresh == null
          ? null
          : () async {
              await widget.onRefresh?.call();
              if (!mounted) return;
              _refreshController.refreshCompleted(resetFooterState: true);
            },
      onLoading: widget.onLoading == null
          ? null
          : () async {
              bool noMore = await widget.onLoading?.call() ?? false;
              if (!mounted) return;
              noMore
                  ? _refreshController.loadNoData()
                  : _refreshController.loadComplete();
            },
      child: widget.child,
    );
  }
}

class GifOfHeader extends RefreshIndicator {
  const GifOfHeader() : super(height: 80, refreshStyle: RefreshStyle.Follow);
  @override
  State<StatefulWidget> createState() {
    return GifOfHeaderState();
  }
}

class GifOfHeaderState extends RefreshIndicatorState<GifOfHeader> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void onModeChange(RefreshStatus? mode) {
    if (mode == RefreshStatus.refreshing) {}
    super.onModeChange(mode);
  }

  @override
  Future<void> endRefresh() {
    return Future.delayed(const Duration(microseconds: 500), () {});
  }

  @override
  void resetValue() {
    super.resetValue();
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus mode) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.w),
      child: Center(
        child: SizedBox(
          height: 20.w,
          width: 20.w,
          child: CircularProgressIndicator(
            color: StyleTheme.orange255Color,
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
