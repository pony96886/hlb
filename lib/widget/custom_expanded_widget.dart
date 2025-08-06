import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';

import '../util/style_theme.dart';

class CustomExpandedWidget extends StatefulWidget {
  final List<String>? titles;
  final List<Widget>? pages;
  final Widget? expandedWidget;
  final double labelPadding;
  final bool isTabBar;
  const CustomExpandedWidget({Key? key, this.titles, this.pages, this.expandedWidget, this.labelPadding = 0.0, this.isTabBar = true}) : super(key: key);

  @override
  State<CustomExpandedWidget> createState() => _CustomExpandedWidgetState();
}

class _CustomExpandedWidgetState extends State<CustomExpandedWidget> {

  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: widget.titles!.length,
        child: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (context, innerScrolled) => <Widget> [
// SliverOverlapAbsorber(
//   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
//   sliver:
// )
            widget.isTabBar
                ? SliverAppBar(
              pinned: true,
              //appBar是否置顶 是否固定在顶部 为true是固定，为false是不固定可滑出屏幕
              floating: false,
              //是否应该在用户滚动时变得可见 比如pinned 为false可滑出屏幕 当向下滑时可先滑出 状态栏
              snap: false,
              //当手指放开时，SliverAppBar是否会根据当前的位置展开/收起
              stretch: false,
              //是否可拉伸伸展
              forceElevated: false,
              //是否显示阴影
              backgroundColor: Colors.white,
              expandedHeight: 280.w,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: widget.expandedWidget,
              ),
              bottom: PreferredSize(
                preferredSize: Size.zero,
                child: Container(
                  color: Colors.white,
                  width: ScreenWidth,
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: TabBar(
                    isScrollable: true,
                    unselectedLabelColor: StyleTheme.gray153Color,
                    labelStyle: StyleTheme.font_gray_153_17,
                    labelColor: StyleTheme.orange255Color,
                    labelPadding: EdgeInsets.symmetric(horizontal: 20.w),
                    indicatorColor: StyleTheme.black34Color,
                    indicatorPadding: EdgeInsets.symmetric(horizontal: 20.w),
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: widget.titles!.map((String name) => Tab(text: name)).toList(),
                  ),
                ),
              ),
            ) :SliverAppBar(
              backgroundColor: Colors.white,
              expandedHeight: 240.w,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: widget.expandedWidget,
              ),
            ),
            // SliverToBoxAdapter(
            //     child: SizedBox(
            //       height: 240.w,
            //       child: widget.expandedWidget,
            //     )
            // )
          ],
          body: widget.isTabBar
              ? TabBarView(children: widget.pages!)
              : widget.pages!.first,
//       .map((tab) => Builder(
//     builder: (context) => SingleChildScrollView(
//       child: SizedBox(
//     height: ScreenHeight,
//     child: tab,
//   ),
//     ),
//   )
// ).toList()
//       .map((tab) => Builder(
//     builder: (context) => CustomScrollView(
//       key: PageStorageKey<Widget>(tab),
//       slivers: <Widget>[
//         // SliverOverlapInjector(
//         //     handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
//         SliverToBoxAdapter(
//           child: SizedBox(
//             height: ScreenHeight,
//             child: tab,
//           ),
//         )
//       ],
//     ),
//   )
// ).toList()
//           ),
        )
    );
  }
}

/// CustomScroll 版本
// return DefaultTabController(
//         length: widget.titles!.length,
//         child: CustomScrollView(
//           controller: scrollController,
//           slivers: widget.isTabBar
//               ? [
//             SliverAppBar(
//               pinned: true, //appBar是否置顶 是否固定在顶部 为true是固定，为false是不固定可滑出屏幕
//               floating: true, //是否应该在用户滚动时变得可见 比如pinned 为false可滑出屏幕 当向下滑时可先滑出 状态栏
//               snap: true, //当手指放开时，SliverAppBar是否会根据当前的位置展开/收起
//               stretch: true, //是否可拉伸伸展
//               forceElevated: false, //是否显示阴影
//               backgroundColor: Colors.white,
//               expandedHeight: 360.w,
//               flexibleSpace: FlexibleSpaceBar(
//                 collapseMode: CollapseMode.pin,
//                 background: widget.expandedWidget,
//               ),
//               bottom: PreferredSize(
//                 preferredSize: Size(ScreenWidth, 50.w),
//                 child: Container(
//                   alignment: Alignment.center,
//                   child: Container(
//                     color: Colors.white,
//                     width: ScreenWidth,
//                     padding: EdgeInsets.symmetric(horizontal: 60.w),
//                     child: TabBar(
//                       isScrollable: true,
//                       unselectedLabelColor: StyleTheme.gray153Color,
//                       labelStyle: StyleTheme.font_gray_153_17,
//                       labelColor: StyleTheme.orange255Color,
//                       labelPadding: EdgeInsets.symmetric(horizontal: 20.w),
//                       indicatorColor: StyleTheme.black34Color,
//                       indicatorPadding: EdgeInsets.symmetric(horizontal: 20.w),
//                       indicatorSize: TabBarIndicatorSize.tab,
//                       tabs: widget.titles!.map((String name) => Tab(text: name)).toList(),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SliverToBoxAdapter(
//               child: SizedBox(
//                 height: ScreenHeight,
//                 child: TabBarView(
//                     children: widget.pages!
//                 ),
//               ),
//             )
//           ]
//               : [
//             SliverAppBar(
//               backgroundColor: Colors.white,
//               expandedHeight: 320.w,
//               flexibleSpace: FlexibleSpaceBar(
//                 collapseMode: CollapseMode.pin,
//                 background: widget.expandedWidget,
//               ),
//             ),
//             SliverToBoxAdapter(
//               child: SizedBox(
//                 height: ScreenHeight,
//                 child: widget.pages!.first,
//               ),
//             )
//           ],
//         )
//     );