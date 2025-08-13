import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hlw/base/base_main_view.dart';
import 'package:hlw/base/base_widget.dart';
import 'package:hlw/model/user_model.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../base/base_store.dart';

class HomeInviteFriends extends BaseWidget {
  const HomeInviteFriends({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> cState() {
    return _HomeInviteFriendsState();
  }
}

typedef GetLockParentWindow = Function(bool getLockParentWindow);

class _HomeInviteFriendsState extends BaseWidgetState<HomeInviteFriends> {
  bool _lockParentWindow = false;
  final GlobalKey _globalKey = GlobalKey();

  @override
  void onCreate() {}

  @override
  Widget appbar() {
    // TODO: implement appbar
    return Container();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  void saveImgShare() async {
    // 有彈窗但是儲存沒效果
    // Utils.log('DateTime:${DateTime.now()}  ${DateTime.now().toIso8601String()}  ${DateTime.now().toLocal().toString()}');
    // final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    // Map<String, dynamic> map = {};
    // if (Platform.isWindows) {
    //   map = UtilsDeviceInfo.readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo);
    //   _directoryName = '/C:/Users/${map['hostName']}/Pictures';
    // } else if (Platform.isMacOS) {
    //   map = UtilsDeviceInfo.readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo);
    //   _directoryName = '/Users/${map['hostName']}/Pictures';
    // }
    // final String? file = await FilePicker.platform.saveFile(
    //     dialogTitle: '请选择资料夹',
    //     fileName: '${DateTime.now()}.png',
    //     type: FileType.image, initialDirectory: _directoryName,
    //     lockParentWindow: _lockParentWindow
    // );
    Utils.showText(Utils.txt('zxjt'));
    setState(() {
      _lockParentWindow = false;
    });
  }

  Widget _shareView(UserModel? userModel) {
    return RepaintBoundary(
      key: _globalKey,
      child: Container(
        width: 540.w,
        height: ScreenHeight - 74.w,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 50.w),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        offset: const Offset(0, 0),
                        blurRadius: 8.w,
                        spreadRadius: 0.w),
                  ],
                  border: Border.all(color: Colors.transparent),
                  borderRadius: BorderRadius.all(Radius.circular(10.w))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 58.w,
                      width: 58.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: StyleTheme.gray238Color, width: 1.w),
                          borderRadius: BorderRadius.all(Radius.circular(5.w))),
                      child: LocalPNG(
                        name: "hlw_scan",
                        width: 24.w,
                        height: 24.w,
                      ),
                    ),
                  ),
                  SizedBox(height: 19.w),
                  Text(
                    '扫码下载黑料网',
                    style: StyleTheme.font_black_34_27,
                  ),
                  SizedBox(height: 5.w),
                  Text(
                    '看爆料吃热瓜，每日热更，全网首发',
                    style: StyleTheme.font_gray_102_17,
                  ),
                  SizedBox(height: 20.w),
                  Container(
                    width: 240.w,
                    height: 240.w,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5.w),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: StyleTheme.gray238Color, width: 1.w),
                        borderRadius: BorderRadius.all(Radius.circular(10.w))),
                    child: QrImage(
                      data: '${userModel?.share?.share_url}',
                      version: 3,
                      size: double.infinity,
                    ),
                  ),
                  SizedBox(height: 30.w),
                  Container(
                    width: 336.w,
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Container(
                          height: 1.w,
                          width: 120.w,
                          color: StyleTheme.gray238Color,
                        ),
                        Expanded(child: Container()),
                        Text(
                          '我的推广码',
                          style: StyleTheme.font_black_68_15,
                        ),
                        Expanded(child: Container()),
                        Container(
                          height: 1.w,
                          width: 120.w,
                          color: StyleTheme.gray238Color,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.w),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(text: '${userModel?.share?.aff_code}'));
                      Utils.showText(Utils.txt('fzcg') + '');
                    },
                    child: Container(
                      width: 286.w,
                      height: 40.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: StyleTheme.gray238Color, width: 1.w),
                          borderRadius:
                              BorderRadius.all(Radius.circular(2.5.w))),
                      child: Text(
                        '${userModel?.share?.aff_code!}',
                        style: StyleTheme.font_black_34_15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.w),
          ],
        ),
      ),
      // Column(
      //   children: [
      //     SizedBox(height: ScreenUtil().setWidth(242)),
      //     Container(
      //       width: ScreenUtil().setWidth(225),
      //       height: ScreenUtil().setWidth(275),
      //       decoration: BoxDecoration(
      //         color: const Color(0x9923262f),
      //         borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
      //       ),
      //       child: Column(
      //         children: [
      //           SizedBox(height: ScreenUtil().setWidth(15)),
      //           SizedBox(
      //             height: ScreenUtil().setWidth(51),
      //             child: RichText(
      //               text: TextSpan(
      //                 text: Utils.txt('wdggm'),
      //                 style: TextStyle(
      //                   color: const Color.fromRGBO(255, 255, 255, 1),
      //                   fontSize: ScreenUtil().setSp(16.5),
      //                   // fontWeight: FontWeight.bold,
      //                 ),
      //                 children: <TextSpan>[
      //                   const TextSpan(text: '  '),
      //                   TextSpan(
      //                       text: '${Provider.of<BaseStore>(context, listen: false).user?.share?.aff_code!}',
      //                       style: TextStyle(
      //                           color: const Color(0xff50edff),
      //                           fontSize: ScreenUtil().setSp(25.3),
      //                           fontWeight: FontWeight.w600)
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //           Container(
      //             color: Colors.white,
      //             width: ScreenUtil().setWidth(189.5),
      //             height: ScreenUtil().setWidth(189.5),
      //             child: QrImage(
      //               data: '${userModel?.share?.share_url!}',
      //               version: 3,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //     SizedBox(height: ScreenUtil().setWidth(44)),
      //     Text(
      //       Utils.txt('gwdz') + '：url',
      //       style: TextStyle(
      //           color: Colors.white,
      //           decoration: TextDecoration.none,
      //           fontSize: ScreenUtil().setSp(19),
      //           fontWeight: FontWeight.w600),
      //     ),
      //     SizedBox(height: ScreenUtil().setWidth(11)),
      //     Text(
      //       Utils.txt('qwsy'),
      //       style: TextStyle(
      //         color: Colors.white,
      //         decoration: TextDecoration.none,
      //         height: 1.4,
      //         fontWeight: FontWeight.normal,
      //         fontSize: ScreenUtil().setSp(13),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  @override
  Widget pageBody(BuildContext context) {
    final UserModel? userModel =
        Provider.of<BaseStore>(context, listen: false).user;
    return BaseMainView(
      paddingTop: 84.w,
      paddingLeft: 100.w,
      isBackBtn: true,
      backTitle: '邀请好友',
      leftWidget: SingleChildScrollView(
        // child: Stack(
        //   children: [
        //     _shareView(userModel),
        child: SizedBox(
          width: 560.w,
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10.w),
              _ScanView(userModel: userModel),
              SizedBox(height: 40.w),
              _BtnView(
                lockParentWindow: _lockParentWindow,
                saveImgShare: saveImgShare,
                getLockParentWindow: (bool getLockParentWindow) =>
                    setState(() => _lockParentWindow = getLockParentWindow),
              ),
              SizedBox(height: 42.w),
              const _StepView(),
            ],
          ),
        ),
        //   ],
        // ),
      ),
    );
  }
}

