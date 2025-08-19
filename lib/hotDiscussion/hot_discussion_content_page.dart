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

class HotDiscussionContentPage extends StatefulWidget {
  final int index;

  const HotDiscussionContentPage({super.key, this.index = 0});

  @override
  State createState() => _HotDiscussionContentPageState();
}

class _HotDiscussionContentPageState extends State<HotDiscussionContentPage> {
  bool isHud = true;
  bool netError = false;
  bool noMore = false;
  int page = 1;
  List tps = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.index == 0
        ? _todayWidget()
        : EasyPullRefresh(
            onRefresh: () async {
              return true;
            },
            onLoading: () async {
              return true;
            },
            sameChild: _buildContainerWidget(),
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

  Widget _todayWidget() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GridView.count(
            addRepaintBoundaries: false,
            addAutomaticKeepAlives: false,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            cacheExtent: ScreenHeight * 3,
            crossAxisCount: 4,
            mainAxisSpacing: 52.w,
            crossAxisSpacing: 20.w,
            childAspectRatio: 374.w / 664.w,
            children: [
              Utils.newsModuleUI(context, defaultItemData, style: 3),
              Utils.newsModuleUI(context, defaultItemData, style: 3),
              Utils.newsModuleUI(context, defaultItemData, style: 3),
              Utils.newsModuleUI(context, defaultItemData, style: 3)
            ],
          ),
          SizedBox(
            height: 52.w,
          ),
          InkWell(
            onTap: () {
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
                "换一个话题",
                style: StyleTheme.font_brown_103_26_bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContainerWidget() {
    return ListView(children: [
      _buildFilterWidget(),
      SizedBox(
        height: 28.w,
      ),
      _buildGridViewWidget(),
    ]);
  }

  Widget _buildFilterWidget() {
    return Column(
      children: [
        GenCustomNav(
          defaultStyle: StyleTheme.font_gray_161_20_bold,
          selectStyle: StyleTheme.font_orange_244_20_600,
          isCenter: false,
          isCover: true,
          titles: ["热门推荐", "本周最新", "最多观看"],
          pages: [],
        ),
      ],
    );
  }

  Widget _buildGridViewWidget() {
    return GridView.count(
      addRepaintBoundaries: false,
      addAutomaticKeepAlives: false,
      padding: EdgeInsets.symmetric(horizontal: 29.5.w),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      cacheExtent: ScreenHeight * 3,
      crossAxisCount: 4,
      mainAxisSpacing: 52.w,
      crossAxisSpacing: 20.w,
      childAspectRatio: 374.w / 664.w,
      children: [
        defaultItemData,
        defaultItemData,
        defaultItemData,
        defaultItemData,
        defaultItemData,
      ].map((e) => Utils.newsModuleUI(context, e, style: 3)).toList(),
    );
  }
}
