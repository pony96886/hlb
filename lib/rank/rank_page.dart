import 'dart:async';

import 'package:hlw/base/base_main_view.dart';
import 'package:hlw/model/response_model.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';

import 'package:hlw/base/base_widget.dart';
import 'package:hlw/base/request_api.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';

import '../base/gen_custom_nav.dart';
import '../util/easy_pull_refresh.dart';
import '../util/pageviewmixin.dart';

class RankPage extends BaseWidget {
  RankPage({Key? key, this.isShow = false, this.type = 'past'})
      : super(key: key);
  bool isShow;
  String type;
  @override
  cState() => _RankPageState();
}

class _RankPageState extends BaseWidgetState<RankPage> {
  bool networkErr = false;
  bool isHud = true;
  List<List> _dataList = [];

  @override
  void onCreate() {
    if (widget.isShow) {
      _getData();
    }
  }

  @override
  void didUpdateWidget(covariant RankPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_dataList.isEmpty &&
        oldWidget.isShow == false &&
        widget.isShow == true) {
      _getData();
    }
  }

  @override
  Widget appbar() => Container();

  Future<bool> _getData() async {
    ResponseModel<dynamic>? res1 = await pastHotList(type: 1);
    ResponseModel<dynamic>? res2 = await pastHotList(type: 2);
    if (res1?.data == null || res2?.data == null) {
      networkErr = true;
      if (mounted) setState(() {});
      return false;
    }
    if (res1?.status == 1 && res2?.status == 1) {
      _dataList = [res1?.data, res2?.data];
    } else {
      Utils.showText('${res1?.msg}\n${res2?.msg}', call: () {});
    }
    isHud = false;
    if (mounted) setState(() {});
    return false;
  }

  Widget _buildWidget(List e) {
    return _RefreshWidget(list: e, onRefresh: _getData);
  }

  @override
  void onDestroy() {}

  @override
  pageBody(BuildContext context) {
    return BaseMainView(
      paddingTop: 87.w,
      paddingBottom: 15.w,
      leftWidget: SizedBox(
        width: 640.w,
        height: ScreenHeight - 102.w,
        child: networkErr
            ? LoadStatus.netErrorWork(onTap: () {
          networkErr = false;
          _getData();
        })
            : isHud
            ? LoadStatus.showLoading(mounted)
            : _dataList.isEmpty
            ? LoadStatus.noData()
            : GenCustomNav(
          isCenter: false,
          titles: const [
            '热贴浏览榜',
            '热贴评论榜',
          ],
          pages: _dataList
              .map((e) => PageViewMixin(
                    child: _buildWidget(e),
                  ))
              .toList(),
        ),
      ),
    );
  }

}

class _RefreshWidget extends StatelessWidget {
  final List list;
  final Future<bool> Function() onRefresh;
  const _RefreshWidget ({Key? key, required this.list, required this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10.w, bottom: 20.w),
        padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
        decoration: BoxDecoration(color: StyleTheme.gray245Color, borderRadius: BorderRadius.all(Radius.circular(5.w))),
        child: Column(
          children: [
            Expanded(
              child: EasyPullRefresh(
                onRefresh: onRefresh,
                sameChild: ListView.separated(
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                  shrinkWrap: true,
                  cacheExtent: ScreenHeight * 3,
                  separatorBuilder: (context, index) => SizedBox(height: 15.w),
                  itemBuilder: (context, index) => _PastWidget(index: index, e: list[index]),
                  itemCount: list.length,
                ),
              ),
            ),
            SizedBox(height: 20.w),
          ],
        ),
    );
  }
}

class _PastWidget extends StatelessWidget {
  final int index;
  final dynamic e;
  const _PastWidget({Key? key, required this.index, required this.e})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Utils.navTo(context, "/homecontentdetailpage/${e["id"]}"),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 28.w,
              height: 28.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: index < 3
                      ? StyleTheme.orange255Color
                      : StyleTheme.gray102Color,
                  borderRadius: BorderRadius.all(Radius.circular(5.w))),
              child: Text(
                '${index + 1}',
                style: StyleTheme.font_white_255_16,
              )),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              e['title'],
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: StyleTheme.gray51Color,
                  height: 1.5),
              softWrap: true,
              maxLines: 3,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}