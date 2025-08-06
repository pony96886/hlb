import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../util/eventbus_class.dart';
import '../util/local_png.dart';
import '../util/style_theme.dart';

/// 上滑
class GoTopWidget extends StatelessWidget {
  const GoTopWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          UtilEventbus().fire(EventbusClass({"GoTop" : "GoTop"}));
        },
        child: Container(
          color: StyleTheme.gray153Color,
          padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 8.w),
          child: Column(
            children: [
              LocalPNG(name: "hlw_go_top", width: 16.w, height: 16.w),
              SizedBox(height: 2.w),
              Text('顶部', style: StyleTheme.font_white_255_11_medium),
            ],
          ),
        ),
      ),
    );
  }
}