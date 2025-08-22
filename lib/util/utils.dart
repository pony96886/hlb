// ignore_for_file: prefer_function_declarations_over_variables
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:bot_toast/bot_toast.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:hlw/base/base_store.dart';
import 'package:hlw/util/go_split_routers.dart';
import 'package:common_utils/common_utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hlw/base/request_api.dart';
import 'package:hlw/util/app_global.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/netimage_tool.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:flutter_split_view/flutter_split_view.dart';
import 'package:hive/hive.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:ui' as ui;

import '../model/general_ads_model.dart';

class Utils {
  static Map _cacheJSON = {}; //全局使用
  static bool isPC = Platform.isMacOS || Platform.isWindows;

  //字符串转MD5
  static String toMD5(String data) {
    return EncryptUtil.encodeMd5(data);
  }

  //随机字符串
  static String randomId(int range) {
    String str = "";
    List<String> arr = [
      "0",
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "a",
      "b",
      "c",
      "d",
      "e",
      "f",
      "g",
      "h",
      "i",
      "j",
      "k",
      "l",
      "m",
      "n",
      "o",
      "p",
      "q",
      "r",
      "s",
      "t",
      "u",
      "v",
      "w",
      "x",
      "y",
      "z",
      "A",
      "B",
      "C",
      "D",
      "E",
      "F",
      "G",
      "H",
      "I",
      "J",
      "K",
      "L",
      "M",
      "N",
      "O",
      "P",
      "Q",
      "R",
      "S",
      "T",
      "U",
      "V",
      "W",
      "X",
      "Y",
      "Z"
    ];
    for (int i = 0; i < range; i++) {
      int pos = Random().nextInt(arr.length - 1);
      str += arr[pos];
    }
    return str;
  }

  //xfile限制视频大小
  static Future<bool> videoLimitSize(PlatformFile file,
      {int size = 100}) async {
    int length = file.size;
    if (length / (1024 * 1024) > size) {
      Utils.showText(
        kIsWeb
            ? Utils.txt("qxzbmbv").replaceAll("500", "$size")
            : Utils.txt("qxzbmbv"),
      );
      return true;
    }
    return false;
  }

  //xfile限制图片大小
  static Future<bool> pngLimitSize(PlatformFile file) async {
    int length = file.size;
    if (length / 1024 > 1000) {
      Utils.showText(Utils.txt("qxzbkbp"));
      return true;
    }
    return false;
  }

  //初始化加载本地JSON
  static Future<void> loadJSON() async {
    if (_cacheJSON.isEmpty) {
      ByteData data = await rootBundle.load("assets/file/ext.json");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      _cacheJSON = jsonDecode(utf8.decode(bytes));
    }
  }

  //加载本地文字
  static String txt(String key) {
    return _cacheJSON[key] ?? "未知";
  }

  static String spliceAddress(BuildContext ctx, id) {
    var conf = Provider.of<BaseStore>(ctx, listen: false).config;
    return '${conf?.pc_site_url}/archives/$id.html';
  }

