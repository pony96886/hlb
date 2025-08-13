import 'package:hlw/base/base_widget.dart';
import 'package:hlw/base/short_vlc_player.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/utils.dart';
// import 'package:fijkplayer/fijkplayer.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomePlayerPage extends BaseWidget {
  const HomePlayerPage({Key? key, this.cover, this.url}) : super(key: key);
  final String? cover;
  final String? url;

  @override
  State<StatefulWidget> cState() {
    return _HomePlayerPageState();
  }
}

class _HomePlayerPageState extends BaseWidgetState<HomePlayerPage> {
  late String cover;
  late String url;
  @override
  Widget appbar() {
    return Container();
  }

  @override
  void onCreate() {
    cover = Uri.decodeComponent(widget.cover ?? "");
    url = Uri.decodeComponent(widget.url ?? "");
    Utils.log(url);
  }

  @override
  void onDestroy() {}

  @override
  Widget pageBody(BuildContext context) {
    return Container(
      color: Colors.black,
      child: widget.url?.isEmpty == true
          ? LoadStatus.noData()
          : ShortVLCPlayer(key: ValueKey(url), cover_url: cover, url: url),
    );
  }
}
