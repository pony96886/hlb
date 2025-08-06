import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hlw/base/base_main_view.dart';
import 'package:hlw/base/base_widget.dart';
import 'package:hlw/base/request_api.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';

import '../util/easy_pull_refresh.dart';

class MineWithdrawalNowAccount extends BaseWidget {
  MineWithdrawalNowAccount({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _MineWithdrawalNowAccountState();
  }
}

typedef GetAccount = Function(int getIndex);
typedef GetName = Function(String getName);
typedef GetNumber = Function(String getNumber);

class _MineWithdrawalNowAccountState extends BaseWidgetState<MineWithdrawalNowAccount> {
  bool isHud = true;
  bool netError = false;
  bool noMore = false;
  int page = 1, _selectIndex = 0;
  String name = '', number = '';
  late List _accounts;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget appbar() {
    // TODO: implement appbar
    return Container();
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
    _getData();
  }

  Future<bool> _getData() {
    return cashBankCardList().then((value) {
      if (value?.data == null) {
        netError = true;
        if (mounted) setState(() {});
        return false;
      }
      final List list = value?.data;
      if (page == 1) {
        _accounts = list;
        noMore = false;
      } else if (page > 1 && list.isNotEmpty) {
        for (var element in list) {
          if (_accounts.contains(element)) _accounts.add(element);
        }
      } else {
        noMore = true;
      }
      isHud = false;
      if (mounted) setState(() {});
      return noMore;
    });
  }

  _addNewAccount() {
    Utils.showDialog(
      width: 500.w,
      height: 360.w,
      padding: EdgeInsets.only(top: 40.w, bottom: 10.w, left: 20.w, right: 20.w),
      backgroundColor: Colors.white,
      showBtnClose: true,
      title: '添加提现账户',
      cancelTxt: null,
      confirmTxt: null,
      customWidget: (void Function()? cancel) => _Dialog(
          postNewAccount: _postNewAccount, cancel: cancel,
          getName: (String getName) => setState(() => name = getName),
          getNumber: (String getNumber) => setState(() => number = getNumber
        ),
      ),
    );
    // Utils.startGif(tip: Utils.txt('jzz'));
    // incomeApplyWithdraw(amount: int.parse(amount)).then((value) {
    //   Utils.closeGif();
    //   if (value?.status == 1) {
    //     Utils.showDialog(
    //       confirmTxt: Utils.txt('quren'),
    //       setContent: () {
    //         return Utils.getContentSpan(
    //           value?.msg ?? '',
    //           style: StyleTheme.font_gray_153_12,
    //           linkStyle: StyleTheme.font(size: 12, color: const Color.fromRGBO(25, 103, 210, 1)),
    //         );
    //       },
    //       confirm: () {
    //         finish();
    //       },
    //     );
    //   } else {
    //     Utils.showText(value?.msg ?? '');
    //   }
    // });
  }

  _postNewAccount() {
    Utils.startGif(tip: Utils.txt('jzz'));
    cashAddBankCard(name: name, card: number, type: '').then((value) {
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
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    return BaseMainView(
      paddingTop: 94.w, paddingLeft: 110.w,
        isBackBtn: true,
        backTitle: '选择账号',
        leftWidget: Container(
          width: 540.w,
          height: ScreenHeight - 94.w,
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(height: 20.w),
              netError
                  ? LoadStatus.netErrorWork(onTap: () {
                netError = false;
                _getData();
              })
                  : isHud
                  ? LoadStatus.showLoading(mounted)
                  : _accounts.isEmpty
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
                child: ListView.builder(
                    controller: _scrollController,
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: _accounts.length,
                    itemBuilder: (cx, index) {
                      dynamic e = _accounts[index];
                      return _ItemAccount(e: e, selectIndex: _selectIndex, index: index, getIndex: (int getIndex) => setState(() => _selectIndex = index));
                    }),
                sliverChild: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      dynamic e = _accounts[index];
                      return _ItemAccount(e: e, selectIndex: _selectIndex, index: index, getIndex: (int getIndex) => setState(() => _selectIndex = index));
                    }, childCount: _accounts.length, addRepaintBoundaries: false, addAutomaticKeepAlives: false,
                    )
                ),
              ),
              SizedBox(height: 20.w),
              _BtnNewAccount(addNewAccount: _addNewAccount),
              SizedBox(height: 40.w),
              const _BtnSure(),
            ],
          ),
        ),
    );
  }
}

