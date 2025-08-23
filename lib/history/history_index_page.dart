import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:hlw/base/gen_custom_nav.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:hlw/util/easy_pull_refresh.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/utils.dart';
import 'package:hlw/widget/search_bar_widget.dart';

import '../util/style_theme.dart';
import 'history_content_page.dart';

class HistoryIndexPage extends StatefulWidget {
  final dynamic args;

  const HistoryIndexPage({super.key, this.args});

  @override
  State createState() => _HistoryIndexPageState();
}

class _HistoryIndexPageState extends State<HistoryIndexPage> {
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
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 32.w,
      ),
      child: GenCustomNav(
        isCenter: false,
        defaultSelectIndex: tabSelectIndex,
        indexFunc: (index) {
          tabSelectIndex = index;
          setState(() {});
        },
        titles: const ["尘封", "榜单", "往期"],
        pages: [
          HistoryContentPage(
            index: 0,
          ),
          HistoryContentPage(
            index: 1,
          ),
          HistoryContentPage(
            index: 2,
          ),
        ],
      ),
    );
  }
}
