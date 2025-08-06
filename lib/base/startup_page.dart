import 'dart:async';

import 'package:hlw/base/index_page.dart';
import 'package:hlw/util/app_global.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/netimage_tool.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hlw/util/desktop_extension.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({Key? key}) : super(key: key);

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  DateTime? lastPopTime;
  Map? adsmap = AppGlobal.appBox?.get('adsmap');
  String weburl = AppGlobal.appBox?.get('office_web') ?? "";
  int count = 6;
  int startIndex = 0;
  bool isCheck = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    checkLines();
  }

  /// 加载AD图
  Widget startLaunchPNG() {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (adsmap?['url'] == '' || adsmap?['url'] == null) return;
            //上报点击量
            // reqAdClickCount(id: adsmap?['id'], type: adsmap?['type']);
            Utils.openURL(adsmap?['url']);
          },
          child: Center(
            child: NetImageTool(url: adsmap?['image'], fit: BoxFit.fitHeight),
          ),
        ),
        Positioned(
          top: StyleTheme.topHeight + 10.w,
          right: 15.w,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (count > 0) return;
              adsmap = null;
              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 15.w),
              height: 35.w,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 0, 0, 0.5),
                borderRadius: BorderRadius.circular(35.w),
              ),
              child: Center(
                child: Text(
                  '${count > 0 ? count : Utils.txt('tggg')}',
                  style: StyleTheme.font(size: 15, weight: FontWeight.w500),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void adsWatch() {
    if (adsmap == null) {
      setState(() {});
      return;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (count <= 0) {
        timer.cancel();
        return;
      }
      count--;
      setState(() {});
    });
  }

  void checkLines() {
    /// 检测线路
    Utils.checkline(
      onFailed: () {
        isCheck = false;
        setState(() {});
      },
      onSuccess: () {
        if (startIndex == 0) {
          startIndex = 1;
          adsWatch();
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppGlobal.context = context;
    return WillPopScope(
        child: Scaffold(
          backgroundColor: StyleTheme.bgColor,
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Utils.unFocusNode(context);
            },
            child: AppGlobal.apiBaseURL.isEmpty
                ? _WebWidget(
                    isCheck: isCheck, webUrl: weburl, checkLines: checkLines)
                : adsmap is! Map
                    ? IndexPage(key: ValueKey(adsmap))
                    : startLaunchPNG(),
          ),
        ),
        onWillPop: () async {
          //点击返回键的操作
          if (lastPopTime == null ||
              DateTime.now().difference(lastPopTime!) >
                  const Duration(seconds: 2)) {
            lastPopTime = DateTime.now();
            Utils.showText(Utils.txt('zatck'));
            return false;
          } else {
            lastPopTime = DateTime.now();
            await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            return true;
          }
        });
  }
}

class _WebWidget extends StatelessWidget {
  final bool isCheck;
  final String webUrl;
  final Function checkLines;
  const _WebWidget(
      {Key? key,
      required this.isCheck,
      this.webUrl = '',
      required this.checkLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isCheck
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Utils.txt('jcxlsd'),
                  style:
                      StyleTheme.font(size: 14, color: StyleTheme.gray204Color),
                ),
                SizedBox(height: 20.w),
                Visibility(
                  visible: webUrl.isNotEmpty,
                  child: GestureDetector(
                  onTap: () {
                    Utils.openURL(webUrl);
                  },
                  child: Text(
                    Utils.txt('gwdzdz') + '：$webUrl',
                    style: StyleTheme.font_orange_255_14,
                    maxLines: 3,
                    ),
                  )
                ),
              ],
            )
          : LoadStatus.netErrorWork(
              text: Utils.txt('wfljqsz'),
              onTap: () {
                checkLines();
              }),
    );
  }
}