class _ScanView extends StatelessWidget {
  final UserModel? userModel;
  const _ScanView({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 540.w,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 50.w, horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8.w),
        ],
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 58.w,
              width: 58.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: StyleTheme.gray238Color, width: 1.w),
                borderRadius: BorderRadius.all(Radius.circular(5.w)),
              ),
              child: LocalPNG(name: "hlw_scan", width: 24.w, height: 24.w),
            ),
          ),
          SizedBox(height: 19.w),
          Text(
            '扫码下载黑料网',
            style: StyleTheme.font_black_34_27,
          ),
          SizedBox(height: 5.w),
          Text(
            '看爆料吃热瓜，每日热更，全网首发',
            style: StyleTheme.font_gray_102_17,
          ),
          SizedBox(height: 20.w),
          Container(
            width: 240.w,
            height: 240.w,
            alignment: Alignment.center,
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: StyleTheme.gray238Color, width: 1.w),
              borderRadius: BorderRadius.all(Radius.circular(10.w)),
            ),
            child: QrImage(
              data: '${userModel?.share?.share_url}',
              version: 3,
              size: double.infinity,
            ),
          ),
          SizedBox(height: 30.w),
          Container(
            width: ScreenWidth * 0.2625,
            alignment: Alignment.center,
            child: Row(
              children: [
                Container(
                  height: 1.w,
                  width: 120.w,
                  color: StyleTheme.gray238Color,
                ),
                Expanded(child: Container()),
                Text(
                  '我的推广码',
                  style: StyleTheme.font_black_68_15,
                ),
                Expanded(child: Container()),
                Container(
                  height: 1.w,
                  width: 120.w,
                  color: StyleTheme.gray238Color,
                ),
              ],
            ),
          ),
          SizedBox(height: 10.w),
          GestureDetector(
            onTap: () {
              Clipboard.setData(
                  ClipboardData(text: '${userModel?.share?.aff_code}'));
              Utils.showText(Utils.txt('fzcg') + '');
            },
            child: Container(
              width: 286.w,
              height: 40.w,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: StyleTheme.gray238Color, width: 1.w),
                          borderRadius:
                              BorderRadius.all(Radius.circular(2.5.w))),
                      child: Text(
                        '${userModel?.share?.aff_code!}',
                        style: StyleTheme.font_black_34_15,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    width: 40.w,
                    height: 40.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: StyleTheme.orange255Color,
                        borderRadius: BorderRadius.all(Radius.circular(10.w))),
                    child: LocalPNG(
                      name: "hlw_copy",
                      width: 20.w,
                      height: 20.w,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BtnView extends StatelessWidget {
  final bool lockParentWindow;
  final Function saveImgShare;
  final GetLockParentWindow getLockParentWindow;
  const _BtnView(
      {Key? key,
      required this.lockParentWindow,
      required this.saveImgShare,
      required this.getLockParentWindow})
      : super(key: key);

  Widget _btnDouble(String text, Color color, bool loading) {
    return Container(
      width: 200.w,
      height: 54.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(27.w))),
      child: Text(
        text,
        style: StyleTheme.font_white_255_17,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 54.w,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: lockParentWindow
                ? null
                : () {
                    getLockParentWindow(true);
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      saveImgShare();
                    });
                  },
            child:
                _btnDouble('截图保存', StyleTheme.black34Color, lockParentWindow),
          ),
          Expanded(child: Container()),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(
                  text:
                      '${Provider.of<BaseStore>(context, listen: false).user?.share?.share_url}'));
              Utils.showText(Utils.txt('fzcg') + '');
            },
            child:
                _btnDouble('复制链接', StyleTheme.orange255Color, lockParentWindow),
          ),
        ],
      ),
    );
  }
}

class _StepView extends StatelessWidget {
  const _StepView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('邀请步骤', style: StyleTheme.font_black_34_27),
        SizedBox(height: 15.w),
        Text('第一步', style: StyleTheme.font_black_34_17),
        SizedBox(height: 5.w),
        Text('点击【保存图片】或【复制链接】', style: StyleTheme.font_gray_102_14_40),
        SizedBox(height: 20.w),
        Text('第二步', style: StyleTheme.font_black_34_17),
        SizedBox(height: 5.w),
        Text('将图片或链接通过各种渠道发送出去', style: StyleTheme.font_gray_102_14_40),
        SizedBox(height: 10.w),
        LocalPNG(name: 'hlw_share_app', width: 516.w, height: 86.w),
        SizedBox(height: 10.w),
        LocalPNG(name: 'hlw_share_game', width: 516.w, height: 86.w),
        SizedBox(height: 30.w),
      ],
    );
  }
}
