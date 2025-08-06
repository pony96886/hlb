import 'package:hlw/util/encdecrypt.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/netimage_tool.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'dart:convert' as convert;

class HomePreviewViewPage extends StatefulWidget {
  HomePreviewViewPage({Key? key, this.url = ""}) : super(key: key);
  String url;

  @override
  _HomePreviewViewPageState createState() => _HomePreviewViewPageState();
}

class _HomePreviewViewPageState extends State<HomePreviewViewPage> {
  int currentIndex = 0;
  late PageController _controller;
  List<GlobalKey> keyList = [];
  List<TransformationController> transformationControllerList = [];
  int _selectedIndex = 0;
  PhotoViewScaleState scaleState = PhotoViewScaleState.initial;
  bool hasPop = false;
  Map mediaMap = {};

  void setupData() {
    if (widget.url.isEmpty) return;
    mediaMap = convert.jsonDecode(EncDecrypt.decry(widget.url));

    mediaMap['resources'].forEach((item) {
      GlobalKey _key = GlobalKey();
      TransformationController transformationController =
          TransformationController();
      transformationControllerList.add(transformationController);
      keyList.add(_key);
    });
    _controller = PageController(initialPage: mediaMap['index']);
    _controller.addListener(() {
      if (_controller.page == _controller.page) {
        _selectedIndex = _controller.page!.toInt();
        setState(() {});
      }
    });
    currentIndex = mediaMap['index'];
    _selectedIndex = currentIndex;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setupData();
    Utils.setStatusBar(isLight: true);
  }

  @override
  void dispose() {
    super.dispose();
    Utils.setStatusBar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: widget.url.isEmpty
          ? Container()
          : Stack(
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onHorizontalDragUpdate: (e) {},
                      onTap: () {
                        if (scaleState == PhotoViewScaleState.initial) {
                          Utils.splitPopView(context);
                        }
                      },
                      onVerticalDragUpdate: (e) {
                        if (scaleState == PhotoViewScaleState.initial) {
                          if (e.delta.dy > 5 && hasPop == false) {
                            hasPop = true;
                            Utils.splitPopView(context);
                          }
                        }
                      },
                      child: PhotoViewGallery.builder(
                        scrollPhysics: const BouncingScrollPhysics(),
                        pageController: _controller,
                        itemCount: mediaMap['resources'].length,
                        onPageChanged: (index) {},
                        scaleStateChangedCallback: (value) {
                          scaleState = value;
                        },
                        builder: (context, index) {
                          var e = mediaMap['resources'][index];
                          Widget tp = NetImageTool(fit: BoxFit.contain, url: e);
                          return PhotoViewGalleryPageOptions.customChild(
                            initialScale: 1.0,
                            minScale: 1.0,
                            maxScale: 10.0,
                            child: tp,
                          );
                        },
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      child: IgnorePointer(
                        child: Container(
                          height: 80.w,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(0, 0, 0, 0.6),
                                Color.fromRGBO(0, 0, 0, 0.0)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                        child: Column(
                      children: [
                        Container(height: StyleTheme.topHeight),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: StyleTheme.margin),
                          height: StyleTheme.navHegiht,
                          child: Stack(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    child: SizedBox(
                                      height: double.infinity,
                                      child: LocalPNG(
                                        name: "51_close_n",
                                        width: 14.w,
                                        height: 14.w,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    onTap: () {
                                      Utils.splitPopView(context);
                                    },
                                  ),
                                  Text(
                                    "${_selectedIndex + 1} / ${mediaMap['resources'].length}",
                                    style: StyleTheme.font(),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ))
                  ],
                ),
              ],
            ),
    );
  }
}

double? initScale({
  required Size imageSize,
  required Size size,
  double? initialScale,
}) {
  final double n1 = imageSize.height / imageSize.width;
  final double n2 = size.height / size.width;
  if (n1 > n2) {
    final FittedSizes fittedSizes =
        applyBoxFit(BoxFit.contain, imageSize, size);
    //final Size sourceSize = fittedSizes.source;
    final Size destinationSize = fittedSizes.destination;
    return size.width / destinationSize.width;
  } else if (n1 / n2 < 1 / 4) {
    final FittedSizes fittedSizes =
        applyBoxFit(BoxFit.contain, imageSize, size);
    //final Size sourceSize = fittedSizes.source;
    final Size destinationSize = fittedSizes.destination;
    return size.height / destinationSize.height;
  }

  return initialScale;
}
