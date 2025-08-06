import 'package:hlw/base/base_widget.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';

class EmptyPage extends BaseWidget {
  EmptyPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _EmptyPageState();
  }
}

class _EmptyPageState extends BaseWidgetState<EmptyPage> {
  @override
  Widget appbar() {
    // TODO: implement appbar
    return Utils.createNav(
      left: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          finish();
        },
        child: Container(
          alignment: Alignment.centerLeft,
          width: 40.w,
          height: 40.w,
          child: LocalPNG(
            name: "51_nav_back",
            width: 17.w,
            height: 17.w,
            fit: BoxFit.contain,
          ),
        ),
      ),
      title: Utils.txt('404ym'),
    );
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        finish();
      },
      child: Center(
        child: Text(
          '404 not found page, please click back',
          style: StyleTheme.font_black_31_16_semi,
        ),
      ),
    );
  }
}
