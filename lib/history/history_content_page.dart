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

  const HistoryContentPage({super.key, this.index = 0});

  @override
  State createState() => _HistoryContentPageState();
}

class _HistoryContentPageState extends State<HistoryContentPage> {
  bool isHud = true;
  bool netError = false;
  bool noMore = false;
  int page = 1;
  List tps = [];

  @override
  void initState() {
    super.initState();
  }

  bool showFilter = true;

  @override
  Widget build(BuildContext context) {
    return widget.index == 0 && showFilter
        ? _filterWidget()
        : EasyPullRefresh(
            onRefresh: () async {
              return true;
            },
            onLoading: () async {
              return true;
            },
            sameChild: _buildGridViewWidget(),
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
          _buildFilterButtons([
            "首页",
            "今日看料",
            "反差女神",
            "看片",
            "每日比赛",
            "每日大赛",
            "首页",
            "今日看料",
            "反差女神",
            "看片",
            "每日比赛",
            "每日大赛",
            "首页",
            "今日看料",
            "反差女神",
            "看片",
            "每日比赛",
            "每日大赛",
            "首页",
            "今日看料",
            "反差女神",
            "看片",
            "每日比赛",
            "每日大赛"
          ], filter1Index, onTap: (index) {
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
          _buildFilterButtons([
            "一个月以前",
            "半年以前",
            "一年以前",
            "全部",
          ], filter2Index, onTap: (index) {
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

  Widget _buildFilterButtons(List<String> items, int selectedIndex,
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
        String e = entry.value;
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
              e,
              style: index == selectedIndex
                  ? StyleTheme.font_orange_244_22_bold
                  : StyleTheme.font_white_255_22_bold,
            ),
          ),
        );
      }).toList(),
    );
  }

  dynamic defaultItemData = {
    "id": 39668,
    "title": "黑料网最新入口，黑料回家路，黑料合集每日更新，回家路合集页",
    "plates": {},
    "created_date": "2025-05-01 00:00:00",
    "is_ad": 0,
    "thumb":
        "https://new.fwvkjw.cn/upload_01/upload/20250813/2025081312034176716.png",
  };

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
      children: [
        defaultItemData,
        defaultItemData,
        defaultItemData,
        defaultItemData,
        defaultItemData,
      ].map((e) => Utils.newsModuleUI(context, e, style: 2)).toList(),
    );
  }
}
