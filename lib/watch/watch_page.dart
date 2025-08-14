import 'package:flutter/widgets.dart';
import 'package:hlw/base/base_store.dart';
import 'package:hlw/base/gen_custom_nav.dart';
import 'package:hlw/base/request_api.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/pageviewmixin.dart';
import 'package:hlw/watch/watch_content_page.dart';
import 'package:hlw/widget/search_bar_widget.dart';
import 'package:provider/provider.dart';

class WatchPage extends StatefulWidget {
  final bool isShow;
  const WatchPage({Key? key, this.isShow = false}) : super(key: key);

  @override
  State createState() => WatchPageState();
}

class WatchPageState extends State<WatchPage> with TickerProviderStateMixin {
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
        child: _buildWatchWidget(),
      ),
      const SearchBarWidget(),
    ]);
  }

  Widget _buildWatchWidget() {
    Widget current = GenCustomNav(
      isCenter: false,
      titles: elements.map((e) => e["name"].toString()).toList(),
      pages: elements.map((e) {
        return PageViewMixin(
          child: WatchContentPage(id: e["id"], banners: banners),
        );
      }).toList(),
    );
    return Container(
      padding: EdgeInsets.fromLTRB(29.5.w, 0, 29.5.w, 0),
      child: current,
    );
  }
}
