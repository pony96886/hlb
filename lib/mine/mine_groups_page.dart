import 'package:hlw/base/base_widget.dart';
import 'package:hlw/base/request_api.dart';
import 'package:hlw/util/easy_pull_refresh.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:hlw/widget/search_bar_widget.dart';

class MineGroupsPage extends BaseWidget {
  const MineGroupsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> cState() {
    return _MineGroupsPageState();
  }
}

class _MineGroupsPageState extends BaseWidgetState<MineGroupsPage> {
  List dataList = [];
  bool isHud = true;

  Future<bool> getData() {
    // return reqContactList().then((value) {
    //   if (value?.status == 1) {
    //     dataList = value?.data?["office_contact"]["data"];
    //   } else {
    //     Utils.showText(value?.msg ?? "");
    //   }
    //   isHud = false;
    //   setState(() {});
    //   return true;
    // });
    isHud = false;
    return Future.value(true);
  }

  @override
  void onCreate() {
    getData();
  }

  @override
  Widget appbar() {
    return Container();
  }

  @override
  void onDestroy() {}

  @override
  Widget pageBody(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 90.w,
          bottom: 0,
          left: 0,
          right: 0,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(left: 48.w, right: 48.w, top: 52.w),
            child: isHud
                ? LoadStatus.showLoading(mounted)
                : dataList.isEmpty
                    ? LoadStatus.noData()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text.rich(
                            textAlign: TextAlign.left,
                            TextSpan(children: [
                              TextSpan(
                                text: '请使用翻墙VPN进入官方交流群点击 ',
                                style: StyleTheme.font_white_255_32_600,
                              ),
                              TextSpan(
                                text: "福利/翻墙VPN",
                                style: StyleTheme.font_orange_244_32_600,
                              ),
                              TextSpan(
                                text: "下载即可一键翻墙",
                                style: StyleTheme.font_white_255_32_600,
                              ),
                            ]),
                          ),
                          SizedBox(
                            height: 88.w,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              _buildItem(
                                title: "官方用户交流社群",
                                subTitle: "一起看片就一起分享心得",
                                contentTitle: "微信",
                                conntent: "立即加群，还有小视频福利等你哟!",
                              ),
                              SizedBox(
                                width: 80.w,
                              ),
                              _buildItem(
                                title: "广告洽谈",
                                subTitle: "代理合作/商务合作",
                                contentTitle: "微信",
                                conntent: "立即加群，还有小视频福利等你哟!",
                              )
                            ],
                          )
                        ],
                      ),
          ),
        ),
        SearchBarWidget(isBackBtn: true, backTitle: Utils.txt('gfjlq')),
      ],
    );
  }

  Widget _buildItem(
      {String title = "",
      String subTitle = "",
      String contentTitle = "微信",
      String conntent = "立即加群，还有小视频福利等你哟!",
      Future Function()? onTap}) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: StyleTheme.font_white_255_30_600,
        ),
        SizedBox(
          height: 20.w,
        ),
        Text(
          subTitle,
          style: StyleTheme.font_gray_153_22,
        ),
        SizedBox(
          height: 40.w,
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(30.w),
          decoration: BoxDecoration(
            color: StyleTheme.white10,
            borderRadius: BorderRadius.circular(12.w),
          ),
          child: Row(
            children: [
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: StyleTheme.gray255Color1,
                  borderRadius: BorderRadius.circular(12.w),
                ),
              ),
              SizedBox(
                width: 24.w,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contentTitle,
                    style: StyleTheme.font_white_255_24_bold,
                  ),
                  SizedBox(
                    height: 20.w,
                  ),
                  Text(
                    conntent,
                    style: StyleTheme.font_gray_153_20,
                  ),
                ],
              )),
              SizedBox(
                width: 24.w,
              ),
              InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(40.w),
                child: Container(
                  alignment: Alignment.center,
                  width: 120.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.w),
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        Color(0xFFF49A34),
                        Color(0xFFF4C455),
                      ],
                    ),
                  ),
                  child: Text(
                    "加入",
                    style: StyleTheme.font_brown_103_20_bold,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    ));
  }
}
