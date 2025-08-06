import 'package:hlw/util/style_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/network_imagecrp.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:shimmer/shimmer.dart';

//网络图片加载
class NetImageTool extends StatelessWidget {
  const NetImageTool({
    Key? key,
    this.url = "",
    this.fit = BoxFit.cover,
    this.scale = 1.0,
    this.radius = const BorderRadius.all(Radius.circular(0)),
    this.isThirdExt = false,
  }) : super(key: key);
  final String url;
  final BoxFit fit;
  final double scale;
  final BorderRadius radius;
  final bool isThirdExt;

  @override
  Widget build(BuildContext context) {
    // print('图片-------> $url');
    return ClipRRect(
      borderRadius: radius,
      child: url.isEmpty
          ? Container(color: StyleTheme.gray204Color)
          : _NetImageWork(
              provider: NetworkImageCRP(
                url,
                scale: scale,
                context: context,
              ),
              fit: fit,
            ),
    );
  }
}

class _NetImageWork extends StatefulWidget {
  const _NetImageWork({Key? key, @required this.provider, this.fit})
      : assert(provider != null),
        super(key: key);
  final BoxFit? fit;
  final NetworkImageCRP? provider;

  @override
  State<_NetImageWork> createState() => __NetImageWorkState();
}

class __NetImageWorkState extends State<_NetImageWork>
    with SingleTickerProviderStateMixin {
  ImageStream? _imageStream;
  ImageInfo? _imageInfo;
  bool _loading = true; //图片加载状态，加载中则为true
  AnimationController? _controller;
  Animation<double>? _animation;
  DisposableBuildContext<State<_NetImageWork>>? _scrollAwareContext;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollAwareContext = DisposableBuildContext<State<_NetImageWork>>(this);
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _animation = Tween(begin: 1.0, end: 1.0).animate(_controller!);
    _controller?.forward();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _resolveImage();
  }

  @override
  void didUpdateWidget(covariant _NetImageWork oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.provider != oldWidget.provider) _resolveImage();
  }

  void _resolveImage() {
    final ScrollAwareImageProvider _provider = ScrollAwareImageProvider<Object>(
      context: _scrollAwareContext!,
      imageProvider: widget.provider!,
    );
    final ImageStream? oldImageStream = _imageStream;
    //调用imageProvider.resolve方法，获得ImageStream。
    _imageStream = _provider.resolve(createLocalImageConfiguration(context));
    //判断新旧ImageStream是否相同，如果不同，则需要调整流的监听器
    if (_imageStream?.key != oldImageStream?.key) {
      final ImageStreamListener listener = ImageStreamListener(_updateImage);
      oldImageStream?.removeListener(listener);
      _imageStream?.addListener(listener);
    }
  }

  void _updateImage(ImageInfo imageInfo, bool synchronousCall) {
    if (mounted) {
      _imageInfo = imageInfo;
      _loading = false;
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? (kIsWeb && widget.fit == BoxFit.cover
            ? Container(color: const Color.fromRGBO(204, 204, 204, 1))
            : widget.fit == BoxFit.contain
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(StyleTheme.margin),
                      child: SizedBox(
                        height: 20.w,
                        width: 20.w,
                        child: CircularProgressIndicator(
                          color: StyleTheme.gray77Color,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  )
                : Shimmer.fromColors(
                    baseColor: const Color.fromRGBO(204, 204, 204, 1),
                    highlightColor: const Color.fromRGBO(204, 204, 204, .5),
                    enabled: _loading,
                    child: Container(color: Colors.white),
                  ))
        : widget.fit == BoxFit.cover
            ? RawImage(
                filterQuality: FilterQuality.medium, //质量越高容易花屏
                width: double.infinity,
                height: double.infinity,
                opacity: _animation,
                image: _imageInfo!.image,
                scale: _imageInfo!.scale,
                repeat: ImageRepeat.noRepeat,
                fit: widget.fit,
              )
            : LayoutBuilder(builder: (context, constraints) {
                double width = constraints.maxWidth;
                double w = _imageInfo!.image.width.toDouble();
                double h = _imageInfo!.image.height.toDouble();
                width = w > width ? width : w;
                return RawImage(
                  width: width,
                  height: width / w * h,
                  filterQuality: FilterQuality.medium,
                  opacity: _animation,
                  image: _imageInfo!.image,
                  scale: _imageInfo!.scale,
                  repeat: ImageRepeat.noRepeat,
                  fit: widget.fit,
                );
              });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _imageStream?.removeListener(ImageStreamListener(_updateImage));
    _controller?.dispose();
    _scrollAwareContext?.dispose();
    super.dispose();
  }
}
