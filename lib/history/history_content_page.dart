import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hlw/base/gen_custom_nav.dart';
import 'package:hlw/base/request_api.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:hlw/util/easy_pull_refresh.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';

class HistoryContentPage extends StatefulWidget {
  final int index;
  DateTime selectedDate = DateTime.now();

  HistoryContentPage({super.key, required this.selectedDate, this.index = 0});

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

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<bool> getData() async {
    if (widget.index == 0 && historyCategories == null) {
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
      dynamic res = widget.index == 1
          ? await reqHistoryRanking()
          : await reqHistoryCalendar(
              date: DateUtil.formatDate(widget.selectedDate,
                  format: "yyyy-MM-dd"),
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

  bool showFilter = true;

  @override
  Widget build(BuildContext context) {
    return isHud
        ? LoadStatus.showLoading(mounted)
        : netError
            ? LoadStatus.netErrorWork(onTap: () {
                netError = false;
                getData();
              })
            : widget.index != 0 && array.isEmpty
                ? LoadStatus.noData()
                : widget.index == 0 && showFilter
                    ? _filterWidget()
                    : SingleChildScrollView(
                        child: EasyPullRefresh(
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
                      );
  }

  int filter1Index = 0;

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
            filter1Index = index;
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
          _buildFilterButtons(historyCategories["times"] as List, filter2Index,
              onTap: (index) {
            filter2Index = index;
            setState(() {});
          }),
          SizedBox(
            height: 52.w,
          ),
          InkWell(
            onTap: () {
              showFilter = false;
              setState(() {});
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

  Widget _buildFilterButtons(List<dynamic> items, int selectedIndex,
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
              color: index == selectedIndex
                  ? StyleTheme.orange249Color25
                  : StyleTheme.white255Color10,
              borderRadius: BorderRadius.circular(15.w),
            ),
            child: Text(
              e['name'],
              style: index == selectedIndex
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
      addRepaintBoundaries: false,
      addAutomaticKeepAlives: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      cacheExtent: ScreenHeight * 3,
      crossAxisCount: 3,
      mainAxisSpacing: 52.w,
      crossAxisSpacing: 20.w,
      childAspectRatio: 505.w / 368.w,
      padding: EdgeInsets.symmetric(horizontal: 29.5.w),
      children:
          array.map((e) => Utils.newsModuleUI(context, e, style: 2)).toList(),
    );
  }
}
