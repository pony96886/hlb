import 'package:hlw/base/base_store.dart';
import 'package:hlw/model/user_model.dart';
import 'package:hlw/util/eventbus_class.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:provider/provider.dart';

class RightModuleUI extends StatefulWidget {
  const RightModuleUI({Key? key, this.bgColor = Colors.white}) : super(key: key);
  final Color bgColor;
  // const Color.fromRGBO(247, 248, 249, 1)

  @override
  State<RightModuleUI> createState() => _RightModuleUIState();
}

class _RightModuleUIState extends State<RightModuleUI> {
  late StateSetter _reloadTextSetter;
  List dataList = [];
  bool isHud = true;

  var discrip;

  void getData() {
    // reqContactList().then((value) {
    //   if (value?.status == 1) {
    //     dataList = value?.data?["office_contact"]["data"];
    //   } else {
    //     Utils.showText(value?.msg ?? "");
    //   }
    //   isHud = false;
    //   setState(() {});
    // });
  }

  @override
  void initState() {
    super.initState();
    discrip = UtilEventbus().on<EventbusClass>().listen((event) {
      if (event.arg["name"] == 'rightBanner') {
        _reloadTextSetter(() {});
      }
    });
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      _reloadTextSetter = stateSetter;
      UserModel? user = Provider.of<BaseStore>(context, listen: false).user;
      return Container(
          width: StyleTheme.rightWidth,
          height: ScreenHeight,
          color: widget.bgColor,
          padding: EdgeInsets.symmetric(horizontal: StyleTheme.margin),
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                SizedBox(height: ScreenHeight * 0.046875),
                //投稿
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (user?.username?.isEmpty == true) {
                      Utils.showDialog(
                        cancelTxt: Utils.txt('quxao'),
                        confirmTxt: Utils.txt('quren'),
                        setContent: () {
                          return RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: Utils.txt('zcyhcz'),
                                style: StyleTheme.font_gray_153_12),
                          ]));
                        },
                        confirm: () {
                          Utils.navTo(context, "/mineloginpage");
                        },
                      );
                      return;
                    }
                    if (user?.create_content?.allow == 1) {
                      Utils.navTo(context, '/homeeditorpage');
                    } else {
                      Utils.showText(user?.create_content?.msg ?? '', time: 2);
                    }
                  },
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Utils.txt('tgzq'),
                            style: StyleTheme.font_black_31_12_medium),
                        SizedBox(height: 5.w),
                        Container(
                          height: 115.w,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3.w)),
                              border: Border.all(
                                  color:
                                      const Color.fromRGBO(201, 202, 208, 1))),
                        ),
                        SizedBox(height: 8.w),
                        Row(
                          children: [
                            Row(
                              children: [
                                LocalPNG(
                                    name: "51_mine_imgpicker",
                                    width: 19.w,
                                    height: 16.w),
                                SizedBox(width: 3.w),
                                Text(Utils.txt('tp'),
                                    style: StyleTheme.font_black_31_10)
                              ],
                            ),
                            SizedBox(width: 13.w),
                            Row(
                              children: [
                                LocalPNG(
                                    name: "51_mine_videopicker",
                                    width: 19.w,
                                    height: 16.w),
                                SizedBox(width: 3.w),
                                Text(Utils.txt('sping'),
                                    style: StyleTheme.font_black_31_10)
                              ],
                            ),
                            const Spacer(),
                            Container(
                              width: 55.w,
                              height: 21.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: StyleTheme.red246Color,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3.w))),
                              child: Text(
                                Utils.txt('fb'),
                                style: StyleTheme.font(
                                    size: 10, weight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                      ]),
                ),
                SizedBox(height: 20.w),
                // AppGlobal.banners.isEmpty
                //     ? SizedBox(height: 20.w)
                //     : Padding(
                //         padding: EdgeInsets.only(top: 20.w),
                //         child: Utils.bannerSwiper(
                //             width:
                //                 StyleTheme.rightWidth - StyleTheme.margin * 2,
                //             whRate: 150 / 350,
                //             data: AppGlobal.banners,
                //             radius: 3.w),
                //       ),
                isHud
                    ? Container()
                    : dataList.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: dataList.asMap().keys.map((index) {
                              dynamic e = dataList[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${e['name']}',
                                    style: StyleTheme.font_black_31_12_medium,
                                  ),
                                  SizedBox(height: 5.w),
                                  Text(
                                    '${e['decs']}',
                                    style: StyleTheme.font_black_31_10,
                                  ),
                                  SizedBox(height: 7.w),
                                  Container(
                                    padding: EdgeInsets.all(10.w),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(3.w),
                                        color: Colors.white,
                                        shape: BoxShape.rectangle,
                                        boxShadow: [
                                          BoxShadow(
                                              color: StyleTheme.gray230Color,
                                              offset: const Offset(0, 0),
                                              blurStyle: BlurStyle.normal,
                                              spreadRadius: 1.w,
                                              blurRadius: 1.w),
                                        ]),
                                    child: Builder(builder: (cx) {
                                      List tps = List.from(e['list']);
                                      return Column(
                                        children: tps.asMap().keys.map((x) {
                                          dynamic e = tps[x];
                                          return GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () {
                                              Utils.openURL(e['url']);
                                            },
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 36.w,
                                                  child: Row(
                                                    children: [
                                                      LocalPNG(
                                                        name: e['type'] ==
                                                                'Telegram'
                                                            ? '51_mine_tg'
                                                            : '51_mine_potato',
                                                        width: 36.w,
                                                        height: 36.w,
                                                      ),
                                                      SizedBox(width: 10.w),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text('${e['name']}',
                                                                style: StyleTheme
                                                                    .font_black_31_12_medium),
                                                            SizedBox(
                                                                height: 2.w),
                                                            Text('${e['decs']}',
                                                                style: StyleTheme
                                                                    .font_gray_153_10),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: 10.w),
                                                      Container(
                                                        width: 60.w,
                                                        height: 21.w,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: StyleTheme
                                                              .red246Color,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      12.5.w)),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          Utils.txt('ljjr'),
                                                          style: StyleTheme.font(
                                                              size: 10,
                                                              weight: FontWeight
                                                                  .w600),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: tps.length - 1 == x
                                                        ? 0
                                                        : 10.w)
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    }),
                                  ),
                                  SizedBox(height: 20.w)
                                ],
                              );
                            }).toList())
                        : LoadStatus.noData()
              ])));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    discrip.cancel();
    super.dispose();
  }
}
