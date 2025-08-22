import 'package:hlw/home/home_content_page.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/pageviewmixin.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/widget/search_bar_widget.dart';
import 'package:provider/provider.dart';

import '../base/base_store.dart';
import '../base/gen_custom_nav.dart';
import '../base/request_api.dart';

class HomePage extends StatefulWidget {
  final bool isShow;

  const HomePage({Key? key, this.isShow = false}) : super(key: key);

  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool netError = false;
  bool _loading = true;
  List elements = [], banners = [];

  int layoutType = 2; //1 list ， 2 gird

  @override
  void initState() {
    super.initState();
    // getDataBanners();
    getData();
  }

  void getData() {
    reqHome().then((value) {
      if (value?.data == null) {
        netError = true;
        if (mounted) setState(() {});
        return;
      }
      if (value?.status == 1) {
        elements = List.from(value?.data['list'] ?? []);
      }
      _loading = false;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (netError) {
      return LoadStatus.netErrorWork(onTap: () {
        netError = false;
        getData();
      });
    }
    if (_loading) return LoadStatus.showLoading(mounted);
    if (elements.isEmpty) return LoadStatus.noData();
    return _widget();
  }

  Widget _widget() {
    return Stack(children: [
      Positioned(
        top: 90.w + 5.w,
        // 5 边距
        bottom: 0,
        left: 0,
        right: 0,
        child: _buildPostWidget(),
      ),
      const SearchBarWidget(),
    ]);
  }

  Widget _buildPostWidget() {
    return GenCustomNav(
      isCenter: false,
      tabPadding: 40.w,
      rightWidget: Container(
        margin: EdgeInsets.only(left: 10.w, right: 30.w),
        height: 40.w,
        width: 120.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.w)),
          color: StyleTheme.white10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  setState(() {
                    layoutType = 1;
                  });
                },
                child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 13.w, vertical: 5.w),
                    width: 54.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(24.w)),
                      color: layoutType == 1 ? StyleTheme.yellow255Color : Colors.transparent,
                    ),
                    child: LocalPNG(name: layoutType == 1 ? 'hlw_list_icon_h': 'hlw_list_icon_n'))),
            SizedBox(width: 10.w),
            GestureDetector(
                onTap: () {
                  setState(() {
                    layoutType = 2;
                  });
                },
                child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 13.w, vertical: 5.w),
                    width: 54.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(24.w)),
                      color: layoutType == 2 ? StyleTheme.yellow255Color : Colors.transparent,
                    ),
                    child: LocalPNG(name: layoutType == 2 ? 'hlw_girl_icon_h': 'hlw_girl_icon_n'))),
          ],
        ),
      ),
      titles: elements.map((e) => e["name"].toString()).toList(),
      pages: elements.map((e) {
        return PageViewMixin(
          child: HomeContentPage(id: e["mid"], layoutType: layoutType),
        );
      }).toList(),
    );
  }
}
