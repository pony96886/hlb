// ignore_for_file: use_key_in_widget_constructors

import 'dart:async';
import 'dart:math' as math;

import 'package:hlw/util/style_theme.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart' as physics;
import 'package:hlw/util/desktop_extension.dart';

class WindowsPullRefresh extends StatefulWidget {
  const WindowsPullRefresh({
    Key? key,
    this.child,
    this.onRefresh,
    this.onLoading,
    this.isSliver = true,
  }) : super(key: key);
  final Widget? child;
  final bool isSliver;
  final Future<bool> Function()? onRefresh;
  final Future<bool> Function()? onLoading;

  @override
  State<WindowsPullRefresh> createState() => _WindowsPullRefreshState();
}

class _WindowsPullRefreshState extends State<WindowsPullRefresh> {
  late EasyRefreshController _controller;

  void setupData() {
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupData();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isSliver
        ? EasyRefresh(
      controller: _controller,
      child: CustomScrollView(
        slivers: [
          widget.child ?? SliverToBoxAdapter(child: Container()),
          const FooterLocator.sliver(),
        ],
      ),
      header: widget.onRefresh == null
          ? null
          : ExtClassicHeader(
        textStyle: StyleTheme.font(size: 14, color: Colors.white),
        showMessage: false,
        showText: false,
        spacing: 5,
        safeArea: false,
      ),
      footer: widget.onLoading == null
          ? null
          : ExtClassicFooter(
        textStyle: StyleTheme.font(size: 14, color: Colors.white),
        showMessage: true,
        showText: true,
        spacing: 5,
        position: IndicatorPosition.locator,
      ),
      onRefresh: widget.onRefresh == null
          ? null
          : () async {
        await widget.onRefresh?.call();
        if (!mounted) return;
        _controller.finishRefresh();
        _controller.resetFooter();
        setState(() {});
      },
      onLoad: widget.onLoading == null
          ? null
          : () async {
        bool noMore = await widget.onLoading?.call() ?? false;
        if (!mounted) return;
        _controller.finishLoad(noMore
            ? IndicatorResult.noMore
            : IndicatorResult.success);
        setState(() {});
      },
    )
        : EasyRefresh(
      controller: _controller,
      child: widget.child ?? Container(),
      header: widget.onRefresh == null
          ? null
          : ExtClassicHeader(
        textStyle: StyleTheme.font(size: 14, color: Colors.white),
        showMessage: false,
        showText: false,
        spacing: 5,
        safeArea: false,
      ),
      footer: widget.onLoading == null
          ? null
          : ExtClassicFooter(
        textStyle: StyleTheme.font(size: 14, color: Colors.white),
        showMessage: true,
        showText: true,
        spacing: 5,
      ),
      onRefresh: widget.onRefresh == null
          ? null
          : () async {
        await widget.onRefresh?.call();
        if (!mounted) return;
        _controller.finishRefresh();
        _controller.resetFooter();
        setState(() {});
      },
      onLoad: widget.onLoading == null
          ? null
          : () async {
        bool noMore = await widget.onLoading?.call() ?? false;
        if (!mounted) return;
        _controller.finishLoad(noMore
            ? IndicatorResult.noMore
            : IndicatorResult.success);
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Classic header.
class ExtClassicHeader extends Header {
  final Key? key;

  /// The location of the widget.
  /// Only supports [MainAxisAlignment.center],
  /// [MainAxisAlignment.start] and [MainAxisAlignment.end].
  final MainAxisAlignment mainAxisAlignment;

  /// Background color.
  final Color? backgroundColor;

  /// Text on [IndicatorMode.drag].
  final String? dragText;

  /// Text on [IndicatorMode.armed].
  final String? armedText;

  /// Text on [IndicatorMode.ready].
  final String? readyText;

  /// Text on [IndicatorMode.processing].
  final String? processingText;

  /// Text on [IndicatorMode.processed].
  final String? processedText;

  /// Text on [IndicatorResult.noMore].
  final String? noMoreText;

  /// Text on [IndicatorResult.fail].
  final String? failedText;

  /// Whether to display text.
  final bool showText;

  /// Message text.
  /// %T will be replaced with the last time.
  final String? messageText;

  /// Whether to display message.
  final bool showMessage;

  /// The dimension of the text area.
  /// When less than 0, calculate the length of the text widget.
  final double? textDimension;

  /// The dimension of the icon area.
  final double iconDimension;

  /// Spacing between text and icon.
  final double spacing;

  /// Icon when [IndicatorResult.success].
  final Widget? succeededIcon;

  /// Icon when [IndicatorResult.fail].
  final Widget? failedIcon;

  /// Icon when [IndicatorResult.noMore].
  final Widget? noMoreIcon;

  /// Icon on pull.
  final CIPullIconBuilder? pullIconBuilder;

  /// Text style.
  final TextStyle? textStyle;

  /// Build text.
  final CITextBuilder? textBuilder;

  /// Text style.
  final TextStyle? messageStyle;

  /// Build message.
  final CIMessageBuilder? messageBuilder;

  /// Link [Stack.clipBehavior].
  final Clip clipBehavior;

  /// Icon style.
  final IconThemeData? iconTheme;

  /// Progress indicator size.
  final double? progressIndicatorSize;

  /// Progress indicator stroke width.
  /// See [CircularProgressIndicator.strokeWidth].
  final double? progressIndicatorStrokeWidth;

  const ExtClassicHeader({
    this.key,
    double triggerOffset = 70,
    bool clamping = false,
    IndicatorPosition position = IndicatorPosition.above,
    Duration processedDuration = const Duration(seconds: 1),
    physics.SpringDescription? spring,
    SpringBuilder? readySpringBuilder,
    bool springRebound = true,
    FrictionFactor? frictionFactor,
    bool safeArea = true,
    double? infiniteOffset,
    bool? hitOver,
    bool? infiniteHitOver,
    bool hapticFeedback = false,
    bool triggerWhenReach = false,
    bool triggerWhenRelease = false,
    double maxOverOffset = double.infinity,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.backgroundColor,
    this.dragText,
    this.armedText,
    this.readyText,
    this.processingText,
    this.processedText,
    this.noMoreText,
    this.failedText,
    this.showText = true,
    this.messageText,
    this.showMessage = true,
    this.textDimension,
    this.iconDimension = 24,
    this.spacing = 16,
    this.succeededIcon,
    this.failedIcon,
    this.noMoreIcon,
    this.pullIconBuilder,
    this.textStyle,
    this.textBuilder,
    this.messageStyle,
    this.messageBuilder,
    this.clipBehavior = Clip.hardEdge,
    this.iconTheme,
    this.progressIndicatorSize,
    this.progressIndicatorStrokeWidth,
  }) : super(
    triggerOffset: triggerOffset,
    clamping: clamping,
    processedDuration: processedDuration,
    spring: spring,
    readySpringBuilder: readySpringBuilder,
    springRebound: springRebound,
    frictionFactor: frictionFactor,
    safeArea: safeArea,
    infiniteOffset: infiniteOffset,
    hitOver: hitOver,
    infiniteHitOver: infiniteHitOver,
    position: position,
    hapticFeedback: hapticFeedback,
    triggerWhenReach: triggerWhenReach,
    triggerWhenRelease: triggerWhenRelease,
    maxOverOffset: maxOverOffset,
  );

  @override
  Widget build(BuildContext context, IndicatorState state) {
    return _ExtClassicIndicator(
      key: key,
      state: state,
      backgroundColor: backgroundColor,
      mainAxisAlignment: mainAxisAlignment,
      dragText: dragText ?? '下拉刷新',
      armedText: armedText ?? '释放刷新',
      readyText: readyText ?? '加载中',
      processingText: processingText ?? '加载中',
      processedText: processedText ?? '成功',
      noMoreText: noMoreText ?? '',
      failedText: failedText ?? '失败',
      showText: showText,
      messageText: messageText ?? '最后更新 %T',
      showMessage: showMessage,
      textDimension: textDimension,
      iconDimension: iconDimension,
      spacing: spacing,
      reverse: state.reverse,
      succeededIcon: succeededIcon,
      failedIcon: failedIcon,
      noMoreIcon: noMoreIcon,
      pullIconBuilder: pullIconBuilder,
      textStyle: textStyle,
      textBuilder: textBuilder,
      messageStyle: messageStyle,
      messageBuilder: messageBuilder,
      clipBehavior: clipBehavior,
      iconTheme: iconTheme,
      progressIndicatorSize: progressIndicatorSize,
      progressIndicatorStrokeWidth: progressIndicatorStrokeWidth,
    );
  }
}

/// Classic footer.
class ExtClassicFooter extends Footer {
  final Key? key;

  /// The location of the widget.
  /// Only supports [MainAxisAlignment.center],
  /// [MainAxisAlignment.start] and [MainAxisAlignment.end].
  final MainAxisAlignment mainAxisAlignment;

  /// Background color.
  final Color? backgroundColor;

  /// Text on [IndicatorMode.drag].
  final String? dragText;

  /// Text on [IndicatorMode.armed].
  final String? armedText;

  /// Text on [IndicatorMode.ready].
  final String? readyText;

  /// Text on [IndicatorMode.processing].
  final String? processingText;

  /// Text on [IndicatorMode.processed].
  final String? processedText;

  /// Text on [IndicatorResult.noMore].
  final String? noMoreText;

  /// Text on [IndicatorResult.fail].
  final String? failedText;

  /// Whether to display text.
  final bool showText;

  /// Message text.
  /// %T will be replaced with the last time.
  final String? messageText;

  /// Whether to display message.
  final bool showMessage;

  /// The dimension of the text area.
  /// When less than 0, calculate the length of the text widget.
  final double? textDimension;

  /// The dimension of the icon area.
  final double iconDimension;

  /// Spacing between text and icon.
  final double spacing;

  /// Icon when [IndicatorResult.success].
  final Widget? succeededIcon;

  /// Icon when [IndicatorResult.fail].
  final Widget? failedIcon;

  /// Icon when [IndicatorResult.noMore].
  final Widget? noMoreIcon;

  /// Icon on pull.
  final CIPullIconBuilder? pullIconBuilder;

  /// Text style.
  final TextStyle? textStyle;

  /// Build text.
  final CITextBuilder? textBuilder;

  /// Text style.
  final TextStyle? messageStyle;

  /// Build message.
  final CIMessageBuilder? messageBuilder;

  /// Link [Stack.clipBehavior].
  final Clip clipBehavior;

  /// Icon style.
  final IconThemeData? iconTheme;

  /// Progress indicator size.
  final double? progressIndicatorSize;

  /// Progress indicator stroke width.
  /// See [CircularProgressIndicator.strokeWidth].
  final double? progressIndicatorStrokeWidth;

  const ExtClassicFooter({
    this.key,
    double triggerOffset = 70,
    bool clamping = false,
    IndicatorPosition position = IndicatorPosition.above,
    Duration processedDuration = Duration.zero,
    physics.SpringDescription? spring,
    SpringBuilder? readySpringBuilder,
    bool springRebound = true,
    FrictionFactor? frictionFactor,
    bool safeArea = true,
    double? infiniteOffset = 70,
    bool? hitOver,
    bool? infiniteHitOver,
    bool hapticFeedback = false,
    bool triggerWhenReach = false,
    bool triggerWhenRelease = false,
    double maxOverOffset = double.infinity,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.backgroundColor,
    this.dragText,
    this.armedText,
    this.readyText,
    this.processingText,
    this.processedText,
    this.noMoreText,
    this.failedText,
    this.showText = true,
    this.messageText,
    this.showMessage = true,
    this.textDimension,
    this.iconDimension = 24,
    this.spacing = 16,
    this.succeededIcon,
    this.failedIcon,
    this.noMoreIcon,
    this.pullIconBuilder,
    this.textStyle,
    this.textBuilder,
    this.messageStyle,
    this.messageBuilder,
    this.clipBehavior = Clip.hardEdge,
    this.iconTheme,
    this.progressIndicatorSize,
    this.progressIndicatorStrokeWidth,
  }) : super(
    triggerOffset: triggerOffset,
    clamping: clamping,
    processedDuration: processedDuration,
    spring: spring,
    readySpringBuilder: readySpringBuilder,
    springRebound: springRebound,
    frictionFactor: frictionFactor,
    safeArea: safeArea,
    infiniteOffset: infiniteOffset,
    hitOver: hitOver,
    infiniteHitOver: infiniteHitOver,
    position: position,
    hapticFeedback: hapticFeedback,
    triggerWhenReach: triggerWhenReach,
    triggerWhenRelease: triggerWhenRelease,
    maxOverOffset: maxOverOffset,
  );

  @override
  Widget build(BuildContext context, IndicatorState state) {
    return _ExtClassicIndicator(
      key: key,
      state: state,
      backgroundColor: backgroundColor,
      mainAxisAlignment: mainAxisAlignment,
      dragText: '上拉刷新',
      armedText: '释放刷新',
      readyText: '加载中',
      processingText: '加载中',
      processedText: '成功',
      noMoreText: '-----我是有底线的-----',
      failedText: '失败',
      showText: showText,
      messageText: '最后更新 %T',
      showMessage: showMessage,
      textDimension: textDimension,
      iconDimension: iconDimension,
      spacing: spacing,
      reverse: !state.reverse,
      succeededIcon: succeededIcon,
      failedIcon: failedIcon,
      noMoreIcon: noMoreIcon,
      pullIconBuilder: pullIconBuilder,
      textStyle: textStyle,
      textBuilder: textBuilder,
      messageStyle: messageStyle,
      messageBuilder: messageBuilder,
      clipBehavior: clipBehavior,
      iconTheme: iconTheme,
      progressIndicatorSize: progressIndicatorSize,
      progressIndicatorStrokeWidth: progressIndicatorStrokeWidth,
    );
  }
}

///_ClassicIndicator

/// Pull icon widget builder.
typedef CIPullIconBuilder = Widget Function(
    BuildContext context, IndicatorState state, double animation);

/// Text widget builder.
typedef CITextBuilder = Widget Function(
    BuildContext context, IndicatorState state, String text);

/// Message widget builder.
typedef CIMessageBuilder = Widget Function(
    BuildContext context, IndicatorState state, String text, DateTime dateTime);

/// Default progress indicator size.
const _kDefaultProgressIndicatorSize = 16.0;

/// Default progress indicator stroke width.
const _kDefaultProgressIndicatorStrokeWidth = 1.0;

/// Classic indicator.
/// Base widget for [ClassicHeader] and [ClassicFooter].
class _ExtClassicIndicator extends StatefulWidget {
  /// Indicator properties and state.
  final IndicatorState state;

  /// The location of the widget.
  /// Only supports [MainAxisAlignment.center],
  /// [MainAxisAlignment.start] and [MainAxisAlignment.end].
  final MainAxisAlignment mainAxisAlignment;

  /// Background color.
  final Color? backgroundColor;

  /// Text on [IndicatorMode.drag].
  final String dragText;

  /// Text on [IndicatorMode.armed].
  final String armedText;

  /// Text on [IndicatorMode.ready].
  final String readyText;

  /// Text on [IndicatorMode.processing].
  final String processingText;

  /// Text on [IndicatorMode.processed].
  final String processedText;

  /// Text on [IndicatorResult.noMore].
  final String noMoreText;

  /// Text on [IndicatorResult.fail].
  final String failedText;

  /// Whether to display text.
  final bool showText;

  /// Message text.
  /// %T will be replaced with the last time.
  final String messageText;

  /// Whether to display message.
  final bool showMessage;

  /// The dimension of the text area.
  /// When less than 0, calculate the length of the text widget.
  final double? textDimension;

  /// The dimension of the icon area.
  final double iconDimension;

  /// Spacing between text and icon.
  final double spacing;

  /// True for up and left.
  /// False for down and right.
  final bool reverse;

  /// Icon when [IndicatorResult.success].
  final Widget? succeededIcon;

  /// Icon when [IndicatorResult.fail].
  final Widget? failedIcon;

  /// Icon when [IndicatorResult.noMore].
  final Widget? noMoreIcon;

  /// Icon on pull builder.
  final CIPullIconBuilder? pullIconBuilder;

  /// Text style.
  final TextStyle? textStyle;

  /// Build text.
  final CITextBuilder? textBuilder;

  /// Text style.
  final TextStyle? messageStyle;

  /// Build message.
  final CIMessageBuilder? messageBuilder;

  /// Link [Stack.clipBehavior].
  final Clip clipBehavior;

  /// Icon style.
  final IconThemeData? iconTheme;

  /// Progress indicator size.
  final double? progressIndicatorSize;

  /// Progress indicator stroke width.
  /// See [CircularProgressIndicator.strokeWidth].
  final double? progressIndicatorStrokeWidth;

  const _ExtClassicIndicator({
    Key? key,
    required this.state,
    required this.mainAxisAlignment,
    this.backgroundColor,
    required this.dragText,
    required this.armedText,
    required this.readyText,
    required this.processingText,
    required this.processedText,
    required this.noMoreText,
    required this.failedText,
    this.showText = true,
    required this.messageText,
    required this.reverse,
    this.showMessage = true,
    this.textDimension,
    this.iconDimension = 24,
    this.spacing = 5,
    this.succeededIcon,
    this.failedIcon,
    this.noMoreIcon,
    this.pullIconBuilder,
    this.textStyle,
    this.textBuilder,
    this.messageStyle,
    this.messageBuilder,
    this.clipBehavior = Clip.hardEdge,
    this.iconTheme,
    this.progressIndicatorSize,
    this.progressIndicatorStrokeWidth,
  })  : assert(
  mainAxisAlignment == MainAxisAlignment.start ||
      mainAxisAlignment == MainAxisAlignment.center ||
      mainAxisAlignment == MainAxisAlignment.end,
  'Only supports [MainAxisAlignment.center], [MainAxisAlignment.start] and [MainAxisAlignment.end].'),
        super(key: key);

  @override
  State<_ExtClassicIndicator> createState() => __ExtClassicIndicatorState();
}

class __ExtClassicIndicatorState extends State<_ExtClassicIndicator>
    with TickerProviderStateMixin<_ExtClassicIndicator> {
  /// Icon [AnimatedSwitcher] switch key.
  late GlobalKey _iconAnimatedSwitcherKey;

  /// Update time.
  late DateTime _updateTime;

  /// Icon animation controller.
  late AnimationController _iconAnimationController;

  MainAxisAlignment get _mainAxisAlignment => widget.mainAxisAlignment;

  Axis get _axis => widget.state.axis;

  double get _offset => widget.state.offset;

  double get _actualTriggerOffset => widget.state.actualTriggerOffset;

  double get _triggerOffset => widget.state.triggerOffset;

  double get _safeOffset => widget.state.safeOffset;

  IndicatorMode get _mode => widget.state.mode;

  IndicatorResult get _result => widget.state.result;

  @override
  void initState() {
    super.initState();
    _iconAnimatedSwitcherKey = GlobalKey();
    _updateTime = DateTime.now();
    _iconAnimationController = AnimationController(
      value: 0,
      vsync: this,
      duration: const Duration(microseconds: 200),
    );
    _iconAnimationController.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(_ExtClassicIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update time.
    if (widget.state.mode == IndicatorMode.processed &&
        oldWidget.state.mode != IndicatorMode.processed) {
      _updateTime = DateTime.now();
    }
    if (widget.state.mode == IndicatorMode.armed &&
        oldWidget.state.mode == IndicatorMode.drag) {
      // Armed animation.
      _iconAnimationController.animateTo(1,
          duration: const Duration(milliseconds: 200));
    } else if (widget.state.mode == IndicatorMode.drag &&
        oldWidget.state.mode == IndicatorMode.armed) {
      // Recovery animation.
      _iconAnimationController.animateBack(0,
          duration: const Duration(milliseconds: 200));
    } else if (widget.state.mode == IndicatorMode.processing &&
        oldWidget.state.mode != IndicatorMode.processing) {
      // Reset animation.
      _iconAnimationController.reset();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _iconAnimationController.dispose();
  }

  /// The text of the current state.
  String get _currentText {
    if (_result == IndicatorResult.noMore) {
      return widget.noMoreText;
    }
    switch (_mode) {
      case IndicatorMode.drag:
        return widget.dragText;
      case IndicatorMode.armed:
        return widget.armedText;
      case IndicatorMode.ready:
        return widget.readyText;
      case IndicatorMode.processing:
        return widget.processingText;
      case IndicatorMode.processed:
      case IndicatorMode.done:
        if (_result == IndicatorResult.fail) {
          return widget.failedText;
        } else {
          return widget.processedText;
        }
      default:
        return widget.dragText;
    }
  }

  /// Message text.
  String get _messageText {
    if (widget.messageText.contains('%T')) {
      String fillChar = _updateTime.minute < 10 ? "0" : "";
      return widget.messageText.replaceAll(
          "%T", "${_updateTime.hour}:$fillChar${_updateTime.minute}");
    }
    return widget.messageText;
  }

  /// Build icon.
  Widget _buildIcon() {
    if (widget.pullIconBuilder != null) {
      return widget.pullIconBuilder!
          .call(context, widget.state, _iconAnimationController.value);
    }
    Widget icon;
    final iconTheme = widget.iconTheme ?? Theme.of(context).iconTheme;
    ValueKey iconKey;
    if (_result == IndicatorResult.noMore) {
      iconKey = const ValueKey(IndicatorResult.noMore);
      icon = SizedBox(
        child: widget.noMoreIcon ??
            const Icon(
              Icons.inbox_outlined,
              color: Colors.white,
            ),
      );
    } else if (_mode == IndicatorMode.processing ||
        _mode == IndicatorMode.ready) {
      iconKey = const ValueKey(IndicatorMode.processing);
      final progressIndicatorSize =
          widget.progressIndicatorSize ?? _kDefaultProgressIndicatorSize;
      icon = SizedBox(
        width: progressIndicatorSize,
        height: progressIndicatorSize,
        child: CircularProgressIndicator(
          strokeWidth: widget.progressIndicatorStrokeWidth ??
              _kDefaultProgressIndicatorStrokeWidth,
          color: Colors.white,
        ),
      );
    } else if (_mode == IndicatorMode.processed ||
        _mode == IndicatorMode.done) {
      if (_result == IndicatorResult.fail) {
        iconKey = const ValueKey(IndicatorResult.fail);
        icon = SizedBox(
          child: widget.failedIcon ??
              Icon(
                Icons.error_outline,
                color: Colors.white,
                weight: 0.5.w,
                size: 20.w,
              ),
        );
      } else {
        iconKey = const ValueKey(IndicatorResult.success);
        icon = SizedBox(
          child: widget.succeededIcon ??
              Transform.rotate(
                angle: _axis == Axis.vertical ? 0 : -math.pi / 2,
                child: Icon(
                  Icons.done,
                  color: Colors.white,
                  weight: 0.5.w,
                  size: 20.w,
                ),
              ),
        );
      }
    } else {
      iconKey = const ValueKey(IndicatorMode.drag);
      icon = SizedBox(
        child: Transform.rotate(
          angle: -math.pi * _iconAnimationController.value,
          child: Icon(
            widget.reverse
                ? (_axis == Axis.vertical
                ? Icons.arrow_upward
                : Icons.arrow_back)
                : (_axis == Axis.vertical
                ? Icons.arrow_downward
                : Icons.arrow_forward),
            color: Colors.white,
            weight: 0.5.w,
            size: 20.w,
          ),
        ),
      );
    }
    return AnimatedSwitcher(
      key: _iconAnimatedSwitcherKey,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
      child: IconTheme(
        key: iconKey,
        data: iconTheme,
        child: _result == IndicatorResult.noMore && widget.noMoreIcon == null
            ? Container()
            : Container(
            height: 40.w,
            width: 120.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: StyleTheme.gray102Color,
                borderRadius: BorderRadius.all(Radius.circular(20.w))),
            child: icon
        ),
      ),
    );
  }

  /// Build text.
  Widget _buildText() {
    return Center(
      child: Container(
        height: 40.w,
        width: 120.w,
        alignment: Alignment.center,
        constraints: BoxConstraints(minWidth: 120.w),
        decoration: BoxDecoration(
          color: StyleTheme.gray102Color,
          borderRadius: BorderRadius.circular(20.w),
        ),
        child: Text(
          _currentText,
          style: StyleTheme.font_white_255_14,
        ),
      ),
    );
    return widget.textBuilder?.call(context, widget.state, _currentText) ??
        Text(
          _currentText,
          style: widget.textStyle ?? Theme.of(context).textTheme.titleMedium,
        );
  }

  /// Build text.
  Widget _buildMessage() {
    return widget.messageBuilder
        ?.call(context, widget.state, widget.messageText, _updateTime) ??
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            _messageText,
            style: widget.messageStyle ?? Theme.of(context).textTheme.bodySmall,
          ),
        );
  }

  /// When the list direction is vertically.
  Widget _buildVerticalWidget() {
    return Stack(
      clipBehavior: widget.clipBehavior,
      children: [
        if (_mainAxisAlignment == MainAxisAlignment.center)
          Positioned(
              left: 0,
              right: 0,
              top: _offset < _actualTriggerOffset
                  ? -(_actualTriggerOffset - _offset + (widget.reverse ? _safeOffset : -_safeOffset)) / 2
                  : (!widget.reverse ? _safeOffset : 0),
              bottom: _offset < _actualTriggerOffset
                  ? null
                  : (!widget.reverse ? _safeOffset : 0),
              // height: _offset < _actualTriggerOffset ? _actualTriggerOffset : null,
              child: Center(
                child: _buildVerticalBody(),
              )
          ),
        if (_mainAxisAlignment != MainAxisAlignment.center)
          Positioned(
            left: 0,
            right: 0,
            top: _mainAxisAlignment == MainAxisAlignment.start
                ? (!widget.reverse ? _safeOffset : 0)
                : null,
            bottom: _mainAxisAlignment == MainAxisAlignment.end
                ? (widget.reverse ? _safeOffset : 0)
                : null,
            child: _buildVerticalBody(),
          ),
      ],
    );
  }

  /// The body when the list is vertically direction.
  Widget _buildVerticalBody() {
    return Container(
      padding: EdgeInsets.zero,
      // alignment: Alignment.center,
      // height: _triggerOffset + 10.w,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            width: widget.iconDimension,
            child: _buildIcon(),
          ),
          if (widget.showText)
            Container(
              margin: EdgeInsets.only(left: widget.spacing),
              width: widget.textDimension,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildText(),
                  if (widget.showMessage) _buildMessage(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// When the list direction is horizontally.
  Widget _buildHorizontalWidget() {
    return Stack(
      clipBehavior: widget.clipBehavior,
      children: [
        if (_mainAxisAlignment == MainAxisAlignment.center)
          Positioned(
            left: _offset < _actualTriggerOffset
                ? -(_actualTriggerOffset - _offset + (widget.reverse ? _safeOffset : -_safeOffset)) / 2
                : (!widget.reverse ? _safeOffset : 0),
            right: _offset < _actualTriggerOffset
                ? null
                : (widget.reverse ? _safeOffset : 0),
            top: 0,
            bottom: 0,
            width: _offset < _actualTriggerOffset ? _actualTriggerOffset : null,
            child: Center(
              child: _buildHorizontalBody(),
            ),
          ),
        if (_mainAxisAlignment != MainAxisAlignment.center)
          Positioned(
            left: _mainAxisAlignment == MainAxisAlignment.start
                ? (!widget.reverse ? _safeOffset : 0)
                : null,
            right: _mainAxisAlignment == MainAxisAlignment.end
                ? (widget.reverse ? _safeOffset : 0)
                : null,
            top: 0,
            bottom: 0,
            child: _buildHorizontalBody(),
          ),
      ],
    );
  }

  /// The body when the list is horizontal direction.
  Widget _buildHorizontalBody() {
    return Container(
      alignment: Alignment.center,
      width: _triggerOffset,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.showText)
            Container(
              margin: EdgeInsets.only(bottom: widget.spacing),
              width: widget.textDimension,
              child: RotatedBox(
                quarterTurns: -1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildText(),
                    if (widget.showMessage) _buildMessage(),
                  ],
                ),
              ),
            ),
          Container(
            alignment: Alignment.center,
            height: widget.iconDimension,
            child: _buildIcon(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double offset = _offset;
    if (widget.state.indicator.infiniteOffset != null &&
        widget.state.indicator.position == IndicatorPosition.locator &&
        (_mode != IndicatorMode.inactive ||
            _result == IndicatorResult.noMore)) {
      offset = _actualTriggerOffset;
    }
    return Container(
      color: widget.backgroundColor,
      width: _axis == Axis.vertical ? double.infinity : offset,
      height: _axis == Axis.horizontal ? double.infinity : offset,
      child: _axis == Axis.vertical ? _buildVerticalWidget() : _buildHorizontalWidget(),
    );
  }
}
