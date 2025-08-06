import 'package:hlw/base/base_main_view.dart';
import 'package:hlw/base/base_widget.dart';
import 'package:hlw/base/request_api.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:provider/provider.dart';

import '../base/base_store.dart';
import '../util/load_status.dart';

class MineContributionIncomePage extends BaseWidget {
  MineContributionIncomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _MineContributionIncomePageState();
  }
}

class _MineContributionIncomePageState
    extends BaseWidgetState<MineContributionIncomePage> {
  bool isHud = true;
  bool netError = false;
  bool noMore = false;

  @override
  Widget appbar() => Container();

  @override
  void onCreate() {
    _getData();
  }

  dynamic balance;
  Future<bool> _getData() {
    return reqUserOver().then((value) {
      if (value?.data == null) {
        netError = true;
        if (mounted) setState(() {});
        return false;
      }
      balance = value?.data['balance'];
      isHud = false;
      if (mounted) setState(() {});
      return noMore;
    });
  }

  @override
  void onDestroy() {}

  @override
  Widget pageBody(BuildContext context) {
    return BaseMainView(
      paddingTop: 94.w,
      paddingLeft: 110.w,
      isBackBtn: true,
      backTitle: '稿费收益',
      leftWidget: SizedBox(
        width: 540.w,
        height: ScreenHeight - 94.w,
        child: Column(children: [
          SizedBox(height: 10.w),
          netError
              ? LoadStatus.netErrorWork(onTap: () {
                  netError = false;
                  _getData();
                })
              : isHud
                  ? LoadStatus.showLoading(mounted)
                  : _BalanceWidget(balance: balance.toString()),
          SizedBox(height: 40.w),
          const _ActionsWidget(),
        ]),
      ),
    );
  }

}

class _BalanceWidget extends StatelessWidget {
  final String balance;
  const _BalanceWidget({Key? key, required this.balance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 112.w,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: StyleTheme.gray238Color, width: 1.w),
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(Utils.txt('gfsy'), style: StyleTheme.font_black_34_13),
          SizedBox(height: 10.w),
          Text(
            '¥${balance.isEmpty ? 0.00 : balance}',
            style: StyleTheme.font_black_34_30,
          ),
        ],
      ),
    );
  }
}

class _ActionsWidget extends StatelessWidget {
  const _ActionsWidget({Key? key}) : super(key: key);

  Widget _btn(Function() tap, String text, Color color) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        width: 200.w,
        height: 54.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(27.w),
        ),
        child: Text(text, style: StyleTheme.font_white_255_17),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Row(children: [
        _btn(() => Utils.navTo(context, '/minewithdrawalrecord'), '明细', StyleTheme.black34Color),
        SizedBox(width: 60.w),
        _btn(() => Utils.openURL('${Provider.of<BaseStore>(context, listen: false).config?.client_withdraw_tg}'), '立即提现', StyleTheme.orange255Color), // /minewithdrawalnow
      ]),
    );
  }
}

// class ContributionChildPage extends StatefulWidget {
//   const ContributionChildPage({Key? key, this.status = 0}) : super(key: key);
//   final int status; //0已发布 1待审核 2被拒绝
//
//   @override
//   State<ContributionChildPage> createState() => _ContributionChildPageState();
// }
//
// class _ContributionChildPageState extends State<ContributionChildPage> {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         padding: EdgeInsets.symmetric(horizontal: StyleTheme.margin),
//         itemCount: 10,
//         itemBuilder: (cx, index) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   SizedBox(
//                     width: StyleTheme.contentWidth / 2,
//                     height: StyleTheme.contentWidth / 2 / 375 * 130,
//                     child: NetImageTool(
//                       url: '',
//                       radius: BorderRadius.all(Radius.circular(3.w)),
//                     ),
//                   ),
//                   SizedBox(width: 10.w),
//                   Expanded(
//                       child: SizedBox(
//                     height: StyleTheme.contentWidth / 2 / 375 * 130,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('title title title',
//                             style: StyleTheme.font(
//                               size: 15,
//                               weight: FontWeight.bold,
//                               color: StyleTheme.black31Color,
//                             ),
//                             maxLines: 3),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("post time",
//                                 style: StyleTheme.font_black_31_12),
//                             widget.status == 0
//                                 ? Text("${Utils.txt('gfsy')}：0 RMB",
//                                     style: StyleTheme.font_red_246_12)
//                                 : SizedBox(width: 20.w),
//                           ],
//                         )
//                       ],
//                     ),
//                   ))
//                 ],
//               ),
//               Visibility(
//                 visible: widget.status != 0,
//                 child: Container(
//                 padding: EdgeInsets.only(top: 10.w),
//                 child: RichText(
//                     text: TextSpan(
//                         text: Utils.txt('dqshjd'),
//                         style: StyleTheme.font_black_31_13,
//                         children: [
//                           TextSpan(
//                             text: widget.status == 1
//                                 ? Utils.txt('dsh')
//                                 : 'reason content',
//                             style: StyleTheme.font_red_246_13,
//                           )
//                         ])),
//                 )
//               ),
//               SizedBox(height: 20.w),
//             ],
//           );
//         });
//   }
// }