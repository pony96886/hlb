import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';

import '../util/local_png.dart';
import '../util/netimage_tool.dart';
import '../util/style_theme.dart';
import '../util/utils.dart';

class PostItemWidget extends StatelessWidget {
  final int style;
  final int state;
  final dynamic args;

  /// style: 1 横向样式 2 纵向样式
  /// state: 1 已分布 2 通过/待回调 3 待审核 4 被拒绝
  const PostItemWidget(
    this.args, {
    super.key,
    this.style = 1,
    this.state = 1,
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
        switch (state) {
          case 1:
          case 2:
            Utils.navTo(context, "/homecontentdetailpage/${args["id"]}");
            break;
          // case 3: // 待审核
          case 4: //
            Utils.navTo(context, "/homeeditorpage/${args["id"]}");
            break;
          default:
        }
      },
      child: current,
    );
  }

  String get plates {
    String plates =
        DateUtil.formatDateStr(args["created_date"], format: "yyyy年MM日dd");
    if (args["plates"] is Map && (args["plates"] as Map).isNotEmpty) {
      plates += ' · ${(args["plates"] as Map).values.toList().join(' ')}';
    }
    if (args["plates"] is List && (args["plates"] as List).isNotEmpty) {
      plates += ' · ${(args["plates"] as List).map((i) {
        if (i is String) return i;
        if (i is Map) return '${i['name']}';
        return ''; // 未知类型
      }).join(' ')}';
    }

    return plates;
  }

  Widget _buildStyleOneWidget(BuildContext context) {
    return Column(children: [
      SizedBox(
        width: 920.w,
        height: 150.w,
        child: Row(children: [
          Stack(children: [
            SizedBox(
              width: 440.w,
              height: 150.w,
              // width: StyleTheme.contentWidth / 2,
              // height: StyleTheme.contentWidth / 2 / 375 * 130,
              child: NetImageTool(
                radius: BorderRadius.all(Radius.circular(3.w)),
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
          SizedBox(width: 40.w),
          SizedBox(
            height: 150.w,
            // height: StyleTheme.contentWidth / 2 / 375 * 130,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  args["title"],
                  style: StyleTheme.font_white_20,
                  maxLines: 3,
                ),
                SizedBox(height: 10.w),
                Text(
                  plates,
                  style: StyleTheme.font_gray_153_14,
                  maxLines: 1,
                ),
                Expanded(child: Container()),
                Visibility(
                  visible: args['id'] > 0,
                  child: Utils.btnRed(
                    '编辑',
                    () => Utils.navTo(context, '/homeeditorpage/${args['id']}'),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
      SizedBox(height: 20.w),
      Container(
        height: 70.w,
        width: double.infinity,
        color: StyleTheme.gray246Color,
        padding: EdgeInsets.all(10.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Utils.txt('ggly') + ":",
              style: StyleTheme.font_red_245_15_bold,
            ),
            Text(
              "${args['remark']}",
              style: StyleTheme.font_gray_102_14,
            ),
          ],
        ),
      ),
      SizedBox(height: 20.w), // 間距
    ]);
  }

  Widget _buildStyleTwoWidget(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        width: 440.w,
        height: 150.w,
        // width: (StyleTheme.contentWidth - 5.w) / 2,
        // height: (StyleTheme.contentWidth - 5.w) / 2 / 375 * 130,
        child: Stack(children: [
          NetImageTool(
            radius: BorderRadius.all(Radius.circular(3.w)),
            url: args['thumb'],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: (args['is_hot'] != 1 || args['is_ad'] == 1)
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
            Text(
              args['is_ad'] == 1 &&
                      args['ad'] is Map &&
                      args['ad']['name'] != null &&
                      args['ad']['name'] != ''
                  ? '${args['ad']['name']}'
                  : '${args["title"]}',
              style: StyleTheme.font_white_20,
              maxLines: 2,
            ),
            SizedBox(height: 10.w),
            Expanded(
              child: Text(
                plates,
                style: StyleTheme.font_gray_153_17,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
