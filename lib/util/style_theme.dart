// ignore_for_file: non_constant_identifier_names

import 'package:hlw/util/app_global.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';

class StyleTheme {
  //距离
  static double get margin => 13.w;

  //单一页面距离
  static double get singleMargin => 220.w;

  /*导航条高度*/
  static double get navHegiht => 40.w;

  static double get topHeight => kIsWeb
      ? 5.w
      : Utils.isPC
          ? 5.w
          : MediaQuery.of(AppGlobal.context!).padding.top;
  static bool ipx = kIsWeb && (ScreenHeight / ScreenWidth >= 1.26);
  static double bottom = ipx ? 15.w : 0;

  /*底部导航条高度*/
  static double get botHegiht => 55.w;

  static double get pxBotHegiht => ipx ? (botHegiht + bottom) : botHegiht;

  /*内容页宽度*/
  static double get contentWidth =>
      Utils.isPC ? ScreenWidth - 90.w - 26.w - rightWidth : ScreenWidth;

  //右边模块宽度
  static double get rightWidth => 320.w;

  //颜色
  static Color bgColor = const Color.fromRGBO(24, 24, 24, 1);
  static Color navColor = const Color.fromRGBO(255, 255, 255, 1);
  static Color black0Color = Colors.black;
  static Color black0Color120 = const Color.fromRGBO(0, 0, 0, 0.120);
  static Color black0Color720 = const Color.fromRGBO(0, 0, 0, 0.720);
  static Color black14Color = const Color.fromRGBO(14, 14, 14, 1);
  static Color black24Color = const Color.fromRGBO(24, 24, 24, 1);
  static Color black29Color = const Color.fromRGBO(29, 29, 29, 1);
  static Color black31Color = const Color.fromRGBO(31, 31, 31, 1);
  static Color black34Color = const Color.fromRGBO(34, 34, 34, 1);
  static Color gray51Color = const Color.fromRGBO(51, 51, 51, 1);
  static Color black68Color = const Color.fromRGBO(68, 68, 68, 1);
  static Color gray187Color = const Color.fromRGBO(187, 187, 187, 1);
  static Color gray230Color = const Color.fromRGBO(230, 230, 230, 1);
  static Color gray233Color = const Color.fromRGBO(233, 233, 233, 1);
  static Color gray235Color = const Color.fromRGBO(235, 235, 235, 1);
  static Color gray204Color = const Color.fromRGBO(204, 204, 204, 1);
  static Color gray244Color = const Color.fromRGBO(244, 244, 244, 1);
  static Color gray242Color = const Color.fromRGBO(242, 242, 242, 1);
  static Color gray241Color = const Color.fromRGBO(241, 241, 241, 1);
  static Color gray77Color = const Color.fromRGBO(77, 77, 77, 1);
  static Color gray246Color = const Color.fromRGBO(246, 246, 246, 1);
  static Color gray245Color = const Color.fromRGBO(245, 245, 245, 1);
  static Color gray238Color = const Color.fromRGBO(238, 238, 238, 1);
  static Color gray195Color = const Color.fromRGBO(195, 195, 195, 1);
  static Color brown102Color = const Color.fromRGBO(102, 72, 22, 1);
  static Color red245Color = const Color.fromRGBO(245, 74, 82, 1);
  static Color red246Color = const Color.fromRGBO(246, 74, 82, 1);
  static Color red252Color = const Color.fromRGBO(252, 244, 230, 1);
  static Color gray85Color = const Color.fromRGBO(85, 85, 85, 1);
  static Color gray102Color = const Color.fromRGBO(102, 102, 102, 1);
  static Color gray102Color40 = const Color.fromRGBO(102, 102, 102, 0.4);
  static Color gray119Color = const Color.fromRGBO(119, 119, 119, 1);
  static Color gray128Color = const Color.fromRGBO(128, 128, 128, 1);
  static Color gray151Color = const Color.fromRGBO(151, 151, 151, 1);
  static Color gray153Color = const Color.fromRGBO(153, 153, 153, 1);
  static Color gray194Color = const Color.fromRGBO(194, 202, 217, 1);
  static Color gray153Color64 = const Color.fromRGBO(153, 153, 153, 0.64);
  static Color gray161Color64 = const Color.fromRGBO(161, 161, 161, 1);
  static Color gray170Color = const Color.fromRGBO(170, 170, 170, 1);
  static Color gray186Color = const Color.fromRGBO(186, 186, 186, 1);
  static Color gray216Color2 = const Color.fromRGBO(216, 216, 216, 0.2);
  static Color gray225Color = const Color.fromRGBO(225, 225, 225, 1);
  static Color gray229Color = const Color.fromRGBO(229, 229, 229, 1);
  static Color gray225Color45 = const Color.fromRGBO(225, 225, 225, 0.451);
  static Color gray231Color = const Color.fromRGBO(231, 231, 231, 1);
  static Color gray247Color = const Color.fromRGBO(247, 247, 247, 1);
  static Color gray255Color2 = const Color.fromRGBO(255, 255, 255, 0.2);
  static Color gray255Color1 = const Color.fromRGBO(255, 255, 255, 0.1);
  static Color blue25Color = const Color.fromRGBO(25, 103, 210, 1);
  static Color yellow255Color = const Color.fromRGBO(255, 187, 59, 1);
  static Color orange255Color = const Color.fromRGBO(255, 144, 0, 1);
  static Color orange249Color = const Color.fromRGBO(244, 154, 52, 1);
  static Color orange47Color = const Color.fromRGBO(47, 29, 24, 1);

