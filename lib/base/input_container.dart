import 'package:hlw/base/base_store.dart';
import 'package:hlw/model/user_model.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/netimage_tool.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:provider/provider.dart';

class InputContainer extends StatelessWidget {
  InputContainer({
    Key? key,
    this.child,
    this.onEditingCompleteText,
    this.onSelectPicComplete,
    this.onOutEventComplete,
    this.onCollectEventComplete,
    this.hintText,
    this.bg = Colors.white,
    this.focusNode,
    this.isCollect = false,
    this.padding = 0,
    this.width,
    this.childPrefix,
  }) : super(key: key);
  final bool isCollect;
  final Color bg;
  final Widget? child, childPrefix;
  final String? hintText;
  final double? width;
  final double padding;
  final TextEditingController controller = TextEditingController();
  final ValueChanged? onEditingCompleteText;
  final Function? onSelectPicComplete;
  final Function? onOutEventComplete;
  final Function? onCollectEventComplete;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<BaseStore>(context, listen: false).user;
    return Container(
      width: width,
      color: StyleTheme.bgColor,
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                onOutEventComplete?.call();
                Utils.unFocusNode(context);
              },
              child: child ?? Container(),
            ),
          ),
          Container(
            width: width,
            padding: EdgeInsets.symmetric(horizontal: padding.w),
            child: Divider(
              height: 1.w,
              color: StyleTheme.white10,
            ),
          ),
          Container(
            padding: EdgeInsets.all(13.w),
            height: 66.w,
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                onSelectPicComplete == null
                    ? SizedBox(
                  height: 40.w,
                  width: 40.w,
                  child: NetImageTool(
                    url: user?.thumb ?? "",
                    radius: BorderRadius.all(Radius.circular(15.w)),
                  ),
                )
                    : GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Utils.unFocusNode(context);
                    onSelectPicComplete?.call();
                  },
                  child: LocalPNG(
                      name: "hlw_mine_head",
                      width: 40.w,
                      height: 40.w),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      focusNode: focusNode,
                      controller: controller,
                      style: StyleTheme.font_white_255_20,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        prefix: childPrefix,
                        hintText: hintText,
                        hintStyle: StyleTheme.font_gray_153_20,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: const OutlineInputBorder(
                          gapPadding: 0,
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                      ),
                      minLines: 1,
                      maxLines: 2,
                      onTap: () {},
                      onSubmitted: (_) {},
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Utils.unFocusNode(context);
                    onEditingCompleteText?.call(controller.text);
                    controller.text = "";
                  },
                  child: Container(
                    width: 70.w,
                    height: 40.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: StyleTheme.white10,
                      borderRadius: BorderRadius.circular((20.w)),
                    ),
                    child: Text(
                      '发送',
                      style: StyleTheme.font_gray_153_20,
                    ),
                  ),
                ),
                // onCollectEventComplete == null
                //     ? GestureDetector(
                //         behavior: HitTestBehavior.translucent,
                //         onTap: () {
                //           Utils.unFocusNode(context);
                //           onEditingCompleteText?.call(controller.text);
                //           controller.text = "";
                //         },
                //         child:
                //         LocalPNG(
                //           name: "51_mine_send",
                //           width: 23.w,
                //           height: 22.w,
                //         ),
                //       )
                //     :
                // SizedBox(
                //         width: 70.w,
                //         height: 40.w,
                //         child: Row(
                //           children: [
                //             GestureDetector(
                //               behavior: HitTestBehavior.translucent,
                //               onTap: () {
                //                 Utils.unFocusNode(context);
                //                 onCollectEventComplete?.call();
                //               },
                //               child: LocalPNG(
                //                 name: isCollect ? "51_collect_h" : "51_collect_n",
                //                 width: 26.w,
                //                 height: 26.w,
                //               ),
                //             ),
                //             SizedBox(width: 20.w),
                //             GestureDetector(
                //               behavior: HitTestBehavior.translucent,
                //               onTap: () {
                //                 Utils.unFocusNode(context);
                //                 onEditingCompleteText?.call(controller.text);
                //                 controller.text = "";
                //               },
                //               child: LocalPNG(
                //                 name: "51_mine_send",
                //                 width: 23.w,
                //                 height: 22.w,
                //               ),
                //             ),
                //             SizedBox(width: 1.w),
                //           ],
                //         ),
                //       ),
              ],
            ),
          )
        ],
      ),
    );
  }
}