  //设置状态栏颜色
  static setStatusBar({bool isLight = false}) {
    if (kIsWeb) {
      return SystemChrome.setSystemUIOverlayStyle(
          isLight ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);
    } else if (Platform.isAndroid) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, //全局设置透明
        statusBarIconBrightness: isLight ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: isLight ? Colors.black : Colors.white,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    } else if (Platform.isIOS) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      //导航栏状态栏文字颜色
      SystemChrome.setSystemUIOverlayStyle(
          isLight ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);
    }
  }

  //日志输出
  static log(dynamic object) {
    LogUtil.init(
      //tag: "DD",
      isDebug: !(const bool.fromEnvironment("dart.vm.product")),
      maxLen: 128,
    );
    if (kDebugMode) {
      print(object);
    }
    // LogUtil.v(object);
    // const bool inProduction = bool.fromEnvironment('dart.vm.product');
    // if (!inProduction) dev.log(jsonEncode(object).toString());
  }

  //提示alert
  static showText(String text, {int time = 1, Function()? call}) {
    BotToast.showCustomText(
      toastBuilder: (_) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: StyleTheme.black0Color720,
                  borderRadius: BorderRadius.all(Radius.circular(5.w))),
              margin: EdgeInsets.symmetric(horizontal: 40.w),
              padding: EdgeInsets.all(20.w),
              child: Text(
                text.isEmpty ? Utils.txt('wzxx') : text,
                style: StyleTheme.font(size: 20),
                maxLines: 100,
              ),
            )
          ],
        );
      },
      duration: Duration(seconds: time),
      onClose: call,
    );
  }

  static openURL(String url) async {
    try {
      await launchUrl(
        Uri.base.resolve(url),
        mode: LaunchMode.externalNonBrowserApplication,
        webOnlyWindowName: "_blank",
      );
    } catch (e) {
      Utils.showText(Utils.txt('wzcw'));
    }
  }

  static void checkline({Function? onSuccess, Function? onFailed}) async {
    Box? box = AppGlobal.appBox;
    List<String> unChecklines = AppGlobal.apiLines;//todo：需要恢复以下代码
    // List<String> unChecklines = box?.get('lines_url') == null
    //     ? AppGlobal.apiLines
    //     : List<String>.from(box?.get('lines_url'));
    List<Map> errorLines = [];
    Function checkGit;
    Function doCheck;
    Function handleResult;

    Function reportErrorLines = () async {
      // 上报错误线路&保存服务端推荐线路到本地
      if (errorLines.isEmpty) return;
      await reqReportLine(list: errorLines);
    };

    handleResult = (String line) async {
      if (line.isNotEmpty) {
        AppGlobal.apiBaseURL = line;
        await reportErrorLines();
        onSuccess?.call();
      } else {
        onFailed?.call();
      }
    };

    checkGit = () async {
      String? git = box?.get("github_url") == null
          // ? "https://raw.githubusercontent.com/little-5/backup/master/hlw.txt"
          ? "https://raw.githubusercontent.com/little-5/backup/master/new-heiliao.txt"
          : box?.get("github_url").toString();
      dynamic result;
      if (kIsWeb) {
        result = await html.HttpRequest.request(git ?? "", method: "GET")
            .then((value) => value.response)
            .timeout(const Duration(milliseconds: 5 * 1000));
      } else {
        result = await Dio(
                BaseOptions(connectTimeout: 5 * 1000, receiveTimeout: 5 * 1000))
            .get(git ?? "");
      }

      handleResult(result.toString().trim());
    };

    doCheck = ({String line = ""}) async {
      if (line.isEmpty) return;
      int code = 0;
      try {
        if (kIsWeb) {
          code = await html.HttpRequest.request('$line/api/callback/checkLine',
                  method: "POST")
              .then((value) => value.status ?? 0)
              .timeout(const Duration(milliseconds: 5 * 1000));
        } else {
          code = await Dio(BaseOptions(
                  connectTimeout: 5 * 1000, receiveTimeout: 5 * 1000))
              .post('$line/api/callback/checkLine')
              .then((value) => value.statusCode ?? 0);
        }
      } catch (err) {
        code = 0;
      }
      Utils.log(code);
      if (code == 200) {
        handleResult(line);
      } else {
        errorLines.add({'url': line});
        //启用备用github线路
        if (errorLines.length == unChecklines.length &&
            unChecklines.length > 1) {
          checkGit();
        }
      }
    };

    // ConnectivityResult connectivityResult =
    //     await Connectivity().checkConnectivity();
    // if (connectivityResult == ConnectivityResult.none) {
    List<ConnectivityResult> results = await Connectivity().checkConnectivity();
    ConnectivityResult result =
        results.isNotEmpty ? results.first : ConnectivityResult.none;
    if (result == ConnectivityResult.none) {
      onFailed?.call();
    } else {
      for (var i = 0; i < unChecklines.length; i++) {
        if (AppGlobal.apiBaseURL.isEmpty) {
          await doCheck(line: unChecklines[i]);
        } else {
          break;
        }
      }
    }
  }

  //检查安装未知安装包
  static checkRequestInstallPackages() async {
    if (Platform.isAndroid) {
      PermissionStatus _status = await Permission.requestInstallPackages.status;
      if (_status == PermissionStatus.granted) {
        return true;
      } else if (_status == PermissionStatus.permanentlyDenied) {
        Utils.showText(Utils.txt('jjazqq'));
        return false;
      } else {
        await Permission.requestInstallPackages.request();
        return true;
      }
    }
  }

  //检查是否已有读写内存权限
  static checkStoragePermission() async {
    if (Platform.isAndroid) {
      PermissionStatus storageStatus = await Permission.storage.status;
      if (storageStatus == PermissionStatus.granted) {
        return true;
      } else if (storageStatus == PermissionStatus.permanentlyDenied) {
        Utils.showText(Utils.txt('jjqxts'));
        return false;
      } else {
        await Permission.storage.request();
        return true;
      }
    }
  }

  static getPICURL(dynamic data) {
    if (data['cover_url'] != null && data['cover_url'] != '') {
      return data['cover_url'];
    } else if (data['media_url'] != null && data['media_url'] != '') {
      return data['media_url'];
    } else if (data['img_url'] != null && data['img_url'] != '') {
      return data['img_url'];
    } else if (data['resource_url'] != null && data['resource_url'] != '') {
      return data['resource_url'];
    } else if (data['thumb_horizontal'] != null &&
        data['thumb_horizontal'] != '') {
      return data['thumb_horizontal'];
    } else if (data['thumb_vertical'] != null && data['thumb_vertical'] != '') {
      return data['thumb_vertical'];
    } else if (data['cover_thumb_horizontal'] != null &&
        data['cover_thumb_horizontal'] != '') {
      return data['cover_thumb_horizontal'];
    } else if (data['cover_thumb_vertical'] != null &&
        data['cover_thumb_vertical'] != '') {
      return data['cover_thumb_vertical'];
    } else if (data['cover_vertical'] != null && data['cover_vertical'] != '') {
      return data['cover_vertical'];
    } else if (data['cover_horizontal'] != null &&
        data['cover_horizontal'] != '') {
      return data['cover_horizontal'];
    } else if (data['thumb_horizontal_url'] != null &&
        data['thumb_horizontal_url'] != '') {
      return data['thumb_horizontal_url'];
    } else if (data['cover'] != null && data['cover'] != '') {
      return data['cover'];
    } else if (data['thumb'] != null && data['thumb'] != '') {
      return data['thumb'];
    } else if (data['thumb_vertical_url'] != null &&
        data['thumb_vertical_url'] != '') {
      return data['thumb_vertical_url'] ?? "";
    } else {
      return data["url"] ?? "";
    }
  }

  static renderFixedNumber(int value) {
    var tips;
    if (value >= 10000) {
      var newvalue = (value / 1000) / 10.round();
      tips = formatNum(newvalue, 1) + Utils.txt('w');
    } else if (value >= 1000) {
      var newvalue = (value / 100) / 10.round();
      tips = formatNum(newvalue, 1) + Utils.txt('qa');
    } else {
      tips = value.toString().split('.')[0];
    }
    return tips;
  }

  static renderByteNumber(int value) {
    var tips;
    if (value >= 1024 * 1024) {
      var newvalue = (value / (1024 * 1024));
      tips = formatNum(newvalue, 1) + 'M';
    } else if (value >= 1024) {
      var newvalue = (value / 1024);
      tips = formatNum(newvalue, 1) + 'K';
    } else {
      tips = value.toString().split('.')[0];
    }
    return tips;
  }

  static renderNumber(int value) {
    var tips;
    if (value >= 10000) {
      var newvalue = (value / 1000) / 10.round();
      tips = formatNum(newvalue, 1) + 'w';
    } else if (value >= 1000) {
      var newvalue = (value / 100) / 10.round();
      tips = formatNum(newvalue, 1) + 'k';
    } else {
      tips = value.toString().split('.')[0];
    }
    return tips;
  }

  static formatNum(double number, int postion) {
    if ((number.toString().length - number.toString().lastIndexOf(".") - 1) <
        postion) {
      //小数点后有几位小数
      return number
          .toStringAsFixed(postion)
          .substring(0, number.toString().lastIndexOf(".") + postion + 1)
          .toString();
    } else {
      return number
          .toString()
          .substring(0, number.toString().lastIndexOf(".") + postion + 1)
          .toString();
    }
  }

  static Size boundingTextSize(
      BuildContext context, String text, TextStyle style,
      {int maxLines = 2 ^ 31, double maxWidth = double.infinity}) {
    if (text.isEmpty) {
      return Size.zero;
    }
    final TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        locale: Localizations.localeOf(context),
        text: TextSpan(text: text, style: style),
        maxLines: maxLines)
      ..layout(maxWidth: maxWidth);
    return textPainter.size;
  }

  static openRoute(BuildContext context, GeneralAdsModel? ad) {
    if (ad == null) return;
    if (ad.url_config?.isEmpty == true) return;
    if (ad.type == 2) {
      String _url = ad.url_config ?? "";
      List _urlList = _url.split('??');
      Map<String, dynamic> pramas = {};
      if (_urlList.first == "web") {
        pramas["url"] = _urlList.last.toString().substring(4);
        if (kIsWeb) {
          final _url = Uri.decodeComponent(pramas.values.first.trim() ?? '');
          _url.isNotEmpty == true
              ? Utils.openURL(_url)
              : Utils.showText(Utils.txt('cccwl') + '');
        } else {
          Utils.navTo(context, "/${_urlList.first}/${pramas.values.first}");
        }
      } else {
        if (_urlList.length > 1 && _urlList.last != "") {
          _urlList[1].split("&").forEach((item) {
            List stringText = item.split('=');
            pramas[stringText[0]] =
                stringText.length > 1 ? stringText[1] : null;
          });
        }
        String pramasStrs = "";
        if (pramas.values.isNotEmpty) {
          pramas.forEach((key, value) {
            pramasStrs += "/$value";
          });
        }
        Utils.navTo(context, "/${_urlList.first}$pramasStrs");
      }
    } else {
      final _url = ad.url_config?.trim() ?? '';
      _url.isNotEmpty == true
          ? Utils.openURL(_url)
          : Utils.showText(Utils.txt('cccwl') + '');
    }
  }

  //点击广告统一路径
  static Widget bannerSwiper({
    double width = 380,
    double whRate = 1.0,
    List<dynamic>? data,
    double radius = 0,
  }) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        child: Container(
          color: StyleTheme.gray204Color,
          width: width,
          height: width * whRate,
          child: data == null
              ? Container()
              : Swiper(
                  autoplay: data.length > 1,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        if (Utils.unFocusNode(context)) {
                          openRoute(
                              context, GeneralAdsModel.fromJson(data[index]));
                        }
                      },
                      child: NetImageTool(url: Utils.getPICURL(data[index])),
                    );
                  },
                  itemCount: data.length,
                  pagination: SwiperPagination(builder:
                      SwiperCustomPagination(builder: (context, config) {
                    int count = data.length;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: List.generate(count, (index) {
                        return config.activeIndex == index
                            ? Container(
                                width: 9.w,
                                height: 3.w,
                                margin: EdgeInsets.only(right: 5.w),
                                decoration: BoxDecoration(
                                  color: StyleTheme.red245Color,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(0.w)),
                                ),
                              )
                            : Container(
                                width: 9.w,
                                height: 3.w,
                                margin: EdgeInsets.only(right: 5.w),
                                decoration: BoxDecoration(
                                  color: StyleTheme.gray102Color,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(0.w)),
                                ),
                              );
                      }),
                    );
                  })),
                ),
        ));
  }

  //点击广告统一路径 放大、缩小
  static Widget bannerScaleSwiper({
    double width = 380,
    double whRate = 1.0,
    List<dynamic>? data,
    double radius = 0,
    bool autoplay = false,
  }) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        child: Container(
          color: Colors.transparent,
          width: width,
          height: width * whRate * 0.62,
          alignment: Alignment.center,
          child: data == null
              ? Container()
              : Container(
                  key: ValueKey(data),
                  alignment: Alignment.centerLeft,
                  color: Colors.transparent,
                  width: width,
                  height: width * whRate * 0.6,
                  child: Swiper(
                    autoplay: autoplay,
                    viewportFraction: 0.5,
                    scale: 0.8,
                    outer: true,
                    fade: 0.5,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          if (Utils.unFocusNode(context)) {
                            openRoute(
                                context, GeneralAdsModel.fromJson(data[index]));
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: StyleTheme.gray204Color,
                                  offset: const Offset(0, 0),
                                  blurStyle: BlurStyle.normal,
                                  spreadRadius: 0.w,
                                  blurRadius: 10.w)
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular((3.w)),
                          ),
                          child: NetImageTool(
                            url: Utils.getPICURL(data[index]),
                            radius: BorderRadius.all(Radius.circular(3.w)),
                          ),
                        ),
                      );
                    },
                    itemCount: data.length,
                    pagination: SwiperPagination(builder:
                        SwiperCustomPagination(builder: (context, config) {
                      int count = data.length;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(count, (index) {
                          return config.activeIndex == index
                              ? Container(
                                  width: 9.w,
                                  height: 3.w,
                                  margin: EdgeInsets.only(right: 5.w),
                                  decoration: BoxDecoration(
                                    color: StyleTheme.orange255Color,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0.w)),
                                  ),
                                )
                              : Container(
                                  width: 9.w,
                                  height: 3.w,
                                  margin: EdgeInsets.only(right: 5.w),
                                  decoration: BoxDecoration(
                                    color: StyleTheme.gray102Color,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0.w)),
                                  ),
                                );
                        }),
                      );
                    })),
                  ),
                ),
        ));
  }

  /// 点击广告统一路径 放大、缩小
  static Widget bannerScaleExtSwiper({
    EdgeInsetsGeometry? padding,
    double? containerWidth,
    // required double containerHeight,
    required double itemWidth,
    required double itemHeight,
    List<dynamic>? data,
    double radius = 10,
    bool autoplay = true,
    double viewportFraction = 1, // 占满整个窗口
    double scale = 1, // 缩放比例[0- 1] 1-不缩放
    double spacing = 0, // 无间距
    double lineWidth = 9,
    BoxFit fit = BoxFit.fill,
  }) {
    if (data == null || data.isEmpty) return const SizedBox();

    Widget current = Swiper(
      viewportFraction: viewportFraction,
      autoplay: autoplay && data.length > 1,
      itemCount: data.length,
      scale: scale,
      outer: true,
      fade: 0.5,
      itemBuilder: (BuildContext context, int index) {
        Widget current = NetImageTool(
          fit: fit,
          url: Utils.getPICURL(data[index]),
          radius: BorderRadius.circular(radius),
        );

        if (spacing != 0) {
          current = Container(
            margin: EdgeInsets.fromLTRB(spacing * 0.5, 0, spacing * 0.5, 0),
            constraints:
                BoxConstraints.tightFor(width: itemWidth, height: itemHeight),
            // width: itemWidth,
            // height: itemHeight,
            child: current,
          );
        }

        return GestureDetector(
          onTap: () => Utils.unFocusNode(context)
              ? Utils.openRoute(context, GeneralAdsModel.fromJson(data[index]))
              : null,
          child: current,
        );
      },
      pagination: SwiperPagination(
        margin: EdgeInsets.all(10.w),
        builder: SwiperCustomPagination(
          builder: (context, conf) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: data.asMap().keys.map((idx) {
                return Container(
                  margin: EdgeInsets.only(right: 5.w),
                  color: conf.activeIndex == idx
                      ? StyleTheme.orange255Color
                      : StyleTheme.gray235Color,
                  width: lineWidth.w,
                  height: 3.w,
                );
              }).toList(),
            );
          },
        ),
      ),
    );

    current = Container(
      margin: padding,
      width: containerWidth,
      height: itemHeight + 23.w,
      // alignment: Alignment.center,
      child: current,
    );
    return current;
    // if (radius == 0) return current;
    // return ClipRRect(
    //   borderRadius: BorderRadius.circular(radius),
    //   child: current,
    // );
  }

  //统一跳转指定页面
  static navTo(BuildContext context, String path) {
    GoSplitRouters.prepJumpRoute(context, path: path);
  }

  //跳转指定SplitView页面
  static splitToView(BuildContext context, Widget page, {Object? arguments}) {
    SplitView.of(context).push(page, arguments: arguments);
  }

  //Pop SplitView页面
  static splitPopView(BuildContext context) {
    SplitView.of(context).pop();
  }

  static String realHash([String? value]) {
    if (kIsWeb) {
      var currentHash = html.window.location.hash.replaceAll('#', '');
      if (value == null) return currentHash;
      if (currentHash.lastIndexOf('/') == currentHash.length - 1) {
        return '$currentHash$value';
      } else {
        return '$currentHash/$value';
      }
    } else {
      var location = '${AppGlobal.appRouter?.location ?? ""}/$value';
      if (value == null) return AppGlobal.appRouter?.location ?? "";
      if (location.contains('//')) {
        var current = location.replaceAll('//', '/');
        return current;
      } else {
        return location;
      }
    }
  }

  //加载动画
  static startGif({String tip = "发布中"}) {
    BotToast.showCustomLoading(
      toastBuilder: ((cancelFunc) =>
          Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
                height: 30.w,
                width: 30.w,
                child: CircularProgressIndicator(
                  color: StyleTheme.orange255Color,
                  strokeWidth: 2,
                )),
            SizedBox(
              height: 12.w,
            ),
            Text(tip, style: StyleTheme.font_orange_255_20)
          ])),
    );
  }

  //关闭动画
  static closeGif() {
    BotToast.closeAllLoading();
  }

  //自定义对话框
  static showDialog({
    bool? showBtnClose = false,
    String? title = '温馨提示',
    String? cancelTxt,
    String? confirmTxt = "确定",
    double? width,
    double? height,
    EdgeInsets? padding,
    Color? cancelTextColor = const Color.fromRGBO(10, 11, 13, 0.6),
    Color? confirmTextColor = const Color.fromRGBO(241, 241, 241, 1),
    Color? cancelBoxColor = const Color.fromRGBO(28, 28, 28, 0.2),
    Color? confirmBoxColor = const Color.fromRGBO(255, 144, 0, 1),
    Color? backgroundColor = const Color(0xFFf2f2f2),
    VoidCallback? cancel,
    VoidCallback? confirm,
    VoidCallback? backgroundReturn,
    Function? setContent,
    Widget Function(void Function() cancel)? customWidget,
  }) {
    return BotToast.showAnimationWidget(
      clickClose: false,
      allowClick: false,
      onlyOne: false,
      crossPage: true,
      backButtonBehavior: BackButtonBehavior.none,
      wrapToastAnimation: (controller, cancel, child) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                backgroundReturn?.call();
              },
              //The DecoratedBox here is very important,he will fill the entire parent component
              child: AnimatedBuilder(
                builder: (_, child) => Opacity(
                  opacity: controller.value,
                  child: child,
                ),
                child: const DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black38),
                  child: SizedBox.expand(),
                ),
                animation: controller,
              ),
            ),
            AnimatedBuilder(
              child: child,
              animation: controller,
              builder: (context, child) {
                Tween<Offset> tweenOffset = Tween<Offset>(
                  begin: const Offset(0.0, 0.8),
                  end: Offset.zero,
                );
                Tween<double> tweenScale = Tween<double>(begin: 0.3, end: 1.0);
                Animation<double> animation = CurvedAnimation(
                    parent: controller, curve: Curves.decelerate);
                return FractionalTranslation(
                  translation: tweenOffset.evaluate(animation),
                  child: ClipRect(
                    child: Transform.scale(
                      scale: tweenScale.evaluate(animation),
                      child: Opacity(
                        child: child,
                        opacity: animation.value,
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        );
      },
      toastBuilder: (cancelFunc) {
        return Center(
          child: Container(
              // margin: EdgeInsets.symmetric(horizontal: 400.w),
              // padding: EdgeInsets.all(20.w),
              width: width ?? 385.w,
              height: height ?? 260.w,
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(20.w))),
              child: Stack(
                children: [
                  Visibility(
                    visible: showBtnClose!,
                    child: Positioned(
                      top: 10.w,
                      right: 10.w,
                      child: GestureDetector(
                        child: LocalPNG(
                          name: "hlw_close_gray",
                          width: 24.w,
                          height: 24.w,
                          fit: BoxFit.contain,
                        ),
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          cancelFunc();
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      padding: padding ?? EdgeInsets.only(top: 50.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RichText(
                            text: TextSpan(
                                text: title,
                                style: StyleTheme.font_black_34_20),
                            maxLines: 1,
                          ),
                          SizedBox(height: 36.w),
                          customWidget == null
                              ? setContent?.call()
                              : customWidget(cancelFunc),
                          cancelTxt == null && confirmTxt == null
                              ? Container()
                              : SizedBox(height: 36.w),
                          cancelTxt == null && confirmTxt == null
                              ? Container()
                              : Row(
                                  key: ValueKey(
                                      cancelTxt == null && confirmTxt == null),
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    cancelTxt == null
                                        ? Container()
                                        : GestureDetector(
                                            key: ValueKey(cancelTxt),
                                            onTap: () {
                                              cancelFunc();
                                              cancel?.call();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.w,
                                                  horizontal: 20.w),
                                              decoration: BoxDecoration(
                                                color: cancelBoxColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(16.w)),
                                              ),
                                              child: Center(
                                                  child: RichText(
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                    text: cancelTxt,
                                                    style: StyleTheme.font(
                                                      size: 15,
                                                      color: cancelTextColor!,
                                                    ),
                                                  ),
                                                ]),
                                              )),
                                            ),
                                          ),
                                    SizedBox(
                                        width: cancelTxt == null ? 0 : 20.w),
                                    confirmTxt == null
                                        ? Container()
                                        : GestureDetector(
                                            key: ValueKey(confirmTxt),
                                            onTap: () {
                                              cancelFunc();
                                              confirm?.call();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.w,
                                                  horizontal: 20.w),
                                              decoration: BoxDecoration(
                                                  color: confirmBoxColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              16.w))),
                                              alignment: Alignment.center,
                                              child: Center(
                                                  child: RichText(
                                                      text: TextSpan(children: [
                                                TextSpan(
                                                  text: confirmTxt,
                                                  style: StyleTheme.font(
                                                      size: 15,
                                                      color: confirmTextColor!),
                                                )
                                              ]))),
                                            ),
                                          )
                                  ],
                                ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
        );
      },
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  // 新闻模块UI复用 style: 1 横向样式 2 纵向样式
  // state 1 已分布 2 通过/待回调 3 待审核 4 被拒绝
  static Widget newsModuleUI(BuildContext context, dynamic e,
      {int style = 1, int state = 1}) {
    String JsonStr = e.toString();
    String plates =
        DateUtil.formatDateStr(e["created_date"], format: "yyyy年MM日dd");
    if (e["plates"] is Map && (e["plates"] as Map).isNotEmpty) {
      plates += ' · ${(e["plates"] as Map).values.toList().join(' ')}';
    }
    if (e["plates"] is List && (e["plates"] as List).isNotEmpty) {
      plates += ' · ${(e["plates"] as List).map((i) {
        if (i is String) return i;
        if (i is Map) return '${i['name']}';
        return ''; // 未知类型
      }).join(' ')}';
    }
    Widget current = Container();
    if (style == 1) {
      current = Column(children: [
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
                  url: e['thumb'] ?? '',
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: (e['is_hot'] != 1 || e['is_ad'] == 1)
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
                    e["title"],
                    style: StyleTheme.font_black_34_17_bold,
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
                    visible: e['id'] > 0,
                    child: btnRed(
                      '编辑',
                      () => navTo(context, '/homeeditorpage/${e['id']}'),
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
              Text(txt('ggly') + ":", style: StyleTheme.font_red_245_15_bold),
              Text("${e['remark']}", style: StyleTheme.font_gray_102_14),
            ],
          ),
        ),
        SizedBox(height: 20.w), // 間距
      ]);
    }
    if (style == 2) {
      current = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: Stack(children: [
            NetImageTool(
              radius: BorderRadius.circular(12.w),
              url: e['thumb'] ?? '',
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: -1,
              child: Container(
                padding: EdgeInsets.only(
                    left: 20.w, right: 20.w, top: 40.w, bottom: 24.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black,
                      Colors.black.withOpacity(0),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12.w),
                    bottomRight: Radius.circular(12.w),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        LocalPNG(name: "icon_play", width: 18.w, height: 16.w),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(
                          '1.6w',
                          style: StyleTheme.font_white_255_20,
                          maxLines: 1,
                        )
                      ],
                    ),
                    Text(
                      '97:11',
                      style: StyleTheme.font_white_255_20,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 72.w,
                height: 40.w,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    LocalPNG(name: "news_tag_bg", width: 72.w, height: 40.w),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '30',
                            style: StyleTheme.font_white_255_22_bold,
                          ),
                          SizedBox(width: 3.w),
                          LocalPNG(name: "hlw_coin_icon", width: 28.w, height: 28.w),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ]),
        ),
        SizedBox(height: 16.w),
        SizedBox(
          height: 60.w,
          child: Text(
            e['is_ad'] == 1 &&
                e['ad'] is Map &&
                e['ad']['name'] != null &&
                e['ad']['name'] != ''
                ? '${e['ad']['name']}'
                : '${e["title"]}',
            style: StyleTheme.font_white_255_20,
            maxLines: 2,
          ),
        ),
        SizedBox(height: 16.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "2天",
              style: StyleTheme.font_gray_153_18,
              maxLines: 1,
            ),
            Text(
              "10评论",
              style: StyleTheme.font_gray_153_18,
              maxLines: 1,
            )
          ],
        ),
      ]);
    }

    if (style == 3) {
      current = current =
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: Stack(children: [
            NetImageTool(
              radius: BorderRadius.circular(12.w),
              url: e['thumb'] ?? '',
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: -1,
              child: Container(
                padding: EdgeInsets.only(
                    left: 20.w, right: 20.w, top: 40.w, bottom: 16.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black,
                      Colors.black.withOpacity(0),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12.w),
                    bottomRight: Radius.circular(12.w),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        LocalPNG(name: "icon_hot", width: 24.w, height: 24.w),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(
                          '1.6w',
                          style: StyleTheme.font_white_255_20,
                          maxLines: 1,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        LocalPNG(
                            name: "icon_comment", width: 24.w, height: 24.w),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(
                          '1.6w',
                          style: StyleTheme.font_white_255_20,
                          maxLines: 1,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        LocalPNG(
                            name: "icon_collect", width: 24.w, height: 24.w),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(
                          '1.6w',
                          style: StyleTheme.font_white_255_20,
                          maxLines: 1,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.1),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12.w),
              bottomRight: Radius.circular(12.w),
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 60.w,
                child: Text(
                  e['is_ad'] == 1 &&
                          e['ad'] is Map &&
                          e['ad']['name'] != null &&
                          e['ad']['name'] != ''
                      ? '${e['ad']['name']}'
                      : '${e["title"]}',
                  style: StyleTheme.font_white_255_22_bold,
                  maxLines: 2,
                ),
              ),
              SizedBox(height: 16.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "2024年9月9日 23:00:00",
                    style: StyleTheme.font_gray_153_18,
                    maxLines: 1,
                  ),
                ],
              ),
            ],
          ),
        )
      ]);
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (e["badge"] == "AD") {
          Utils.openURL(e["advertiser_url"]);
          return;
        }
        // Utils.navTo(context,
        //     "/${style == 1 ? "homeeditorpage" : "homecontentdetailpage"}/${e["id"]}");
        switch (state) {
          case 1:
          case 2:
            Utils.navTo(context, "/homecontentdetailpage/${e["id"]}");
            break;
          // case 3: // 待审核
          case 4: //
            Utils.navTo(context, "/homeeditorpage/${e["id"]}");
            break;
          default:
        }
      },
      child: current,
    );
  }

  //nav搜索UI
  static Widget navModuleUI(BuildContext context, {int spacer = 40}) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          // SizedBox(height: 10.w),
          Padding(
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Utils.navTo(context, "/homesearchpage");
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    width: 500.w,
                    height: 36.w,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                        color: StyleTheme.gray247Color,
                        borderRadius: BorderRadius.all(Radius.circular(17.w))),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        LocalPNG(
                          name: "hlw_top_search",
                          width: 20.w,
                          height: 20.w,
                        ),
                        SizedBox(width: 20.w),
                        Text(
                          Utils.txt('srsgjz'),
                          style: StyleTheme.font_gray_170_17,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(width: spacer.w),
              ],
            ),
          ),
          // SizedBox(height: 10.w),
          // Divider(color: const Color.fromRGBO(125, 125, 125, 1), height: 1.w),
        ],
      ),
    );
  }

  //关闭键盘
  static bool unFocusNode(BuildContext context) {
    if (Utils.isPC) return true;
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
    if (currentFocus.focusedChild == null && kIsWeb) {
      return true;
    } else if (currentFocus.hasPrimaryFocus) {
      return true;
    } else {
      return false;
    }
  }

  //导航栏
  static Widget createNav({Widget? left, Widget? right, String? title}) {
    return Column(
      children: [
        SizedBox(height: StyleTheme.topHeight),
        Container(
          padding: EdgeInsets.symmetric(horizontal: StyleTheme.margin),
          height: StyleTheme.navHegiht,
          width: ScreenWidth,
          child: Stack(
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    left ?? SizedBox(width: 20.w, height: 20.w),
                    Expanded(
                        child: Text(title ?? "",
                            style: StyleTheme.nav_title_font,
                            textAlign: TextAlign.left)),
                    SizedBox(width: 10.w),
                    right ?? SizedBox(width: 20.w, height: 20.w),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  static String convertEmojiAndHtml(String str) {
    // 转 html
    var unescape = HtmlUnescape();
    str = unescape.convert(str);
    // 转 emoji
    final Pattern unicodePattern = RegExp(r'\\\\u([0-9A-Fa-f]{4})');
    final String newStr =
        str.replaceAllMapped(unicodePattern, (Match unicodeMatch) {
      final int hexCode = int.parse(unicodeMatch.group(1) ?? "0", radix: 16);
      final unicode = String.fromCharCode(hexCode);
      return unicode;
    });
    return newStr;
  }

  //时间转换
  static num _oneMinute = 60000;
  static num _oneHour = 3600000;
  static num _oneDay = 86400000;
  static num _oneWeek = 604800000;

  static final String _oneSecondAgo = Utils.txt('mq');
  static final String _oneMinuteAgo = Utils.txt('fq');
  static final String _oneHourAgo = Utils.txt('sq');
  static final String _oneDayAgo = Utils.txt('tq');
  static final String _oneMonthAgo = Utils.txt('yq');
  static final String _oneYearAgo = Utils.txt('nq');

  //时间转换
  static String format(DateTime date) {
    num delta =
        DateTime.now().millisecondsSinceEpoch - date.millisecondsSinceEpoch;

    if (delta < 1 * _oneMinute) {
      num seconds = _toSeconds(delta);
      return (seconds <= 0 ? 1 : seconds).toInt().toString() + _oneSecondAgo;
    }
    if (delta < 60 * _oneMinute) {
      num minutes = _toMinutes(delta);
      return (minutes <= 0 ? 1 : minutes).toInt().toString() + _oneMinuteAgo;
    }
    if (delta < 24 * _oneHour) {
      num hours = _toHours(delta);
      return (hours <= 0 ? 1 : hours).toInt().toString() + _oneHourAgo;
    }
    if (delta < 48 * _oneHour) {
      return Utils.txt('zut');
    }
    if (delta < 30 * _oneDay) {
      num days = _toDays(delta);
      return (days <= 0 ? 1 : days).toInt().toString() + _oneDayAgo;
    }
    if (delta < 12 * 4 * _oneWeek) {
      num months = _toMonths(delta);
      return (months <= 0 ? 1 : months).toInt().toString() + _oneMonthAgo;
    } else {
      num years = _toYears(delta);
      return (years <= 0 ? 1 : years).toInt().toString() + _oneYearAgo;
    }
  }

  static num _toSeconds(num date) {
    return date / 1000;
  }

  static num _toMinutes(num date) {
    return _toSeconds(date) / 60;
  }

  static num _toHours(num date) {
    return _toMinutes(date) / 60;
  }

  static num _toDays(num date) {
    return _toHours(date) / 24;
  }

  static num _toMonths(num date) {
    return _toDays(date) / 30;
  }

  static num _toYears(num date) {
    return _toMonths(date) / 12;
  }

  //特殊字符处理
  static Widget getContentSpan(
    String text, {
    bool isCopy = false,
    TextStyle? style,
    TextStyle? linkStyle,
  }) {
    style ??= StyleTheme.font_black_31_14;
    linkStyle ??=
        StyleTheme.font(size: 14, color: const Color.fromRGBO(25, 103, 210, 1));
    List<InlineSpan> _contentList = [];

    RegExp exp = RegExp(
        r'(http|ftp|https)://([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?');
    Iterable<RegExpMatch> matches = exp.allMatches(text);

    int index = 0;
    for (var match in matches) {
      /// start 0  end 8
      /// start 10 end 12
      String c = text.substring(match.start, match.end);
      if (match.start == index) {
        index = match.end;
      }
      if (index < match.start) {
        String a = text.substring(index, match.start);
        index = match.end;
        _contentList.add(
          TextSpan(text: a, style: style),
        );
      }
      if (RegexUtil.isURL(c)) {
        _contentList.add(TextSpan(
            text: c,
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Utils.openURL(text.substring(match.start, match.end));
              }));
      } else {
        _contentList.add(
          TextSpan(text: c, style: style),
        );
      }
    }
    if (index < text.length) {
      String a = text.substring(index, text.length);
      _contentList.add(
        TextSpan(text: a, style: style),
      );
    }
    if (isCopy) {
      return SelectableText.rich(
        TextSpan(children: _contentList),
        strutStyle:
            const StrutStyle(forceStrutHeight: true, height: 1, leading: 0.5),
      );
    }
    return RichText(
        textAlign: TextAlign.left,
        text: TextSpan(children: _contentList),
        strutStyle:
            const StrutStyle(forceStrutHeight: true, height: 1, leading: 0.5));
  }

  static String getCustomUniqueId(String uuid) {
    String pushChars = uuid;
    int lastPushTime = 0;
    List lastRandChars = [];
    int now = DateTime.now().millisecondsSinceEpoch;
    bool duplicateTime = (now == lastPushTime);
    lastPushTime = now;
    List timeStampChars = List<String>.filled(8, '0');
    for (int i = 7; i >= 0; i--) {
      timeStampChars[i] = pushChars[now % 64];
      now = (now / 64).floor();
    }
    if (now != 0) {
      print("Id should be unique");
    }
    String uniqueId = timeStampChars.join('');
    if (!duplicateTime) {
      for (int i = 0; i < 12; i++) {
        lastRandChars.add((Random().nextDouble() * 64).floor());
      }
    } else {
      int i = 0;
      for (int i = 11; i >= 0 && lastRandChars[i] == 63; i--) {
        lastRandChars[i] = 0;
      }
      lastRandChars[i]++;
    }
    for (int i = 0; i < 12; i++) {
      uniqueId += pushChars[lastRandChars[i]];
    }
    return uniqueId;
  }

  // Future<int> getIntUniqueId() async {
  //   //int型態的uuid
  //   String _uuid = '';
  //   final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  //   if (Platform.isMacOS)
  //     _uuid = UtilsDeviceInfo.readMacOsDeviceInfo(
  //         await deviceInfoPlugin.macOsInfo)['systemGUID'];
  //   if (Platform.isWindows)
  //     _uuid = UtilsDeviceInfo.readWindowsDeviceInfo(
  //         await deviceInfoPlugin.windowsInfo)['deviceId'];
  //   Utils.log('uuid: $_uuid');
  //   final List<int> bytes = Uuid.parse(_uuid);
  //   // Utils.log('uuid: $bytes');
  //   _uuid = '';
  //   for (var element in bytes) {
  //     _uuid += element.toString();
  //   }
  //   // Utils.log('uuid: $_uuid');
  //   // Utils.log('uuid: ${num.parse(_uuid)}');
  //   // Utils.log('uuid: ${num.parse(_uuid).toInt()}');
  //   return num.parse(_uuid).toInt();
  // }

  static List listMapNoDuplicate(List data) {
    Set a = {};
    List h = [];
    for (int i = 0; i < data.length; i++) {
      a.add(data[i]["id"]);
    }
    List b = a.toList();
    for (int j = 0; j < a.length; j++) {
      for (int i = 0; i < data.length; i++) {
        if (b[j] == data[i]['id']) {
          h.add(data[i]);
          break;
        }
      }
    }
    return h;
  }

  // static Future<void> openWebViewMacos(PresentationStyle presentationStyle, String url) async { #flutter_macos_webview
  //   Utils.startGif();
  //   final webView = FlutterMacOSWebView(
  //     onOpen: () {
  //       if (kDebugMode) {
  //         print('Opened');
  //       }
  //       Utils.closeGif();
  //     },
  //     onClose: () {
  //       if (kDebugMode) {
  //         print('Closed');
  //       }
  //       Utils.closeGif();
  //     },
  //     onPageStarted: (url) {
  //       if (kDebugMode) {
  //         print('Page started: $url');
  //       }
  //       Utils.closeGif();
  //     },
  //     onPageFinished: (url) {
  //       if (kDebugMode) {
  //         print('Page finished: $url');
  //       }
  //       Utils.closeGif();
  //     },
  //     onWebResourceError: (err) {
  //       if (kDebugMode) {
  //         'Error: ${err.errorCode}, ${err.errorType}, ${err.domain}, ${err.description}';
  //       }
  //       Utils.showDialog(
  //         showBtnClose: true,
  //         setContent: () {
  //           return Text(
  //             '请检察网路连线状态,或向官网/官方TG群反应!',
  //             style: StyleTheme.font_gray_153_15,
  //           );
  //         },
  //       );
  //     },
  //   );
  //
  //   await webView.open(
  //     url: url,
  //     sheetCloseButtonTitle: '关闭',
  //     presentationStyle: presentationStyle,
  //     size: appWindow.size,
  //     userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1',
  //   );
  //
  //   await Future.delayed(const Duration(milliseconds: 200));
  //   // await webView.close();
  // }

// static void initWebView(String url) async {  #desktop_webview_window
//   final _isAvailable = await WebviewWindow.isWebviewAvailable();
//   if (_isAvailable) {
//     final _javaScriptToEval = [
//       """
// function test() {
//   return;
// }
// test();
// """,
//       'eval({"name": "test", "user_agent": navigator.userAgent})',
//       '1 + 1',
//       'undefined',
//       '1.0 + 1.0',
//       '"test"',
//     ];
//     final webView = await WebviewWindow.create(
//       configuration: CreateConfiguration(
//         windowHeight: 1000,
//         windowWidth: 1280,
//         userDataFolderWindows: await _getWebViewPath(),
//         titleBarTopPadding: Platform.isMacOS || Platform.isWindows || Platform.isLinux ? 20 : 0,
//       ),
//     );
//     webView
//       ..setBrightness(Brightness.dark)
//       ..setApplicationNameForUserAgent(" WebviewExample/1.0.0")
//       ..launch(Uri.decodeComponent(url ?? ""))
//       ..addOnUrlRequestCallback((url) {
//         debugPrint('url: $url');
//         final uri = Uri.parse(url);
//         if (uri.path == '/login_success') {
//           debugPrint('login success. token: ${uri.queryParameters['token']}');
//           webView.close();
//         }
//       })
//       ..onClose.whenComplete(() {
//         debugPrint("on close");
//       });
//     await Future.delayed(const Duration(seconds: 2));
//     for (final javaScript in _javaScriptToEval) {
//       try {
//         final ret = await webView.evaluateJavaScript(javaScript);
//         debugPrint('evaluateJavaScript: $ret');
//       } catch (e) {
//         debugPrint('evaluateJavaScript error: $e \n $javaScript');
//       }
//     }
//   } else {
//     Utils.showDialog(
//       showBtnClose: true,
//       setContent: () {
//         const _url = 'https://learn.microsoft.com/en-us/microsoft-edge/webview2/concepts/distribution';
//         return RichText(
//             textAlign: TextAlign.center,
//             text: TextSpan(
//               children: [
//                 TextSpan(
//                   text: '请先安装WebView2 Runtime',
//                   style: StyleTheme.font_gray_153_15,
//                 ),
//                 TextSpan(
//                   text: '\n$_url',
//                   style: StyleTheme.font_blue_30_14,
//                   recognizer: TapGestureRecognizer()..onTap = () => Utils.openURL(_url),
//                 ),
//               ],
//             ));
//       },
//     );
//   }
// }
//
// static Future<String> _getWebViewPath() async {
//   final document = await getApplicationDocumentsDirectory();
//   return p.join(
//     document.path,
//     'desktop_webview_window',
//   );
// }

  static Widget btnRed(String text, Function() tap) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: tap,
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 16.w),
          decoration: BoxDecoration(
              color: StyleTheme.red245Color,
              borderRadius: BorderRadius.all(Radius.circular(5.w))),
          child: Text(text, style: StyleTheme.font(size: 14))),
    );
  }

  static Future<ui.Image> getImageInfo(String path) async {
    Image image = Image.file(File(path));
    Completer<ui.Image> completer = Completer<ui.Image>();
    image.image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
    }));
    ui.Image info = await completer.future;
    return info;
  }
}

extension FluroRouterE on BuildContext {
  void pop([dynamic result]) => AppGlobal.appRouter?.pop();
}
