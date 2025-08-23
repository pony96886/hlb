import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hlw/base/gen_custom_nav.dart';
import 'package:hlw/base/request_api.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:hlw/util/easy_pull_refresh.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';

class HistoryContentPage extends StatefulWidget {
  final int index;

  HistoryContentPage({super.key, this.index = 0});

  @override
  State createState() => _HistoryContentPageState();
}

class _HistoryContentPageState extends State<HistoryContentPage> {
  bool isHud = true;
  bool netError = false;
  bool noMore = false;
  int page = 1;
  List array = [];

  dynamic? historyCategories;

  bool showFilter = true;

  DateTime? selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<bool> getData() async {
    if (widget.index == 0) {
      if (showFilter) {
        dynamic res = await reqHistoryCategories();
        if (res?.status == 0) {
          netError = true;
          isHud = false;
          if (mounted) setState(() {});
          return false;
        }
        historyCategories = res?.data;
        noMore = true;
        isHud = false;
        if (mounted) setState(() {});
      } else {
        dynamic res = await reqHistoryArchive(
            mid: filter1Index
                .map((e) {
                  return historyCategories["categories"][e]['mid'];
                })
                .toList()
                .join(","),
            tid: historyCategories["times"][filter2Index]['id'],
            page: page);
        if (res != null) {
          if (res?.status == 0) {
            netError = true;
            isHud = false;
            if (mounted) setState(() {});
            return false;
          }
          List tp = res?.data?['list'] ?? [];
          if (page == 1) {
            noMore = false;
            array = tp;
          } else if (tp.isNotEmpty) {
            array.addAll(tp);
          } else {
            noMore = true;
          }
          isHud = false;
          if (mounted) setState(() {});
          return noMore;
        }
      }
    } else {
      dynamic res = widget.index == 1
          ? await reqHistoryRanking()
          : await reqHistoryCalendar(
              date: DateUtil.formatDate(selectedDate, format: "yyyy-MM-dd"),
              page: page);
      if (res != null) {
        if (res?.status == 0) {
          netError = true;
          isHud = false;
          if (mounted) setState(() {});
          return false;
        }
        List tp = res?.data?['list'] ?? [];
        if (page == 1) {
          noMore = false;
          array = tp;
        } else if (tp.isNotEmpty) {
          array.addAll(tp);
        } else {
          noMore = true;
        }
        isHud = false;
        if (mounted) setState(() {});
        return noMore;
      }
    }
    return noMore;
  }

