// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';

double _scale = 1.0; //系数

double get ScreenWidth => ScreenUtil().screenWidth;
double get ScreenHeight => ScreenUtil().screenHeight;

//适配Windows尺寸 pt转px
extension DesktopExtension on num {
  ///[ScreenUtil.setWidth]
  double get w => Platform.isMacOS
      ? ScreenUtil().setWidth(this)
      : ScreenUtil().setWidth(this) * _scale;
  double get sp => Platform.isMacOS
      ? ScreenUtil().setSp(this)
      : ScreenUtil().setSp(this) * _scale;
}
