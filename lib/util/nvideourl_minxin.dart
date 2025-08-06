//通用处理获取URL连接

import 'package:hlw/base/request_api.dart';
import 'package:hlw/util/app_global.dart';
import 'package:hlw/util/encdecrypt.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:video_player/video_player.dart';
import 'package:universal_html/html.dart' as html;
import 'package:hlw/util/shelf_proxy.dart';

mixin NVideoURLMinxin<T extends StatefulWidget> on State<T> {
  //获取播放控制器
  Future<VideoPlayerController>? initController({
    String source240 = "",
    String preview_url = "",
    bool isLocal = false,
    bool isNew = false,
  }) {
    String purl = "";
    if (source240.isNotEmpty) {
      purl = source240;
    } else if (preview_url.isNotEmpty) {
      purl = preview_url;
    }

    if (kIsWeb) {
      if (AppGlobal.m3u8_encrypt == '1') {
        Dio().get(purl).then((res) {
          String decrypted = EncDecrypt.decryptM3U8(res.data);
          final _blob =
              html.Blob([decrypted], 'application/x-mpegURL', 'native');
          final _url = html.Url.createObjectUrl(_blob);
          Utils.log(_url);
          return VideoPlayerController.network(_url);
        });
      } else {
        return Future(() {
          return VideoPlayerController.network(purl);
        });
      }
    } else if (!isLocal) {
      if (AppGlobal.m3u8_encrypt == '1') {
        createServer(purl).then((proxyConfig) {
          String proxyurl =
              purl.replaceAll(proxyConfig['origin'], proxyConfig['localproxy']);
          return VideoPlayerController.network(proxyurl);
        });
      } else {
        return Future(() {
          return VideoPlayerController.network(purl);
        });
      }
    } else {
      // 创建本地播放服务
      createStaticServer(purl).then((url) {
        return VideoPlayerController.network(url);
      });
    }
  }

  Map payIcons = {
    'alipay': 'dd_zf_xfb_n',
    'wechat': 'dd_zf_mx_n',
    'bankcard': 'dd_zf_yt_n',
    'usdt': 'dd_zf_us_n',
    'agent': 'dd_zf_agn_n',
    'money': 'dd_zf_con_n',
    'ecny': 'dd_zf_ecny_n'
  };

  showPayAlert(Map product, String tip) {
    int currentX = 0;
    List pays;
    pays = List.from(product['pay']);
    html.WindowBase? winRef;
    dynamic origin = '${html.window.location.origin}/';

    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setBottomSheetState) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1C),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30.w))),
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 24.5.w, bottom: 19.5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        Text(
                          Utils.txt('xzzf'),
                          style: StyleTheme.font_black_31_18,
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: LocalPNG(
                            name: "dd_alert_close_n",
                            width: 14.w,
                            height: 14.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(TextSpan(
                      text: Utils.txt('zfje') + ' ',
                      style: StyleTheme.font_black_31_14,
                      children: [
                        TextSpan(
                            text: '${product['promo_price_yuan']}' +
                                Utils.txt('rmbd'),
                            style: StyleTheme.font_black_31_15)
                      ])),
                  Column(
                    children: pays
                        .asMap()
                        .keys
                        .map((e) => GestureDetector(
                              onTap: () {
                                setBottomSheetState(() {
                                  currentX = e;
                                });
                              },
                              behavior: HitTestBehavior.translucent,
                              child: Padding(
                                padding: EdgeInsets.only(top: 20.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        LocalPNG(
                                          name: payIcons[pays[e]['channel']],
                                          width: 40.w,
                                          height: 40.w,
                                        ),
                                        SizedBox(width: 10.w),
                                        Text(
                                          pays[e]['name'],
                                          style: StyleTheme.font_black_31_15,
                                        )
                                      ],
                                    ),
                                    LocalPNG(
                                      name: currentX == e
                                          ? 'dd_radiosel_n'
                                          : 'dd_radio_n',
                                      width: 15.w,
                                      height: 15.w,
                                    )
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  GestureDetector(
                      onTap: () async {
                        LoadStatus.showSLoading(text: Utils.txt('zzqqzf'));
                        if (pays[currentX]['channel'] == 'money') {
                          reqOrderExchange(product_id: product['id'])
                              .then((value) {
                            LoadStatus.closeLoading();
                            if (value?.data == null) {
                              Utils.showText(Utils.txt('dhhs'));
                              return;
                            }
                            if (value?.status == 1) {
                              reqUserInfo(context);
                              Utils.showText(Utils.txt('dhhc'));
                            } else {
                              Utils.showText(value?.msg ?? "");
                            }
                          });
                        } else {
                          if (kIsWeb) {
                            winRef = html.window
                                .open('${origin}waiting.html', "_blank");
                          }
                          reqCreatePaying(
                                  pay_type: 'online',
                                  pay_way: pays[currentX]['channel'],
                                  product_id: product['id'])
                              .then((value) {
                            LoadStatus.closeLoading();
                            if (kIsWeb) {
                              Navigator.of(context).pop();
                            }
                            if (value?.status == 1 && value?.data != null) {
                              if (value?.data['payUrl'] != null) {
                                if (kIsWeb) {
                                  winRef?.location.href = value?.data['payUrl'];
                                } else {
                                  Utils.openURL(value?.data['payUrl']);
                                }
                              } else {
                                if (kIsWeb) {
                                  winRef?.close();
                                  showPayErr();
                                }
                                Utils.showText(Utils.txt('cddsb'));
                              }
                            } else {
                              if (kIsWeb) {
                                winRef?.close();
                                showPayErr();
                              }
                              Utils.showText(value?.msg ?? "");
                            }
                          });
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.w),
                        child: Container(
                          height: 40.w,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromRGBO(247, 187, 13, 1),
                                Color.fromRGBO(247, 187, 13, 1),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.w)),
                          ),
                          child: Center(
                            child: Text(Utils.txt('tjao'),
                                style: StyleTheme.font_black_31_15),
                          ),
                        ),
                      )),
                  SizedBox(height: 10.w),
                  Text(
                    Utils.txt('zfxts'),
                    style: StyleTheme.font_black_31_15,
                  ),
                  SizedBox(height: 5.w),
                  Text(
                    tip,
                    style: StyleTheme.font_black_31_15,
                    maxLines: 100,
                  ),
                  SizedBox(height: kIsWeb ? 30.w : 10.w)
                ],
              )),
            );
          });
        });
  }

  showPayErr() {
    Utils.showDialog(
      confirmTxt: Utils.txt('quren'),
      setContent: () {
        return DefaultTextStyle(
            style: StyleTheme.font_black_31_15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Utils.txt('zfsb')),
                SizedBox(height: 14.w),
                Text(Utils.txt('zfsby')),
                SizedBox(height: 14.w),
                Text(Utils.txt('zfsbe'))
              ],
            ));
      },
    );
  }
}
