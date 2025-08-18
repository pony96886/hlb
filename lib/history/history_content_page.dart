import 'package:flutter/cupertino.dart';
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

  @override
  Widget build(BuildContext context) {
    return EasyPullRefresh(
      onRefresh: () async {
        return true;
      },
      onLoading: () async {
        return true;
      },
      sameChild: _buildGridViewWidget(),
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
