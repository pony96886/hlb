import 'dart:io';
import 'package:app_install/api_generated.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/netimage_tool.dart';
import 'package:hlw/util/network_http.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:path_provider/path_provider.dart';

import '../model/general_ads_model.dart';

double _alertWidth = 305.w;

class UpdateSysAlert {
  //弹窗AD
  static void showAvtivetysAlert({
    VoidCallback? cancel,
    VoidCallback? confirm,
    GeneralAdsModel? ad,
  }) {
    BotToast.showWidget(
      toastBuilder: (cancelFunc) => GestureDetector(
        onTap: () {
          cancelFunc();
          cancel?.call();
        },
        child: Container(
          constraints: BoxConstraints(
            maxHeight: ScreenHeight,
          ),
          width: ScreenWidth,
          decoration: const BoxDecoration(color: Colors.black38),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    cancelFunc();
                    confirm?.call();
                  },
                  child: SizedBox(
                    // width: (ad?.show_width ?? 305).w,
                    // height: (ad?.show_height ?? 340).w,
                    width: (ad?.show_width ?? 305).w * 1.35,
                    height: (ad?.show_height ?? 340).w * 1.35,
                    child: NetImageTool(url: ad?.thumb ?? ""),
                  ),
                ),
                SizedBox(height: 20.w),
                GestureDetector(
                  onTap: () {
                    cancelFunc();
                    cancel?.call();
                  },
                  child: SizedBox(
                    width: 35.w,
                    height: 35.w,
                    child: const LocalPNG(name: "51_alert_close"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //系统公告
  static void showAnnounceAlert({
    VoidCallback? cancel,
    VoidCallback? confirm,
    String? text,
  }) {
    var tips = text?.split('#');
    BotToast.showWidget(
      toastBuilder: (cancelFunc) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              cancelFunc();
              cancel?.call();
            },
            child: Container(
              decoration: const BoxDecoration(color: Colors.black38),
            ),
          ),
          Positioned(
            child: Center(
              child: Stack(
                children: [
                  SizedBox(
                    width: _alertWidth,
                    height: 430.w,
                    child: Stack(
                      children: [
                        LocalPNG(
                          name: '51_system_notice',
                          width: _alertWidth,
                          height: _alertWidth / 305 * 112,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: _alertWidth / 305 * 112 - 2.w),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(15.w),
                                  bottomLeft: Radius.circular(15.w))),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 20.w),
                              Expanded(
                                child: SingleChildScrollView(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: tips?.map((e) {
                                            return Utils.getContentSpan(e);
                                          }).toList() ??
                                          [],
                                    )),
                              ),
                              SizedBox(height: 15.w),
                              Container(
                                padding: EdgeInsets.only(
                                  left: StyleTheme.margin,
                                  right: StyleTheme.margin,
                                  bottom: 15.w,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        cancelFunc();
                                        confirm?.call();
                                      },
                                      child: Container(
                                        width: 110.w,
                                        height: 36.w,
                                        decoration: BoxDecoration(
                                          color: StyleTheme.red245Color,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(18.w)),
                                        ),
                                        child: Center(
                                            child: RichText(
                                                text: TextSpan(children: [
                                          TextSpan(
                                            text: Utils.txt('quren'),
                                            style: StyleTheme.font(size: 13),
                                          ),
                                        ]))),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 版本更新
  static void showUpdateAlert({
    VoidCallback? cancel,
    VoidCallback? confirm,
    VoidCallback? site,
    VoidCallback? guide,
    String? version,
    String? text,
    bool mustupdate = false,
  }) {
    var tips = text?.split('#');
    BotToast.showWidget(
      toastBuilder: (cancelFunc) => Stack(children: [
        Container(
          decoration: const BoxDecoration(color: Colors.black38),
        ),
        Center(
          child: SizedBox(
            width: _alertWidth,
            height: 440.w,
            child: Stack(children: [
              Container(
                margin: EdgeInsets.only(top: _alertWidth / 305 * 144 - 20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15.w),
                    bottomLeft: Radius.circular(15.w),
                  ),
                ),
              ),
              LocalPNG(
                name: '51_update_up_bg',
                width: _alertWidth,
                height: _alertWidth / 305 * 144,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: _alertWidth / 305 * 144 - 20.w),
                  Center(
                    child: Text(
                      Utils.txt('fxxbb'),
                      style: StyleTheme.font_black_31_18,
                    ),
                  ),
                  SizedBox(height: 15.w),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: tips?.map((e) {
                              return Utils.getContentSpan(e);
                            }).toList() ??
                            [],
                      ),
                    ),
                  ),
                  SizedBox(height: 5.w),
                  Container(
                    padding: EdgeInsets.only(
                      left: StyleTheme.margin,
                      right: StyleTheme.margin,
                    ),
                    child: Column(children: [
                      Platform.isAndroid
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: StyleTheme.margin / 2),
                              child: Material(
                                color: Colors.transparent,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    guide?.call();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        Utils.txt("bbtl"),
                                        style: StyleTheme.font_gray_102_14,
                                      ),
                                      Text(
                                        Utils.txt("gxqbkzn"),
                                        style: StyleTheme.font(
                                          size: 14,
                                          color: const Color(0xFF5ABBF9),
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            mustupdate
                                ? Container()
                                : GestureDetector(
                                    onTap: () {
                                      if (mustupdate) return;
                                      cancelFunc();
                                      cancel?.call();
                                    },
                                    child: Container(
                                      width: 110.w,
                                      height: 36.w,
                                      decoration: BoxDecoration(
                                        color: StyleTheme.gray204Color,
                                        borderRadius:
                                            BorderRadius.circular(18.w),
                                      ),
                                      child: Center(
                                        child: RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                              text: Utils.txt('zbgx'),
                                              style: StyleTheme.font(size: 13),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ),
                                  ),
                            mustupdate ? Container() : const Spacer(),
                            GestureDetector(
                              onTap: () {
                                if (!mustupdate) {
                                  cancelFunc();
                                } else if (mustupdate && Platform.isAndroid) {
                                  cancelFunc();
                                } else if (mustupdate && Utils.isPC) {
                                  cancelFunc();
                                }
                                confirm?.call();
                              },
                              child: Container(
                                width: 110.w,
                                height: 36.w,
                                padding: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                    color: StyleTheme.red245Color,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(18.w))),
                                alignment: Alignment.center,
                                child: Center(
                                    child: RichText(
                                        text: TextSpan(children: [
                                  TextSpan(
                                    text: Utils.txt('ljgx'),
                                    style: StyleTheme.font(size: 13),
                                  )
                                ]))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 15.w),
                        child: GestureDetector(
                          onTap: () => site?.call(),
                          child: Center(
                            child: Text(
                              Utils.txt('gwgx'),
                              style: StyleTheme.font(
                                size: 15,
                                color: const Color(0xFF5ABBF9),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  static void androidUpdateAlert({
    VoidCallback? cancel,
    String? url = "",
    String? version,
  }) {
    BotToast.showWidget(
      toastBuilder: (cancelFunc) => _DownLoadApk(
        url: url,
        version: version,
        onTap: () {
          cancelFunc();
          cancel?.call();
        },
      ),
    );
  }
}

class _DownLoadApk extends StatefulWidget {
  const _DownLoadApk({
    Key? key,
    this.onTap,
    this.url,
    this.version,
  }) : super(key: key);

  final GestureTapCallback? onTap;
  final String? url;
  final String? version;

  @override
  __DownloadApkState createState() => __DownloadApkState();
}

class __DownloadApkState extends State<_DownLoadApk> {
  int progress = 0;

  Future<void> _installApp(savePath) async {
    try {
      await Utils.checkRequestInstallPackages();
      await Utils.checkStoragePermission();
      AppInstaller().install(savePath).then((result) {}).catchError((error) {});
    } on Exception catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    getExternalStorageDirectory().then((documents) {
      String savePath =
          '${documents?.path}/hlwk.${DateTime.now().millisecondsSinceEpoch}.apk';
      NetworkHttp.download(widget.url ?? "", savePath,
          onReceiveProgress: (int count, int total) {
        var tmp = (count / total * 100).toInt();
        if (tmp % 1 == 0) {
          setState(() {
            progress = tmp;
          });
        }
        if (count >= total) {
          _installApp(savePath);
        }
      }).catchError((err) {
        BotToast.cleanAll();
        Utils.showText(Utils.txt('xzsb'));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Stack(
        children: [
          Positioned(
              child: Center(
            child: SizedBox(
              width: 345.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10.w))),
                    padding:
                        EdgeInsets.symmetric(vertical: 15.w, horizontal: 20.w),
                    child: Column(
                      children: [
                        Text(
                          Utils.txt('zzgx') + " V${widget.version}",
                          style: StyleTheme.font_black_31_18,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 10.w,
                        ),
                        Text(
                          Utils.txt('sjlts'),
                          style: StyleTheme.font_gray_102_12,
                          textAlign: TextAlign.left,
                          maxLines: 5,
                        ),
                        SizedBox(
                          height: 25.w,
                        ),
                        SizedBox(
                          width: 185.w,
                          height: 4.w,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2.w)),
                                child: Stack(
                                  children: <Widget>[
                                    Opacity(
                                      opacity: 0.3,
                                      child: Container(
                                        width: 185.w,
                                        height: 4.w,
                                        decoration: BoxDecoration(
                                          color: StyleTheme.red245Color,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4.w)),
                                        child: Container(
                                          width: progress / 100 * 185.w,
                                          height: 4.w,
                                          decoration: BoxDecoration(
                                            color: StyleTheme.red245Color,
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
                        SizedBox(
                          height: 12.w,
                        ),
                        Center(
                          child: Text(
                            '$progress%',
                            style: StyleTheme.font_red_245_14,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
