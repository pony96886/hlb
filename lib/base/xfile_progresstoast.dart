import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hlw/util/network_http.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';

class XFileProgressToast extends StatefulWidget {
  const XFileProgressToast({
    super.key,
    required this.uploadType,
    required this.file,
    required this.response,
    this.cancel,
  });
  final String uploadType;
  final PlatformFile file;
  final Function(dynamic) response;
  final Function()? cancel;

  @override
  State createState() => _XFileProgressToastState();
}

class _XFileProgressToastState extends State<XFileProgressToast> {
  String progress = Utils.txt('scz');
  CancelToken cancelToken = CancelToken();
  @override
  void initState() {
    super.initState();
    _upData();
  }

  _upData() async {
    dynamic res;
    if (kIsWeb) {
      res = await NetworkHttp.xfileBytesUploadMp4(
        cancelToken: cancelToken,
        file: widget.file,
        position: 'upload',
        progressCallback: (count, total) {
          Future.delayed(const Duration(milliseconds: 1000)).then((value) {
            var tmp = (count / total * 100).toInt();
            if (tmp % 1 == 0) {
              progress = "${Utils.txt('scz')} $tmp%";
              setState(() {});
            }
          });
        },
      );
    } else {
      switch (widget.uploadType) {
        case '10':
          res = await NetworkHttp.s3fileUploadMp4(
            file: widget.file,
            cancelToken: cancelToken,
            progressCallback: updateProgress,
          );
          break;
        case '11':
          res = await NetworkHttp.s3ChunkedUploadMp4(
            file: widget.file,
            cancelToken: cancelToken,
            progressCallback: updateProgress,
          );
          break;
        case '00':
          res = await NetworkHttp.r2fileUploadMp4(
            file: widget.file,
            cancelToken: cancelToken,
            progressCallback: updateProgress,
          );
          break;
        case '01':
          res = await NetworkHttp.r2ChunkedUploadMp4(
            file: widget.file,
            cancelToken: cancelToken,
            progressCallback: updateProgress,
          );
          break;
        default:
        // res = await NetworkHttp.xfileUploadMp4(
        // res = await NetworkHttp.uploadToR2ChunkedService(
        //   cancelToken: cancelToken,
        //   file: widget.file,
        //   // position: 'upload',
        //   progressCallback: (count, total) {},
        // );
      }
    }
    widget.response(res == null ? {} : jsonDecode(res));
  }

  void updateProgress(int count, int total) {
    var tmp = (count / total * 100).toInt();
    if (tmp % 1 == 0) {
      progress = "${Utils.txt('scz')} $tmp%";
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(3.w)),
            color: Colors.black38,
          ),
          height: 110.w,
          width: 110.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 30.w,
                width: 30.w,
                child: CircularProgressIndicator(
                  color: StyleTheme.orange255Color,
                  strokeWidth: 2,
                ),
              ),
              SizedBox(
                height: 12.w,
              ),
              Text(progress, style: StyleTheme.font_orange_255_12)
            ],
          ),
        ),
        SizedBox(height: 20.w),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            cancelToken.cancel();
            widget.cancel?.call();
          },
          child: Container(
            height: 30.w,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              // color: StyleTheme.gray187Color.withOpacity(0.8),
              borderRadius: BorderRadius.all(Radius.circular(3.w)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Text('取消上传')],
            ),
          ),
        ),
      ],
    );
  }
}
