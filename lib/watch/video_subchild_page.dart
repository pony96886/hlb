import 'package:hlw/base/request_api.dart';
import 'package:hlw/model/element_model.dart';
import 'package:hlw/util/easy_pull_refresh.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hlw/model/element_model.dart';

class VideoSubChildPage extends StatefulWidget {
  const VideoSubChildPage(
      {super.key, this.index = 0, this.fun, this.param, this.sort, this.id});

  final int? id;
  final String? sort;
  final int index;
  final Function(List banners, List navis)? fun;
  final Map? param;

  @override
  State<VideoSubChildPage> createState() => _VideoSubChildPageState();
}

class _VideoSubChildPageState extends State<VideoSubChildPage> {
  bool isHud = true;
  bool netError = false;
  bool noMore = false;
  int page = 1;
  List array = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future<bool> getData() async {
    dynamic res = await reqVideoCategoryList(
        id: widget.id ?? 0, sort: widget.sort ?? '0', page: page);
    if (res?.status == 0) {
      netError = true;
      isHud = false;
      if (mounted) setState(() {});
      return false;
    }
    List tp = res?.data?['list'] ?? [];
    if (page == 1) {
      noMore = false;
      array = tp;
      widget.fun?.call(List.from(res?.data?['banner'] ?? []),
          List.from(res?.data?['plate'] ?? []));
    } else if (tp.isNotEmpty) {
      array.addAll(tp);
    } else {
      noMore = true;
    }
    isHud = false;
    if (mounted) setState(() {});
    return noMore;
  }

  @override
  Widget build(BuildContext context) {
    return isHud
        ? LoadStatus.showLoading(mounted)
        : netError
            ? LoadStatus.netErrorWork(onTap: () {
                netError = false;
                getData();
              })
            : array.isEmpty
                ? LoadStatus.noData()
                : Builder(builder: (cx) {
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
                            sameChild: GridView.builder(
                              padding: EdgeInsets.only(
                                  left: StyleTheme.margin,
                                  right: StyleTheme.margin,
                                  bottom: 50.w),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 20.w,
                                crossAxisSpacing: 20.w,
                                childAspectRatio: 335 / 277,
                              ),
                              scrollDirection: Axis.vertical,
                              itemCount: array.length,
                              itemBuilder: (context, index) {
                                dynamic data = array[index];
                                return Utils.videoModuleUI(context, e: data);
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  });
  }
}
