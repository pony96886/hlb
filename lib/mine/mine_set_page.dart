import 'dart:io';

import 'package:hlw/base/base_main_view.dart';
import 'package:hlw/base/base_store.dart';
import 'package:hlw/base/base_widget.dart';
import 'package:hlw/base/request_api.dart';
import 'package:hlw/base/update_sysalert.dart';
import 'package:hlw/mine/mine_bind_email_page.dart';
import 'package:hlw/model/config_model.dart';
import 'package:hlw/model/user_model.dart';
import 'package:hlw/util/app_global.dart';
import 'package:hlw/util/eventbus_class.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/netimage_tool.dart';
import 'package:hlw/util/network_http.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:provider/provider.dart';

class MineSetPage extends BaseWidget {
  MineSetPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _MineSetPageState();
  }
}

class _MineSetPageState extends BaseWidgetState<MineSetPage> {
  String? fileUrl;

  @override
  void onCreate() {}

  @override
  Widget appbar() {
    return Container();
  }

  //版本更新
  void _updateAlert(ConfigModel? data) {
    UpdateSysAlert.showUpdateAlert(
      site: () {
        Utils.openURL(data?.office_site ?? "");
      },
      guide: () {
        Utils.openURL(data?.solution ?? "");
      },
      cancel: () {},
      confirm: () {
        if (Platform.isAndroid) {
          UpdateSysAlert.androidUpdateAlert(
              version: data?.version?.version, url: data?.version?.apk);
        } else {
          Utils.openURL(data?.version?.apk ?? "");
        }
      },
      version: "V${data?.version?.version}",
      text: data?.version?.tips,
      mustupdate: data?.version?.must == 1,
    );
  }

  @override
  void onDestroy() {}

