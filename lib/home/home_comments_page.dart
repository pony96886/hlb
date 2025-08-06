import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';

class HomeCommentsPage extends StatefulWidget {
  const HomeCommentsPage({
    Key? key,
    this.data,
    this.isSecond = false,
    this.replyCall,
    this.resetCall,
  }) : super(key: key);
  final dynamic data;
  final bool isSecond;
  final Function(List<String> tip, String commid)? replyCall;
  final Function()? resetCall;

  @override
  State createState() => _HomeCommentsPageState();
}

class _HomeCommentsPageState extends State<HomeCommentsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15.w),
        _buildRootCommentWidget(),
        SizedBox(height: 13.w),
        PostChildrenCommentWidget(
          data: widget.data['comments'], // {}
        ),
        SizedBox(height: 15.w),
      ],
    );
  }

  Widget _buildRootCommentWidget() {
    if (widget.data is! Map) return const SizedBox();
    return _RootCommentWidget(
    data: widget.data,
    reply: () {
      final List<String> list = [
        Utils.txt("hf"),
        "@${widget.data["reply_nickname"] ?? ""}："
      ];
      if (Utils.unFocusNode(context)) {
        widget.replyCall?.call(list, widget.data["id"].toString());
      } else {
        widget.replyCall?.call([], "");
      }
    });
  }
}

class _RootCommentWidget extends StatelessWidget {
  final dynamic data;
  final Function() reply;
  const _RootCommentWidget({Key? key, required this.data, required this.reply})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          textAlign: TextAlign.left,
          TextSpan(children: [
            TextSpan(
              text: '${data["reply_nickname"]}：',
              style: StyleTheme.font_black_34_16_medium,
            ),
            TextSpan(
              text: data["content"] != null
                  ? Utils.convertEmojiAndHtml(data["content"])
                  : "",
              style: StyleTheme.font_gray_153_16,
            ),
          ]),
          maxLines: 100,
        ),
        SizedBox(height: 5.w),
        Row(children: [
          Expanded(
            child: Text(
              data["gap_str"] ?? "",
              style: StyleTheme.font_gray_153_14,
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: reply,
            child: Row(children: [
              LocalPNG(
                name: "hlw_reply_n",
                width: 18.w,
                height: 18.w,
              ),
              SizedBox(width: 5.w),
              Text(
                Utils.txt("hf"),
                style: StyleTheme.font_gray_153_14,
              )
            ]),
          ),
        ]),
      ],
    );
  }
}

class PostChildrenCommentWidget extends StatefulWidget {
  final dynamic data;
  const PostChildrenCommentWidget({super.key, this.data});

  @override
  State createState() => _PostChildrenCommentWidgetState();
}

class _PostChildrenCommentWidgetState extends State<PostChildrenCommentWidget> {
  bool isAll = false; // 显示所有评论
  int max = 5;
  List<dynamic> _comments = [];
  List<dynamic> _tcoments = [];

  @override
  void initState() {
    super.initState();
    _toDealWithDataAction();
  }

  @override
  void didUpdateWidget(covariant PostChildrenCommentWidget oldWidget) {
    _toDealWithDataAction();
    super.didUpdateWidget(oldWidget);
  }

  void _toDealWithDataAction() {
    if (widget.data is! Map) return;
    _comments = widget.data["list"] is! List
        ? []
        : List.from(widget.data["list"] ?? []);
    // 回复超过5条就显示更多评论
    _tcoments = _comments.length > max
        ? List.from(_comments.sublist(0, max))
        : List.from(_comments);
  }

  @override
  Widget build(BuildContext context) {
    if (_comments.isEmpty) return const SizedBox();

    Widget current = ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: isAll ? _comments.length : _tcoments.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: _buildItemBuilder,
    );

    return Container(
      margin: EdgeInsets.fromLTRB(0, 10.w, 0, 0),
      padding: EdgeInsets.fromLTRB(10.w, 5.w, 10.w, 5.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.w),
        color: StyleTheme.gray247Color,
      ),
      width: double.infinity,
      child: current,
    );
  }

  Widget _buildItemBuilder(BuildContext context, int index) {
    dynamic obj = isAll ? _comments[index] : _tcoments[index];
    if (obj is! Map) return const SizedBox();
    return _ItemWidget(
      obj: obj, index: index, max: max, isAll: isAll, tComments: _tcoments, comments: _comments,
      tapReplay: () => setState(() => isAll = true),
    );
  }

}

class _ItemWidget extends StatelessWidget {
  final dynamic obj;
  final int index, max;
  final bool isAll;
  final List tComments, comments;
  final Function() tapReplay;
  const _ItemWidget({Key? key, required this.obj, required this.index, required this.max, required this.isAll, required this.tComments, required this.comments,
    required this.tapReplay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15.w),
        Text.rich(TextSpan(children: [
          WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: _AuthorWidget(obj: obj)),
          TextSpan(
              text: "${obj["reply_nickname"] ?? ""}",
              style: StyleTheme.font_black_34_16_medium),
          WidgetSpan(child: SizedBox(width: 10.w)),
          TextSpan(
              text: obj["gap_str"] ?? "", style: StyleTheme.font_gray_153_14),
        ])),
        SizedBox(height: 6.w),
        Text(
          obj["content"] != null
              ? Utils.convertEmojiAndHtml(obj["content"])
              : "",
          style: StyleTheme.font_gray_153_15,
          maxLines: 100,
        ),
        _MoreReplyWidget(isAll: isAll, index: index, max: max, tComments: tComments, comments: comments, tap: tapReplay),
        SizedBox(height: 15.w),
      ],
    );
  }
}

class _AuthorWidget extends StatelessWidget {
  final dynamic obj;
  const _AuthorWidget({Key? key, required this.obj})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (obj['is_owner'] != 1) return const SizedBox();
    return Container(
      margin: EdgeInsets.only(right: 3.w),
      height: 18.w,
      width: 40.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [StyleTheme.red245Color, StyleTheme.red245Color],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(8.w)),
      ),
      child: Center(
        child: Text('楼主', style: StyleTheme.font_black_34_13),
      ),
    );
  }
}

class _MoreReplyWidget extends StatelessWidget {
  final bool isAll;
  final int index, max;
  final List tComments, comments;
  final Function() tap;
  const _MoreReplyWidget({Key? key, required this.isAll, required this.index, required this.max, required this.tComments, required this.comments, required this.tap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isAll) return const SizedBox(); // 过滤下面判断零界点
    if (index != tComments.length - 1 || comments.length <= max) {
      return const SizedBox();
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: tap,
      child: Padding(
        padding: EdgeInsets.only(top: 15.w),
        child: Container(
          height: 44.w,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(230, 230, 230, 1.0),
            borderRadius: BorderRadius.all(Radius.circular(10.w)),
          ),
          child: Center(
            child: Text(
              '查看全部${comments.length}条回复评论',
              style: StyleTheme.font_black_31_14,
            ),
          ),
        ),
      ),
    );
  }
}