import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:hlw/base/base_store.dart';
import 'package:hlw/base/gen_custom_nav.dart';
import 'package:hlw/base/request_api.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:hlw/util/easy_pull_refresh.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:hlw/watch/video_subchild_page.dart';
import 'package:provider/provider.dart';

import '../model/config_model.dart';

class WatchContentPage extends StatefulWidget {
  final int id;

  const WatchContentPage({
    super.key,
    required this.id,
  });

  @override
  State createState() => _WatchContentPageState();
}

class _WatchContentPageState extends State<WatchContentPage> {
  int page = 1;
  List tps = [];
  List banners = [];

  late final ConfigModel? cf =
      Provider.of<BaseStore>(context, listen: false).config;
  late final List sortNavis = cf?.config?.sort_video ?? [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
            headerSliverBuilder: (cx, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(child: _buildBannerWidget()),
              ];
            },
            body: GenCustomNav(
              titles:
                  sortNavis.map((e) => (e["name"] ?? "") as String).toList(),
              pages: sortNavis.asMap().keys.map((index) {
                dynamic data = sortNavis[index];
                return VideoSubChildPage(id: widget.id, sort: data['sort'],
                 fun: (bannerList, naviList) {
                   banners = bannerList;
                   // navis = naviList;
                   if (mounted) setState(() {});
                 });
              }).toList(),
              tabPadding: 40.w,
              isCover: true,
              selectStyle: StyleTheme.font_orange_244_20_600,
              defaultStyle: StyleTheme.font_gray_153_20,
            ),
          );
  }

  Widget _buildBannerWidget() {
    return Visibility(
      visible: banners.isNotEmpty,
      child: Utils.bannerScaleExtSwiper(
        data: banners,
        itemWidth: 700.w,
        // 图片宽
        itemHeight: 300.w,
        // 图片高(240) + 23 + 10
        viewportFraction: 700 / 1508,
        // 1548 - 20 * 2
        scale: 1,
        spacing: 20.w,
        lineWidth: 20.w,
        autoplay: false,
      ),
    );
  }
}
