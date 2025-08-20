import 'package:hlw/base/base_widget.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:hlw/widget/search_bar_widget.dart';

class MineNorquestionPage extends BaseWidget {
  const MineNorquestionPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> cState() {
    return _MineNorquestionPageState();
  }
}

class _MineNorquestionPageState extends BaseWidgetState<MineNorquestionPage> {
  @override
  void onCreate() {}

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
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              children: [
                _buildItem(),
                _buildItem(),
                _buildItem(),
                _buildItem(),
                _buildItem(),
                _buildItem(),
                _buildItem(),
                _buildItem(),
              ],
            ),
          ),
        ),
        SearchBarWidget(isBackBtn: true, backTitle: Utils.txt('chjwt')),
      ],
    );
  }

  Widget _buildItem() {
    return Container(
      margin: EdgeInsets.only(bottom: 40.w),
      decoration: BoxDecoration(
        color: StyleTheme.gray255Color1,
        borderRadius: BorderRadius.circular(12.w),
      ),
      padding: EdgeInsets.all(32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "如何接收加密货币呢?",
            style: StyleTheme.font_white_20_600,
          ),
          SizedBox(
            height: 16.w,
          ),
          Text(
            "多米钱包是一款专注于虚拟币投资与转账的金融应用。它提供了一个安全、便捷的平台，让用户能够轻松管理自己的虚拟资产。无论是进行虚拟币的买卖、存储还是转账，多米钱包都能提供流畅的操作体验。我们致力于保障用户的资金安全，采用多重加密技术和严格的风控体系，让用户放心投资。多米钱包，您的虚拟币理财好帮手，让财富增值更加简单高效。",
            style: StyleTheme.font_gray_153_18,
            softWrap: true,
            overflow: TextOverflow.visible,
          )
        ],
      ),
    );
  }
}
