import 'package:hlw/base/base_store.dart';
import 'package:hlw/base/request_api.dart';
import 'package:hlw/model/user_model.dart';
import 'package:hlw/util/easy_pull_refresh.dart';
import 'package:hlw/util/eventbus_class.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/netimage_tool.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:provider/provider.dart';

class MinePage extends StatelessWidget {
  MinePage({Key? key, this.isShow = false}) : super(key: key);
  final bool isShow;

  @override
  Widget build(BuildContext context) {
    return _MinePage(isShow: isShow);
  }
}

class _MinePage extends StatefulWidget {
  const _MinePage({Key? key, this.isShow = false}) : super(key: key);
  final bool isShow;

  @override
  State<_MinePage> createState() => __MinePageState();
}

class __MinePageState extends State<_MinePage> {
  List<Map> guaFuncList = [
    {
      'name': 'wanted'

      // "route": "/minesharepage",
    },
    {
      'name': 'post'

      // "route": "/minesigninpage",
    },
  ];
  List<Map> footerList = [
    {
      "icon": "51_mine_collect",
      "title": Utils.txt('wdsc'),
      "route": "/minecollectpage",
    },
    {
      "icon": "51_mine_contact",
      "title": Utils.txt('zuxkf'),
      "route": "/mineservicepage",
    },
    {
      "icon": "51_mine_comment",
      "title": Utils.txt('plhf'),
      "route": "/minerepliedcomments_page",
    },
    {
      "icon": "51_mine_problems",
      "title": Utils.txt('chjwt'),
      "route": "/minenorquestionpage",
    },
    {
      "icon": "51_mine_share",
      "title": Utils.txt('fenxag'),
      "route": "/minesharepage",
    },
    {
      "icon": "51_mine_post",
      "title": Utils.txt('wdtg'),
      "route": "/minecontributionpage",
    },
    {
      "icon": "51_mine_income",
      "title": Utils.txt('gfsy'),
      "route": "/minecontributionincomepage",
    },
  ];
  var discrip;
  bool isHud = true;
  bool redShow = false;
  double margin = 80.w;

  Future<bool> getData() {
    //刷新用户信息 + 消息
    return reqUserInfo(context).then((_) {
      return reqSystemNotice(context).then((_) {
        isHud = false;
        setState(() {});
        return true;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    discrip = UtilEventbus().on<EventbusClass>().listen((event) {
      if (event.arg["name"] == 'login') {
        setState(() {});
      } else if (event.arg["name"] == 'logout') {
        setState(() {});
      }
    });

    getData();
  }

  @override
  void didUpdateWidget(covariant _MinePage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.isShow && isHud) {
    } else {}
  }

  //头部数据
  Widget _headWidget() {
    UserModel? tp = Provider.of<BaseStore>(context, listen: false).user;
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: 20.w),
            Padding(
              padding: EdgeInsets.only(left: margin),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Utils.navTo(context, "/minesetpage");
                },
                child: SizedBox(
                  height: 60.w,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: StyleTheme.red246Color,
                              width: 1.w,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(margin))),
                        height: 60.w,
                        width: 60.w,
                        child: SizedBox(
                          height: 59.w,
                          width: 59.w,
                          child: NetImageTool(
                            url: tp?.thumb ?? "",
                            radius: BorderRadius.all(
                              Radius.circular(29.5.w),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tp?.nickname ?? "",
                              style: StyleTheme.font_black_31_20_semi,
                              maxLines: 1,
                            ),
                            SizedBox(height: 8.w),
                            Row(
                              children: [
                                Text(
                                  "ID: ${tp?.uid ?? "0"}",
                                  style: StyleTheme.font_black_31_13,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const Spacer(),
                      tp?.username?.isEmpty == true // || true
                          ? Row(
                              children: [
                                GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      Utils.navTo(context, "/mineloginpage");
                                    },
                                    child: SizedBox(
                                      height: double.infinity,
                                      child: Center(
                                        child: Text(Utils.txt('ljdl'),
                                            style: StyleTheme.font_gray_153_13),
                                      ),
                                    )),
                                SizedBox(
                                  width: 10.w,
                                ),
                              ],
                            )
                          : Container(),
                      LocalPNG(
                        name: '51_mine_arrow',
                        width: 12.w,
                        height: 16.w,
                      ),
                      SizedBox(
                        width: margin,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.w),
            tp?.navigation?.ad_big == null
                ? Container()
                : Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: margin),
                        child: SizedBox(
                          height:
                              (StyleTheme.contentWidth - margin * 2) / 350 * 55,
                          child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                // 此类app用的，PC没用
                                // Utils.openRoute(
                                //     context, tp?.navigation?.ad_big);
                              },
                              child: NetImageTool(
                                url: Utils.getPICURL(tp?.navigation?.ad_big),
                              )),
                        ),
                      ),
                    ],
                  ),
          ],
        )
      ],
    );
  }

  //中部数据
  Widget _centerWidget() {
    UserModel? user = Provider.of<BaseStore>(context, listen: false).user;
    List list = [];
    if (user?.navigation?.ad1 != null) {
      list.add(user?.navigation?.ad2);
    }
    if (user?.navigation?.ad2 != null) {
      list.add(user?.navigation?.ad1);
    }

    return list.isEmpty
        ? Container()
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: margin),
            child: Column(
              children: [
                SizedBox(height: 20.w),
                SizedBox(
                  height: (StyleTheme.contentWidth - margin * 2) / 2 / 175 * 55,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: list
                        .map(
                          (e) => Expanded(
                            child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  // 此类app用的，PC没用
                                  // Utils.openRoute(context, e);
                                },
                                child: NetImageTool(
                                  url: Utils.getPICURL(e),
                                )),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          );
  }

  //尾部数据
  Widget _footerWidget() {
    UserModel? tp = Provider.of<BaseStore>(context, listen: false).user;
    return GridView.builder(
      padding: EdgeInsets.only(
        top: 20.w,
        bottom: 7.w,
        left: margin,
        right: margin,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: footerList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 20.w,
        crossAxisSpacing: 50.w,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        dynamic e = footerList[index];
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Utils.navTo(context, e["route"]);
          },
          child: Stack(children: [
            Column(
              children: [
                LocalPNG(name: e["icon"], width: 32.w, height: 32.w),
                SizedBox(height: 10.w),
                Text(
                  e["title"],
                  style: StyleTheme.font_black_31_14,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: e["icon"] == "51_mine_comment"
                  ? tp?.unread_reply == 0
                      ? Container()
                      : Row(
                          children: [
                            Container(
                              width: 18.w,
                              height: 18.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: StyleTheme.red246Color,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(9.w))),
                              child: Text(
                                  "${(tp?.unread_reply ?? 0) >= 99 ? '99+' : (tp?.unread_reply ?? 0)}",
                                  style: StyleTheme.font(size: 9)),
                            ),
                            SizedBox(width: 5.w)
                          ],
                        )
                  : Container(),
            )
          ]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isHud
        ? LoadStatus.showLoading(mounted)
        : Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: StyleTheme.topHeight),
                  Expanded(
                    child: EasyPullRefresh(
                      onRefresh: () {
                        return getData();
                      },
                      sameChild: SingleChildScrollView(
                        padding: EdgeInsets.zero,
                        child: SizedBox(
                          height: ScreenHeight,
                          child: Column(
                            children: [
                              _headWidget(),
                              Container(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    _centerWidget(),
                                    _footerWidget(),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    discrip.cancel();
    super.dispose();
  }
}
