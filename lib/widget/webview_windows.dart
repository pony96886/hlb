// import 'dart:async';
//
// import 'package:bitsdojo_window/bitsdojo_window.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:webview_windows/webview_windows.dart';
//
// import '../util/local_png.dart';
// import '../util/style_theme.dart';
// import '../util/utils.dart';
// import 'dart:math' as math;
//
// class WebViewWindows extends StatefulWidget {
//   final String url;
//   const WebViewWindows({super.key, this.url = ''});
//
//   @override
//   State<WebViewWindows> createState() => _WebViewWindows();
// }
//
// class _WebViewWindows extends State<WebViewWindows> {
//   final _controller = WebviewController();
//   final List<StreamSubscription> _subscriptions = [];
//   bool _isWebViewSuspended = false;
//
//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }
//
//   Future<void> initPlatformState() async {
//     try {
//       await _controller.initialize();
//       _subscriptions.add(_controller.url.listen((url) {
//
//       }));
//
//       _subscriptions
//           .add(_controller.containsFullScreenElementChanged.listen((flag) {
//         debugPrint('Contains fullscreen element: $flag');
//         flag ? appWindow.minimize() : appWindow.maximize();
//       }));
//
//       await _controller.setBackgroundColor(Colors.transparent);
//       await _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
//       await _controller.loadUrl(widget.url);
//
//       if (!mounted) return;
//       setState(() {});
//     } on PlatformException catch (e) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         Utils.showDialog(
//           showBtnClose: true,
//           setContent: () {
//             const _url = 'https://learn.microsoft.com/en-us/microsoft-edge/webview2/concepts/distribution';
//             return RichText(
//                 textAlign: TextAlign.center,
//                 text: TextSpan(
//                   children: [
//                     TextSpan(
//                       text: '$e',
//                       style: StyleTheme.font_black_34_15,
//                     ),
//                     TextSpan(
//                       text: '若您权限已通过 请先安装WebView2 Runtime',
//                       style: StyleTheme.font_gray_153_15,
//                     ),
//                     TextSpan(
//                       text: '\n$_url',
//                       style: StyleTheme.font_blue_30_14,
//                       recognizer: TapGestureRecognizer()..onTap = () => Utils.openURL(_url),
//                     ),
//                   ],
//                 ));
//           },
//         );
//       });
//     }
//   }
//
//   Widget compositeView() {
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         children: [
//           Card(
//             elevation: 0,
//             child: Row(children: [
//               GestureDetector(
//                 onTap: () {
//                   _controller.goBack();
//                 },
//                 child: LocalPNG(name: "51_nav_back_w", width: 20.w, height: 20.w),
//               ),
//               SizedBox(width: 20.w),
//               GestureDetector(
//                 onTap: () {
//                   _controller.goForward();
//                 },
//                 child: Transform.rotate(
//                   angle: math.pi,
//                   child: LocalPNG(name: "51_nav_back_w", width: 20.w, height: 20.w),
//                 ),
//               ),
//               SizedBox(width: 20.w),
//               IconButton(
//                 icon: const Icon(Icons.refresh),
//                 splashRadius: 20,
//                 onPressed: () {
//                   _controller.reload();
//                 },
//               ),
//               SizedBox(width: 20.w),
//             ]),
//           ),
//           Expanded(
//               child: Card(
//                   color: Colors.transparent,
//                   elevation: 0,
//                   clipBehavior: Clip.antiAliasWithSaveLayer,
//                   child: Stack(
//                     children: [
//                       Webview(
//                         _controller,
//                         permissionRequested: (String url, WebviewPermissionKind kind, bool isUserInitiated) => _onPermissionRequested(context, url, kind , isUserInitiated),
//                       ),
//                       StreamBuilder<LoadingState>(
//                           stream: _controller.loadingState,
//                           builder: (context, snapshot) {
//                             if (snapshot.hasData &&
//                                 snapshot.data == LoadingState.loading) {
//                               return const LinearProgressIndicator();
//                             } else {
//                               return Container();
//                             }
//                           }),
//                     ],
//                   ))),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // floatingActionButton: FloatingActionButton(
//       //   tooltip: _isWebViewSuspended ? '恢复' : '暂停',
//       //   onPressed: () async {
//       //     if (_isWebViewSuspended) {
//       //       await _controller.resume();
//       //     } else {
//       //       await _controller.suspend();
//       //     }
//       //     setState(() {
//       //       _isWebViewSuspended = !_isWebViewSuspended;
//       //     });
//       //   },
//       //   child: Icon(_isWebViewSuspended ? Icons.play_arrow : Icons.pause),
//       // ),
//       body: Center(
//         child: compositeView(),
//       ),
//     );
//   }
//
//   Future<WebviewPermissionDecision> _onPermissionRequested(
//       BuildContext context, String url, WebviewPermissionKind kind, bool isUserInitiated) async {
//     final decision = await showDialog<WebviewPermissionDecision>(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         title: const Text('请求权限'),
//         content: Text('已请求权限 \'$kind\''),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () =>
//                 Navigator.pop(context, WebviewPermissionDecision.deny),
//             child: const Text('否认'),
//           ),
//           TextButton(
//             onPressed: () =>
//                 Navigator.pop(context, WebviewPermissionDecision.allow),
//             child: const Text('允许'),
//           ),
//         ],
//       ),
//     );
//
//     return decision ?? WebviewPermissionDecision.none;
//   }
//
//   @override
//   void dispose() {
//     for (var s in _subscriptions) {
//       s.cancel();
//     }
//     _controller.dispose();
//     super.dispose();
//   }
// }