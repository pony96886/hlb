import 'dart:async';

import 'package:hive/hive.dart';
import 'package:hlw/base/base_widget.dart';
import 'package:hlw/base/request_api.dart';
import 'package:hlw/util/app_global.dart';
import 'package:hlw/util/eventbus_class.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:provider/provider.dart';

import '../base/base_store.dart';
import '../model/user_model.dart';

enum OperateType { register, bindEmail, login, forgot }

class MineLoginPage extends BaseWidget {
  final String login;
  const MineLoginPage({super.key, this.login = "false"});

  @override
  State cState() => _MineLoginPageState();
}

class _MineLoginPageState extends BaseWidgetState<MineLoginPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late OperateType optType;
  final accountTxt = TextEditingController();
  // 首次密码
  final passwordTxt = TextEditingController();
  // 再次密码
  final onceAgainVc = TextEditingController();

  final mailTxt = TextEditingController();
  final verificationTxt = TextEditingController();
  final scrollController = ScrollController();
  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void onCreate() {
    optType = widget.login == 'true' ? OperateType.login : OperateType.register;
    Utils.log('login: ${widget.login}');
    if (widget.login == "true") {
      changeLogin();
    }
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _animation =
        CurvedAnimation(parent: _animationController!, curve: Curves.easeIn);
    _animationController?.forward();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (MediaQuery.of(context).viewInsets.bottom == 0) {
        scrollController.jumpTo(0);
      }
    });
  }

  @override
  void onDestroy() {
    accountTxt.clear();
    accountTxt.dispose();
    passwordTxt.clear();
    passwordTxt.dispose();
    onceAgainVc.clear();
    onceAgainVc.dispose();
    mailTxt.clear();
    mailTxt.dispose();
    verificationTxt.clear();
    verificationTxt.dispose();
    scrollController.dispose();
    _animationController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget appbar() => Container();

  @override
  Widget backGroundView() {
    return const LocalPNG(name: "hlw_mine_login_bg");
  }

  // 登入頁
  void changeLogin() {
    setState(() => optType = OperateType.login);
    _animationController?.reset();
    _animationController?.forward();
  }

  /// 註冊頁
  void changeRegister() {
    setState(() => optType = OperateType.register);
    _animationController?.reset();
    _animationController?.forward();
  }

  /// 忘記密碼頁
  void changeForget() {
    setState(() => optType = OperateType.forgot);
    _animationController?.reset();
    _animationController?.forward();
  }

  /// 规则校验
  /// 账号效验 字母、数字, 长度6-20
  bool _toAccountCheckAction(String value) {
    return RegExp(r'^[a-zA-Z0-9]{6,20}$').hasMatch(value);
  }

  /// 密码效验 字母、数字, 长度6-20
  bool _toPasswodCheckAction(String value) {
    return RegExp(r'^[a-zA-Z0-9]{6,20}$').hasMatch(value);
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

  /// 用户注册
  void userRegister() {
    if (_toAccountCheckAction(accountTxt.text) == false) {
      Utils.showText('账号只能是字母、数字，至少6位');
      return;
    }
    if (_toPasswodCheckAction(passwordTxt.text) == false) {
      Utils.showText('密码只能是字母、数字，至少6位');
      return;
    }

    if (_toPasswodCheckAction(onceAgainVc.text) == false) {
      Utils.showText('确认密码只能是字母、数字，至少6位');
      return;
    }

    if (onceAgainVc.text != passwordTxt.text) {
      Utils.showText('两次密码不相同，请重新输入');
      return;
    }

    /// 全屏加载，禁止其他操作
    LoadStatus.showSLoading(text: Utils.txt('zzzc'));
    reqLoginByReg(
      username: accountTxt.text.trim(),
      password: passwordTxt.text.trim(),
    ).then((res) {
      if (res?.status == 1) {
        AppGlobal.apiToken =
            res?.data is Map ? res?.data['token'] : res?.data ?? "";
        AppGlobal.appBox?.put("hlw_token", AppGlobal.apiToken);
        showDialogBox();
        setState(() => optType = OperateType.bindEmail);
      } else {
        Utils.showText(res?.msg ?? "");
      }
    }).whenComplete(() {
      LoadStatus.closeLoading();
    });
  }

  /// 用户登录
  void userLogin() {
    Utils.unFocusNode(context);
    if (_toAccountCheckAction(accountTxt.text) == false) {
      Utils.showText('账号只能是字母、数字，至少6位');
      return;
    }
    if (_toPasswodCheckAction(passwordTxt.text) == false) {
      Utils.showText('密码只能是字母、数字，至少6位');
      return;
    }
    LoadStatus.showSLoading(text: Utils.txt('zzdl'));
    reqLoginByAccount(username: accountTxt.text, password: passwordTxt.text)
        .then((res) {
      if (res?.status == 1) {
        Utils.showText(Utils.txt('cgdl'));
        AppGlobal.apiToken =
            res?.data is Map ? res?.data['token'] : res?.data ?? "";
        AppGlobal.appBox?.put("hlw_token", AppGlobal.apiToken);
        reqUserInfo(context).then((res) {
          UtilEventbus().fire(EventbusClass({"login": "login"}));
          finish();
          // UtilEventbus().fire(EventbusClass({"name": "rightBanner"}));
        });
      } else {
        Utils.showText(res?.msg ?? "");
      }
    }).whenComplete(() {
      LoadStatus.closeLoading();
    });
  }

  /// 邮箱绑定
  void bindEmail() {
    Utils.unFocusNode(context);
    if (_toEmailCheckAction(mailTxt.text) == false) {
      Utils.showText('请输入正确邮箱地址');
      return;
    }
    if (_toVerifyCodeCheckAction(verificationTxt.text) == false) {
      Utils.showText('请输入数字驗證碼');
      return;
    }

    Utils.startGif(tip: Utils.txt('zzzc'));
    reqBindEmail(email: mailTxt.text, code: verificationTxt.text).then((value) {
      if (value?.status == 1) {
        UserModel? tp = Provider.of<BaseStore>(context, listen: false).user;
        if (tp == null) return;
        tp.email = mailTxt.text;
        Provider.of<BaseStore>(context, listen: false).setUser(tp);
        finish();
      } else {
        Utils.showText(value?.msg ?? "");
      }
    }).whenComplete(() {
      LoadStatus.closeLoading();
    });
  }

  /// 忘記密碼
  void userForget() {
    Utils.unFocusNode(context);
    if (_toEmailCheckAction(mailTxt.text) == false) {
      Utils.showText('请输入正确邮箱地址');
      return;
    }

    if (_toVerifyCodeCheckAction(verificationTxt.text) == false) {
      Utils.showText('请输入数字驗證碼');
      return;
    }

    if (_toPasswodCheckAction(passwordTxt.text) == false) {
      Utils.showText('密码只能是字母、数字，至少6位');
      return;
    }

    if (_toPasswodCheckAction(onceAgainVc.text) == false) {
      Utils.showText('确认密码只能是字母、数字，至少6位');
      return;
    }

    if (onceAgainVc.text != passwordTxt.text) {
      Utils.showText('两次密码不相同，请重新输入');
      return;
    }

    resetPwd(
      email: mailTxt.text,
      code: verificationTxt.text,
      pwd: passwordTxt.text.trim(),
    ).then((value) {
      if (value?.status == 1) {
        AppGlobal.apiToken =
            value?.data is Map ? value?.data['token'] : value?.data ?? "";
        AppGlobal.appBox?.put("hlw_token", AppGlobal.apiToken);
        reqUserInfo(context).then((res) {
          Utils.showText('密码已更新');
          UtilEventbus().fire(EventbusClass({"login": "login"}));
          finish();
          // UtilEventbus().fire(EventbusClass({"name": "rightBanner"}));
        }).whenComplete(() {
          LoadStatus.closeLoading();
        });
      } else {
        LoadStatus.closeLoading();
        Utils.showText(value?.msg ?? "");
      }
    });
  }

  /// 弹出对话框提示用户保存自己的账号和密码
  void showDialogBox() {
    Utils.showDialog(
      padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 40.w),
      confirmBoxColor: StyleTheme.orange255Color,
      confirmTxt: Utils.txt('fzzhqbc'),
      setContent: () {
        return RichText(
          text: TextSpan(children: [
            TextSpan(
              text: Utils.txt('fzzhqbctx'),
              style: StyleTheme.font_gray_153_12,
            ),
            TextSpan(
              text: Utils.txt('fzzhqbcqw'),
              style: StyleTheme.font(size: 14, color: StyleTheme.red245Color),
            )
          ]),
        );
      },
      confirm: () {
        LoadStatus.showSLoading(text: Utils.txt('jzz'));
        reqUserInfo(context).then((res) {
          /// 复制信息
          Clipboard.setData(
            ClipboardData(
              text: '回家地址：${res?.data?.share?.share_url} '
                  '帐号：${accountTxt.text} '
                  '密码：${passwordTxt.text}',
            ),
          );

          /// 退出当前页面
          Utils.showText(Utils.txt('zccgdl'), call: () {
            if (mounted) {
              Future.delayed(const Duration(milliseconds: 100), () {
                // finish();
                UtilEventbus().fire(EventbusClass({"name": "login"}));
                UtilEventbus().fire(EventbusClass({"name": "rightBanner"}));
              });
            }
          });
        }).whenComplete(() {
          LoadStatus.closeLoading();
        });
      },
    );
  }

  @override
  Widget pageBody(BuildContext context) {
    Widget current = Stack(children: [
      Positioned(
        left: 40.w,
        top: 40.w,
        child: _buildPopButtonWidget(),
      ),
      Center(
        child: _buildContainerWidget(),
      ),
    ]);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Utils.unFocusNode(context);
      },
      child: current,
    );
  }

  /// 返回
  Widget _buildPopButtonWidget() {
    return GestureDetector(
      child: LocalPNG(
        name: "51_nav_back_w",
        width: 17.w,
        height: 17.w,
        fit: BoxFit.contain,
      ),
      behavior: HitTestBehavior.translucent,
      onTap: () {
        UtilEventbus().fire(EventbusClass({"login": "login"}));
        Navigator.pop(context);
      },
    );
  }

  /// 内容
  Widget _buildContainerWidget() {
    Widget current = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(0.0, 10.w, 10.w, 46.w),
          alignment: Alignment.topRight,
          child: _buildCloseContextWidget(), // 24.w
        ),
        LocalPNG(name: "hlw_logo", width: 200.w, height: 80.w, fit: BoxFit.fitWidth),
        _buildSwitchContentWidget(),
        SizedBox(height: 50.w), // 底部边距
      ],
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.w)),
            border: Border.all(color: Colors.transparent),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 24.w),
            ],
            color: Colors.black,
          ),
          width: 540.w,
          child: current,
        ),
        SizedBox(height: 30.w),
        Text('-温馨提示-', style: StyleTheme.font_orange_244_20_600),
        SizedBox(height: 10.w),
        Text('1.请务必记住自己的账号密码', style: StyleTheme.font_gray_153_18),
        Text('2.不提供密码修改', style: StyleTheme.font_gray_153_18),
        Text('3.不提供密码找回功能', style: StyleTheme.font_gray_153_18),
      ],
    );
  }

  /// 退出
  Widget _buildCloseContextWidget() {
    return GestureDetector(
      child: LocalPNG(
        name: "hlw_close_gray",
        width: 24.w,
        height: 24.w,
        fit: BoxFit.contain,
        color: Colors.white,
      ),
      behavior: HitTestBehavior.translucent,
      onTap: () {
        UtilEventbus().fire(EventbusClass({"login": "login"}));
        Navigator.pop(context);
      },
    );
  }

  /// 选择
  Widget _buildSwitchContentWidget() {
    Widget? current;
    switch (optType) {
      case OperateType.register:
        current = _buildRegisterWidget();
        break;
      case OperateType.bindEmail:
        current = _buildRegEmailWidget();
        break;
      case OperateType.login:
        current = _buildCurLoginWidget();
        break;
      case OperateType.forgot:
        current = _buildForgotWidget();
        break;
      default:
    }

    return FadeTransition(
      child: current,
      opacity: _animation!,
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
      hintStyle: StyleTheme.font_gray_153_20,
      suffix: suffix,
      suffixStyle: StyleTheme.font_black_34_20,
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
      style: StyleTheme.font(size: 20, color: StyleTheme.black31Color),
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
          style: StyleTheme.font_white_255_20,
        ),
      ),
    );
  }

  ///
  /// 注册内容
  ///
  Widget _buildRegisterWidget() {
    return Column(children: [
      SizedBox(height: 30.w),
      _buildTextFieldWidget(
        controller: accountTxt,
        hintText: '请设置用户名',
      ),
      SizedBox(height: 8.w),
      SizedBox(
        width: 320.w,
        child: Text(
          '用户名将用于登陆时使用，请务必牢记',
          style: StyleTheme.font_gray_153_15,
          textAlign: TextAlign.start,
        ),
      ),
      SizedBox(height: 18.w),
      _buildTextFieldWidget(
        controller: passwordTxt,
        hintText: '请设置密码',
        obscureText: true,
      ),
      SizedBox(height: 10.w),
      _buildTextFieldWidget(
        controller: onceAgainVc,
        hintText: '请输入确认密码',
        obscureText: true,
      ),
      SizedBox(height: 30.w),
      _buildSubmitActionWidget(
        title: Utils.txt('zuche'),
        onTap: userRegister,
      ),
      SizedBox(height: 18.w),
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => changeLogin(),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(
            '已有账号？',
            style: StyleTheme.font_gray_153_20,
          ),
          Text(
            Utils.txt('dneglu'),
            style: StyleTheme.font_gray_153_20,
          ),
        ]),
      ),
    ]);
  }

  ///
  /// 登陆内容
  ///
  Widget _buildCurLoginWidget() {
    return Column(children: [
      SizedBox(height: 30.w),
      _buildTextFieldWidget(
        controller: accountTxt,
        hintText: '请输入用户名',
      ),
      SizedBox(height: 10.w),
      _buildTextFieldWidget(
        controller: passwordTxt,
        hintText: '请输入密码',
        obscureText: true,
      ),
      SizedBox(height: 8.w),
      // Text(
      //   '黑料客户端与黑料网APP账号互通，用户名登录即可',
      //   style: StyleTheme.font_gray_153_15,
      //   maxLines: 2,
      // ),
      SizedBox(height: 30.w),
      _buildSubmitActionWidget(
        title: Utils.txt('dneglu'),
        onTap: userLogin,
      ),
      SizedBox(height: 18.w),
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => changeRegister(),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(
            '还没有注册？',
            style: StyleTheme.font_gray_153_20,
          ),
          Text(
            Utils.txt('zuche'),
            style: StyleTheme.font_gray_153_20,
          ),
        ]),
      ),
      SizedBox(height: 16.w),
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => changeForget(),
        child: Text(
          '忘记账号或密码',
          style: StyleTheme.font_gray_153_20,
        ),
      ),
    ]);
  }

  ///
  /// 忘记账号
  ///
  Widget _buildForgotWidget() {
    return Column(children: [
      SizedBox(height: 30.w),
      Text(
        '忘记密码了吗?',
        style: StyleTheme.font_gray_153_20,
      ),
      Text(
        '请填写您绑定的邮箱!',
        style: StyleTheme.font_gray_153_20,
      ),
      SizedBox(height: 18.w),
      _buildTextFieldWidget(
        controller: mailTxt,
        hintText: '请输入您的邮箱',
        allow: false,
        length: 30,
      ),
      SizedBox(height: 10.w),
      _buildTextFieldWidget(
        controller: verificationTxt,
        hintText: '请输入您的验证码',
        length: 6,
        suffix: VerificationCodeWidget(
          mailVc: mailTxt,
        ),
      ),
      SizedBox(height: 10.w),
      _buildTextFieldWidget(
        controller: passwordTxt,
        hintText: '请设置密码',
        obscureText: true,
      ),
      SizedBox(height: 10.w),
      _buildTextFieldWidget(
        controller: onceAgainVc,
        hintText: '请输入确认密码',
        obscureText: true,
      ),
      SizedBox(height: 30.w),
      _buildSubmitActionWidget(
        title: '确定',
        onTap: userForget,
      ),
    ]);
  }

  ///
  /// 注册邮箱
  ///
  Widget _buildRegEmailWidget() {
    return Column(children: [
      SizedBox(height: 30.w),
      _buildTextFieldWidget(
        controller: mailTxt,
        hintText: '请输入您的邮箱',
        allow: false,
        length: 30,
      ),
      SizedBox(height: 10.w),
      _buildTextFieldWidget(
        controller: verificationTxt,
        hintText: '请输入您的验证码',
        length: 6,
        suffix: VerificationCodeWidget(
          mailVc: mailTxt,
        ),
      ),
      SizedBox(height: 30.w),
      _buildSubmitActionWidget(
        title: '确定',
        onTap: bindEmail,
      ),
    ]);
  }
}

