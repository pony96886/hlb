// ignore_for_file: no_logic_in_create_state, curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:hlw/base/xfile_progresstoast.dart';
import 'package:hlw/markdown/markdown_format.dart';
import 'package:hlw/util/network_http.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:translator/translator.dart';
import 'dart:ui' as ui;

class MarkDownToolView extends StatefulWidget {
  /// Callback called when text changed
  final Function onTextChanged;

  /// Initial value you want to display
  final String initialValue;

  /// Validator for the TextFormField
  final String? Function(String? value)? validators;

  /// String displayed at hintText in TextFormField
  final String? label;

  /// Change the text direction of the input (RTL / LTR)
  final TextDirection textDirection;

  /// The maximum of lines that can be display in the input
  final int? maxLines;

  /// List of action the component can handle
  final List<MarkdownType> actions;

  /// Optional controller to manage the input
  final TextEditingController? controller;

  /// Overrides input text style
  final TextStyle? textStyle;

  /// If you prefer to use the dialog to insert links, you can choose to use the markdown syntax directly by setting [insertLinksByDialog] to false. In this case, the selected text will be used as label and link.
  /// Default value is true.
  final bool insertLinksByDialog;

  /// Constructor for [MarkdownTextInput]
  const MarkDownToolView(
    this.onTextChanged,
    this.initialValue, {
    super.key,
    this.label = '',
    this.validators,
    this.textDirection = TextDirection.ltr,
    this.maxLines = 10,
    this.actions = MarkdownType.values,
    this.textStyle,
    this.controller,
    this.insertLinksByDialog = true,
  });

  @override
  State createState() =>
      _MarkDownToolViewState(controller ?? TextEditingController());
}

class _MarkDownToolViewState extends State<MarkDownToolView> {
  final TextEditingController _controller;
  var textController = TextEditingController();
  var linkController = TextEditingController();
  var textFocus = FocusNode();
  var linkFocus = FocusNode();
  TextSelection textSelection =
      const TextSelection(baseOffset: 0, extentOffset: 0);
  FocusNode focusNode = FocusNode();
  bool isUploadVideo = false;
  String imagePath = '';
  String uploadType = '00'; // 00 R2不分片 01 R2分片 10 S3不分片 11 S3分片
  String videoPath = '';
  StreamSubscription? _streamSubscription;

  _MarkDownToolViewState(this._controller);

