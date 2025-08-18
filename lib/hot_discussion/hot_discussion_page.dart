import 'package:flutter/material.dart';

import '../util/style_theme.dart';

class HotDiscussionPage extends StatefulWidget {
  final dynamic args;
  const HotDiscussionPage({super.key, this.args});

  @override
  State createState() => _HotDiscussionPageState();
}

class _HotDiscussionPageState extends State<HotDiscussionPage> {
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
