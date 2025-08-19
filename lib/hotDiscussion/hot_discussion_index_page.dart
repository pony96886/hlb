import 'package:flutter/material.dart';
import 'package:hlw/base/gen_custom_nav.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:hlw/util/easy_pull_refresh.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/utils.dart';
import 'package:hlw/widget/search_bar_widget.dart';

import '../util/style_theme.dart';
import 'hot_discussion_content_page.dart';

class HotDiscussionIndexPage extends StatefulWidget {
  final dynamic args;

  const HotDiscussionIndexPage({super.key, this.args});

  @override
  State createState() => _HotDiscussionIndexPageState();
}

class _HotDiscussionIndexPageState extends State<HotDiscussionIndexPage> {
  DateTime? selectedDate = DateTime.now();

  int tabSelectIndex = 2;

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
    return GenCustomNav(
      isCenter: false,
      titles: ["今日话题", "历史话题"],
      pages: [
        HotDiscussionContentPage(
          index: 0,
        ),
        HotDiscussionContentPage(
          index: 1,
        ),
      ],
    );
  }
}
