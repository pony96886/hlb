import 'dart:async';
import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:hlw/base/update_sysalert.dart';
import 'package:hlw/history/history_index_page.dart';
import 'package:hlw/home/home_page.dart';
import 'package:hlw/hotDiscussion/hot_discussion_index_page.dart';
import 'package:hlw/jinxuan/welfare_page.dart';
import 'package:hlw/mine/mine_groups_page.dart';
import 'package:hlw/mine/mine_norquestion_page.dart';
import 'package:hlw/mine/mine_share_page.dart';
import 'package:hlw/model/alert_ads_model.dart';
import 'package:hlw/model/config_model.dart';
import 'package:hlw/util/app_global.dart';
import 'package:hlw/util/eventbus_class.dart';
import 'package:hlw/util/image_request_async.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:hlw/watch/watch_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:hlw/base/request_api.dart';
import 'package:flutter_split_view/flutter_split_view.dart';
import 'package:provider/provider.dart';
import "package:universal_html/html.dart" as html;

import '../circle/circle_index_page.dart';
import '../model/general_ads_model.dart';
import '../model/user_model.dart';

import 'base_store.dart';

double kNavBarWidth = 305.w;

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State createState() => _IndexPageState();
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
        AppGlobal.appBox?.put("lines_url", value?.data?.config?.lines_url);
        AppGlobal.appBox?.put("github_url", value?.data?.config?.github_url);
        AppGlobal.appBox?.put('office_web', value?.data?.config?.office_site);
        AppGlobal.appBox?.put('office_site', value?.data?.config?.office_site);
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
        });
        //缓存广告AD
        String? _adurl = value?.data?.ads?.img_url;
        if (_adurl != null) {
          ImageRequestAsync.getImageRequest(_adurl).then((_) {
            AppGlobal.appBox?.put('adsmap', {
              'image': _adurl,
              'url': value?.data?.ads?.url
            });
          });
        } else {
          AppGlobal.appBox?.put('adsmap', null);
        }
        //seo设置
        if (kIsWeb) {
          final descTag = html.document.head!
              .querySelector('meta[name="description"]') as html.MetaElement?;
          final description = value?.data?.config?.description ?? "";
          final kwTag = html.document.head!
              .querySelector('meta[name="keywords"]') as html.MetaElement?;
          final keywords = value?.data?.config?.keywords ?? "";
          final title = value?.data?.config?.title ?? "";
          if (kwTag != null &&
              descTag != null &&
              description.isNotEmpty &&
              keywords.isNotEmpty &&
              title.isNotEmpty) {
            kwTag.content = keywords;
            descTag.content = description;
            html.document.title = title;
          }
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
      String? aff = u.queryParameters['hlwpc_aff'];
      if (aff != null) {
        reqInvitation(affCode: aff);
      }
    } else {
      Clipboard.getData(Clipboard.kTextPlain).then((value) {
        if (value?.text != null) {
          List cliptextList = value?.text?.split(":").toList() ?? [];
          if (cliptextList.length > 1) {
            if (cliptextList[0] == 'hlwpc_aff') {
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

    if (data.versionMsg != null) {
      var targetVersion = data.versionMsg?.version?.replaceAll('.', '');
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
    } else {
      _showActivety(data);
    }
  }


  //APPS显示
  void _appsAlert(ConfigModel? data) {
    List<dynamic> apps = data?.popup_apps ?? [];
    if (apps.isEmpty == true) {
      _noticeAlert(data);
      return;
    }
    UpdateSysAlert.showAppAlert(apps, cancel: () {
      _noticeAlert(data);
    });
  }

  //公告显示
  void _noticeAlert(ConfigModel? data) {
    if (data?.versionMsg?.mstatus == 1) {
      UpdateSysAlert.showAnnounceAlert(
        text: data?.versionMsg?.message,
        cancel: () {
          _addMainScreen();
        },
        confirm: () {
          _addMainScreen();
        },
      );
      return;
    }
    _addMainScreen();
  }

  //加载添加到主屏幕功能
  void _addMainScreen() async {}

  //版本更新
  void _updateAlert(ConfigModel? data) {
    UpdateSysAlert.showUpdateAlert(
      site: () {
        Utils.openURL(data?.config?.office_site ?? "");
      },
      guide: () {
        Utils.openURL(data?.config?.solution ?? "");
      },
      cancel: () {
        _showActivety(data);
      },
      confirm: () {
        if (Platform.isAndroid) {
          UpdateSysAlert.androidUpdateAlert(
              version: data?.versionMsg?.version, url: data?.versionMsg?.apk);
        } else {
          Utils.openURL(data?.versionMsg?.apk ?? "");
        }
      },
      version: "V${data?.versionMsg?.version}",
      text: data?.versionMsg?.tips,
      mustupdate: data?.versionMsg?.must == 1,
    );
  }

  //显示弹窗
  void _showActivety(ConfigModel? data, {int index = 0}) {
    if (data?.pop_ads == null) {
      _appsAlert(data);
      return;
    }
    AlertAdsModel? tp = data?.pop_ads?[index];
    UpdateSysAlert.showAvtivetysAlert(
        ad: tp,
        cancel: () {
          if (index == (data?.pop_ads?.length ?? 0) - 1) {
            _appsAlert(data);
          } else {
            _showActivety(data, index: index + 1);
          }
        },
        confirm: () {
          //上报点击量
          reqAdClickCount(id: tp?.report_id, type: tp?.report_type);
          if (tp?.type == "router") {
            String _url = tp?.url_str ?? "";
            List _urlList = _url.split('??');
            Map<String, dynamic> pramas = {};
            if (_urlList.first == "web") {
              pramas["url"] = _urlList.last.toString().substring(4);
              Utils.navTo(context, "/${_urlList.first}/${pramas.values.first}");
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
            Utils.openURL(tp?.url_str?.trim() ?? "");
            if (index == (data?.pop_ads?.length ?? 0) - 1) {
              _appsAlert(data);
            } else {
              _showActivety(data, index: index + 1);
            }
          }
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
      childWidth: kNavBarWidth,
      breakpoint: ScreenWidth - kNavBarWidth,
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

  StreamSubscription? _streamSubscription;

  _eventBus() {
    _streamSubscription = UtilEventbus().on<EventbusClass>().listen((event) {
      if (event.arg["login"] != null && event.arg["login"] == 'login') {
        setState(() {
          _selectIndex = 0;
          SplitView.of(context).setSecondary(customWidget(context));
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _eventBus();
    //等待500毫秒初始化
    Future.delayed(const Duration(milliseconds: 500), () {
      SplitView.of(context).setSecondary(customWidget(context));
    });
  }

  Widget selectMainWidget() {
    switch (_selectIndex) {
      case 0: // 黑料
        return const HomePage();
      case 1: // 看片
        return const WatchPage();
      case 2: // 圈子
        // return RankPage(isShow: true);
        return const CircleIndexPage();
      case 3: // 精选
        return const WelfarePage(isShow: true);
      case 4: // 历史
        return const HistoryIndexPage();
      case 5: // 热议
        return const HotDiscussionIndexPage();
      default:
        return const SizedBox();
    }
  }

  Widget customWidget(BuildContext context) {
    return Container(
      color: StyleTheme.bgColor,
      child: selectMainWidget(),
    ); // 不要用Expanded包裹
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
        decoration: BoxDecoration(color: StyleTheme.black0Color),
        padding: EdgeInsets.only(top: 18.5.w),
        // 避免橫向拉伸
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (Platform.isMacOS) ...[
                  WindowTitleBarBox(
                    child: Row(children: [
                      CloseWindowButton(),
                      MinimizeWindowButton(),
                      MaximizeWindowButton(),
                    ]),
                  ),
                  SizedBox(height: 20.w),
                ],
                GestureDetector(
                  // 官網
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    final _url = config?.config?.office_site;
                    _url != null && _url.isNotEmpty == true
                        ? Utils.openURL(_url)
                        : Utils.showText(Utils.txt('cccwl') + '');
                    // Platform.isMacOS ? Utils.openWebViewMacos(PresentationStyle.sheet, _url) : Utils.navTo(context, '/web/$_url');
                  },
                  child: LocalPNG(
                    name: 'hlw_logo',
                    width: 138.w,
                    height: 32.w,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 25.w),
          Expanded(child: _buildOperationListWidget()),
          Container(
            color: const Color.fromRGBO(255, 255, 255, .2),
            height: 1.w,
            width: double.infinity,
          ),
          Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(height: 40.w),
            GestureDetector(
              onTap: () {
                Utils.splitToView(context, const MineNorquestionPage());
              },
              child: Row(children: [
                SizedBox(width: 15.w + 17.w),
                LocalPNG(name: "icon-help", width: 28.w, height: 28.w),
                SizedBox(width: 32.w),
                Text("常见问题", style: StyleTheme.font_gray_194_20)
              ]),
            ),
            SizedBox(height: 40.w),
            GestureDetector(
              onTap: () {
                Utils.splitToView(context, MineSharePage());
              },
              child: Row(children: [
                SizedBox(width: 15.w + 17.w),
                LocalPNG(name: "icon-share", width: 28.w, height: 28.w),
                SizedBox(width: 32.w),
                Text("分享", style: StyleTheme.font_gray_194_20)
              ]),
            ),
            SizedBox(height: 40.w),
            GestureDetector(
              onTap: () {
                Utils.splitToView(context, const MineGroupsPage());
              },
              child: Row(children: [
                SizedBox(width: 15.w + 17.w),
                LocalPNG(name: "icon-telegram", width: 28.w, height: 28.w),
                SizedBox(width: 32.w),
                Text("TG群", style: StyleTheme.font_gray_194_20)
              ]),
            ),
            SizedBox(height: 40.w),
          ]),
        ]),
      ),
    );
  }

  Widget _buildOperationListWidget() {
    int len = 6;
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: false,
      physics: const BouncingScrollPhysics(),
      itemCount: len,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: kNavBarWidth / 68.w,
        crossAxisCount: 1,
        mainAxisSpacing: 0,
      ),
      itemBuilder: _buildOperationItemWidget,
    );
  }

  Widget _buildOperationItemWidget(context, int index) {
    String text;
    String icon;
    String link = '';
    TextStyle style = _selectIndex == index
        ? StyleTheme.font_orange_244_20
        : StyleTheme.font_gray_194_20;
    switch (index) {
      case 0: // 首页
        text = '黑料';
        icon = 'hlw_tab_0_black_${_selectIndex == index ? 'h' : 'n'}';
        break;
      case 1: // 黑料大事记
        text = '看片';
        icon = 'hlw_tab_0_watch_${_selectIndex == index ? 'h' : 'n'}';
        break;
      case 2: // 黑料热点排行
        text = '圈子';
        icon = 'hlw_tab_0_circle_${_selectIndex == index ? 'h' : 'n'}';
        break;
      case 3: // 黑料官方APP
        text = '精选';
        icon = 'hlw_tab_0_featured_${_selectIndex == index ? 'h' : 'n'}';
        break;
      case 4: // 黑料官方微信QQ群
        text = '历史';
        icon = 'hlw_tab_0_history_${_selectIndex == index ? 'h' : 'n'}';
        break;
      case 5: // 黑料精品福利站
        text = '热议';
        icon = 'hlw_tab_0_hot_${_selectIndex == index ? 'h' : 'n'}';
        break;
      case 6: // 黑料官方论坛
        text = '黑料官方论坛';
        icon = 'hlw_tab_0_forum';
        // link = config?.client_forum_bbs ?? '';
        break;
      default:
        text = '测试天';
        icon = 'hlw_tab_forum'; // 仅仅占位
    }

    Widget current = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 17.w),
        LocalPNG(name: icon, width: 28.w, fit: BoxFit.fitWidth),
        SizedBox(width: 32.w),
        Expanded(child: Text(text, style: style))
      ],
    );

    Decoration? decoration;
    if (_selectIndex == index) {
      decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(12.w),
        color: StyleTheme.orange47Color,
      );
    }

    current = Container(
      margin: EdgeInsets.fromLTRB(15.w, 9.w, 30.w, 9.w),
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
