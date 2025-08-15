import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: StyleTheme.bgColor,
      body: Column(children: [
        Container(),
        Container(),
      ]),
    );
  }
}
