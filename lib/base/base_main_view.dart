import 'package:hlw/base/request_api.dart';
import 'package:hlw/model/config_model.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:provider/provider.dart';

import '../widget/go_top_widget.dart';
import '../widget/search_bar_widget.dart';
import 'base_store.dart';

class BaseMainView extends StatefulWidget {
  final double paddingTop, paddingBottom, paddingLeft, rightPadding;
  final Widget leftWidget;
  final Widget? dateWidget;
  final List<dynamic>? banners;
  final dynamic dataDetail, dataArticle;
  final String cid, backTitle;
  final bool isBackBtn, showHead;
  const BaseMainView({
    Key? key,
    required this.paddingTop,
    this.paddingBottom = 0.0,
    this.paddingLeft = 60.0,
    this.rightPadding = 0.0,
    required this.leftWidget,
    this.dateWidget,
    this.dataDetail,
    this.dataArticle,
    this.banners,
    this.cid = '',
    this.isBackBtn = false,
    this.showHead = true,
    this.backTitle = '',
  }) : super(key: key);

  @override
  State<BaseMainView> createState() => BaseMainViewState();
}

class BaseMainViewState extends State<BaseMainView> {
  // StreamSubscription? _streamSubscription;
  List banners = [];
  bool bannerHud = true, bannerError = false;

  @override
  void initState() {
    super.initState();
    _getDataBanner();
    // _eventBus();
  }

  _getDataBanner() {
    if (widget.banners?.isEmpty == true || widget.dataDetail == null) {
      reqAds(position_id: 2).then((value) {
        if (value?.data == null) {
          bannerError = true;
          if (mounted) setState(() {});
          return;
        }
        banners = List.from(value?.data["ad_list"]);
        if (mounted) setState(() {});
      });
    } else {
      banners = widget.banners!;
      if (mounted) setState(() {});
    }
  }

