import 'package:hlw/base/base_main_view.dart';
import 'package:hlw/base/base_store.dart';
import 'package:hlw/base/base_widget.dart';
import 'package:hlw/base/request_api.dart';
import 'package:hlw/model/user_model.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:provider/provider.dart';

class MineUpdatePage extends BaseWidget {
  const MineUpdatePage({Key? key, this.type = "nickname", this.title = ""})
      : super(key: key);
  final String? type; //修改昵称：nickname 填写邀请码：invite 兑换码：code
  final String? title;

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _MineUpdatePageState();
  }
}

class _MineUpdatePageState extends BaseWidgetState<MineUpdatePage> {
  //文本框
  TextEditingController controller = TextEditingController();

  @override
  void onCreate() {
    // TODO: implement onCreate
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

  void dealPostData() {
    if (controller.text.isEmpty) {
      Utils.showText(Utils.txt('qtxnrong'));
      return;
    }
    UserModel? user = Provider.of<BaseStore>(context, listen: false).user;

    Utils.startGif(tip: Utils.txt('jzz'));

    //修改昵称
    if (widget.type == "nickname") {
      reqUpdateUserInfo(nickname: controller.text).then((value) {
        Utils.closeGif();
        if (value?.status == 1 && user != null) {
          user.nickname = controller.text;
          Provider.of<BaseStore>(context, listen: false).setUser(user);
          // 修改昵称没有弹出成功 因为返回的msg是空的 所以直接弹出一个 成功 然后直接返回
          Utils.showText(Utils.txt('cg'));
          finish();
          return;
        }
        if (value?.msg?.isNotEmpty == true) {
          Utils.showText(value?.msg ?? "");
        }
      });
    }
    //填写邀请码
    if (widget.type == "invite") {
      reqInvitation(affCode: controller.text).then((value) {
        Utils.closeGif();
        if (value?.status == 1 && user != null) {
          user.invited_by = controller.text;
          Provider.of<BaseStore>(context, listen: false).setUser(user);
        }
        if (value?.msg?.isNotEmpty == true) {
          Utils.showText(value?.msg ?? "");
        }
      });
    }
    //填写兑换码
    if (widget.type == "code") {
      reqOnExchange(cdk: controller.text).then((value) {
        Utils.closeGif();
        if (value?.msg?.isNotEmpty == true) {
          Utils.showText(value?.msg ?? "");
        }
      });
    }
  }

  @override
  Widget pageBody(BuildContext context) {
    return BaseMainView(
        paddingTop: 94.w,
        paddingLeft: 110.w,
        isBackBtn: true,
        backTitle: widget.type == "nickname" ? Utils.txt('xgnichen') : widget.title ?? "",
        leftWidget: SizedBox(
          width: 540.w,
          height: ScreenHeight - 94.w,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Utils.unFocusNode(context);
            },
            child: Column(
              children: [
                SizedBox(height: 20.w),
                Container(
                  height: 74.w,
                  margin: EdgeInsets.symmetric(horizontal: StyleTheme.margin),
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                      color: StyleTheme.gray242Color,
                      borderRadius: BorderRadius.all(Radius.circular(10.w))),
                  alignment: Alignment.center,
                  child: TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter(
                          RegExp("[a-zA-Z]|[0-9]|[\u4e00-\u9fa5]"),
                          allow: true),
                      LengthLimitingTextInputFormatter(10)
                    ],
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    onChanged: (e) {},
                    onSubmitted: (e) {},
                    controller: controller,
                    style: StyleTheme.font_black_34_17,
                    textInputAction: TextInputAction.done,
                    cursorColor: StyleTheme.black31Color,
                    decoration: InputDecoration(
                      hintText: "${Utils.txt("qsr")}${widget.title ?? ""}",
                      hintStyle: StyleTheme.font_gray_102_17,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          borderSide: const BorderSide(color: Colors.transparent, width: 0)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          borderSide: const BorderSide(color: Colors.transparent, width: 0)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          borderSide: const BorderSide(color: Colors.transparent, width: 0)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          borderSide: const BorderSide(color: Colors.transparent, width: 0)),
                    ),
                  ),
                ),
                SizedBox(height: 50.w),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: StyleTheme.margin),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      dealPostData();
                    },
                    child: Container(
                      height: 74.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: StyleTheme.orange255Color,
                        borderRadius: BorderRadius.all(Radius.circular(10.w)),
                      ),
                      child: Text(
                        Utils.txt('quren'),
                        style: StyleTheme.font_white_255_17,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
