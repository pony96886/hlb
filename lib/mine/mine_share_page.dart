import 'dart:io';

import 'package:flutter/cupertino.dart';
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
import 'package:hlw/widget/search_bar_widget.dart';
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
    final Widget shareTitle = LocalPNG(
      name: "share_title",
      width: 460.w,
      height: 60.w,
      fit: BoxFit.fill,
    );
    return Stack(
      children: [
        LocalPNG(
          fit: BoxFit.cover,
          name: "share_bg",
          width: double.infinity,
        ),
        Positioned(
          top: 90.w,
          bottom: 0,
          left: 0,
          right: 0,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 30.w),
            child: Column(
              children: [
                shareTitle,
                SizedBox(
                  height: 36.w,
                ),
                Text(
                  "一起学会分享，一起来看漫画，一起来看小说",
                  style: StyleTheme.font_white_255_22_600,
                ),
                SizedBox(
                  height: 52.w,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _build_left(),
                    SizedBox(
                      width: 100.w,
                    ),
                    _build_right()
                  ],
                )
              ],
            ),
          ),
        ),
        SearchBarWidget(isBackBtn: true, backTitle: Utils.txt('fx')),
      ],
    );
  }

  Widget _build_right() {
    return LocalPNG(
      name: "hlw_share_right",
      width: 458.w,
      height: 681.w,
    );
  }

  Widget _build_left() {
    return SizedBox(
      height: 681.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 500.w,
            decoration: BoxDecoration(
              color: StyleTheme.white20,
              borderRadius: BorderRadius.circular(18.w),
            ),
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.w),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: "我的推广码 ",
                              style: StyleTheme.font_white_255_28),
                          TextSpan(
                              text: "GSSD",
                              style: StyleTheme.font_orange_244_28_600)
                        ],
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: StyleTheme.black0Color,
                          width: 1.w,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.w),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      LocalPNG(
                        name: "share_qrcode_border",
                        width: 360.w,
                        height: 360.w,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: QrImage(
                          data: '${member?.share?.share_url}',
                          backgroundColor: Colors.white,
                          version: 3,
                          size: 312.w,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              ActionShareButton(
                text: Utils.txt('bctp'),
                onTap: isSaving
                    ? null
                    : () {
                        isSaving = true;
                        setState(() {});
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          _saveImgShare();
                        });
                      },
                isLoadding: isSaving,
              ),
              SizedBox(
                width: 40.w,
              ),
              ActionShareButton(
                text: Utils.txt('fzlj'),
                onTap: _copyLinkShare,
                isLoadding: false,
              ),
            ],
          )
        ],
      ),
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
        height: 72.w,
        width: 230.w,
        alignment: Alignment.center,
        decoration: image == null
            ? BoxDecoration(
                color: StyleTheme.orange47Color,
                borderRadius: BorderRadius.circular(40.w),
                border: Border.all(
                  color: StyleTheme.orange244Color,
                  width: 1.w,
                ),
              )
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
                  style: StyleTheme.font_orange_244_26_medium,
                ),
        ),
      ),
    );
  }
}