  @override
  Widget build(BuildContext context) {
    return isHud
        ? LoadStatus.showLoading(mounted)
        : netError
            ? LoadStatus.netErrorWork(onTap: () {
                netError = false;
                getData();
              })
            : array.isEmpty && !showFilter
                ? LoadStatus.noData()
                : widget.index == 0 && showFilter
                    ? _filterWidget()
                    : Stack(
                        clipBehavior: Clip.none,
                        children: [
                          EasyPullRefresh(
                            onRefresh: () {
                              page = 1;
                              return getData();
                            },
                            onLoading: () {
                              page++;
                              return getData();
                            },
                            sameChild: _buildGridViewWidget(),
                          ),
                          if (widget.index != 0 || !showFilter)
                            Positioned(
                                top: -28.w - StyleTheme.navHegiht + 10.w,
                                right: 29.5.w,
                                child: Container(
                                  height: StyleTheme.navHegiht,
                                  alignment: Alignment.center,
                                  child: widget.index == 0
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "当前喜好：",
                                              style: StyleTheme
                                                  .font_gray_161_20_bold,
                                            ),
                                            Text(
                                              "${filter1Index.map((e) {
                                                    return historyCategories[
                                                            "categories"][e]
                                                        ['name'];
                                                  }).toList().join(",")} - ${historyCategories["times"][filter2Index]['name']}",
                                              style: StyleTheme
                                                  .font_orange_255_20_500,
                                            ),
                                            SizedBox(
                                              width: 20.w,
                                            ),
                                            GestureDetector(
                                              child: Container(
                                                width: 120.w,
                                                height: 40.w,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          40.w),
                                                  gradient: LinearGradient(
                                                    begin:
                                                        Alignment.centerRight,
                                                    end: Alignment.centerLeft,
                                                    colors: [
                                                      Color(0xFFF49A34),
                                                      Color(0xFFF4C455),
                                                    ],
                                                  ),
                                                ),
                                                child: Text(
                                                  "编辑喜好",
                                                  style: StyleTheme
                                                      .font_brown_103_20_bold,
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      : GestureDetector(
                                          onTap: _pickDate,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${selectedDate?.year}-${selectedDate?.month.toString().padLeft(2, '0')}-${selectedDate?.day.toString().padLeft(2, '0')}",
                                                style: StyleTheme
                                                    .font_gray_194_20_bold,
                                              ),
                                              SizedBox(
                                                width: 12.w,
                                              ),
                                              LocalPNG(
                                                name: "icon_calendar",
                                                width: 30.w,
                                                height: 30.w,
                                                fit: BoxFit.contain,
                                              ),
                                            ],
                                          ),
                                        ),
                                )),
                        ],
                      );
  }

  List<int> filter1Index = [0];

  int filter2Index = 0;

  Widget _filterWidget() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 52.w, left: 160.w, right: 160.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "欢迎来到尘封的历史博物馆",
            style: StyleTheme.font_orange_194_40_bold,
          ),
          SizedBox(
            height: 40.w,
          ),
          Row(
            children: [
              Text(
                "1.选择你喜欢的分类，我们根据你的喜好推送相关尘封的历史贴文",
                style: StyleTheme.font_white_255_24_bold,
              )
            ],
          ),
          SizedBox(
            height: 28.w,
          ),
          _buildFilterButtons(
              historyCategories["categories"] as List, filter1Index,
              onTap: (index) {
            // filter1Index = index;
            filter1Index.contains(index)
                ? filter1Index.length > 1
                    ? filter1Index.remove(index)
                    : null
                : filter1Index.add(index);
            setState(() {});
          }),
          SizedBox(
            height: 40.w,
          ),
          Row(
            children: [
              Text(
                "1.选择你喜欢的分类，我们根据你的喜好推送相关尘封的历史贴文",
                style: StyleTheme.font_white_255_24_bold,
              )
            ],
          ),
          SizedBox(
            height: 28.w,
          ),
          _buildFilterButtons(
              historyCategories["times"] as List, [filter2Index],
              onTap: (index) {
            filter2Index = index;
            setState(() {});
          }),
          SizedBox(
            height: 52.w,
          ),
          InkWell(
            onTap: () {
              if (filter1Index.isNotEmpty) {
                showFilter = false;
                isHud = true;
                getData();
                setState(() {});
              }
            },
            borderRadius: BorderRadius.circular(15.w), // InkWell 圆角同步
            child: Container(
              alignment: Alignment.center,
              width: 400.w,
              height: 72.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.w),
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    Color(0xFFF49A34),
                    Color(0xFFF4C455),
                  ],
                ),
              ),
              child: Text(
                "确认",
                style: StyleTheme.font_brown_103_26_bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget _buildFilterButtons(List<dynamic> items, List<int> selectedIndexs,
      {void Function(int)? onTap}) {
    return GridView.count(
      addRepaintBoundaries: false,
      addAutomaticKeepAlives: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      cacheExtent: ScreenHeight * 3,
      crossAxisCount: 6,
      mainAxisSpacing: 20.w,
      crossAxisSpacing: 20.w,
      childAspectRatio: 200.w / 61.w,
      children: items.asMap().entries.map((entry) {
        dynamic e = entry.value;

        int index = entry.key;
        return InkWell(
          onTap: () {
            if (onTap != null) {
              onTap(index);
            }
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selectedIndexs.contains(index)
                  ? StyleTheme.orange249Color25
                  : StyleTheme.white255Color10,
              borderRadius: BorderRadius.circular(15.w),
            ),
            child: Text(
              e['name'],
              style: selectedIndexs.contains(index)
                  ? StyleTheme.font_orange_244_22_bold
                  : StyleTheme.font_white_255_22_bold,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGridViewWidget() {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 52.w,
      crossAxisSpacing: 20.w,
      childAspectRatio: 505.w / 368.w,
      padding: EdgeInsets.symmetric(horizontal: 29.5.w),
      shrinkWrap: true,
      // 让 GridView 适应内容高度
      physics: AlwaysScrollableScrollPhysics(),
      // 保证可以滚动触发加载更多
      children:
          array.map((e) => Utils.newsModuleUI(context, e, style: 2)).toList(),
    );
  }
}
