import 'package:hlw/base/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/utils.dart';

class NormalWeb extends BaseWidget {
  final String? url;
  final Widget? widgetMacos;
  const NormalWeb({Key? key, this.url, this.widgetMacos}) : super(key: key);

  @override
  State<NormalWeb> createState() => _NormalWebState();

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _NormalWebState();
  }
}

class _NormalWebState extends BaseWidgetState<NormalWeb> {

  @override
  void onCreate() {
    // TODO: implement onCreate
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    if (widget.url != null && widget.url?.isNotEmpty == true) Utils.openURL(widget.url!);
    return Container();
    // final _url = widget.url ?? "";
    // if (Platform.isMacOS) Utils.openWebViewMacos(PresentationStyle.sheet, _url);
    // return Platform.isMacOS ? widget.widgetMacos! : WebViewWindows(url: _url);
  }
}