  Future<void> imagePickerAssets() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      PlatformFile file = result.files.first;
      bool flag = await Utils.pngLimitSize(file);
      if (flag) return;
      uploadFileImg(file);
    } else {
      // User canceled the picker
    }
  }

  void uploadFileImg(PlatformFile file) async {
    Utils.startGif(tip: Utils.txt('scz'));
    var data;
    if (kIsWeb) {
      data = await NetworkHttp.xfileHtmlUploadImage(
          file: file, position: 'upload');
    } else {
      data = await NetworkHttp.xfileUploadImage(file: file, position: 'upload');
    }
    if (data['code'] == 1) {
      var newImagePath = data['msg'];
      var result = await reqUpdateUserInfo(thumb: newImagePath);
      Utils.closeGif();
      if (result?.status == 1) {
        if (!kIsWeb) fileUrl = file.path;
        UserModel? user = Provider.of<BaseStore>(context, listen: false).user;
        user?.thumb = AppGlobal.imgBaseUrl + newImagePath;
        if (user != null) {
          Provider.of<BaseStore>(context, listen: false).setUser(user);
        }
        setState(() {});
      } else {
        Utils.showText(result?.msg ?? "");
      }
    } else {
      Utils.closeGif();
      Utils.showText(data['msg'] ?? "failed");
    }
  }

  void showImagePicker() {
    imagePickerAssets();
  }

  void _bindEmail() {
    UserModel? tp = Provider.of<BaseStore>(context, listen: false).user;
    if (tp?.email?.isNotEmpty ?? false) {
      Utils.showText('您已绑定了邮箱');
      return;
    }
    Utils.showDialog(
      width: 500.w,
      height: 350.w,
      padding: EdgeInsets.only(top: 40.w, left: 20.w, right: 20.w),
      backgroundColor: Colors.white,
      showBtnClose: true,
      title: '绑定邮箱',
      cancelTxt: null,
      confirmTxt: null,
      customWidget: (void Function()? cancel) => SizedBox(
        width: 500.w,
        height: 245.w,
        child: MineBindEmailPage(callback: () {
          cancel?.call();
          if (mounted) setState(() {});
        }),
      ),
    );
  }

  @override
  Widget pageBody(BuildContext context) {
    final UserModel? user = Provider.of<BaseStore>(context, listen: true).user;
    final bool isLogin = AppGlobal.apiToken.isNotEmpty;
    return BaseMainView(
      paddingTop: 94.w,
      paddingLeft: 100.w,
      paddingBottom: 50.w,
      rightPadding: 0,
      isBackBtn: true,
      backTitle: '设置',
      leftWidget: SingleChildScrollView(
        child: SizedBox(
          height: ScreenHeight - 94.w - 50.w,
          width: 440.w,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Column(children: [
                  SizedBox(height: 20.w),
                  _BtnUpload(userModel: user, showImagePicker: showImagePicker),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 27.w),
                    child: Column(children: [
                      _Item(
                        title: Utils.txt('pnch'),
                        rightText: user?.nickname ?? "",
                        onTap: () => Utils.navTo(
                          context,
                          "/mineupdatepage/nickname/${Utils.txt('pnch')}",
                        ),
                      ),
                      _Item(
                          title: Utils.txt('dgqbb'),
                          rightText: '${AppGlobal.appinfo['version']}',
                          onTap: () {
                            ConfigModel? cf =
                                Provider.of<BaseStore>(context, listen: false)
                                    .config;
                            var targetVersion =
                                cf?.version?.version?.replaceAll('.', '');
                            var currentVersion = AppGlobal.appinfo['version']
                                .replaceAll('.', '');
                            var needUpdate = int.parse(targetVersion ?? "100") >
                                int.parse(currentVersion);
                            if (kIsWeb) {
                              //web不需要更新
                              Utils.openURL(cf?.office_site ?? "");
                              return;
                            }
                            if (needUpdate) {
                              _updateAlert(cf);
                            } else {
                              Utils.showText('您当前已是最新版本');
                            }
                          }),
                      _Item(
                          title: '清除缓存',
                          rightText: '',
                          onTap: () async {
                            reqClearCached();
                            if (kIsWeb) {
                              PaintingBinding.instance.imageCache.clear();
                            }
                            await AppGlobal.imageCacheBox?.clear();
                            Utils.showText(Utils.txt('qhcg'));
                          }),
                      _Item(
                        title: '绑定邮箱',
                        rightText: user?.email ?? '',
                        onTap: () => _bindEmail(),
                      ),
                    ]),
                  ),
                ]),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _BtnExit(isLogin: isLogin)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String? title;
  final String? rightText;
  final Function? onTap;
  const _Item(
      {Key? key,
      required this.title,
      required this.rightText,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 18.w),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title ?? "",
                  style: StyleTheme.font_gray_153_20,
                ),
                Expanded(child: Container()),
                rightText != null
                    ? Text(
                        rightText!,
                        key: ValueKey(rightText),
                        style: StyleTheme.font_white_255_20,
                        textAlign: TextAlign.right,
                      )
                    : Container(),
                SizedBox(
                  width: 10.w,
                ),
                LocalPNG(
                  name: '51_mine_arrow',
                  width: 20.w,
                  height: 20.w,
                  color: Colors.grey,
                ),
              ],
            ),
            SizedBox(height: 15.w),
            Divider(
              color: StyleTheme.white10 ,
              height: 1.w,
            ),
          ],
        ),
      ),
    );
  }
}

class _BtnUpload extends StatelessWidget {
  final UserModel? userModel;
  final Function() showImagePicker;
  const _BtnUpload(
      {Key? key, required this.userModel, required this.showImagePicker})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showImagePicker();
      },
      child: SizedBox(
        width: 120.w,
        height: 120.w,
        child: Stack(
          children: [
            NetImageTool(
              url: userModel?.thumb ?? "",
              radius: BorderRadius.all(Radius.circular(60.w)),
            ),
            Align(
              alignment: Alignment.center,
              child: LocalPNG(
                name: 'hlw_mine_upload',
                width: 30.w,
                height: 30.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BtnExit extends StatelessWidget {
  final bool isLogin;
  const _BtnExit({Key? key, required this.isLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isLogin,
      child: GestureDetector(
        onTap: () {
          Utils.startGif(tip: Utils.txt('tuichz'));
          reqClearCached().then((_) {
            AppGlobal.apiToken = '';
            AppGlobal.appBox?.delete('hlw_token');
            reqUserInfo(context).then((_) {
              Utils.closeGif();
              UtilEventbus().fire(EventbusClass({"login": "login"}));
              Navigator.pop(context);
              // UtilEventbus().fire(EventbusClass({"name": "rightBanner"}));
            });
          });
        },
        child: Container(
          height: 54.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: StyleTheme.black34Color,
              borderRadius: BorderRadius.all(Radius.circular(10.w))),
          child: Text(
            Utils.txt('tcdl'),
            style: StyleTheme.font_white_255_17,
          ),
        ),
      ),
    );
  }
}
