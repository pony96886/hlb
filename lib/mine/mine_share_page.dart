import 'dart:io';

import 'package:hlw/base/base_store.dart';
import 'package:hlw/base/base_widget.dart';
import 'package:hlw/model/config_model.dart';
import 'package:hlw/model/user_model.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MineSharePage extends BaseWidget {
  MineSharePage({Key? key}) : super(key: key);

  @override
  _MineSharePageState cState() => _MineSharePageState();
}

class _MineSharePageState extends BaseWidgetState<MineSharePage> {
  GlobalKey rootWidgetKey = GlobalKey();
  bool isSaving = false;

  UserModel? member;
  int userInviteNumber = 0; // 用户邀请数量

  _saveImgShare() async {
    if (kIsWeb || Utils.isPC) {
      Utils.showText(Utils.txt('zxjt'));
      isSaving = false;
      setState(() {});
    } else if (Platform.isAndroid || Platform.isIOS) {
      PermissionStatus storageStatus = await Permission.camera.status;
      if (storageStatus == PermissionStatus.denied) {
        storageStatus = await Permission.camera.request();
        if (storageStatus == PermissionStatus.denied ||
            storageStatus == PermissionStatus.permanentlyDenied) {
          Utils.showText(Utils.txt('qdkqx'));
          isSaving = false;
          setState(() {});
        } else {
          localStorageImage();
        }
        return;
      } else if (storageStatus == PermissionStatus.permanentlyDenied) {
        Utils.showText(Utils.txt('wfbc'));
        isSaving = false;
        setState(() {});
        return;
      }
      localStorageImage();
    }
  }

  localStorageImage() async {
    RenderRepaintBoundary boundary = rootWidgetKey.currentContext
        ?.findRenderObject() as RenderRepaintBoundary;

    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    final result = await ImageGallerySaver.saveImage(pngBytes); //这个是核心的保存图片的插件
    if (result['isSuccess']) {
      Utils.showText(
        Utils.txt('xxcgwd'),
      );
    } else if (Platform.isAndroid) {
      if (result.length > 0) {
        Utils.showText(Utils.txt('xxcgwd'));
      }
    }
    isSaving = false;
    setState(() {});
  }

  @override
  Widget appbar() {
    // TODO: implement appbar
    return Container();
  }

