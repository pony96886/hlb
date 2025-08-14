import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:hlw/base/base_store.dart';
import 'package:hlw/base/startup_page.dart';
import 'package:hlw/util/app_global.dart';
import 'package:hlw/util/certificate.dart';
import 'package:hlw/util/go_routers.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:worker_manager/worker_manager.dart';
import 'package:isolated_worker/js_isolated_worker.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  //让初始化执行完再执行下一步
  await _initData(args);

  HttpOverrides.global = MyHttpOverrides();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => BaseStore()),
    ],
    child: const RootPage(),
  ));
  await _initPCSize();
  Utils.setStatusBar();
}

//初始化PC版本尺寸大小
Future<void> _initPCSize() async {
  if (Platform.isMacOS || Platform.isWindows) {
    doWhenWindowReady(() {
      final win = appWindow;
      const initialSize = Size(1920 * 0.75, 1080 * 0.75);
      // const initialSize = Size(960, 540);
      // const initialSize = Size(1280, 800);
      win.minSize = initialSize;
      win.size = initialSize;
      win.alignment = Alignment.center;
      win.title = "黑料网";
      win.show();
    });
  }
}

Future<void> _initData(List<String> args) async {
  // 初始化数据库，必须放在最前面
  await Hive.initFlutter();
  // await Hive.deleteBoxFromDisk('hlwbox');
  AppGlobal.appBox = await Hive.openBox('hlwbox'); // 用于存储一些简单的键值对

  AppGlobal.imageCacheBox = await Hive.openBox('hlwbox_ImageCache'); //图片缓存
  //注册图片线程
  await Executor().warmUp();
  if (kIsWeb) {
    AppGlobal.isRegisterJs = await JsIsolatedWorker().importScripts([
      'js/aware.js?v=2',
      'https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.1/crypto-js.min.js?v=2'
    ]);
  }
  // 初始化APP基础信息
  AppGlobal.apiToken = AppGlobal.appBox?.get('hlw_token') ?? "";
  AppGlobal.appinfo = {
    "oauth_id": AppGlobal.appBox?.get('oauth_id') ??
        Utils.toMD5(
            '${Utils.randomId(16)}_${DateTime.now().millisecondsSinceEpoch.toString()}'),
    "bundleId": "com.pwa.hlw",
    "version": "1.2.0",
    "oauth_type": "web",
    "language": 'zh',
    "via": 'pwa',
  };
  //设备ID统一32位
  if (!kIsWeb) {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      AppGlobal.appinfo = {
        "oauth_id": Utils.toMD5(androidInfo.fingerprint),
        "bundleId": packageInfo.packageName,
        "version": packageInfo.version,
        "oauth_type": "android",
      };
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      AppGlobal.appinfo = {
        "oauth_id": Utils.toMD5(iosInfo.identifierForVendor ?? ""),
        "bundleId": packageInfo.packageName,
        "version": packageInfo.version,
        "oauth_type": "ios",
      };
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo macInfo = await deviceInfo.macOsInfo;
      AppGlobal.appinfo = {
        "oauth_id": Utils.toMD5(macInfo.systemGUID ?? ""),
        "bundleId": packageInfo.packageName,
        "version": packageInfo.version,
        "oauth_type": "macos",
      };
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      AppGlobal.appinfo = {
        "oauth_id": Utils.toMD5(windowsInfo.deviceId),
        "bundleId": packageInfo.packageName,
        "version": packageInfo.version,
        "oauth_type": "windows",
      };
    }
  } else {
    AppGlobal.appBox?.put('oauth_id', AppGlobal.appinfo['oauth_id']);
  }

  //本地JSON初始化
  await Utils.loadJSON();

  //初始化路由
  AppGlobal.appRouter = GoRouters.init();
}

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (context) =>
                    Utils.isPC ? pcWidget(context) : clientWidget(),
              ),
            ],
          );
        });
  }

  //mac and windows init widegt
  Widget pcWidget(BuildContext context) {
    final botToastBuilder = BotToastInit();
    //final win = appWindow;
    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      builder: (context, child) => MaterialApp(
        // localeListResolutionCallback: (locales, supportedLocales) {
        //   return const Locale('zh');
        // },
        // localeResolutionCallback: (locale, supportedLocales) {
        //   return const Locale('zh');
        // },
        // localizationsDelegates: const [
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        //   GlobalCupertinoLocalizations.delegate,
        // ],
        // supportedLocales: const [
        //   Locale('zh', 'CH'),
        //   Locale('en', 'US'),
        // ],
        debugShowCheckedModeBanner: false,
        builder: (context, widget) {
          widget = botToastBuilder(context, widget);
          widget = MediaQuery(
            //设置文字大小不随系统设置改变
            data: MediaQuery.of(context).copyWith(
                textScaleFactor: 1.0,
                gestureSettings: const DeviceGestureSettings()),
            child: widget,
          );
          return widget;
        },
        title: Utils.txt("apbt"),
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          scrollbarTheme: const ScrollbarThemeData().copyWith(
            radius: Radius.circular(5.w),
            thumbColor: MaterialStateProperty.all(StyleTheme.gray229Color),
          ),
          primarySwatch: const MaterialColor(
            0xFFFFFFFF, //
            <int, Color>{
              50: Color(0xFFFFFFFF),
              100: Color(0xFFFFFFFF),
              200: Color(0xFFFFFFFF),
              300: Color(0xFFFFFFFF),
              400: Color(0xFFFFFFFF),
              500: Color(0xFFFFFFFF),
              600: Color(0xFFFFFFFF),
              700: Color(0xFFFFFFFF),
              800: Color(0xFFFFFFFF),
              900: Color(0xFFFFFFFF),
            },
          ),
        ),
        initialRoute: "/",
        home: const StartupPage(),
      ),
    );
  }

  //pwa android and ios
  Widget clientWidget() {
    final botToastBuilder = BotToastInit();
    return ScreenUtilInit(
      designSize: const Size(375, 667),
      builder: (context, child) => MaterialApp.router(
        // localeListResolutionCallback: (locales, supportedLocales) {
        //   return const Locale('zh');
        // },
        // localeResolutionCallback: (locale, supportedLocales) {
        //   return const Locale('zh');
        // },
        // localizationsDelegates: const [
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        //   GlobalCupertinoLocalizations.delegate,
        // ],
        // supportedLocales: const [
        //   Locale('zh', 'CH'),
        //   Locale('en', 'US'),
        // ],
        debugShowCheckedModeBanner: false,
        builder: (context, widget) {
          widget = botToastBuilder(context, widget);
          widget = MediaQuery(
            //设置文字大小不随系统设置改变
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget,
          );
          return widget;
        },
        title: Utils.txt("apbt"),
        theme: ThemeData(
          scaffoldBackgroundColor: StyleTheme.bgColor,
          primarySwatch: const MaterialColor(
            0xFF000000, //
            <int, Color>{
              50: Color(0xFF000000),
              100: Color(0xFF000000),
              200: Color(0xFF000000),
              300: Color(0xFF000000),
              400: Color(0xFF000000),
              500: Color(0xFF000000),
              600: Color(0xFF000000),
              700: Color(0xFF000000),
              800: Color(0xFF000000),
              900: Color(0xFF000000),
            },
          ),
        ),
        routeInformationParser: AppGlobal.appRouter!.routeInformationParser,
        routerDelegate: AppGlobal.appRouter!.routerDelegate,
        routeInformationProvider: AppGlobal.appRouter!.routeInformationProvider,
      ),
    );
  }
}
