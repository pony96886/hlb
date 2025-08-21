import 'package:bot_toast/bot_toast.dart';
import 'package:hive/hive.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';

class LoadStatus {
  //全屏式loding
  static Function showSLoading({String? text}) {
    String tip = text ?? Utils.txt('jzz');
    return BotToast.showLoading(
        backgroundColor: Colors.black45,
        wrapToastAnimation: (AnimationController animation, fc, Widget child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: StyleTheme.orange255Color),
              SizedBox(height: 15.w),
              Text(tip,
                  style:
                      StyleTheme.font(size: 12, color: StyleTheme.gray204Color))
            ],
          );
        });
  }

  //列表loding
  static Widget showLoading(bool mounted, {String? text, int width = 100}) {
    String tip = text ?? Utils.txt('zzjzsh');
    if (mounted) {
      return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 30.w,
              width: 30.w,
              child: CircularProgressIndicator(
                color: StyleTheme.orange255Color,
                strokeWidth: 2,
              ),
            ),
            SizedBox(height: 15.w),
            Text(tip,
                style:
                    StyleTheme.font(size: 20, color: StyleTheme.gray204Color))
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  //关闭全屏式loading
  static void closeLoading() {
    return BotToast.closeAllLoading();
  }

  //无数据
  static Widget noData({String? text, double w = 285}) {
    String tip = text ?? Utils.txt('zwsj');
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LocalPNG(name: "hlw_nodata",  width: 291.w, height: 291.w, fit: BoxFit.fitWidth),
          SizedBox(height: 10.w),
          Text(tip,
              style: StyleTheme.font(size: 20, color: StyleTheme.gray204Color))
        ],
      ),
    );
  }

  //网络错误
  static Widget netErrorWork({String? text, Function? onTap}) {
    String tip = text ?? Utils.txt('zzsb');
    return InkWell(
      // hoverColor: Colors.white,
      // focusColor: Colors.white,
      // splashColor: Colors.white,
      // highlightColor: Colors.white,
      onTap: () {
        onTap?.call();
      },
      child: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(top: 0.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LocalPNG(name: 'hlw_no_network', width: 291.w, height: 291.w),
              SizedBox(height: 5.w),
              Text(tip,
                  style: StyleTheme.font(
                      size: 20, color: StyleTheme.gray204Color)),
            ],
          ),
        ),
      ),
    );
  }
}