  @override
  void onCreate() {
    // TODO: implement initState
    member = Provider.of<BaseStore>(context, listen: false).user;
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  //复制链接分享
  void _copyLinkShare() {
    Clipboard.setData(ClipboardData(text: '${member?.share?.share_text}'));
    Utils.showText(Utils.txt('fzcg'));
  }

  List textsWithMiddleKey({String text = '', String key = ''}) {
    var results = text.split(key);
    List list = [];
    for (var i = 0; i < results.length; i++) {
      list.add({'type': 0, 'word': results[i]});
      if (i != results.length - 1) {
        list.add({'type': 1, 'word': key});
      }
    }
    return list;
  }

  List textsWithList(List inputList, String key) {
    List list = [];
    for (var item in inputList) {
      if (item['type'] == 1) {
        list.add(item);
      } else {
        list.addAll(textsWithMiddleKey(text: item['word'], key: key));
      }
    }
    return list;
  }

  @override
  Widget pageBody(BuildContext context) {
    ConfigModel? config = Provider.of<BaseStore>(context, listen: false).config;

    return Stack(
      children: [
        Positioned(
          child: Center(
            child: Container(
              color: Colors.transparent,
              width: 375.w,
              height: 667.w,
              child: RepaintBoundary(
                key: rootWidgetKey,
                child: Stack(
                  children: [
                    Positioned.fill(
                      // top: 0
                      child: LocalPNG(
                        name: '51_mine_share_pic_bg',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                        left: 20.w,
                        top: 13.w,
                        child: LocalPNG(
                          name: '51_mine_share_logo',
                          width: 170.w,
                          height: 54.w,
                        )),
                    Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 190.w,
                            ),
                            Container(
                              width: 315.w,
                              height: 369.w,
                              // padding: EdgeInsets.symmetric(horizontal: 20.w),
                              // color: Colors.red,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                      child: LocalPNG(
                                          name: '51_mine_share_code_bg_1')),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 106.w,
                                      ),
                                      Container(
                                        width: 183.w,
                                        height: 183.w,
                                        // padding: EdgeInsets.all(10.w),
                                        decoration: BoxDecoration(
                                            color: Colors.white
                                                .withAlpha((0.2 * 255).toInt()),
                                            borderRadius: BorderRadius.all(
                                                ui.Radius.circular(10.w))),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                                child: LocalPNG(
                                                    // width: 183.w,
                                                    // height: 183.w,
                                                    name:
                                                        '51_mine_share_pic_code_frame')),
                                            Positioned.fill(
                                              child: Container(
                                                alignment: Alignment.center,
                                                // color: Colors.white,
                                                child: QrImage(
                                                  data:
                                                      '${member?.share?.share_url}',
                                                  version: 3,
                                                  size: 160.w,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 60.w,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              Utils.txt('apwd') +
                                                  Utils.txt('tgm'),
                                              style:
                                                  StyleTheme.font_black_31_20,
                                            ),
                                            Text(
                                              member?.share?.aff_code as String,
                                              style: StyleTheme.font_red_246_25,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 104.w,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 2.w),
                                  Text(
                                    Utils.txt('gwdz') +
                                        '：${config?.office_site}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        decoration: TextDecoration.none,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.normal),
                                    textAlign: ui.TextAlign.center,
                                  ),
                                  SizedBox(height: 11.w),
                                  RichText(
                                      maxLines: 3,
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: Utils.txt('qwsy1'),
                                            style: StyleTheme.font_red_246_13),
                                        TextSpan(
                                            text: Utils.txt('qwsy2'),
                                            style: StyleTheme.font_black_31_13),
                                        TextSpan(
                                            text: Utils.txt('qwsy3'),
                                            style: StyleTheme.font_red_246_13),
                                        TextSpan(
                                            text: Utils.txt('qwsy4'),
                                            style: StyleTheme.font_black_31_13),
                                        TextSpan(
                                            text: Utils.txt('qwsy5'),
                                            style: StyleTheme.font_red_246_13),
                                        TextSpan(
                                            text: Utils.txt('qwsy6'),
                                            style: StyleTheme.font_black_31_13),
                                      ])),
                                  // Text(
                                  //   Utils.txt('qwsy'),
                                  //   style: StyleTheme.font_black_31_13,
                                  //   maxLines: 3,
                                  // ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: true,
          child: Stack(
            children: [
              Positioned(
                  child: Container(
                width: ScreenWidth,
                height: ScreenHeight,
                color: StyleTheme.bgColor,
              )),
              Positioned(
                  child: LocalPNG(
                name: '51_mine_share_up_bg',
                width: ScreenWidth,
                height: ScreenHeight,
              )),
              Positioned.fill(
                // top: 0,
                // left: 0,
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: StyleTheme.singleMargin),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: StyleTheme.navHegiht +
                                StyleTheme.topHeight +
                                27.w),
                        LocalPNG(
                          name: '51_mine_share_up_title',
                          width: 259.w,
                          height: 39.w,
                          // height: 667.w,
                        ),
                        SizedBox(height: 14.w),
                        Text(Utils.txt('jzcg'),
                            style: StyleTheme.font_black_31_15),
                        SizedBox(height: 20.w),
                        SizedBox(
                          width: 315.w,
                          height: 350.w,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                  child: LocalPNG(
                                name: '51_mine_share_code_background',
                              )),
                              Positioned.fill(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 80.w,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            Utils.txt('apwd') +
                                                Utils.txt('tgm'),
                                            style: StyleTheme.font_black_31_16,
                                          ),
                                          Text(
                                            member?.share?.aff_code as String,
                                            style: StyleTheme.font_red_246_25,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Container(
                                          width: 183.w,
                                          height: 183.w,
                                          // padding: EdgeInsets.all(10.w),
                                          child: Stack(
                                            children: [
                                              Positioned.fill(
                                                  child: LocalPNG(
                                                      // width: 183.w,
                                                      // height: 183.w,
                                                      name:
                                                          '51_mine_share_code_frame')),
                                              Container(
                                                alignment: Alignment.center,
                                                child: QrImage(
                                                  data:
                                                      '${member?.share?.share_url}',
                                                  version: 3,
                                                  size: 160.w,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 34.w),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ActionShareButton(
                                  text: Utils.txt('bctp'),
                                  onTap: isSaving
                                      ? null
                                      : () {
                                          isSaving = true;
                                          setState(() {});
                                          SchedulerBinding.instance
                                              .addPostFrameCallback((_) {
                                            _saveImgShare();
                                          });
                                        },
                                  isLoadding: isSaving,
                                ),
                                SizedBox(height: 10.w),
                                ActionShareButton(
                                  text: Utils.txt('fzlj'),
                                  onTap: _copyLinkShare,
                                  isLoadding: false,
                                  image: null,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30.w),
                        Text(
                          Utils.txt('yqbz'),
                          style: StyleTheme.font_black_31_24,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.w),
                          child: LocalPNG(
                            name: '51_mine_share_arrow_down',
                            width: 34.w,
                            height: 21.w,
                          ),
                        ),
                        LocalPNG(
                          name: '51_mine_share_progress',
                          width: 292.5.w,
                          height: 357.w,
                        ),
                      ]),
                ),
              ),
              Container(
                color: Colors.transparent,
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: StyleTheme.margin),
                  height: StyleTheme.navHegiht,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: SizedBox(
                            height: double.infinity,
                            child: LocalPNG(
                              name: "51_nav_back",
                              width: 17.w,
                              height: 17.w,
                              fit: BoxFit.contain,
                            )),
                        onTap: () {
                          finish();
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class ActionShareButton extends StatelessWidget {
  final String? text;
  final GestureTapCallback? onTap;
  final bool isLoadding;
  final AssetImage? image;
  const ActionShareButton(
      {Key? key,
      this.text = '',
      required this.onTap,
      required this.isLoadding,
      this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 165.w,
        height: 38.w,
        decoration: image == null
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(19.w),
                color: StyleTheme.red245Color)
            : BoxDecoration(image: DecorationImage(image: image!)),
        child: Center(
          child: isLoadding
              ? SizedBox(
                  width: 23.w,
                  height: 23.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ))
              : Text(
                  text!,
                  style: StyleTheme.font_white_255_16,
                ),
        ),
      ),
    );
  }
}
