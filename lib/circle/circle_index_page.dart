import 'package:flutter/material.dart';

import '../util/style_theme.dart';

class CircleIndexPage extends StatefulWidget {
  final dynamic args;
  const CircleIndexPage({super.key, this.args});

  @override
  State createState() => _CircleIndexPageState();
}

class _CircleIndexPageState extends State<CircleIndexPage> {
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
