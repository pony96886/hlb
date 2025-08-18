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
  DateTime? selectedDate = DateTime.now();

  int tabSelectIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      LocalPNG(
        name: "history_bg",
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
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
        titles: ["尘封", "榜单", "往期"],
        pages: [
          HistoryContentPage(
            index: 0,
          ),
          HistoryContentPage(index: 1),
          HistoryContentPage(index: 2),
        ],
        titleExtraWidget: tabSelectIndex == 0
            ? null
            : InkWell(
                onTap: _pickDate,
                child: Row(
                  children: [
                    Text(
                      "${selectedDate?.year}-${selectedDate?.month.toString().padLeft(2, '0')}-${selectedDate?.day.toString().padLeft(2, '0')}",
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
              ),
      ),
    );
    // return Column(
    //   children: [
    //     current,
    //     Expanded(
    //       child: EasyPullRefresh(
    //         onRefresh: () async {
    //           return true;
    //         },
    //         onLoading: () async {
    //           return true;
    //         },
    //         sameChild: HistoryContentPage(),
    //       ),
    //     ),
    //     SizedBox(height: 20.w),
    //   ],
    // );
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
}