  static Color tabColor_n = const Color.fromRGBO(194, 202, 217, 1);
  static TextStyle tab_font =
      font(size: 20, weight: FontWeight.w500, color: tabColor_n);

  static LinearGradient gradientLinarYellow = const LinearGradient(
    colors: [Color.fromRGBO(255, 210, 80, 1), Color.fromRGBO(247, 187, 13, 1)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  //字体
  static TextStyle nav_title_font =
      font(size: 18, weight: FontWeight.normal, color: black31Color);

  static TextStyle font_orange_255_15 =
      font(size: 15, weight: FontWeight.normal, color: orange255Color);

  static TextStyle font_gray_102_15 =
      font(size: 15, weight: FontWeight.normal, color: gray102Color);

  static TextStyle font_gray_151_15 =
      font(size: 15, weight: FontWeight.normal, color: gray151Color);

  static TextStyle font_gray_153_15_medium =
      font(size: 15, weight: FontWeight.w500, color: gray153Color);

  static TextStyle font_gray_153_15 =
      font(size: 15, weight: FontWeight.normal, color: gray153Color);

  static TextStyle font_gray_187_15 =
      font(size: 15, weight: FontWeight.normal, color: gray187Color);

  static TextStyle font_gray_247_15 =
      font(size: 15, weight: FontWeight.normal, color: gray247Color);

  static TextStyle font_black_34_15 =
      font(size: 15, weight: FontWeight.normal, color: black34Color);

  static TextStyle font_black_34_15_medium =
      font(size: 15, weight: FontWeight.w500, color: black34Color);

  static TextStyle font_black_51_15 =
      font(size: 15, weight: FontWeight.normal, color: gray51Color);

  static TextStyle font_yellow_255_15_bold =
      font(size: 15, weight: FontWeight.bold, color: yellow255Color);

  static TextStyle font_black_0_15 =
      font(size: 15, weight: FontWeight.normal, color: black0Color);

  static TextStyle font_black_0_15_bold =
      font(size: 15, weight: FontWeight.bold, color: black0Color);

  static TextStyle font_black_31_15 =
      font(size: 15, weight: FontWeight.normal, color: black31Color);

  static TextStyle font_black_31_15_medium =
      font(size: 15, weight: FontWeight.w500, color: black31Color);

  static TextStyle font_black_68_15 =
      font(size: 15, weight: FontWeight.normal, color: black31Color);

  static TextStyle font_gray_119_12 =
      font(size: 12, weight: FontWeight.normal, color: gray119Color);

  static TextStyle font_gray_153_12 =
      font(size: 12, weight: FontWeight.normal, color: gray153Color);

  static TextStyle font_gray_153_12_semi =
      font(size: 12, weight: FontWeight.w600, color: gray153Color);

  static TextStyle font_gray_204_12 =
      font(size: 12, weight: FontWeight.normal, color: gray204Color);

  static TextStyle font_black_0_12_bold =
      font(size: 12, weight: FontWeight.bold, color: black0Color);

  static TextStyle font_black_31_12_bold =
      font(size: 12, weight: FontWeight.bold, color: black31Color);

  static TextStyle font_black_31_12_medium =
      font(size: 12, weight: FontWeight.w500, color: black31Color);

  static TextStyle font_black_31_12 =
      font(size: 12, weight: FontWeight.normal, color: black31Color);

  static TextStyle font_black_34_12 =
      font(size: 12, weight: FontWeight.normal, color: black34Color);

  static TextStyle font_black_34_12_medium =
      font(size: 12, weight: FontWeight.w500, color: black34Color);

  static TextStyle font_orange_255_12 =
      font(size: 12, weight: FontWeight.normal, color: orange255Color);

  static TextStyle font_gray_77_13 =
      font(size: 13, weight: FontWeight.normal, color: gray77Color);

  static TextStyle font_gray_119_13 =
      font(size: 13, weight: FontWeight.normal, color: gray119Color);

  static TextStyle font_black_31_13 =
      font(size: 13, weight: FontWeight.normal, color: black31Color);

  static TextStyle font_black_31_10 =
      font(size: 10, weight: FontWeight.normal, color: black31Color);

  static TextStyle font_gray_204_11 =
      font(size: 11, weight: FontWeight.normal, color: gray204Color);

  static TextStyle font_black_31_11 =
      font(size: 11, weight: FontWeight.normal, color: black31Color);

  static TextStyle font_white_255_13 =
      font(size: 13, weight: FontWeight.normal, color: bgColor);

  static TextStyle font_white_255_24_600 =
      font(size: 24, weight: FontWeight.w600, color: Colors.white);

  static TextStyle font_white_161_20_bold =
      font(size: 20, weight: FontWeight.bold, color: gray161Color64);

  static TextStyle font_orange_249_20 =
      font(size: 20, weight: FontWeight.bold, color: orange249Color);

  static TextStyle font_gray_151_13 =
      font(size: 13, weight: FontWeight.normal, color: gray151Color);

  static TextStyle font_gray_187_13 =
      font(size: 13, weight: FontWeight.normal, color: gray187Color);

  static TextStyle font_gray_204_13 =
      font(size: 13, weight: FontWeight.normal, color: gray204Color);

  static TextStyle font_gray_153_20 =
      font(size: 20, weight: FontWeight.bold, color: gray153Color);

  static TextStyle font_gray_161_20_bold =
      font(size: 20, weight: FontWeight.bold, color: gray161Color64);

  static TextStyle font_orange_244_20_600 =
      font(size: 20, weight: FontWeight.w600, color: orange249Color);

  static TextStyle font_white_20 =
      font(size: 20, weight: FontWeight.bold, color: Colors.white);

  static TextStyle font_gray_194_20 =
      font(size: 20, weight: FontWeight.bold, color: gray194Color);

  static TextStyle font_black_31_13_medium =
      font(size: 13, weight: FontWeight.w500, color: black31Color);

  static TextStyle font_black_31_13_bold =
      font(size: 13, weight: FontWeight.bold, color: black31Color);

  static TextStyle font_black_31_13_semi =
      font(size: 13, weight: FontWeight.w600, color: black31Color);

  static TextStyle font_black_34_13 =
      font(size: 13, weight: FontWeight.normal, color: black34Color);

  static TextStyle font_orange_255_13 =
      font(size: 13, weight: FontWeight.normal, color: orange255Color);

  static TextStyle font_orange_255_14 =
      font(size: 14, weight: FontWeight.normal, color: orange255Color);

  static TextStyle font_orange_255_13_bold =
      font(size: 13, weight: FontWeight.bold, color: orange255Color);

  static TextStyle font_gray_102_14_40 =
      font(size: 14, weight: FontWeight.normal, color: gray102Color);

  static TextStyle font_gray_170_14 =
      font(size: 14, weight: FontWeight.normal, color: gray170Color);

  static TextStyle font_gray_187_14 =
      font(size: 14, weight: FontWeight.normal, color: gray187Color);

  static TextStyle font_black_31_14 =
      font(size: 14, weight: FontWeight.normal, color: black31Color);

  static TextStyle font_black_31_14_line = font(
      size: 14,
      weight: FontWeight.normal,
      color: black31Color,
      decoration: TextDecoration.underline);

  static TextStyle font_black_51_14 =
      font(size: 14, weight: FontWeight.normal, color: gray51Color);

  static TextStyle font_black_31_15_bold =
      font(size: 15, weight: FontWeight.bold, color: black31Color);

  static TextStyle font_gray_85_16_medium =
      font(size: 16, weight: FontWeight.w500, color: gray85Color);

  static TextStyle font_black_34_16 =
      font(size: 16, weight: FontWeight.normal, color: black34Color);

  static TextStyle font_black_34_16_medium =
      font(size: 16, weight: FontWeight.w500, color: black34Color);

  static TextStyle font_black_34_16_bold =
      font(size: 16, weight: FontWeight.bold, color: black34Color);

  static TextStyle font_black_31_14_medium =
      font(size: 14, weight: FontWeight.w500, color: black31Color);

  static TextStyle font_black_31_14_bold =
      font(size: 14, weight: FontWeight.bold, color: black31Color);

  static TextStyle font_gray_77_12 =
      font(size: 12, weight: FontWeight.normal, color: gray77Color);

  static TextStyle font_gray_77_10 =
      font(size: 10, weight: FontWeight.normal, color: gray77Color);

  static TextStyle font_gray_119_10 =
      font(size: 10, weight: FontWeight.normal, color: gray119Color);

  static TextStyle font_red_246_10 =
      font(size: 10, weight: FontWeight.normal, color: red246Color);

  static TextStyle font_red_245_12 =
      font(size: 12, weight: FontWeight.normal, color: red245Color);

  static TextStyle font_red_246_12 =
      font(size: 12, weight: FontWeight.normal, color: red246Color);

  static TextStyle font_red_246_12_medium =
      font(size: 12, weight: FontWeight.w500, color: red246Color);

  static TextStyle font_brown_102_14_bold =
      font(size: 14, weight: FontWeight.bold, color: brown102Color);

  static TextStyle font_red_245_13 =
      font(size: 13, weight: FontWeight.normal, color: red245Color);

  static TextStyle font_red_246_13 =
      font(size: 13, weight: FontWeight.normal, color: red246Color);

  static TextStyle font_red_245_14 =
      font(size: 14, weight: FontWeight.normal, color: red245Color);

  static TextStyle font_red_246_14 =
      font(size: 14, weight: FontWeight.normal, color: red246Color);

  static TextStyle font_red_245_15 =
      font(size: 15, weight: FontWeight.normal, color: red245Color);

  static TextStyle font_red_245_15_bold =
      font(size: 15, weight: FontWeight.bold, color: red245Color);

  static TextStyle font_red_246_15_bold =
      font(size: 15, weight: FontWeight.bold, color: red246Color);

  static TextStyle font_red_245_18 =
      font(size: 18, weight: FontWeight.normal, color: red245Color);

  static TextStyle font_red_246_18 =
      font(size: 18, weight: FontWeight.normal, color: red246Color);

  static TextStyle font_orange_255_18 =
      font(size: 18, weight: FontWeight.normal, color: orange255Color);

  static TextStyle font_red_246_25 =
      font(size: 25, weight: FontWeight.normal, color: red246Color);

  static TextStyle font_gray_102_10 =
      font(size: 10, weight: FontWeight.normal, color: gray102Color);

  static TextStyle font_gray_102_12 =
      font(size: 12, weight: FontWeight.normal, color: gray102Color);

  static TextStyle font_gray_102_14 =
      font(size: 14, weight: FontWeight.normal, color: gray102Color);

  static TextStyle font_gray_119_14 =
      font(size: 14, weight: FontWeight.normal, color: gray119Color);

  static TextStyle font_gray_102_13 =
      font(size: 13, weight: FontWeight.normal, color: gray102Color);

  static TextStyle font_white_255_10 =
      font(size: 10, weight: FontWeight.normal);

  static TextStyle font_white_255_11 =
      font(size: 11, weight: FontWeight.normal);

  static TextStyle font_white_255_11_medium =
      font(size: 11, weight: FontWeight.w500);

  static TextStyle font_white_255_11_bold =
      font(size: 11, weight: FontWeight.bold);

  static TextStyle font_white_255_12 =
      font(size: 12, weight: FontWeight.normal);

  static TextStyle font_white_255_13_bold =
      font(size: 13, weight: FontWeight.bold);

  static TextStyle font_gray_153_13 =
      font(size: 13, weight: FontWeight.normal, color: gray153Color);

  static TextStyle font_gray_153_13_64 =
      font(size: 13, weight: FontWeight.normal, color: gray153Color64);

  static TextStyle font_gray_204_13_bold =
      font(size: 13, weight: FontWeight.bold, color: gray204Color);

  static TextStyle font_red_74_13 =
      font(size: 13, weight: FontWeight.normal, color: red246Color);

  static TextStyle font_white_255_14 =
      font(size: 14, weight: FontWeight.normal);

  static TextStyle font_white_255_15 =
      font(size: 15, weight: FontWeight.normal);

  static TextStyle font_white_255_16 =
      font(size: 16, weight: FontWeight.normal);

  static TextStyle font_gray_204_16 =
      font(size: 16, weight: FontWeight.normal, color: gray204Color);

  static TextStyle font_gray_170_16 =
      font(size: 16, weight: FontWeight.normal, color: gray170Color);

  static TextStyle font_gray_170_16_medium =
      font(size: 16, weight: FontWeight.w500, color: gray170Color);

  static TextStyle font_black_0_16 =
      font(size: 16, weight: FontWeight.normal, color: black0Color);

  static TextStyle font_black_31_16_semi =
      font(size: 16, weight: FontWeight.w600, color: black31Color);

  static TextStyle font_black_31_16 =
      font(size: 16, weight: FontWeight.normal, color: black31Color);

  static TextStyle font_black_51_16 =
      font(size: 16, weight: FontWeight.normal, color: gray51Color);

  static TextStyle font_black_0_16_bold =
      font(size: 16, weight: FontWeight.bold, color: black0Color);

  static TextStyle font_orange_255_16 =
      font(size: 16, weight: FontWeight.normal, color: orange255Color);

  static TextStyle font_white_255_17 =
      font(size: 17, weight: FontWeight.normal);

  static TextStyle font_gray_102_17 =
      font(size: 17, weight: FontWeight.normal, color: gray102Color);

  static TextStyle font_gray_153_17 =
      font(size: 17, weight: FontWeight.normal, color: gray153Color);

  static TextStyle font_gray_170_17 =
      font(size: 17, weight: FontWeight.normal, color: gray170Color);

  static TextStyle font_black_0_17 =
      font(size: 17, weight: FontWeight.normal, color: black0Color);

  static TextStyle font_black_0_17_bold =
      font(size: 17, weight: FontWeight.bold, color: black0Color);

  static TextStyle font_black_34_17 =
      font(size: 17, weight: FontWeight.normal, color: black34Color);

  static TextStyle font_black_34_17_bold =
      font(size: 17, weight: FontWeight.bold, color: black34Color);

  static TextStyle font_white_255_22_bold =
      font(size: 22, weight: FontWeight.bold, color: Colors.white);

  static TextStyle font_white_255_24_bold =
      font(size: 22, weight: FontWeight.bold, color: Colors.white);

  static TextStyle font_white_255_20 =
      font(size: 22, weight: FontWeight.normal, color: Colors.white);

  static TextStyle font_black_51_17 =
      font(size: 17, weight: FontWeight.normal, color: gray51Color);

  static TextStyle font_orange_255_17 =
      font(size: 17, weight: FontWeight.normal, color: orange255Color);

  static TextStyle font_black_34_17_medium =
      font(size: 17, weight: FontWeight.w500, color: black34Color);

  static TextStyle font_black_0_18 =
      font(size: 18, weight: FontWeight.normal, color: black0Color);

  static TextStyle font_black_0_18_bold =
      font(size: 18, weight: FontWeight.bold, color: black0Color);

  static TextStyle font_black_31_18 =
      font(size: 18, weight: FontWeight.normal, color: black31Color);

  static TextStyle font_black_31_18_semi =
      font(size: 18, weight: FontWeight.w600, color: black31Color);

  static TextStyle font_black_34_18 =
      font(size: 18, weight: FontWeight.normal, color: black34Color);

  static TextStyle font_black_34_19 =
      font(size: 19, weight: FontWeight.normal, color: black34Color);

  static TextStyle font_orange_255_19 =
      font(size: 19, weight: FontWeight.normal, color: orange255Color);

  static TextStyle font_black_0_20 =
      font(size: 20, weight: FontWeight.normal, color: black0Color);

  static TextStyle font_black_31_20 =
      font(size: 20, weight: FontWeight.normal, color: black31Color);

  static TextStyle font_black_31_20_semi =
      font(size: 20, weight: FontWeight.w600, color: black31Color);

  static TextStyle font_black_34_20 =
      font(size: 20, weight: FontWeight.normal, color: black34Color);

  static TextStyle font_orange_255_20 =
      font(size: 20, weight: FontWeight.normal, color: orange255Color);

  static TextStyle font_black_31_22 =
      font(size: 22, weight: FontWeight.normal, color: black31Color);

  static TextStyle font_black_31_24 =
      font(size: 24, weight: FontWeight.normal, color: black31Color);

  static TextStyle font_red_74_10 =
      font(size: 10, weight: FontWeight.normal, color: red246Color);

  static TextStyle font_gray_128_20 =
      font(size: 20, weight: FontWeight.normal, color: gray128Color);

  static TextStyle font_gray_153_10 =
      font(size: 10, weight: FontWeight.normal, color: gray153Color);

  static TextStyle font_gray_153_11 =
      font(size: 11, weight: FontWeight.normal, color: gray153Color);

  static TextStyle font_gray_204_11_bold =
      font(size: 11, weight: FontWeight.normal, color: gray204Color);

  static TextStyle font_gray_153_14 =
      font(size: 14, weight: FontWeight.normal, color: gray153Color);

  static TextStyle font_gray_153_18 =
      font(size: 18, weight: FontWeight.normal, color: gray153Color);

  static TextStyle font_gray_153_14_medium =
      font(size: 14, weight: FontWeight.w500, color: gray153Color);

  static TextStyle font_gray_153_14_semi =
      font(size: 14, weight: FontWeight.w600, color: gray153Color);

  static TextStyle font_gray_230_16 =
      font(size: 16, weight: FontWeight.normal, color: gray230Color);

  static TextStyle font_gray_153_16_medium =
      font(size: 16, weight: FontWeight.w500, color: gray153Color);

  static TextStyle font_gray_153_16 =
      font(size: 16, weight: FontWeight.normal, color: gray153Color);

  static TextStyle font_blue_30_12 =
      font(size: 12, weight: FontWeight.normal, color: blue25Color);

  static TextStyle font_blue_30_13 =
      font(size: 12, weight: FontWeight.normal, color: blue25Color);

  static TextStyle font_blue_30_14 =
      font(size: 14, weight: FontWeight.normal, color: blue25Color);

  static TextStyle font_black_34_27 =
      font(size: 27, weight: FontWeight.normal, color: black34Color);

  static TextStyle font_black_34_27_bold =
      font(size: 27, weight: FontWeight.bold, color: black34Color);

  static TextStyle font_black_0_29 =
      font(size: 29, weight: FontWeight.normal, color: black0Color);

  static TextStyle font_black_0_29_bold =
      font(size: 29, weight: FontWeight.bold, color: black0Color);

  static TextStyle font_black_0_30 =
      font(size: 30, weight: FontWeight.normal, color: black0Color);

  static TextStyle font_black_34_30 =
      font(size: 30, weight: FontWeight.normal, color: black34Color);

  static TextStyle font_black_34_30_bold =
      font(size: 30, weight: FontWeight.bold, color: black34Color);

  static TextStyle font_black_31_30_semi =
      font(size: 30, weight: FontWeight.w600, color: black31Color);

  static TextStyle font(
      {int size = 16,
      Color color = Colors.white,
      FontWeight weight = FontWeight.normal,
      List<Shadow>? shadows,
      TextDecoration decoration = TextDecoration.none,
      FontStyle fontStyle = FontStyle.normal,
      double? height}) {
    return TextStyle(
        fontFamily: null,
        color: color,
        fontSize: size.sp,
        fontWeight: weight,
        overflow: TextOverflow.ellipsis,
        decoration: decoration,
        fontStyle: fontStyle,
        decorationStyle: TextDecorationStyle.dotted,
        shadows: shadows,
        height: height);
  }
}
