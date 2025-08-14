import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:hlw/base/gen_custom_nav.dart';
import 'package:hlw/base/request_api.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:hlw/util/easy_pull_refresh.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';

class WatchContentPage extends StatefulWidget {
  final int id;
  final dynamic banners;

  const WatchContentPage({
    super.key,
    this.id = 0,
    this.banners,
  });

  @override
  State createState() => _WatchContentPageState();
}

class _WatchContentPageState extends State<WatchContentPage> {
  bool isHud = true;
  bool netError = false;
  bool noMore = false;
  int page = 1;
  List tps = [];
  List banners = [];

  @override
  void initState() {
    super.initState();
    banners = widget.banners;
    getData();
  }

  Future<bool> getData() {
    return reqHomeCategoryList(id: widget.id, page: page).then((value) {
      if (value?.data == null) {
        netError = true;
        if (mounted) setState(() {});
        return false;
      }
      List tmp = value?.data["article"]["list"] ?? [];
      if (page == 1) {
        noMore = false;
        tps = tmp;
      } else if (page > 1 && tmp.isNotEmpty) {
        tps.addAll(tmp);
        tps = Utils.listMapNoDuplicate(tps);
      } else {
        noMore = true;
      }
      isHud = false;
      if (mounted) setState(() {});
      return noMore;
    });
  }

  @override
  void didUpdateWidget(covariant WatchContentPage oldWidget) {
    if (oldWidget.banners != widget.banners) {
      setState(() {
        banners = widget.banners;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (netError) {
      return LoadStatus.netErrorWork(onTap: () {
        netError = false;
        getData();
      });
    }
    if (isHud) return LoadStatus.showLoading(mounted);
    if (tps.isEmpty) return LoadStatus.noData();
    return Builder(builder: (cx) {
      return Column(
        children: [
          Expanded(
            child: EasyPullRefresh(
              onRefresh: () {
                page = 1;
                return getData();
              },
              onLoading: () {
                page++;
                return getData();
              },
              sameChild: _buildContainerWidget(),
            ),
          ),
          SizedBox(height: 20.w),
        ],
      );
    });
  }

  Widget _buildContainerWidget() {
    return ListView(children: [
      _buildBannerWidget(),
      _buildFilterWidget(),
      _buildGridViewWidget(),
    ]);
  }

  Widget _buildFilterWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.w),
      child: GenCustomNav(
        labelPadding: EdgeInsets.only(right: 16.w),
        defaultStyle: StyleTheme.font_gray_161_20_bold,
        selectStyle: StyleTheme.font_orange_244_20_600,
        isCenter: false,
        isCover: true,
        titles: ["热门推荐", "本周最新", "最多观看"],
        pages: [],
      ),
    );
  }

  Widget _buildBannerWidget() {
    return Visibility(
        visible: banners.isNotEmpty,
        child: Utils.bannerScaleExtSwiper(
          data: banners,
          itemWidth: 710.w,
          // 图片宽
          itemHeight: 240.w,
          // 图片高(240) + 23 + 10
          viewportFraction: 0.777,
          // （710 + 5）/ 920 // 1040 - 120
          scale: 1,
          spacing: 5.w,
          lineWidth: 20.w,
        ));
  }

  Widget _buildGridViewWidget() {
    return GridView.count(
      addRepaintBoundaries: false,
      addAutomaticKeepAlives: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      cacheExtent: ScreenHeight * 3,
      crossAxisCount: 4,
      mainAxisSpacing: 52.w,
      crossAxisSpacing: 20.w,
      childAspectRatio: 374.w / 353.w,
      children:
          tps.map((e) => Utils.newsModuleUI(context, e, style: 2)).toList(),
    );
  }
}