  // _eventBus() {
  //   _streamSubscription = UtilEventbus().on<EventbusClass>().listen((event) {
  //     if (event.arg["GoTop"] == 'GoTop' && _scrollController.offset > 0) {
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         if (_scrollController.hasClients) {
  //           _scrollController.animateTo(0,
  //               duration: const Duration(milliseconds: 200),
  //               curve: Curves.easeIn);
  //         }
  //       });
  //     }
  //   });
  // }

  /// banner
  Widget _buildBannerWidget() {
    return Visibility(
      visible: !bannerError || banners.isNotEmpty,
      child: Column(
        children: [
          Utils.bannerScaleExtSwiper(
            data: banners,
            itemWidth: 220.w,
            itemHeight: 75.w,
            radius: 3.w,
          ),
          SizedBox(height: 32.w),
        ],
      ),
    );
  }

  /// 上/下一篇
  Widget _buildArticleWidget() {
    return widget.dataArticle == null
        ? Container()
        : Column(
            key: ValueKey(widget.dataArticle),
            children: [
              _BtnArticleWidget(
                  titleKey: 'sangyp', data: widget.dataArticle['prev_article']),
              SizedBox(height: 10.w),
              _BtnArticleWidget(
                  titleKey: 'xiayp', data: widget.dataArticle['next_article']),
              SizedBox(height: 30.w),
            ],
          );
  }

  /// 日期
  Widget _buildDateWidget() =>
      widget.dateWidget == null ? Container() : widget.dateWidget!;

  void postCollectData() {
    reqCollectContent(cid: widget.cid).then((value) {
      if (value?.status == 1) {
        widget.dataDetail["is_favorite"] =
            widget.dataDetail["is_favorite"] == 0 ? 1 : 0;
        if (mounted) setState(() {});
      } else {
        Utils.showText(value?.msg ?? "");
      }
    });
  }

  @override
  void dispose() {
    // _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ConfigModel? cf =
        Provider.of<BaseStore>(context, listen: false).config;
    final List<Map<String, String>> listMap = widget.dataDetail == null
        ? [
            {
              "title": "商务合作",
              "titleContent": "商务合作/代理合作",
              "subTitle": "Telegram",
              "subContent": "大平台高分成月入十万！",
              "url": "${cf?.client_official_tg}",
            },
            {
              "title": "联系官方审核提现",
              "titleContent": "投稿收益请联系官方",
              "subTitle": "Telegram",
              "subContent": "大平台高收入无限制",
              "url": "${cf?.client_withdraw_tg}",
            }
          ]
        : [
            {
              "title": "官方用户交流社群",
              "titleContent": "一起看片一起分享心得",
              "subTitle": "Telegram",
              "subContent": "马上加入，福利多多！",
              "url": "${cf?.tg_group}",
            }
          ];
    return Stack(
      children: [
        Positioned(
          top: 64.w,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.fromLTRB(widget.paddingLeft.w,
                widget.paddingTop.w - 64.w, 60.w, widget.paddingBottom.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: widget.leftWidget),
                SizedBox(width: 60.w),
                Container(
                  width: 220.w,
                  padding: EdgeInsets.only(top: widget.rightPadding),
                  child: ListView(
                    children: [],
                    //             children: widget.dataDetail == null
                    //                 ? [
                    //                     _buildDateWidget(),
                    //                     _buildBannerWidget(),
                    //                     _LinkWidget(list: listMap),
                    //                   ]
                    //                 : [
                    //                     _buildBannerWidget(),
                    //                     _buildArticleWidget(),
                    //                     _LinkWidget(list: listMap),
                    //                     _RedBagWidget(configModel: cf),
                    //                   ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // child: CustomScrollView(
        //   controller: _scrollController,
        //   slivers: [
        //     SliverToBoxAdapter(
        //       child:
        //     ),
        //   ],
        // ),
        widget.dataDetail == null
            ? Container()
            : Positioned(
                key: ValueKey(widget.dataDetail),
                bottom: 20.w,
                right: 60.w,
                child: const GoTopWidget(),
              ),
        SearchBarWidget(
          isBackBtn: widget.isBackBtn,
          backTitle: widget.backTitle,
          showHead: widget.showHead,
          detailWidget: widget.dataDetail == null
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _BtnDetailWidget(
                        text: '收藏',
                        image: widget.dataDetail == null
                            ? "hlw_collect_n"
                            : widget.dataDetail["is_favorite"] == 0
                                ? "hlw_collect_n"
                                : "hlw_collect_h",
                        textColor: widget.dataDetail == null
                            ? StyleTheme.gray153Color
                            : widget.dataDetail["is_favorite"] == 0
                                ? StyleTheme.gray153Color
                                : StyleTheme.orange255Color,
                        tap: postCollectData),
                    SizedBox(width: 20.w),
                    _BtnDetailWidget(
                      text: Utils.txt('fenxag'),
                      image: "hlw_nav_share_info",
                      textColor: StyleTheme.gray153Color,
                      tap: () => Utils.navTo(context, '/homeinvitefriends'),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _BtnDetailWidget extends StatelessWidget {
  final String text;
  final String image;
  final Color textColor;
  final void Function() tap;
  const _BtnDetailWidget(
      {Key? key,
      required this.text,
      required this.image,
      required this.textColor,
      required this.tap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => tap(),
      child: Row(children: [
        LocalPNG(name: image, width: 20.w, height: 20.w),
        SizedBox(width: 5.w),
        Text(text,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.normal, color: textColor)),
      ]),
    );
  }
}

/// TG鏈接
class _LinkWidget extends StatelessWidget {
  final List<Map<String, String>> list;
  const _LinkWidget({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list
            .map((Map e) =>
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    '${e['title']}',
                    style: StyleTheme.font_black_34_17_medium,
                  ),
                  Text(
                    '${e['titleContent']}',
                    style: StyleTheme.font_gray_153_11,
                  ),
                  SizedBox(height: 10.w),
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: StyleTheme.gray247Color,
                      border: Border.all(
                          color: StyleTheme.gray238Color, width: 1.w),
                      borderRadius: BorderRadius.circular(10.w),
                      shape: BoxShape.rectangle,
                    ),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        final path = Uri.decodeComponent(e['url']);
                        path.isNotEmpty
                            ? Utils.openURL(path)
                            : Utils.showText(Utils.txt('cccwl') + '');
                        // Platform.isMacOS ? Utils.openWebViewMacos(PresentationStyle.sheet, path) : Utils.navTo(context, '/web/$path');
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LocalPNG(
                            name: 'hlw_mine_tg',
                            width: 34.w,
                            height: 34.w,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${e['subTitle']}',
                                    style: StyleTheme.font_black_34_15_medium),
                                SizedBox(height: 5.w),
                                Text('${e['subContent']}',
                                    style: StyleTheme.font_gray_153_11),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30.w),
                ]))
            .toList());
  }
}

/// 上下篇
class _BtnArticleWidget extends StatelessWidget {
  final String titleKey;
  final dynamic data;
  const _BtnArticleWidget(
      {Key? key, required this.titleKey, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// fix crash data['content']
    if (data is! Map) return const SizedBox();
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (data == null || data['id'] == null) return;
        if (Utils.unFocusNode(context)) {
          Utils.navTo(context, "/homecontentdetailpage/${data['id']}");
        }
      },
      child: Container(
        height: 117.w,
        width: double.infinity,
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
            color: StyleTheme.gray245Color,
            borderRadius: BorderRadius.circular(10.w)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Utils.txt(titleKey),
              style: StyleTheme.font_black_34_17,
            ),
            SizedBox(height: 10.w),
            Text(
              data["title"] ?? Utils.txt('zwsj'),
              style: StyleTheme.font_gray_102_12,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}

/// 活动红包
class _RedBagWidget extends StatelessWidget {
  final ConfigModel? configModel;
  const _RedBagWidget({Key? key, required this.configModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (Utils.unFocusNode(context) &&
                configModel?.share != null &&
                configModel?.share != 0) {
              final path = Uri.decodeComponent(
                  Utils.spliceAddress(context, configModel?.share));
              Utils.openURL(path);
              // Platform.isMacOS ? Utils.openWebViewMacos(PresentationStyle.sheet, path) : Utils.navTo(context, '/web/$path');
            }
          },
          child: Container(
            height: 64.w,
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: StyleTheme.gray247Color,
              borderRadius: BorderRadius.circular(10.w),
              shape: BoxShape.rectangle,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LocalPNG(name: "hlw_red_bag", width: 36.w, height: 36.w),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(configModel!.tips_share_text!,
                          style: StyleTheme.font_black_34_15_medium),
                      SizedBox(height: 2.w),
                      Text('点击复制，发给色友即可', style: StyleTheme.font_gray_153_12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
