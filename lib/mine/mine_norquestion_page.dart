import 'package:hlw/base/base_widget.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:hlw/widget/search_bar_widget.dart';

class MineNorquestionPage extends BaseWidget {
  const MineNorquestionPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> cState() {
    return _MineNorquestionPageState();
  }
}

class _MineNorquestionPageState extends BaseWidgetState<MineNorquestionPage> {
  @override
  void onCreate() {}

  @override
  Widget appbar() {
    return Container();
  }

  @override
  void onDestroy() {}

  @override
  Widget pageBody(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: StyleTheme.margin, vertical: 10.w),
          //   child: cf?.help == null || cf?.help?.isEmpty == true
          //       ? LoadStatus.noData()
          //       : Container(
          //           padding:
          //               EdgeInsets.symmetric(horizontal: StyleTheme.singleMargin),
          //           child: Column(
          //             children: cf?.help?.first.items?.map((e) {
          //                   return Align(
          //                     alignment: Alignment.centerLeft,
          //                     child: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Text(
          //                           e.question ?? "",
          //                           style: StyleTheme.font_black_31_18_semi,
          //                           maxLines: 2,
          //                         ),
          //                         SizedBox(height: 10.w),
          //                         Utils.getContentSpan(e.answer ?? "",
          //                             isCopy: true),
          //                         SizedBox(height: 30.w),
          //                       ],
          //                     ),
          //                   );
          //                 }).toList() ??
          //                 [],
          //           ),
          //         ),
          child: Container(),
        ),
        SearchBarWidget(isBackBtn: true, backTitle: Utils.txt('chjwt')),
      ],
    );
  }
}
