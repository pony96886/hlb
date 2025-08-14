// ignore_for_file: must_be_immutable

import 'package:hlw/base/base_store.dart';
import 'package:hlw/model/config_model.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:provider/provider.dart';

class GenCustomNav extends StatefulWidget {
  const GenCustomNav({
    Key? key,
    required this.titles,
    required this.pages,
    this.defaultStyle,
    this.selectStyle,
    this.isCenter = false,
    this.indexFunc,
    this.isCover = false,
    this.isGuide = false,
  }) : super(key: key);
  final List<String> titles;
  final List<Widget> pages;
  final TextStyle? defaultStyle;
  final TextStyle? selectStyle;
  final bool isCenter;
  final bool isCover;
  final bool isGuide;
  final Function(int)? indexFunc;

  @override
  State createState() => _GenCustomNavState();
}

class _GenCustomNavState extends State<GenCustomNav>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  int _selectIndex = 0;
  bool _isOnTab = false, _isSelect = false;
  late TextStyle _defaultStyle;
  late TextStyle _selectStyle;

  Widget _dealTabs() {
    return Theme(
        data: ThemeData(
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent),
        child: Transform.translate(
          offset: Offset(-72.0, 0), // 往左移去掉左边空白
          child: TabBar(
            onTap: (index) {
              _isSelect = true;
              _isOnTab = true;
              _onTabPageChange(index, isOnTab: true);
            },
            overlayColor: MaterialStatePropertyAll(Colors.transparent),
            indicator: BoxDecoration(),
            labelPadding: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.zero,
            dividerColor: Colors.transparent,
            isScrollable: true,
            physics: const BouncingScrollPhysics(),
            tabs: widget.titles.asMap().keys.map((x) {
              _isSelect = _selectIndex == x;
              return Tab(
                  child: widget.isCover
                      ? Container(
                          height: StyleTheme.navHegiht,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          decoration: BoxDecoration(
                            color: _selectIndex == x
                                ? StyleTheme.orange47Color
                                : StyleTheme.gray255Color1,
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.w)),
                          ),
                          child: Text(
                            widget.titles[x],
                            style: _selectIndex == x
                                ? _selectStyle
                                : _defaultStyle,
                          ),
                        )
                      : Row(
                          children: [
                            if (_selectIndex == x) ...[
                              LocalPNG(
                                name: "icon_tab_select",
                                width: 16.w,
                                height: 16.w,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(width: 12.w),
                            ],
                            Text(
                              widget.titles[x],
                              style: _selectIndex == x
                                  ? _selectStyle
                                  : _defaultStyle,
                            )
                          ],
                        ));
            }).toList(),
            controller: _tabController,
          ),
        ));
  }

  void _onTabPageChange(index, {bool isOnTab = false}) {
    if (_selectIndex == index) {
      _isOnTab = false;
      return;
    }
    _selectIndex = index;
    if (!isOnTab) {
      _tabController.animateTo(_selectIndex);
      setState(() {});
      if (widget.indexFunc != null) widget.indexFunc!(_selectIndex);
    } else {
      if (widget.pages.isNotEmpty) {
        _pageController.animateToPage(_selectIndex,
            duration: const Duration(milliseconds: 200), curve: Curves.linear);
      }

      //等待滑动解锁
      Future.delayed(const Duration(milliseconds: 200), () {
        _isOnTab = false;
        setState(() {});
        if (widget.indexFunc != null) widget.indexFunc!(_selectIndex);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //设置默认字体
    if (widget.defaultStyle == null || widget.selectStyle == null) {
      _defaultStyle = StyleTheme.font_white_161_20_bold;
      _selectStyle = StyleTheme.font_white_255_24_600;
    } else {
      _defaultStyle = widget.defaultStyle!;
      _selectStyle = widget.selectStyle!;
    }
    _tabController = TabController(length: widget.titles.length, vsync: this);
    _pageController = PageController();
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ConfigModel? cf = Provider.of<BaseStore>(context, listen: false).config;
    if (widget.titles.isEmpty) return const SizedBox();
    Widget curNavigationBar = _dealTabs();
    if (widget.isCenter) {
      curNavigationBar = Center(child: curNavigationBar);
    } else if (widget.isGuide) {
      curNavigationBar = _UserHeaderWidget(
        navigationBar: curNavigationBar,
        url: cf?.office_site ?? "",
        // url: cf?.config?.forever_www ?? "",
      );
    }
    curNavigationBar = SizedBox(
      height: StyleTheme.navHegiht,
      width: double.infinity,
      child: curNavigationBar,
    );

    return Column(children: [
      curNavigationBar,
      if (widget.pages.isNotEmpty) ...[
        SizedBox(height: 28.w),
        Expanded(
          child: PageView(
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              if (!_isOnTab) _onTabPageChange(index, isOnTab: false);
            },
            controller: _pageController,
            children: widget.pages,
          ),
        ),
      ],
    ]);
  }
}

class _UserHeaderWidget extends StatelessWidget {
  final Widget navigationBar;
  final String url;

  const _UserHeaderWidget({
    Key? key,
    required this.navigationBar,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Utils.openURL(url);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: StyleTheme.margin),
          child: Text("黑料网", style: StyleTheme.font_black_31_13),
        ),
      ),
      Expanded(child: navigationBar), // 导航
      Padding(
        padding: EdgeInsets.only(right: StyleTheme.margin),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => Utils.navTo(context, "/homesearchpage"),
          child: Container(
            alignment: Alignment.centerRight,
            width: 27.w,
            height: 40.w,
            child: LocalPNG(
              name: "51_label_search",
              width: 14.w,
              height: 14.w,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    ]);
  }
}
