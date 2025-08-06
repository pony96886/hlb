import 'dart:async';

import 'package:hlw/base/base_main_view.dart';
import 'package:hlw/base/base_widget.dart';
import 'package:hlw/base/request_api.dart';
import 'package:hlw/util/easy_pull_refresh.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:hlw/util/utils.dart';

class MineWithdrawalRecord extends BaseWidget {
  MineWithdrawalRecord({Key? key}) : super(key: key);

  @override
  State cState() => _MineWithdrawalRecordState();
}

class _MineWithdrawalRecordState extends BaseWidgetState<MineWithdrawalRecord> {
  bool isHud = true;
  bool netError = false;
  bool noMore = false;
  int page = 1;
  List tps = [];

  @override
  void onCreate() {
    _getData();
  }

  Future<bool> _getData() {
    return reqPostContentIncome(page: page).then((value) {
      if (value?.data == null) {
        netError = true;
        if (mounted) setState(() {});
        return false;
      }
      List tp = List.from(value?.data ?? []);
      if (page == 1) {
        noMore = false;
        tps = tp;
        // if(mounted) reqUserInfo(context).then((value) => setState(() {}));
      } else if (page > 1 && tp.isNotEmpty) {
        tps.addAll(tp);
        tps = Utils.listMapNoDuplicate(tps);
      } else {
        noMore = true;
      }
      isHud = false;
      if (mounted) setState(() {});
      return noMore;
    });
    // return reqWithdrawalRecord(page: page).then((value) {
    //   if (value?.data == null) {
    //     netError = true;
    //     if (mounted) setState(() {});
    //     return false;
    //   }
    //   List tp = List.from(value?.data ?? []);
    //   if (page == 1) {
    //     noMore = false;
    //     tps = tp;
    //   } else if (tp.isNotEmpty) {
    //     tps.addAll(tp);
    //   } else {
    //     noMore = true;
    //   }
    //   isHud = false;
    //   if (mounted) setState(() {});
    //   return noMore;
    // });
  }
  @override
  Widget appbar() {
    // TODO: implement appbar
    return Container();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    return BaseMainView(
      paddingTop: 84.w,
      paddingLeft: 110.w,
      paddingBottom: 20.w,
      isBackBtn: true,
      backTitle: '明细',
      leftWidget: SizedBox(
        width: 540.w,
        height: ScreenHeight - 104.w,
        child: netError
            ? LoadStatus.netErrorWork(onTap: () {
              netError = false;
              _getData();
            })
            :isHud
            ? LoadStatus.showLoading(mounted)
            : tps.isEmpty
            ? LoadStatus.noData()
            : EasyPullRefresh(
                onRefresh: () {
                  page = 1;
                  return _getData();
                },
                onLoading: () {
                  page++;
                  return _getData();
                },
                sameChild: ListView.separated(
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: tps.length,
                  itemBuilder: (context, index) => _RecordWidget(e: tps[index]),
                  separatorBuilder: (context, index) => SizedBox(height: 15.w),
                ),
              ),
      ),
    );
  }
}

class _RecordWidget extends StatelessWidget {
  final dynamic e;
  const _RecordWidget({Key? key, required this.e}) : super(key: key);

  String _getMoney() {
    String text = '';
    switch (e['type']) {
      case 1 :
        text = '+';
        break;
      case 2 :
        text = '+';
        break;
      case 3 :
        text = '-';
        break;
    }
    return text;
  }

  Widget _getStatus() {
    TextStyle style = StyleTheme.font_black_34_15;
    String text = '';
    switch (e['type']) {
      case 1 :
        text = Money.income.label;
        break;
      case 2 :
        text = Money.refund.label;
        break;
      case 3 :
        text = Money.withdraw.label;
        break;
    }
    switch (e['state']) {
      case 1 :
        style = StyleTheme.font_orange_255_15;
        text += Money.income.status;
        break;
      case 2 :
        style = StyleTheme.font_black_34_15;
        text += Money.refund.status;
        break;
      case 3 :
        style = StyleTheme.font_red_245_15;
        text += Money.withdraw.status;
        break;
    }
    return Text(text,
        style: style,
        textAlign: TextAlign.center
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 79.w,
        padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: StyleTheme.gray238Color, width: 1.w),
          borderRadius: BorderRadius.circular(10.w),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text('${e['created_at']}',
                    style: StyleTheme.font_gray_153_13,
                    textAlign: TextAlign.center),
                // Expanded(child: Container()),
                // GestureDetector(
                //   onTap: () {
                //     Clipboard.setData(ClipboardData(text: '提現編號: ${e['id']}'));
                //     Utils.showText(Utils.txt('fzcg') + '');
                //   },
                //   child: Row(
                //     children: [
                //       Text('${e['id']}',
                //           style: StyleTheme.font_gray_153_13_64,
                //           textAlign: TextAlign.center),
                //       SizedBox(width: 8.w),
                //       Text('复制',
                //           style: StyleTheme.font_black_34_13,
                //           textAlign: TextAlign.center),
                //     ],
                //   ),
                // ),
              ],
            ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_getMoney()}${e['amount']}',
                    style: StyleTheme.font_black_34_20,
                    textAlign: TextAlign.center),
                _getStatus(),
              ],
            ),
          ],
        )
    );
  }

}

enum Money{
  income(value: 1, label: "稿费收益", status: "成功"),
  refund(value: 2, label: "提现退款", status: "审核"),
  withdraw(value: 3, label: "提现", status: "失败");

  final int value;
  final String label;
  final String status;

  const Money({
    required this.value,
    required this.label,
    required this.status,
  });
}