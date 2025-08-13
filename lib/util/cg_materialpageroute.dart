import 'package:flutter/material.dart';

class CGMaterialPageRoute<T> extends PageRoute<T>
    with MaterialRouteTransitionMixin<T> {
  /// Construct a MaterialPageRoute whose contents are defined by [builder].
  ///
  /// The values of [builder], [maintainState], and [PageRoute.fullscreenDialog]
  /// must not be null.
  CGMaterialPageRoute({
    required this.builder,
    RouteSettings? settings,
    this.maintainState = true,
    bool fullscreenDialog = false,
  }) : super(settings: settings, fullscreenDialog: fullscreenDialog);

  /// Builds the primary contents of the route.
  final WidgetBuilder builder;

  @override
  Widget buildContent(BuildContext context) => builder(context);

  @override
  final bool maintainState;

  @override
  bool get opaque => false;

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';
}
