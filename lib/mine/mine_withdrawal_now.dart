import 'package:hlw/base/base_main_view.dart';
import 'package:hlw/base/base_widget.dart';
import 'package:hlw/base/request_api.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:provider/provider.dart';

import '../base/base_store.dart';
import '../util/local_png.dart';

class MineWithdrawalNow extends BaseWidget {
  MineWithdrawalNow({Key? key}) : super(key: key);

  @override
  State cState() => _MineWithdrawalNowState();
}

class _MineWithdrawalNowState extends BaseWidgetState<MineWithdrawalNow> {
  bool isHud = true;
  bool netError = false;
  String amount = '', account = '';

  @override
  Widget appbar() {
    return Container();
  }

  @override
  void onCreate() {
    final cf = Provider.of<BaseStore>(context, listen: false).config;
    //todo: client_withdraw_rule
    // ruleTxt = cf?.config?.client_withdraw_rule;
    _getData();
  }

  String balance = '';
  dynamic ruleTxt;
  void _getData() {
    reqUserOver().then((value) {
      if (value?.data == null) {
        netError = true;
        if (mounted) setState(() {});
      } else {
        balance = value?.data['balance'];
        isHud = false;
        if (mounted) setState(() {});
      }
    });
    // cashWithdrawRule().then((value) {
    //   if (value?.data == null) {
    //     netError = true;
    //     setState(() {});
    //     return;
    //   }
    //   data = value?.data;
    //   isHud = false;
    //   setState(() {});
    // });
  }

  /// 立即提現
  void _postWithdrawal() {
    if (amount.isEmpty) {
      Utils.showText(Utils.txt('srje'));
      return;
    }
    Utils.startGif(tip: Utils.txt('jzz'));
    incomeApplyWithdraw(amount: int.parse(amount), name: '', card: 0).then((value) {
      Utils.closeGif();
      if (value?.status == 1) {
        Utils.showDialog(
          confirmTxt: Utils.txt('quren'),
          setContent: () {
            return Utils.getContentSpan(
              value?.msg ?? '',
              style: StyleTheme.font_gray_153_12,
              linkStyle: StyleTheme.font(
                  size: 12, color: const Color.fromRGBO(25, 103, 210, 1)),
            );
          },
          confirm: () {
            finish();
          },
        );
      } else {
        Utils.showText(value?.msg ?? '');
      }
    });
  }

  @override
  void onDestroy() {}

  @override
  Widget pageBody(BuildContext context) {
    return BaseMainView(
      paddingTop: 94.w,
      paddingLeft: 110.w,
      rightPadding: 10.w,
      isBackBtn: true,
      backTitle: '提现',
      leftWidget: netError
          ? LoadStatus.netErrorWork(onTap: () {
              netError = false;
              _getData();
            })
          : isHud
              ? LoadStatus.showLoading(mounted)
              : SizedBox(
                  height: ScreenHeight - 94.w,
                  width: 540.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Utils.txt('ye') + "：$balance",
                          style: StyleTheme.font_black_34_17),
                      SizedBox(height: 20.w),
                      Text("提现金额", style: StyleTheme.font_black_34_13),
                      SizedBox(height: 10.w),
                      Container(
                        height: 50.w,
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 10.w),
                        decoration: BoxDecoration(
                            color: StyleTheme.gray238Color,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.w))),
                        child: TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter(RegExp("[0-9]"),
                                allow: true),
                            LengthLimitingTextInputFormatter(5),
                          ],
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          autofocus: false,
                          style: StyleTheme.font_black_34_17,
                          textInputAction: TextInputAction.done,
                          cursorColor: StyleTheme.black34Color,
                          onSubmitted: (value) {},
                          onChanged: (value) {
                            amount = value;
                          },
                          decoration: InputDecoration(
                            hintText: Utils.txt('srje'),
                            hintStyle: StyleTheme.font_gray_153_17,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.5.w)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.5.w)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.5.w)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.5.w)),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.w),
                      Text('合集扣除1元    实际到账99元',
                          style: StyleTheme.font_gray_153_14),
                      SizedBox(height: 30.w),
                      Text("提现账户", style: StyleTheme.font_black_34_13),
                      SizedBox(height: 10.w),
                      GestureDetector(
                        onTap: () {
                          Utils.navTo(context, '/minewithdrawalnowaccount');
                        },
                        child: Container(
                          height: 50.w,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              color: StyleTheme.gray238Color,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.w))),
                          child: Row(
                            children: [
                              Expanded(
                                  child: TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter(
                                      RegExp("[A-Z][a-z][0-9]"),
                                      allow: true),
                                  LengthLimitingTextInputFormatter(5),
                                ],
                                obscureText: false,
                                keyboardType: TextInputType.number,
                                autofocus: false,
                                style: StyleTheme.font_black_34_17,
                                textInputAction: TextInputAction.done,
                                cursorColor: StyleTheme.black34Color,
                                onSubmitted: (value) {},
                                onChanged: (value) {
                                  account = value;
                                },
                                decoration: InputDecoration(
                                  hintText: '请选择提现账户',
                                  hintStyle: StyleTheme.font_gray_153_17,
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0),
                                      borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 0.5.w)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0),
                                      borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 0.5.w)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0),
                                      borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 0.5.w)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0),
                                      borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 0.5.w)),
                                ),
                              )),
                              SizedBox(width: 10.w),
                              LocalPNG(
                                name: '51_mine_parrow',
                                height: 20.w,
                                width: 20.w,
                                color: StyleTheme.gray153Color,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 40.w),
                      Text(Utils.txt('txgz'),
                          style: StyleTheme.font_black_34_13),
                      SizedBox(height: 10.w),
                      Text('${ruleTxt ?? ''}',
                          style: StyleTheme.font_gray_119_12),
                      SizedBox(height: 40.w),
                      Container(
                        height: 54.w,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            _postWithdrawal();
                          },
                          child: Container(
                            height: double.infinity,
                            width: 200.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: StyleTheme.orange255Color,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(27.w))),
                            child: Text('立即提现',
                                style: StyleTheme.font_white_255_17),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