class _Dialog extends StatelessWidget {
  final Function() postNewAccount;
  final void Function()? cancel;
  final GetName getName;
  final GetNumber getNumber;
  const _Dialog({Key? key, required this.postNewAccount, required this.cancel, required this.getName, required this.getNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('账户类型',
                      style: StyleTheme.font_black_34_13),
                  Text('銀行名',
                      style: StyleTheme.font_black_34_13),
                ],
              ),
            ),
            SizedBox(height: 10.w),
            Container(
              height: 50.w,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10.w),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: StyleTheme.gray238Color, width: 1.w),
                  borderRadius: BorderRadius.all(Radius.circular(10.w))),
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter(RegExp("[0-9]"), allow: false),
                  LengthLimitingTextInputFormatter(16),
                ],
                obscureText: false,
                keyboardType: TextInputType.number,
                autofocus: false,
                style: StyleTheme.font_black_34_17,
                textInputAction: TextInputAction.done,
                cursorColor: StyleTheme.black34Color,
                onSubmitted: (value) {},
                onChanged: (value) {
                  getNumber(value);
                },
                decoration: InputDecoration(
                  hintText: '请输入银行卡号',
                  hintStyle: StyleTheme.font_gray_153_17,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(color: Colors.transparent, width: 0.5.w)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(color: Colors.transparent, width: 0.5.w)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(color: Colors.transparent, width: 0.5.w)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(color: Colors.transparent, width: 0.5.w)),
                ),
              ),
            ),
            SizedBox(height: 10.w),
            Container(
              height: 50.w,
              padding: EdgeInsets.only(left: 10.w),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: StyleTheme.gray238Color, width: 1.w),
                  borderRadius: BorderRadius.all(Radius.circular(10.w))),
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter(RegExp("[\u4e00-\u9fa5]"), allow: false),
                ],
                obscureText: false,
                keyboardType: TextInputType.number,
                autofocus: false,
                style: StyleTheme.font_black_34_17,
                textInputAction: TextInputAction.done,
                cursorColor: StyleTheme.black34Color,
                onSubmitted: (value) {},
                onChanged: (value) {
                  getName(value);
                },
                decoration: InputDecoration(
                  hintText: '请输入持卡人姓名',
                  hintStyle: StyleTheme.font_gray_153_17,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(color: Colors.transparent, width: 0.5.w)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(color: Colors.transparent, width: 0.5.w)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(color: Colors.transparent, width: 0.5.w)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(color: Colors.transparent, width: 0.5.w)),
                ),
              ),
            ),
            SizedBox(height: 10.w),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                postNewAccount();
                cancel!();
              },
              child: Container(
                height: 50.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: StyleTheme.orange255Color,
                    borderRadius: BorderRadius.all(Radius.circular(10.w))),
                child: Text('添加',
                    style: StyleTheme.font_white_255_17),
              ),
            ),
          ],
        )
    );
  }
}

class _ItemAccount extends StatelessWidget {
  final dynamic e;
  final int selectIndex, index;
  final GetAccount getIndex;
  const _ItemAccount({Key? key, required this.e, required this.selectIndex, required this.index, required this.getIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            getIndex(index);
          },
          child: Container(
            height: 74.w,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: selectIndex == index ? StyleTheme.orange255Color : StyleTheme.gray238Color, width: 1.w),
              borderRadius: BorderRadius.all(Radius.circular(10.w)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(e['bank_type'],
                        style: StyleTheme.font_black_34_17),
                    Text(e['name'],
                        style: StyleTheme.font_gray_153_14),
                  ],
                ),
                Text(e['card'],
                    style: StyleTheme.font_black_34_20),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.w),
      ],
    );
  }
}

class _BtnNewAccount extends StatelessWidget {
  final Function() addNewAccount;
  const _BtnNewAccount({Key? key, required this.addNewAccount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        addNewAccount();
      },
      child: Container(
        width: double.infinity,
        height: 74.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: StyleTheme.gray238Color,
            borderRadius: BorderRadius.all(Radius.circular(10.w))),
        child: Text('添加新账号',
            style: StyleTheme.font_black_0_17),
      ),
    );
  }
}

class _BtnSure extends StatelessWidget {
  const _BtnSure({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: 200.w,
        height: 54.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: StyleTheme.orange255Color,
            borderRadius: BorderRadius.all(Radius.circular(27.w))),
        child: Text('确定',
            style: StyleTheme.font_white_255_17),
      ),
    );
  }
}