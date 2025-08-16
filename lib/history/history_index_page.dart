import 'package:flutter/material.dart';
import 'package:hlw/base/gen_custom_nav.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:hlw/util/easy_pull_refresh.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/utils.dart';
import 'package:hlw/widget/search_bar_widget.dart';

import '../util/style_theme.dart';

class HistoryIndexPage extends StatefulWidget {
  final dynamic args;

  const HistoryIndexPage({super.key, this.args});

  @override
  State createState() => _HistoryIndexPageState();
}

class _HistoryIndexPageState extends State<HistoryIndexPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        top: 90.w,
        bottom: 0,
        left: 0,
        right: 0,
        child: _buildHistoryWidget(),
      ),
      const SearchBarWidget(),
    ]);
  }

  Widget _buildHistoryWidget() {
    Widget current = Padding(
      padding: EdgeInsets.symmetric(
        vertical: 32.w,
      ),
      child: Row(
        children: [
          Expanded(
              child: GenCustomNav(
            isCenter: false,
            defaultSelectIndex: 2,
            titlePadding: EdgeInsets.symmetric(horizontal: 29.5.w),
            titles: ["尘封", "往期", "往期"],
            pages: [],
          )),
          Row(
            children: [
              Text(
                "2025-07-29",
                style: StyleTheme.font_gray_194_20_bold,
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
          SizedBox(
            width: 29.5.w,
          )
        ],
      ),
    );
    return Column(
      children: [
        current,
        Expanded(
          child: EasyPullRefresh(
            onRefresh: () async {
              return true;
            },
            onLoading: () async {
              return true;
            },
            sameChild: _buildGridViewWidget(),
          ),
        ),
        SizedBox(height: 20.w),
      ],
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
