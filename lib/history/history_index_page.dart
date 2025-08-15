import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';
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
        child: Container(),
      ),
      const SearchBarWidget(),
    ]);
  }
}
