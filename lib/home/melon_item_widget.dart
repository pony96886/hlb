import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';

import '../util/local_png.dart';
import '../util/netimage_tool.dart';
import '../util/style_theme.dart';
import '../util/utils.dart';

class MelonItemWidget extends StatelessWidget {
  final int style;
  final dynamic args;

  /// style: 1 list 横向样式 , 2 gird 纵向样式
  const MelonItemWidget(
    this.args, {
    super.key,
    this.style = 1,
  });

  @override
  Widget build(BuildContext context) {
    Widget current = const SizedBox();
    switch (style) {
      case 1:
        current = _buildStyleOneWidget(context);
        break;
      case 2:
        current = _buildStyleTwoWidget(context);
        break;
      default:
        return const SizedBox();
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (args["badge"] == "AD") {
          Utils.openURL(args["advertiser_url"]);
          return;
        }
        Utils.navTo(context, "/homecontentdetailpage/${args["id"]}");
      },
      child: current,
    );
  }

  Widget _buildStyleOneWidget(BuildContext context) {
    return Row(children: [
      Stack(children: [
        SizedBox(
          width: 356.w,
          height: 180.w,
          child: NetImageTool(
            radius: BorderRadius.all(Radius.circular(5.w)),
            url: args['thumb'] ?? '',
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: (args['is_hot'] != 1 || args['is_ad'] == 1)
              ? Container()
              : LocalPNG(name: "hlw_new_hot", width: 54.w, height: 43.w),
        ),
      ]),
      SizedBox(width: 20.w),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              args["title"],
              style: StyleTheme.font_white_255_22_bold,
              maxLines: 10,
            ),
            SizedBox(height: 10.w),
            Expanded(
              child: Text(
                args?["author"]?['screenName'] ?? '',
                style: StyleTheme.font_gray_153_18,
                maxLines: 3,
              ),
            ),
            Text(
              DateUtil.formatDateStr(args["created"],
                  format: "yyyy年MM日dd"),
              style: StyleTheme.font_gray_153_18,
              maxLines: 1,
            ),
          ],
        ),
      )
    ]);
  }

  Widget _buildStyleTwoWidget(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 265.w,
        width: 505.w,
        child: Stack(children: [
          NetImageTool(
            radius: BorderRadius.circular(12.w),
            url: args?['thumb'] ?? '',
          ),
          Positioned(
            right: 0,
            top: 0,
            child: (args?['is_hot'] != 1 || args?['is_ad'] == 1)
                ? Container()
                : LocalPNG(name: "hlw_new_hot", width: 54.w, height: 43.w),
          ),
        ]),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.w),
            Expanded(
              child: Text(
                args['is_ad'] == 1 &&
                        args['ad'] is Map &&
                        args['ad']['name'] != null &&
                        args['ad']['name'] != ''
                    ? '${args['ad']['name']}'
                    : '${args["title"]}',
                style: StyleTheme.font_white_255_22_medium,
                maxLines: 2,
              ),
            ),
            SizedBox(height: 10.w),
            Text(
              '${args?["author"]?['screenName'] ?? ''} • ${DateUtil.formatDateStr(args["created"],
                  format: "yyyy年MM日dd")}',
              style: StyleTheme.font_gray_153_18,
              maxLines: 1,
            )
          ],
        ),
      ),
    ]);
  }
}
