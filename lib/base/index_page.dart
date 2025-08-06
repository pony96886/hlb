import 'dart:io';

import 'package:hlw/base/update_sysalert.dart';
import 'package:hlw/home/home_page.dart';
import 'package:hlw/model/config_model.dart';
import 'package:hlw/past/past_page.dart';
import 'package:hlw/util/app_global.dart';
import 'package:hlw/util/image_request_async.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:hlw/welfare/welfare_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:hlw/base/request_api.dart';
import 'package:flutter_split_view/flutter_split_view.dart';
import 'package:provider/provider.dart';
import "package:universal_html/html.dart" as html;

import '../model/general_ads_model.dart';
import '../model/user_model.dart';
import '../rank/rank_page.dart';
import 'base_store.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int selectIndex = 0;
  bool netError = false;
  bool isHud = true;

  //初始化数据
  _getData() {
    reqConfig(context).then((value) {
      // Utils.log('Config Response: $value');
      if (value?.status == 1) {
        AppGlobal.appBox?.put("lines_url", value?.data?.lines_url);
        AppGlobal.appBox?.put("github_url", value?.data?.github_url);
        AppGlobal.appBox?.put('office_web', value?.data?.office_site);
        reqUserInfo(context).then((res) {
          // Utils.log('UserInfo Response: $res');
          isHud = false;
          netError = false;
          if (res?.status == 1) {
            _clipBoardText();
            _loadSysAlert(value?.data);
          } else {
            netError = true;
            Utils.showText(Utils.txt('hqsbcs'));
          }
          setState(() {});
          reqUserMeun(context).then((value) {
            if (value?.status == 1) {
              AppGlobal.userMenu = value?.data;
            }
          });
        });
        //缓存广告AD
        String? _adurl = value?.data?.adStart?.first?.thumb;
        if (_adurl != null) {
          ImageRequestAsync.getImageRequest(_adurl).then((_) {
            AppGlobal.appBox?.put('adsmap', {
              'image': _adurl,
              'url': value?.data?.adStart?.first?.url_config
            });
          });
        } else {
          AppGlobal.appBox?.put('adsmap', null);
        }
      } else {
        netError = true;
        setState(() {});
      }
    });
  }

  //填写邀请码
  void _clipBoardText() {
    if (kIsWeb) {
      Uri u = Uri.parse(html.window.location.href);
      String? aff = u.queryParameters['hlwpp_aff'];
      if (aff != null) {
        reqInvitation(affCode: aff);
      }
    } else {
      Clipboard.getData(Clipboard.kTextPlain).then((value) {
        if (value?.text != null) {
          List cliptextList = value?.text?.split(":").toList() ?? [];
          if (cliptextList.length > 1) {
            if (cliptextList[0] == 'hlwpp_aff') {
              if (cliptextList[1] != '') {
                reqInvitation(affCode: cliptextList[1]);
              }
            }
          }
        }
      });
    }
  }

  //系统弹窗
  void _loadSysAlert(ConfigModel? data) {
    if (data == null) return;

    if (data.version != null) {
      var targetVersion = data.version?.version?.replaceAll('.', '');
      var currentVersion = AppGlobal.appinfo['version'].replaceAll('.', '');
      var needUpdate =
          int.parse(targetVersion ?? "100") > int.parse(currentVersion);
      if (kIsWeb) {
        //web不需要更新，只展示广告｜公告
        _showActivety(data);
        return;
      }
      //显示规则 版本更新 > AD弹窗 > 系统公告
      if (needUpdate) {
        _updateAlert(data);
      } else {
        _showActivety(data);
      }
    }
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
      cancel: () {
        _showActivety(data);
      },
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

  //公告显示
  void _noticeAlert(ConfigModel? data) {
    if (data?.version?.mstatus == 1) {
      UpdateSysAlert.showAnnounceAlert(
        text: data?.version?.message,
        cancel: () {},
        confirm: () {},
      );
    }
  }

  //显示弹窗
  void _showActivety(ConfigModel? data, {int index = 0}) {
    if (data?.adAlert?.isEmpty == true) return;
    GeneralAdsModel? tp = data?.adAlert?[index];
    UpdateSysAlert.showAvtivetysAlert(
        ad: tp,
        cancel: () {
          if (index == (data?.adAlert?.length ?? 0) - 1) {
            _noticeAlert(data);
          } else {
            _showActivety(data, index: index + 1);
          }
        },
        confirm: () {
          //上报点击量
          reqAdClickCount(id: tp?.id, type: tp?.type);
          Utils.openRoute(context, tp);
        });
  }

  //清理磁盘
  _initClearDisk() async {
    if (kIsWeb) {
      PaintingBinding.instance.imageCache.clear();
      AppGlobal.imageCacheBox?.clear();
      return;
    }
    String path = AppGlobal.imageCacheBox?.path ?? "";
    int size = await File(path).length();
    //大于500M就清理
    if (size / 1000 / 1000 > 500) await AppGlobal.imageCacheBox?.clear();
  }

  @override
  void initState() {
    super.initState();
    _getData();
    _initClearDisk();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.key,
      backgroundColor: StyleTheme.bgColor,
      resizeToAvoidBottomInset: false,
      body: _buildContainerWidget(),
    );
  }

  Widget _buildContainerWidget() {
    if (netError) {
      return LoadStatus.netErrorWork(onTap: () => _getData());
    }
    if (isHud) {
      return LoadStatus.showLoading(mounted, text: Utils.txt('sjcshz'));
    }
    return pcWidget(context);
  }

  Widget pcWidget(BuildContext context) {
    return SplitView.material(
      childWidth: 240.w,
      breakpoint: ScreenWidth - 240.w,
      child: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectIndex = 0;
  ConfigModel? config;

  @override
  void initState() {
    super.initState();
    //等待500毫秒初始化
    Future.delayed(const Duration(milliseconds: 500), () {
      SplitView.of(context).setSecondary(customWidget(context));
    });
  }

  Widget selectMainWidget() {
    switch (_selectIndex) {
      case 1:
        return PastPage(isShow: true);
      case 2:
        return RankPage(isShow: true);
      case 5:
        return const WelfarePage(isShow: true);
      default:
        return const HomePage();
    }
  }

  Widget customWidget(BuildContext context) {
    return selectMainWidget(); // 不要用Expanded包裹
  }

  void _release(BuildContext context) {
    final UserModel? userModel =
        Provider.of<BaseStore>(context, listen: false).user;
    if (userModel?.username?.isEmpty == true) {
      Utils.showDialog(
        width: 385.w,
        height: 260.w,
        padding: EdgeInsets.only(top: 40.w),
        showBtnClose: true,
        setContent: () {
          return Text(
            '注册用户才可以操作，赶快去注册/登录吧！',
            style: StyleTheme.font_gray_102_14,
            maxLines: 2,
          );
        },
        cancelTxt: Utils.txt('dneglu'),
        cancelBoxColor: StyleTheme.black34Color,
        cancelTextColor: Colors.white,
        cancel: () => Utils.navTo(context, "/mineloginpage/true"),
        confirmTxt: Utils.txt('zuche'),
        confirmBoxColor: StyleTheme.gray225Color45,
        confirmTextColor: StyleTheme.gray51Color,
        confirm: () => Utils.navTo(context, "/mineloginpage"),
      );
    } else {
      Utils.navTo(context, '/homeeditorpage');
    }
  }

  @override
  Widget build(BuildContext context) {
    // LogUtil.v('--- ${ScreenWidth} --- ${ScreenHeight} --- ${100.w} ---');
    config = Provider.of<BaseStore>(context, listen: false).config;
    return Scaffold(
      body: Container(
        width: 240.w,
        height: double.infinity,
        color: StyleTheme.black29Color,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        // 避免橫向拉伸
        child: Column(children: [
          SizedBox(height: 50.w),
          GestureDetector(
            // 官網
            behavior: HitTestBehavior.translucent,
            onTap: () {
              final _url = config?.pc_site_url;
              _url != null && _url.isNotEmpty == true
                  ? Utils.openURL(_url)
                  : Utils.showText(Utils.txt('cccwl') + '');
              // Platform.isMacOS ? Utils.openWebViewMacos(PresentationStyle.sheet, _url) : Utils.navTo(context, '/web/$_url');
            },
            child: LocalPNG(
              name: 'hlw_logo',
              width: 84.w,
              height: 50.w,
            ),
          ),
          SizedBox(height: 25.w),
          Expanded(
            child: _buildOperationListWidget(),
          ),
          SizedBox(height: 25.w),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => _release(context),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(27.w),
                color: StyleTheme.orange255Color,
              ),
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                '发帖',
                style: StyleTheme.font_black_0_17,
              ),
            ),
          ),
          SizedBox(height: 50.w), // 87.w
          SizedBox(
            height: 71.w,
            child: Row(
              children: [
                Expanded(
                  child: _BtnLinkWidget(
                    link: config?.client_withdraw_tg,
                    index: 0,
                    image: 'hlw_mine_tg',
                    text: '官方社群',
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _BtnLinkWidget(
                    link: config?.official_twitter,
                    index: 1,
                    image: 'hlw_twitter',
                    text: '官方twitter',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.w),
        ]),
      ),
    );
  }

  Widget _buildOperationListWidget() {
    int len = 7;
    if (config?.client_forum_bbs?.isEmpty ?? true) len = 6;
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(0, 25.w, 0, 25.w),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: len,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 200 / 44,
        crossAxisCount: 1,
        mainAxisSpacing: 10.w,
      ),
      itemBuilder: _buildOperationItemWidget,
    );
  }

  Widget _buildOperationItemWidget(context, int index) {
    Decoration? decoration;
    String text;
    String icon;
    String link = '';
    TextStyle style = _selectIndex == index
        ? StyleTheme.font_white_255_13
        : StyleTheme.font_gray_204_13;
    switch (index) {
      case 0: // 首页
        text = '首页';
        icon = 'hlw_tab_home${_selectIndex == index ? '_h' : ''}';
        break;
      case 1: // 黑料大事记
        text = '黑料大事记';
        icon = 'hlw_tab_past${_selectIndex == index ? '_h' : ''}';
        break;
      case 2: // 黑料热点排行
        text = '黑料热点排行';
        icon = 'hlw_tab_rank${_selectIndex == index ? '_h' : ''}';
        break;
      case 3: // 黑料官方APP
        text = '黑料官方APP';
        icon = 'hlw_tab_download';
        link = config?.office_site ?? '';
        break;
      case 4: // 黑料官方微信QQ群
        text = '黑料官方微信QQ群';
        icon = 'hlw_tab_group';
        link = config?.official_wx ?? '';
        break;
      case 5: // 黑料精品福利站
        text = '黑料精品福利站';
        icon = 'hlw_tab_welfare${_selectIndex == index ? '_h' : ''}';
        break;
      case 6: // 黑料官方论坛
        text = '黑料官方论坛';
        icon = 'hlw_tab_forum';
        link = config?.client_forum_bbs ?? '';
        break;
      default:
        text = '测试天';
        icon = 'hlw_tab_forum'; // 仅仅占位
    }

    Widget current = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        LocalPNG(name: icon, width: 20.w, height: 20.w),
        SizedBox(width: 10.w),
        Text(text, style: style)
      ],
    );

    if (_selectIndex == index) {
      decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(12.w),
        color: StyleTheme.gray51Color,
      );
    }

    current = Container(
      padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 10.w),
      height: 44.w,
      alignment: Alignment.center,
      decoration: decoration,
      child: current,
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (mounted) setState(() => _selectIndex = index);
        SplitView.of(context).setSecondary(customWidget(context));
        link.isNotEmpty ? Utils.openURL(link) : null;
      },
      child: current,
    );
  }
}

class _BtnLinkWidget extends StatelessWidget {
  final String? link;
  final int index;
  final String image;
  final String text;
  const _BtnLinkWidget({
    Key? key,
    required this.link,
    required this.index,
    required this.image,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        link != null && link?.isNotEmpty == true
            ? Utils.openURL(link!)
            : Utils.showText(Utils.txt('cccwl') + '');
        // final _url = link!;
        // Platform.isMacOS ? Utils.openWebViewMacos(PresentationStyle.sheet, _url) : Utils.navTo(context, '/web/$_url');
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: StyleTheme.gray51Color, width: 1.w),
          borderRadius: BorderRadius.all(Radius.circular(10.w)),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LocalPNG(name: image, width: 24.w, height: 24.w),
            SizedBox(height: 8.w),
            Text(text, style: StyleTheme.font_white_255_12),
          ],
        ),
      ),
    );
  }
}
