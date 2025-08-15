import 'package:hlw/home/home_content_page.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:hlw/util/load_status.dart';
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

  @override
  void initState() {
    super.initState();
    getDataBanners();
    getData();
  }

  void getData() {
    elements =
        Provider.of<BaseStore>(context, listen: false).config?.plate_tab ?? [];
    _loading = false;
    if (mounted) setState(() {});
  }

  getDataBanners() {
    reqAds(position_id: 2).then((value) {
      if (value?.data == null) {
        netError = true;
        if (mounted) setState(() {});
        return;
      }
      if (value?.status == 1) {
        banners = List.from(value?.data["ad_list"]);
      }
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
        top: 90.w + 5.w, // 5 边距
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
      titles: elements.map((e) => e["name"].toString()).toList(),
      pages: elements.map((e) {
        return PageViewMixin(
          child: HomeContentPage(id: e["id"], banners: banners),
        );
      }).toList(),
    );
  }
}
