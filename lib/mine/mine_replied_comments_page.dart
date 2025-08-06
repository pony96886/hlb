import 'package:hlw/base/right_module_ui.dart';
import 'package:hlw/util/easy_pull_refresh.dart';
import 'package:hlw/util/netimage_tool.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';

import 'package:hlw/base/base_widget.dart';
import 'package:hlw/base/request_api.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';

class MineRepliedCommentsPage extends BaseWidget {
  MineRepliedCommentsPage({Key? key}) : super(key: key);
  cState() => _MineRepliedCommentsPageState();
}

class _MineRepliedCommentsPageState
    extends BaseWidgetState<MineRepliedCommentsPage> {
  int page = 1;
  bool noMore = false;
  bool networkErr = false;
  bool isHud = true;
  String? lastIx;

  List _dataList = [];

  Future<bool> _getData() async {
    return mineUserCommentsList(page: page, last_ix: page == 1 ? null : lastIx)
        .then((value) {
      if (value?.data == null) {
        networkErr = true;
        setState(() {});
        return false;
      }
      List tp = List.from(value?.data['list']);
      lastIx = value?.data['last_ix'] ?? "";
      if (page == 1) {
        noMore = false;
        _dataList = tp;
      } else if (tp.isNotEmpty) {
        _dataList.addAll(tp);
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
  }

  // @override
  // Widget appbar() {
  //   return Container();
  // }

  @override
  void onCreate() {
    // TODO: implement onCreate
    // _getData();

    setAppTitle(title: Utils.txt('plhf'));
    _getData();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  Widget listItem(dynamic item) {
    // return Container(
    //   width: double.infinity,
    //   height: 10,
    //   color: Colors.red,
    // );

    dynamic itemContent = item['contents'];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 30.w,
          height: 30.w,
          child: NetImageTool(
            url: Utils.getPICURL(item),
            radius: BorderRadius.all(Radius.circular(15.w)),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item['author'], style: StyleTheme.font_black_31_12_medium),
              SizedBox(height: 7.w),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: item['parent'] != 0
                          ? '@${item['reply_author']}  '
                          : '',
                      style: StyleTheme.font_blue_30_13),
                  TextSpan(
                    text: item['text'],
                    style: StyleTheme.font_gray_102_13,
                  ),
                ]),
                maxLines: 100,
              ),
              SizedBox(height: 8.w),
              GestureDetector(
                onTap: () {
                  Utils.navTo(
                      context, "/homecontentdetailpage/${itemContent["cid"]}");
                },
                child: Container(
                    color: StyleTheme.gray242Color,
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.w),
                    margin: EdgeInsets.only(bottom: 10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          itemContent['title'],
                          style: StyleTheme.font_black_31_14,
                          maxLines: 2,
                        ),
                      ],
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.w),
                child: Text(
                    Utils.format(DateTime.parse(item["created"].toString())),
                    style: StyleTheme.font_gray_153_11),
              ),
              Container(
                color: StyleTheme.gray230Color,
                width: double.infinity,
                height: 0.5,
              ),
              SizedBox(
                height: 10.w,
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  pageBody(BuildContext context) {
    return networkErr
        ? LoadStatus.netErrorWork()
        : isHud
            ? LoadStatus.showLoading(mounted)
            : Row(
                children: [
                  Expanded(
                      child: _dataList.isEmpty
                          ? LoadStatus.noData()
                          : EasyPullRefresh(
                              onRefresh: () {
                                page = 1;
                                return _getData();
                              },
                              onLoading: () {
                                page++;
                                return _getData();
                              },
                              child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: _dataList.length,
                                itemBuilder: (context, index) {
                                  dynamic item = _dataList[index];
                                  return Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: StyleTheme.margin,
                                          vertical: 10.w),
                                      child: listItem(item));
                                },
                              ),
                              sliverChild: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    dynamic item = _dataList[index];
                                    return Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: StyleTheme.margin,
                                            vertical: 10.w),
                                        child: listItem(item));
                                  },
                                  childCount: _dataList.length,
                                ),
                              ),
                            )),
                  RightModuleUI()
                ],
              );
  }
}
