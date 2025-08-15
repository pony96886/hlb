import 'package:flutter/material.dart';

import '../util/style_theme.dart';

class FeatureIndexPage extends StatefulWidget {
  final dynamic args;
  const FeatureIndexPage({super.key, this.args});

  @override
  State createState() => _FeatureIndexPageState();
}

class _FeatureIndexPageState extends State<FeatureIndexPage> {
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
