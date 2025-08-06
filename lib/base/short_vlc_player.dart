// ignore_for_file: non_constant_identifier_names, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/netimage_tool.dart';
import 'package:hlw/util/nvideourl_minxin.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class ShortVLCPlayer extends StatefulWidget {
  const ShortVLCPlayer({
    Key? key,
    this.cover_url = "",
    this.url = "",
  }) : super(key: key);
  final String url;
  final String cover_url;

  @override
  State<ShortVLCPlayer> createState() => _ShortVLCPlayerState();
}

class _ShortVLCPlayerState extends State<ShortVLCPlayer> with NVideoURLMinxin {
  // Reference to the [VideoController] instance.
  VideoController? controller;
  bool isReady = false;
  // Create a [Player] instance from `package:media_kit`.
  Player player = Player(
    configuration: const PlayerConfiguration(
      logLevel: MPVLogLevel.warn,
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initURL();
  }

  initURL() {
    Future.microtask(() async {
      // Create a [VideoController] instance from `package:media_kit_video`.
      // Pass the [handle] of the [Player] from `package:media_kit` to the [VideoController] constructor.
      controller = await VideoController.create(player.handle);
      player.open(Media(widget.url));
      setState(() {});
    });
  }

  @override
  void dispose() {
    Future.microtask(() async {
      Utils.log('Disposing [Player] and [VideoController]...');
      await player.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommandController(
          player: player,
          coverURL: widget.cover_url,
          url: widget.url,
          controller: controller,
        ),
        Positioned(
          left: 0,
          top: 0,
          child: Utils.createNav(
            left: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Utils.splitPopView(context);
              },
              child: Container(
                alignment: Alignment.centerLeft,
                width: 40.w,
                height: 40.w,
                child: LocalPNG(
                  name: "51_nav_back_w",
                  width: 17.w,
                  height: 17.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

//控制层
class CommandController extends StatefulWidget {
  CommandController({
    Key? key,
    required this.player,
    required this.controller,
    this.coverURL = '',
    this.url = '',
  }) : super(key: key);
  final Player player;
  final String coverURL;
  final String url;

  final VideoController? controller;

  @override
  State<CommandController> createState() => _CommandControllerState();
}

class _CommandControllerState extends State<CommandController> {
  bool isPlaying = false;
  bool isBuffering = false;
  bool isCompleted = false;
  bool isError = false;
  bool isCanPress = true;
  bool isVisible = true;
  bool isFirstVisible = true; //是否第一次隐藏
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  List<StreamSubscription> subscriptions = [];

  bool _hideSpeedStu = true;
  double _speed = 1.0;
  Map<String, double> speedList = {
    "2.0": 2.0,
    "1.8": 1.8,
    "1.5": 1.5,
    "1.2": 1.2,
    "1.0": 1.0,
  };

  setupSubscrip() {
    subscriptions = [
      widget.player.streams.error.listen((event) {
        isError = event.code != 200;
        setState(() {});
      }),
      widget.player.streams.completed.listen((event) {
        isCompleted = event;
        setState(() {});
      }),
      widget.player.streams.buffering.listen((event) {
        isBuffering = event;
        setState(() {});
      }),
      widget.player.streams.playing.listen((event) {
        isPlaying = event;
        setState(() {});
      }),
      widget.player.streams.position.listen((event) {
        position = event;
        setState(() {});
      }),
      widget.player.streams.duration.listen((event) {
        duration = event;
        setState(() {});
      }),
    ];
  }

  @override
  void initState() {
    super.initState();
    setupSubscrip();
  }

  // build 倍数列表
  List<Widget> _buildSpeedListWidget() {
    List<Widget> columnChild = [];
    speedList.forEach((String mapKey, double speedVals) {
      columnChild.add(
        Ink(
          child: InkWell(
            onTap: () {
              if (_speed == speedVals) return;
              setState(() {
                _speed = speedVals;
                _hideSpeedStu = true;
                widget.player.setRate(speedVals);
              });
            },
            child: Container(
              alignment: Alignment.center,
              width: 50,
              height: 30,
              child: Text(
                mapKey + " X",
                style: TextStyle(
                  color: _speed == speedVals
                      ? const Color(0xFFe86261)
                      : Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ),
      );
      columnChild.add(
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Container(
            width: 50,
            height: 1,
            color: Colors.white54,
          ),
        ),
      );
    });
    columnChild.removeAt(columnChild.length - 1);
    return columnChild;
  }

  Widget autoHideWidegt() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (isCanPress) {
            isCanPress = false;
            isVisible = true;
            if (mounted) setState(() {});
            Future.delayed(const Duration(seconds: 5), () {
              isVisible = false;
              isCanPress = true;
              _hideSpeedStu = true;
              if (mounted) setState(() {});
            });
          }
        },
        child: isVisible
            ? Stack(
                children: [
                  Center(
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 36.0,
                    ),
                  ),
                  Positioned(
                    top: StyleTheme.navHegiht + StyleTheme.topHeight,
                    left: 0,
                    right: 0,
                    bottom: 80,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        widget.player.playOrPause();
                      },
                      child: Container(),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: IgnorePointer(
                      child: Container(
                        height: 80,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(0, 0, 0, 0.7),
                              Color.fromRGBO(0, 0, 0, 0.0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: StyleTheme.margin,
                    right: StyleTheme.margin,
                    bottom: 30,
                    child: Row(
                      children: [
                        Text(position.toString().substring(2, 7),
                            style: StyleTheme.font_white_255_14),
                        Expanded(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 4.w, // 轨道高度
                              trackShape:
                                  const RoundedRectSliderTrackShape(), // 轨道形状，可以自定义
                              activeTrackColor: Colors.white, // 激活的轨道颜色
                              inactiveTrackColor: Colors.white24, // 未激活的轨道颜色
                              thumbShape: RoundSliderThumbShape(
                                  //  滑块形状，可以自定义
                                  enabledThumbRadius: 8.w // 滑块大小
                                  ),
                              thumbColor: Colors.white, // 滑块颜色
                              overlayShape: RoundSliderOverlayShape(
                                // 滑块外圈形状，可以自定义
                                overlayRadius: 16.w, // 滑块外圈大小
                              ),
                              overlayColor: Colors.white10, // 滑块外圈颜色
                            ),
                            child: Slider(
                              // thumbColor: Colors.white,
                              // activeColor: Colors.white,
                              // inactiveColor: Colors.white24,
                              // secondaryActiveColor: Colors.white,
                              min: 0.0,
                              max: duration.inMilliseconds.toDouble(),
                              value: position.inMilliseconds.toDouble().clamp(
                                    0,
                                    duration.inMilliseconds.toDouble(),
                                  ),
                              onChanged: (e) {
                                position = Duration(milliseconds: e ~/ 1);
                                setState(() {});
                              },
                              onChangeEnd: (e) {
                                widget.player
                                    .seek(Duration(milliseconds: e ~/ 1));
                                if (!widget.player.state.playing) {
                                  widget.player.play();
                                }
                              },
                            ),
                          ),
                        ),
                        Text(duration.toString().substring(2, 7),
                            style: StyleTheme.font_white_255_14),
                        SizedBox(width: StyleTheme.margin),
                        Ink(
                          padding: const EdgeInsets.all(5),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _hideSpeedStu = !_hideSpeedStu;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 40,
                              height: 30,
                              child: Text(
                                _speed.toString() + " X",
                                style: StyleTheme.font_white_255_14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 65.w,
                      right: 4.w,
                      child: !_hideSpeedStu
                          ? Container(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: _buildSpeedListWidget(),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            )
                          : Container())
                ],
              )
            : Builder(builder: (cx) {
                double total = duration.inMilliseconds.toDouble() == 0
                    ? 1
                    : duration.inMilliseconds.toDouble();
                double current = position.inMilliseconds.toDouble();
                return Container(
                  alignment: Alignment.bottomCenter,
                  child: LinearProgressIndicator(
                    minHeight: 4.w,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation(
                        Color.fromRGBO(246, 74, 82, 0.7)),
                    value: current / total,
                  ),
                );
              }),
      ),
    );
  }

  Widget diffStatusWidget() {
    if (isBuffering) {
      return Center(
        child: SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(
            backgroundColor: Colors.grey[400],
            valueColor: const AlwaysStoppedAnimation(
              Colors.white,
            ),
            strokeWidth: 1.w,
          ),
        ),
      );
    } else if (isCompleted) {
      return Stack(
        children: [
          Center(
              child: NetImageTool(url: widget.coverURL, fit: BoxFit.contain)),
          Container(color: Colors.black45),
          Center(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                widget.player.open(Media(widget.url));
                isBuffering = true;
                if (mounted) setState(() {});
              },
              child: const Icon(Icons.replay, color: Colors.white, size: 36.0),
            ),
          )
        ],
      );
    } else if (isError) {
      return Stack(
        children: [
          Center(
              child: NetImageTool(url: widget.coverURL, fit: BoxFit.contain)),
          Container(color: Colors.black45),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 失败图标
              const Icon(
                Icons.error,
                size: 36,
                color: Colors.white,
              ),
              // 错误信息
              const Text(
                "播放失败，反馈给客服！",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      );
    }
    return autoHideWidegt();
  }

  //加载动图
  Widget loadingWidegt() {
    return Stack(
      children: [
        Center(child: NetImageTool(url: widget.coverURL, fit: BoxFit.contain)),
        Container(color: Colors.black45),
        Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(
              backgroundColor: Colors.grey[400],
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              strokeWidth: 1.w,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          widget.controller == null
              ? loadingWidegt()
              : ValueListenableBuilder<int?>(
                  valueListenable: widget.controller!.id,
                  builder: (context, id, _) {
                    return ValueListenableBuilder<Rect?>(
                      valueListenable: widget.controller!.rect,
                      builder: (context, rect, _) {
                        if (id != null &&
                            rect != null &&
                            rect.width > 1.0 &&
                            rect.height > 1.0) {
                          //第一次显示自动隐藏
                          if (isFirstVisible) {
                            isFirstVisible = false;
                            Future.delayed(const Duration(seconds: 5), () {
                              if (!isCanPress) return;
                              isVisible = false;
                              if (mounted) setState(() {});
                            });
                          }
                          return Stack(
                            children: [
                              Center(
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: SizedBox(
                                    width: rect.width,
                                    height: rect.height,
                                    child: Texture(
                                        textureId: id,
                                        filterQuality: FilterQuality.high),
                                  ),
                                ),
                              ),
                              diffStatusWidget()
                            ],
                          );
                        } else {
                          return isCompleted || isError
                              ? diffStatusWidget()
                              : loadingWidegt();
                        }
                      },
                    );
                  },
                ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (final it in subscriptions) {
      it.cancel();
    }
    super.dispose();
  }
}
