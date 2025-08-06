import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:provider/provider.dart';

import '../base/base_store.dart';
import '../base/base_widget.dart';
import '../base/request_api.dart';
import '../model/user_model.dart';
import '../util/style_theme.dart';
import '../util/utils.dart';
import 'mine_login_page.dart';

class MineBindEmailPage extends BaseWidget {
  final void Function()? callback;
  const MineBindEmailPage({Key? key, this.callback}) : super(key: key);

  @override
  cState() => _MineBindEmailPageState();
}

class _MineBindEmailPageState extends BaseWidgetState<MineBindEmailPage> {
  final mailTxt = TextEditingController();
  final verificationTxt = TextEditingController();

  @override
  void onCreate() {}

  void bindEmail() {
    if (_toEmailCheckAction(mailTxt.text) == false) {
      Utils.showText('请输入正确邮箱地址');
      return;
    }
    if (_toVerifyCodeCheckAction(verificationTxt.text) == false) {
      Utils.showText('请输入數字驗證碼');
      return;
    }

    Utils.startGif(tip: Utils.txt('jzz'));
    reqBindEmail(email: mailTxt.text, code: verificationTxt.text,).then((value) {
      Utils.closeGif();
      if (value?.status == 1) {
        UserModel? tp = Provider.of<BaseStore>(context, listen: false).user;
        if (tp == null) return;
        tp.email = mailTxt.text;
        Provider.of<BaseStore>(context, listen: false).setUser(tp);
        Utils.showText(value?.msg ?? "", call: () {
          Future.delayed(const Duration(milliseconds: 100), () {
            widget.callback?.call();
          });
        });
      } else {
        Utils.showText(value?.msg ?? "");
      }
    });
  }

  /// 邮箱验证码
  bool _toVerifyCodeCheckAction(String value) {
    return RegExp(r'^[0-9]*$').hasMatch(value);
  }

  /// 邮箱验证
  bool _toEmailCheckAction(String value) {
    // r'^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$';
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$')
        .hasMatch(value);
  }

  @override
  Widget appbar() {
    return Container();
  }

  @override
  void onDestroy() {}

  @override
  pageBody(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Utils.unFocusNode(context);
        },
        child: Column(children: [
          _buildTextFieldWidget(
            controller: mailTxt,
            hintText: '请输入您的邮箱',
            allow: false,
            length: 30,
          ),
          SizedBox(height: 10.w),
          SizedBox(height: 20.w),
          _buildTextFieldWidget(
            controller: verificationTxt,
            hintText: '请输入您的验证码',
            length: 6,
            suffix: VerificationCodeWidget(
              mailVc: mailTxt,
            ),
          ),
          SizedBox(height: 50.w),
          _buildSubmitActionWidget(
            title: '确定',
            onTap: bindEmail,
          ),
        ]),
      ),
    );
  }

  /// 提交按钮
  Widget _buildSubmitActionWidget(
      {required String title, void Function()? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap?.call(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.w),
          color: StyleTheme.orange255Color,
        ),
        alignment: Alignment.center,
        width: 320.w,
        height: 50.w,
        child: Text(
          title,
          style: StyleTheme.font_white_255_16,
        ),
      ),
    );
  }

  /// 输入框样式
  InputDecoration? _buildInputDecoration({String? hintText, Widget? suffix}) {
    InputBorder? border() => OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: BorderSide(color: Colors.transparent, width: 1.w),
        );
    return InputDecoration(
      hintText: hintText,
      hintStyle: StyleTheme.font_gray_153_14,
      suffix: suffix,
      suffixStyle: StyleTheme.font_black_34_13,
      contentPadding: EdgeInsets.zero,
      isDense: true,
      disabledBorder: border(),
      focusedBorder: border(),
      border: border(),
      enabledBorder: border(),
    );
  }

  /// 创建输入框
  /// format defalut '[a-zA-Z]|[0-9]'
  /// allow default true
  /// length default 20
  Widget _buildTextFieldWidget({
    bool obscureText = false,
    String? hintText,
    TextEditingController? controller,
    String? format,
    bool? allow,
    int? length,
    Widget? suffix,
  }) {
    Widget current = TextField(
      inputFormatters: [
        // FilteringTextInputFormatter(RegExp(format ?? '[a-zA-Z]|[0-9]'),
        //     allow: allow ?? true),
        LengthLimitingTextInputFormatter(length ?? 20),
      ],
      obscureText: obscureText,
      keyboardType: TextInputType.text,
      controller: controller,
      style: StyleTheme.font(size: 16, color: StyleTheme.black31Color),
      textInputAction: TextInputAction.done,
      cursorColor: StyleTheme.black31Color,
      decoration: _buildInputDecoration(hintText: hintText),
    );

    /// 验证码
    if (suffix != null) {
      current = Row(children: [Expanded(child: current), suffix]);
    }

    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      height: 44.w,
      width: 320.w,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: StyleTheme.gray231Color, width: 1.w),
        borderRadius: BorderRadius.all(Radius.circular(5.w)),
      ),
      child: current,
    );
  }
}
