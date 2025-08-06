// ignore_for_file: use_key_in_widget_constructors

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'macos_pull_refresh.dart';
import 'windows_pull_refresh.dart';

//为了兼容Macos和Windows手势问题采取的封装
class EasyPullRefresh extends StatelessWidget {
  const EasyPullRefresh({
    Key? key,
    this.child,
    this.sliverChild,
    this.sameChild,
    this.onRefresh,
    this.onLoading,
    this.controller,
  }) : super(key: key);
  // 无吸顶
  final Widget? sameChild;
  // 吸顶 windows
  final Widget? sliverChild;
  // 吸顶 mac os
  final Widget? child;
  // only mac os
  final ScrollController? controller;
  final Future<bool> Function()? onRefresh;
  final Future<bool> Function()? onLoading;

  @override
  Widget build(BuildContext context) {
    if (sameChild != null) {
      return Platform.isWindows
          ? WindowsPullRefresh(
              child: sameChild,
              onRefresh: onRefresh,
              onLoading: onLoading,
              isSliver: false,
            )
          : MacosPullRefresh(
              child: sameChild,
              onRefresh: onRefresh,
              onLoading: onLoading,
              controller: controller,
            );
    }
    return Platform.isWindows
        ? WindowsPullRefresh(
            child: sliverChild,
            onRefresh: onRefresh,
            onLoading: onLoading,
          )
        : MacosPullRefresh(
            child: child,
            onRefresh: onRefresh,
            onLoading: onLoading,
            controller: controller,
          );
  }
}