///
/// 验证码 部件
///
class VerificationCodeWidget extends StatefulWidget {
  final TextEditingController mailVc;
  const VerificationCodeWidget({super.key, required this.mailVc});

  @override
  State createState() => _VerificationCodeWidgetState();
}

class _VerificationCodeWidgetState extends State<VerificationCodeWidget> {
  Timer? _timer;
  int _count = 0;

  @override
  void dispose() {
    super.dispose();
    _disposeTimer();
  }

  void _disposeTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// 邮箱验证
  bool _toEmailCheckAction(String value) {
    // r'^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$';
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$')
        .hasMatch(value);
  }

  void onGetCode() {
    if (_count > 0) {
      Utils.showText('$_count秒后重试');
      return;
    }

    if (_toEmailCheckAction(widget.mailVc.text) == false) {
      Utils.showText('请输入正确邮箱地址');
      return;
    }
    Utils.startGif(tip: Utils.txt('jzz'));
    reqEmailCode(email: widget.mailVc.text).then((value) {
      Utils.closeGif();
      if (value?.status == 1) {
        if (mounted) setState(() => _count = 60);
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (mounted) setState(() => _count--);
          if (_count == 0) _disposeTimer();
        });
      } else {
        Utils.showText(value?.msg ?? "");
      }
    }).whenComplete(() {
      LoadStatus.closeLoading();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget current = Text(
      _count == 0 ? '获取验证码' : "重新发送(${_count}s)",
      style: _count == 0
          ? StyleTheme.font_black_34_20
          : StyleTheme.font_orange_255_20,
    );
    current = Container(
      height: 40.w,
      width: 102.w,
      alignment: Alignment.center,
      child: current,
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onGetCode(),
      child: current,
    );
  }
}
