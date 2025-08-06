import 'package:hlw/base/base_widget.dart';
import 'package:hlw/base/short_vlc_player.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/utils.dart';
// import 'package:fijkplayer/fijkplayer.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomePlayerPage extends BaseWidget {
  HomePlayerPage({Key? key, this.cover, this.url}) : super(key: key);
  late String? cover;
  late String? url;

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _HomePlayerPageState();
  }
}

class _HomePlayerPageState extends BaseWidgetState<HomePlayerPage> {
  @override
  Widget appbar() {
    // TODO: implement appbar
    return Container();
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
    widget.cover = Uri.decodeComponent(widget.cover ?? "");
    widget.url = Uri.decodeComponent(widget.url ?? "");
    Utils.log(widget.url);
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    return Container(
      color: Colors.black,
      child: widget.url?.isEmpty == true
          ? LoadStatus.noData()
          : ShortVLCPlayer(
             key: ValueKey(widget.url),
             cover_url: widget.cover ?? "", url: widget.url ?? ""
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