  @override
  void initState() {
    _controller.text = widget.initialValue;
    focusNode.requestFocus();
    _controller.addListener(() {
      if (_controller.selection.baseOffset != -1)
        textSelection = _controller.selection;
      widget.onTextChanged(_controller.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    textController.dispose();
    linkController.dispose();
    textFocus.dispose();
    linkFocus.dispose();
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 584.w,
      decoration: BoxDecoration(
        border: Border.all(color: StyleTheme.gray238Color, width: 0.5.w),
        borderRadius: BorderRadius.all(Radius.circular(5.w)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            runSpacing: 0.w,
            spacing: 5.w,
            children: widget.actions.map((type) {
              switch (type) {
                case MarkdownType.title1:
                  return _textInkwell(type, 1);
                case MarkdownType.title2:
                  return _textInkwell(type, 2);
                case MarkdownType.title3:
                  return _textInkwell(type, 3);
                case MarkdownType.title4:
                  return _textInkwell(type, 4);
                case MarkdownType.title5:
                  return _textInkwell(type, 5);
                case MarkdownType.title6:
                  return _textInkwell(type, 6);
                case MarkdownType.link:
                  return _basicInkwell(
                    type,
                    customOnTap: () {
                      if (widget.insertLinksByDialog) {
                        showLinkAlert(type);
                      }
                    },
                  );
                case MarkdownType.image:
                  return _basicInkwell(type, customOnTap: () {
                    imagePickerAssets(true);
                  });
                case MarkdownType.video:
                  return _basicInkwell(type, customOnTap: () {
                    imagePath = '';
                    videoPath = '';
                    showVideoAlert(type);
                  });
                default:
                  return _basicInkwell(type);
              }
            }).toList(),
          ),
          Divider(
            height: 1.w,
            color: StyleTheme.gray238Color,
          ),
          Container(
              padding: EdgeInsets.all(10.w),
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    height: ScreenWidth == 1280.w ? 480.w : 480.w * 0.5,
                    child: TextFormField(
                      focusNode: focusNode,
                      textInputAction: TextInputAction.newline,
                      minLines: 23,
                      maxLines: null,
                      controller: _controller,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      validator: widget.validators != null
                          ? (value) => widget.validators!(value)
                          : null,
                      style: widget.textStyle ??
                          Theme.of(context).textTheme.bodyLarge,
                      cursorColor:
                          widget.textStyle?.color ?? StyleTheme.gray102Color,
                      textDirection: widget.textDirection,
                      decoration: InputDecoration(
                        enabledBorder: borderInputWidget(),
                        focusedBorder: borderInputWidget(),
                        hintText: _controller.text.isEmpty ? widget.label : '',
                        hintStyle: StyleTheme.font_gray_153_17,
                        contentPadding: EdgeInsets.all(10.w),
                      ),
                    ),
                  ))),
        ],
      ),
    );
  }

  textStyle(MarkdownType type) {
    onTap(type, link: '', alt: _controller.text);
  }

  void showVideoAlert(MarkdownType type) async {
    isUploadVideo = true;

    await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              GestureDetector(
                child: const Icon(Icons.close),
                onTap: () {
                  isUploadVideo = false;
                  Navigator.pop(context);
                },
              ),
            ]),
            content: StatefulBuilder(builder: (ctx, StateSetter state) {
              Widget current =
                  Column(mainAxisSize: MainAxisSize.min, children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (imagePath.isNotEmpty) return;
                    Navigator.pop(context);
                    imagePickerAssets(false);
                  },
                  child: Container(
                    height: 36.w,
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: StyleTheme.black31Color),
                      borderRadius: BorderRadius.all(Radius.circular(3.w)),
                    ),
                    child: Row(children: [
                      Expanded(
                        child: Text(
                          imagePath.isEmpty ? Utils.txt('scfm') : imagePath,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Container(
                        height: 20.w,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(10.w)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          Utils.txt('sctp'),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ]),
                  ),
                ),
                SizedBox(height: 15.w),
                Row(children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: '选择上传线路',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        TextSpan(
                          text: ' (如果上传不稳定，请尝试更换线路)',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ]),
                SizedBox(height: 10.w),
                Row(children: [
                  Expanded(
                    child: Row(children: [
                      Radio(
                        value: '00',
                        activeColor: const Color(0xFF6666fe),
                        groupValue: uploadType,
                        onChanged: (val) => state(() => uploadType = '$val'),
                      ),
                      GestureDetector(
                        onTap: () => state(() => uploadType = '00'),
                        child: const Text('上传线路一'),
                      ),
                    ]),
                  ),
                  Expanded(
                    child: Row(children: [
                      Radio(
                        value: '01',
                        activeColor: const Color(0xFF6666fe),
                        groupValue: uploadType,
                        onChanged: (val) => state(() => uploadType = '$val'),
                      ),
                      GestureDetector(
                        onTap: () => state(() => uploadType = '01'),
                        child: const Text('上传线路二'),
                      ),
                    ]),
                  ),
                ]),
                SizedBox(height: 10.w),
                Row(children: [
                  Expanded(
                    child: Row(children: [
                      Radio(
                        value: '10',
                        activeColor: const Color(0xFF6666fe),
                        groupValue: uploadType,
                        onChanged: (val) => state(() => uploadType = '$val'),
                      ),
                      GestureDetector(
                        onTap: () => state(() => uploadType = '10'),
                        child: const Text('上传线路三'),
                      ),
                    ]),
                  ),
                  Expanded(
                    child: Row(children: [
                      Radio(
                        value: '11',
                        activeColor: const Color(0xFF6666fe),
                        groupValue: uploadType,
                        onChanged: (val) => state(() => uploadType = '$val'),
                      ),
                      GestureDetector(
                        onTap: () => state(() => uploadType = '11'),
                        child: const Text('上传线路四'),
                      ),
                    ]),
                  ),
                ]),
                SizedBox(height: 10.w),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (videoPath.isNotEmpty) return;
                    Navigator.pop(context);
                    imagePickerVideoAssets();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    height: 36.w,
                    decoration: BoxDecoration(
                      border: Border.all(color: StyleTheme.black31Color),
                      borderRadius: BorderRadius.all(Radius.circular(3.w)),
                    ),
                    child: Row(children: [
                      Expanded(
                        child: Text(
                          videoPath.isEmpty ? Utils.txt('qxzbmbv') : videoPath,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Container(
                        height: 20.w,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(10.w)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          Utils.txt('scsp'),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                      )
                    ]),
                  ),
                ),
              ]);
              // 固定宽
              return SizedBox(width: 400.w, child: current);
            }),
            contentPadding: EdgeInsets.fromLTRB(20.w, 10.w, 20.w, 10.w),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 10.w, bottom: 10.w),
                child: TextButton(
                  style: ButtonStyle(backgroundColor:
                      MaterialStateProperty.resolveWith((states) {
                    // If the button is pressed, return green, otherwise blue
                    if (states.contains(MaterialState.pressed)) {
                      return StyleTheme.red245Color;
                    } else if (states.contains(MaterialState.disabled)) {
                      return Colors.transparent;
                    }
                    return StyleTheme.red245Color.withOpacity(0.8);
                  })),
                  onPressed: () {
                    if (videoPath.isNotEmpty) {
                      onTap(type, link: videoPath, alt: '');
                      isUploadVideo = false;
                      Navigator.pop(context);
                    } else {
                      Utils.showText(Utils.txt('qxzmpf'));
                    }
                  },
                  child: Text(
                    Utils.txt('quren'),
                    style: StyleTheme.font_white_255_14,
                  ),
                ),
              ),
            ],
          );
        });
  }

  void showLinkAlert(MarkdownType type) async {
    var text = _controller.text
        .substring(textSelection.baseOffset, textSelection.extentOffset);
    textController = TextEditingController()..text = text;
    linkController = TextEditingController();
    textFocus = FocusNode();
    linkFocus = FocusNode();
    var color = StyleTheme.black31Color;
    var language = kIsWeb
        ? window.locale.languageCode
        : Platform.localeName.substring(0, 2);
    var textLabel = 'Text';
    var linkLabel = 'Link';
    try {
      var textTranslation =
          await GoogleTranslator().translate(textLabel, to: language);
      textLabel = textTranslation.text;
      var linkTranslation =
          await GoogleTranslator().translate(linkLabel, to: language);
      linkLabel = linkTranslation.text;
    } catch (e) {
      textLabel = 'Text';
      linkLabel = 'Link';
    }

    await showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    child: const Icon(Icons.close),
                    onTap: () => Navigator.pop(context))
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: Utils.txt('qsrnr'),
                    label: Text(textLabel),
                    labelStyle: TextStyle(color: color),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: color, width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: color, width: 2)),
                  ),
                  autofocus: text.isEmpty,
                  focusNode: textFocus,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (value) {
                    textFocus.unfocus();
                    FocusScope.of(context).requestFocus(linkFocus);
                  },
                ),
                SizedBox(height: 10.w),
                TextField(
                  controller: linkController,
                  decoration: InputDecoration(
                    hintText: Utils.txt('qsrlj'),
                    label: Text(linkLabel),
                    labelStyle: TextStyle(color: color),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: color, width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: color, width: 2)),
                  ),
                  autofocus: text.isNotEmpty,
                  focusNode: linkFocus,
                ),
              ],
            ),
            contentPadding: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.w),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: TextButton(
                  style: ButtonStyle(backgroundColor:
                      MaterialStateProperty.resolveWith((states) {
                    // If the button is pressed, return green, otherwise blue
                    if (states.contains(MaterialState.pressed)) {
                      return StyleTheme.red245Color;
                    } else if (states.contains(MaterialState.disabled)) {
                      return Colors.transparent;
                    }
                    return StyleTheme.red245Color.withOpacity(0.8);
                  })),
                  onPressed: () {
                    onTap(type,
                        link: linkController.text, alt: textController.text);
                    Navigator.pop(context);
                  },
                  child: Text(Utils.txt('quren'),
                      style: StyleTheme.font_white_255_14),
                ),
              ),
            ],
          );
        });
  }

  Future<void> imagePickerAssets(bool isMulti) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: isMulti ? true : false, type: FileType.image);
    if (result != null) {
      for (PlatformFile file in result.files) {
        bool flag = await Utils.pngLimitSize(file);
        if (flag) continue;
        uploadFileImg(file);
      }
    } else {
      // User canceled the picker
      if (isUploadVideo) {
        showVideoAlert(MarkdownType.video);
      }
    }
  }

  void uploadFileImg(PlatformFile file) async {
    Utils.startGif(tip: Utils.txt('scz'));
    var data;
    if (kIsWeb) {
      data = await NetworkHttp.xfileHtmlUploadImage(
          file: file, position: 'upload');
    } else {
      data = await NetworkHttp.xfileUploadImage(file: file, position: 'upload');
    }
    Utils.log(data);
    Utils.closeGif();
    if (data != null && data['code'] == 1) {
      // AppGlobal.apiBaseURL;
      imagePath = '{{img-cdn}}' + data['msg'];
      if (isUploadVideo) {
        showVideoAlert(MarkdownType.video);
      } else {
        final ui.Image image = await Utils.getImageInfo(file.path!);
        onTap(MarkdownType.image,
            link: imagePath, alt: '${image.width}X${image.height}');
      }
    } else {
      Utils.showText(data['msg'] ?? Utils.txt('wfljqsz'));
    }
  }

  //上传视频
  Future<void> imagePickerVideoAssets() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null) {
      PlatformFile file = result.files.first;
      bool flag = await Utils.videoLimitSize(file, size: 500);
      if (flag) return;
      String ext = file.extension?.toLowerCase() ?? '';
      if (ext == "mp4" || ext == 'quicktime') {
        uploadVideo(file);
      } else {
        Utils.showText(Utils.txt("qxzmpf"));
      }
    } else {
      // User canceled the picker
      if (isUploadVideo) {
        showVideoAlert(MarkdownType.video);
      }
    }
  }

  void uploadVideo(PlatformFile file) {
    BotToast.showCustomLoading(
      toastBuilder: (cancel) => XFileProgressToast(
        uploadType: uploadType,
        file: file,
        response: (data) {
          BotToast.closeAllLoading();
          if (data != null && data['code'] == 1) {
            videoPath =
                '{"w":0,"h":0,"c": "","d": 0,"m3u8": "","mp4":"${data['msg']}","id":0}';
            showVideoAlert(MarkdownType.video);
          } else {
            Utils.showText(data['msg'] ?? Utils.txt('wfljqsz'));
          }
        },
        cancel: () {
          BotToast.closeAllLoading();
        },
      ),
    );
  }

  void onTap(MarkdownType type, {String? link, String? alt}) {
    final basePosition = textSelection.baseOffset;
    var noTextSelected =
        (textSelection.baseOffset - textSelection.extentOffset) == 0;
    var fromIndex = textSelection.baseOffset;
    var toIndex = textSelection.extentOffset;

    final result = MarkdownFormat.convertToMarkdown(
        type, _controller.text, fromIndex, toIndex,
        link: link, alt: alt ?? _controller.text.substring(fromIndex, toIndex));

    _controller.value = _controller.value.copyWith(
        text: result.data,
        selection:
            TextSelection.collapsed(offset: basePosition + result.cursorIndex));

    if (noTextSelected) {
      _controller.selection =
          TextSelection.collapsed(offset: _controller.selection.end);
      focusNode.requestFocus();
    }
  }

  OutlineInputBorder borderInputWidget() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: BorderSide(color: Colors.transparent, width: 0.w));
  }

  Widget _basicInkwell(MarkdownType type, {Function? customOnTap}) {
    return InkWell(
      key: Key(type.key),
      onTap: () => customOnTap != null ? customOnTap() : onTap(type),
      child: Container(
        height: 40.w,
        width: 40.w,
        alignment: Alignment.center,
        child: Icon(type.icon),
      ),
    );
  }

  Widget _textInkwell(MarkdownType type, int num, {Function? customOnTap}) {
    return InkWell(
      key: Key(type.key),
      onTap: () => customOnTap != null ? customOnTap() : onTap(type),
      child: Container(
        height: 40.w,
        width: 40.w,
        alignment: Alignment.center,
        child: Text(
          'H$num',
          style:
              TextStyle(fontSize: 11.toDouble(), fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
