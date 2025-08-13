import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:hlw/base/base_widget.dart';
import 'package:hlw/base/request_api.dart';
import 'package:hlw/markdown/markdown_tool_view.dart';
import 'package:hlw/model/response_model.dart';
import 'package:hlw/util/app_global.dart';
import 'package:hlw/util/local_png.dart';
import 'package:hlw/util/netimage_tool.dart';
import 'package:hlw/util/network_http.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hlw/util/desktop_extension.dart';
import 'package:translator/translator.dart';

import '../widget/search_bar_widget.dart';

class HomeEditorPage extends BaseWidget {
  final String id;
  const HomeEditorPage({Key? key, this.id = ''}) : super(key: key);

  @override
  State<StatefulWidget> cState() => _HomeEditorPageState();
}

typedef GetTextEdit = Function(String getTextEdit);
typedef GetDescription = Function(String getDescriptopn);
typedef GetCoverURL = Function(String getUrl);
typedef GetTags = Function(List getTags);

class _HomeEditorPageState extends BaseWidgetState<HomeEditorPage> {
  TextEditingController contentController = TextEditingController(),
      titleController = TextEditingController();
  String description = '';
  String title = '';
  List addTags = [];
  List<Map<String, dynamic>> tagsColor = [];
  String coverURL = '';
  String content = '''# I'm h1
## I'm h2
### I'm h3
#### I'm h4
###### I'm h5
###### I'm h6

```
code code code
```

*bold text*

*italic text*

**strong text**

<u>Underlined Text</u>

`I'm code`

~~del~~

***~~italic strong and del~~***

> Test for blockquote and **strong**


- ul list
- one
    - aa *a* a
    - bbbb
        - CCCC

1. ol list
2. aaaa
3. bbbb
    1. AAAA
    2. BBBB
    3. CCCC


[I'm link](https://github.com/)


- [ ] I'm *CheckBox*

- [x] I'm *CheckBox* too

Test for divider(hr):

---

Test for Table:

header 1 | header 2
---|---
row 1 col 1 | row 1 col 2
row 2 col 1 | row 2 col 2
image:

![777X666]({{img-cdn}}/upload/upload/20230328/2023032810481623958.png)

video:

!player({"w":0,"h":0,"c":"","d":0,"m3u8":"","mp4":"{{mp4-cdn}}/20231115/2023111514345424213/c93d4dfc5dca4676c7d5ccf10d2f6174.mp4","id":0})

''';

  @override
  void onCreate() {
    if (widget.id.isNotEmpty) getData();
  }

  @override
  Widget appbar() => Container();

  void getData() {
    reqDetailContent(cid: widget.id).then((value) {
      if (value?.data == null) {
        if (mounted) setState(() {});
        return;
      }
      if (value?.status == 1) {
        final _data = value?.data["article"];
        title = titleController.text = _data['title'];
        // description = contentController.text = _data['txt'];
        description = contentController.text = _data['content'];
        coverURL = _data['thumb'];
        addTags = '${_data['seo_keywords']}'.split(',');
        titleController.value = TextEditingValue(
          text: title,
          selection: TextSelection.fromPosition(
            TextPosition(
              affinity: TextAffinity.downstream,
              offset: title.length,
            ),
          ),
        );
        contentController.value = TextEditingValue(
          text: description,
          selection: TextSelection.fromPosition(
            TextPosition(
              affinity: TextAffinity.downstream,
              offset: description.length,
            ),
          ),
        );
      }
      if (mounted) setState(() {});
    });
  }

  /// 发布文章
  void _postContent() {
    if (title.isEmpty) {
      Utils.showText('发布失败，文章标题不能为空!'); // Utils.txt('qtxxbt')
      return;
    }
    if (description.isEmpty) {
      Utils.showText('发布失败，文章内容不能为空!'); // Utils.txt('qtxwznr')
      return;
    }
    if (coverURL.isEmpty) {
      Utils.showText('发布失败，请上传文章封面!'); // Utils.txt('srhffm')
      return;
    }
    if (addTags.isEmpty) {
      Utils.showText('发布失败，请添加标签!'); // Utils.txt('qtjibq')
      return;
    }
    Utils.startGif(tip: Utils.txt('jzz'));
    reqPostContent(
      article_id: widget.id, // 不用，前端修改传
      title: title,
      thumb: coverURL,
      content: description,
      tags: addTags.join(','),
    ).then((value) {
      Utils.closeGif();
      if (value?.status == 1) {
        Utils.showDialog(
            confirmTxt: Utils.txt('quren'),
            setContent: () {
              return RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: value?.msg ?? '',
                    style: StyleTheme.font_gray_153_12,
                  ),
                ]),
              );
            },
            confirm: () {
              addTags.clear();
              for (var map in tagsColor) {
                map['isColor'] = false;
              }
              finish();
            });
      } else {
        Utils.showText(value?.msg ?? '');
      }
    });
  }

  /// 预览文章
  void _previewContent() {
    if (title.isEmpty) {
      Utils.showText('预览失败，文章标题不能为空!'); // Utils.txt('qtxxbt')
      return;
    }
    if (description.isEmpty) {
      Utils.showText('预览失败，文章内容不能为空!'); // Utils.txt('qtxwznr')
      return;
    }
    if (coverURL.isEmpty) {
      Utils.showText('预览失败，请上传文章封面!'); // Utils.txt('srhffm')
      return;
    }
    if (addTags.isEmpty) {
      Utils.showText('预览失败，请添加标签!'); // Utils.txt('qtjibq')
      return;
    }
    Utils.startGif(tip: Utils.txt('jzz'));
    reqPreviewContent(
      article_id: widget.id, // 不用，前端修改传
      title: title,
      thumb: coverURL,
      content: description,
      tags: addTags.join(','),
    ).then((value) {
      Utils.closeGif();
      if (value?.status == 1) {
        showDialog(
            context: context, builder: (cx) => _DialogPreview(value: value));
      } else {
        Utils.showText(value?.msg ?? '');
      }
    });
  }

  Future<void> _imagePickerAssets() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      PlatformFile file = result.files.first;
      bool flag = await Utils.pngLimitSize(file);
      if (flag) return;
      uploadFileImg(file);
    } else {
      // User canceled the picker
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
    if (data['code'] == 1) {
      coverURL = data['msg'];
      setState(() {});
    } else {
      Utils.showText(data['msg'] ?? "failed");
    }
  }

  OutlineInputBorder borderInputWidget() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(color: Colors.transparent, width: 0.w),
    );
  }

  @override
  void onDestroy() {
    contentController.dispose();
  }

  @override
  Widget pageBody(BuildContext context) {
    return Stack(children: [
      Positioned(
        top: 97.w,
        left: 60.w,
        right: 60.w,
        bottom: 30.w,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _LeftWidget(
            description: description,
            titleController: titleController,
            contentController: contentController,
            borderInputWidget: borderInputWidget(),
            getTextEdit: (String getTextEdit) =>
                setState(() => title = getTextEdit),
            getDescription: (String getDescription) =>
                setState(() => description = getDescription),
          ),
          SizedBox(width: 60.w),
          _RightWidget(
            coverURL: coverURL,
            imagePickerAssets: _imagePickerAssets,
            showLabelAlert: _showLabelAlert,
            previewContent: _previewContent,
            postContent: _postContent,
            getCoverURL: (String getUrl) => setState(() => coverURL = getUrl),
            tags: addTags,
            removeTag: (tag) => setState(() => addTags.remove(tag)),
          ),
        ]),
      ),
      const SearchBarWidget(
        isBackBtn: true,
        backTitle: '发布文章｜markdown编辑器',
      ),
    ]);
  }

  void _showLabelAlert() async {
    var textController = TextEditingController()..text = '';
    var textFocus = FocusNode();

    var color = StyleTheme.black31Color;
    var language = kIsWeb
        ? window.locale.languageCode
        : Platform.localeName.substring(0, 2);

    var textLabel = 'Text';
    try {
      var textTranslation =
          await GoogleTranslator().translate(textLabel, to: language);
      textLabel = textTranslation.text;
    } catch (e) {
      textLabel = 'Text';
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
                  onTap: () => Navigator.pop(context),
                )
              ],
            ),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                controller: textController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(15),
                ],
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: '添加标签',
                  label: Text(textLabel),
                  labelStyle: TextStyle(color: color),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: color, width: 2)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: color, width: 2)),
                ),
                autofocus: textController.text.isEmpty,
                focusNode: textFocus,
                textInputAction: TextInputAction.next,
                onSubmitted: (value) {
                  textFocus.unfocus();
                  FocusScope.of(context).requestFocus(textFocus);
                },
              ),
            ]),
            contentPadding: EdgeInsets.only(
                left: 20.w, right: 20.w, top: 10.w, bottom: 10.w),
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
                    if (textController.text.isNotEmpty) {
                      addTags.add(textController.text);
                      setState(() {});
                    }
                    Navigator.pop(context);
                  },
                  child: Text('确认', style: StyleTheme.font_white_255_12),
                ),
              ),
            ],
          );
        });
  }
}

class _DialogPreview extends StatelessWidget {
  final ResponseModel<dynamic>? value;
  const _DialogPreview({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        Utils.txt('wzyl'),
        style: StyleTheme.font_black_31_16,
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: 720.w,
        height: 720.w,
        child: SingleChildScrollView(
          child: Builder(builder: (cx) {
            final data = value?.data;
            String html = data['txt'] ?? "";
            html = kIsWeb
                ? html.replaceAll("</br>", "")
                : html.replaceAll("<br>", "").replaceAll("</br>", "");
            return Html(
              shrinkWrap: true,
              data: html,
              style: {
                "*": Style(
                  color: StyleTheme.gray102Color,
                  lineHeight: LineHeight.rem(1.8),
                  margin: Margins.zero,
                ),
                "a": Style(color: StyleTheme.blue25Color)
              },
              customRenders: {
                (_context) {
                  return _context.tree.element?.localName == 'img';
                }: CustomRender.widget(widget: (_context, parsedChild) {
                  String className =
                      _context.tree.element?.attributes["class"] ?? "";
                  String url = _context.tree.element?.attributes["src"] ?? "";
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (className.isNotEmpty) {
                        String? router =
                            _context.tree.element?.attributes["router"] ?? "";
                        if (Utils.unFocusNode(context)) {
                          Utils.openRoute(context, jsonDecode(router));
                        }
                      }
                    },
                    child: NetImageTool(url: url, fit: BoxFit.contain),
                  );
                }),
                (_context) {
                  return _context.tree.element?.localName == 'span';
                }: CustomRender.widget(widget: (_context, parsedChild) {
                  String className =
                      _context.tree.element?.attributes["class"] ?? "";
                  if (className.isNotEmpty) {
                    String? router =
                        _context.tree.element?.attributes["router"] ?? "";
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (Utils.unFocusNode(context)) {
                          Utils.openRoute(context, jsonDecode(router));
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        height: 30.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.w),
                          color: StyleTheme.gray244Color,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _context.tree.element?.text ?? "#",
                              style: StyleTheme.font_blue_30_14,
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return _context.buildContext.widget;
                  }
                }),
                (_context) {
                  return _context.tree.element?.localName == 'video';
                }: CustomRender.widget(widget: (_context, parsedChild) {
                  String? cover =
                      _context.tree.element?.attributes["pic"] ?? "";
                  if (cover.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Utils.txt('spbky'),
                            style: StyleTheme.font_red_245_14),
                        SizedBox(height: 4.w),
                        SizedBox(
                          width: StyleTheme.contentWidth,
                          height: StyleTheme.contentWidth / 16 * 9,
                          child: Stack(
                            children: [
                              NetImageTool(url: cover),
                              Container(color: Colors.black12),
                              Center(
                                child: LocalPNG(
                                  name: "51_play_n",
                                  width: 40.w,
                                  height: 40.w,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return Container();
                }),
              },
              onLinkTap: (url, context, attributes, element) {
                Utils.openURL(url ?? "");
              },
            );
          }),
        ),
      ),
    );
  }
}

class _LeftWidget extends StatefulWidget {
  final InputBorder? borderInputWidget;
  final TextEditingController titleController, contentController;
  final String description;
  final GetTextEdit getTextEdit;
  final GetDescription getDescription;
  const _LeftWidget({
    Key? key,
    required this.titleController,
    required this.contentController,
    required this.borderInputWidget,
    required this.description,
    required this.getTextEdit,
    required this.getDescription,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LeftWidgetState();
}

class _LeftWidgetState extends State<_LeftWidget> {
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    //widget.titleController.text = widget.title;
    focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 640.w,
        child: Column(
          children: [
            SizedBox(height: 10.w),
            TextField(
              focusNode: focusNode,
              controller: widget.titleController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(50),
              ],
              obscureText: false,
              keyboardType: TextInputType.text,
              style: StyleTheme.font_black_31_20,
              textInputAction: TextInputAction.done,
              cursorColor: StyleTheme.black31Color,
              onSubmitted: (value) {},
              onChanged: (value) {
                widget.getTextEdit(value);
              },
              decoration: InputDecoration(
                hintText: widget.titleController.text.isEmpty ? '请输入文章标题' : '',
                hintStyle: StyleTheme.font_gray_153_20,
                contentPadding: EdgeInsets.zero,
                isDense: true,
                disabledBorder: widget.borderInputWidget,
                focusedBorder: widget.borderInputWidget,
                border: widget.borderInputWidget,
                enabledBorder: widget.borderInputWidget,
              ),
            ),
            SizedBox(height: 12.5.w),
            Divider(
              height: 1.w,
              color: StyleTheme.gray238Color,
            ),
            SizedBox(height: 16.5.w),
            MarkDownToolView(
              (String value) => widget.getDescription(value),
              widget.description,
              label: '请填写标题信息',
              controller: widget.contentController,
              textStyle: StyleTheme.font_gray_102_17,
            ),
          ],
        ),
      ),
    );
  }
}

class _RightWidget extends StatelessWidget {
  final String coverURL;
  final Function imagePickerAssets, showLabelAlert, previewContent, postContent;
  final GetCoverURL getCoverURL;
  final List tags;
  final void Function(dynamic) removeTag;
  const _RightWidget({
    Key? key,
    this.coverURL = '',
    required this.imagePickerAssets,
    required this.showLabelAlert,
    required this.previewContent,
    required this.postContent,
    required this.getCoverURL,
    required this.tags,
    required this.removeTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget tags = Wrap(
      runSpacing: 10.w,
      spacing: 10.w,
      children: this.tags.map((i) {
        return Stack(children: [
          Container(
            padding: EdgeInsets.fromLTRB(10.w, 5.w, 10.w, 5.w),
            margin: EdgeInsets.only(top: 5.w, right: 10.w),
            decoration: BoxDecoration(
              color: StyleTheme.gray245Color,
              borderRadius: BorderRadius.circular(3.w),
            ),
            child: Text(i, style: StyleTheme.font_black_34_12),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => removeTag(i),
              child: LocalPNG(
                name: '51_photo_delete',
                width: 13.w,
                height: 13.w,
              ),
            ),
          ),
        ]);
      }).toList(),
    );
    return Builder(builder: (cx) {
      double w = StyleTheme.rightWidth - StyleTheme.margin;
      double h = w / 1280 * 800;
      return SizedBox(
        width: 220.w,
        height: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: '请上传文章封面，710×240 ',
                style: StyleTheme.font_black_34_13,
              ),
              TextSpan(text: '核心', style: StyleTheme.font_gray_153_14),
            ]),
          ),
          SizedBox(height: 10.w),
          _BtnImage(
            coverURL: coverURL,
            h: h,
            w: w,
            assets: imagePickerAssets,
            getCoverURL: getCoverURL,
          ),
          SizedBox(height: 30.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '请添加标签',
                  style: StyleTheme.font_gray_153_14,
                ),
                SizedBox(height: 10.w),
                Flexible(
                  child: SingleChildScrollView(
                    child: tags,
                  ),
                ),
                // SizedBox(height: getTags.isEmpty ? 10.w : 15.w),
                SizedBox(height: 10.w),
                _BtnAdd(alert: showLabelAlert),
              ],
            ),
          ),
          SizedBox(height: 10.w),
          _BtnArticle(
            preview: () => previewContent(),
            post: () => postContent(),
          ),
        ]),
      );
    });
  }
}

class _BtnImage extends StatelessWidget {
  final String coverURL;
  final double h, w;
  final Function assets;
  final GetCoverURL getCoverURL;
  const _BtnImage({
    Key? key,
    required this.coverURL,
    required this.h,
    required this.w,
    required this.assets,
    required this.getCoverURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return coverURL.isEmpty
        ? GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => assets(),
            child: Container(
              width: 120.w,
              height: 120.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: StyleTheme.gray238Color,
                  borderRadius: BorderRadius.all(Radius.circular(5.w))),
              child: LocalPNG(
                  name: "hlw_release_upload", width: 28.5.w, height: 24.w),
            ),
          )
        : SizedBox(
            height: h,
            width: w,
            child: Stack(
              children: [
                Positioned(
                  top: 9.w,
                  right: 9.w,
                  child: SizedBox(
                    height: h - 9.w,
                    width: w - 9.w,
                    child: NetImageTool(
                      url: coverURL.startsWith('http') == true
                          ? coverURL
                          : AppGlobal.imgBaseUrl + coverURL,
                      radius: BorderRadius.all(Radius.circular(3.w)),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => getCoverURL(''),
                    child: LocalPNG(
                      name: '51_photo_delete',
                      width: 18.w,
                      height: 18.w,
                    ),
                  ),
                )
              ],
            ),
          );
  }
}

class _BtnAdd extends StatelessWidget {
  final Function alert;
  const _BtnAdd({Key? key, required this.alert}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: StyleTheme.black34Color,
        borderRadius: BorderRadius.circular(5.w),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => alert(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LocalPNG(
              name: 'hlw_release_label',
              width: 20.w,
              height: 20.w,
            ),
            SizedBox(width: 8.w),
            Text(Utils.txt('tjibq'), style: StyleTheme.font_white_255_13),
          ],
        ),
      ),
    );
  }
}

class _BtnArticle extends StatelessWidget {
  final Function() preview, post;
  const _BtnArticle({Key? key, required this.preview, required this.post})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.w,
      child: Row(
        children: [
          Utils.btnRed(Utils.txt('yulan'), preview),
          SizedBox(width: 20.w),
          Utils.btnRed(Utils.txt('fbtz'), post),
        ],
      ),
    );
  }
}

class _BtnBottom extends StatelessWidget {
  final void Function() cancel, sure;
  const _BtnBottom({Key? key, required this.cancel, required this.sure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Btn(
            text: '取消',
            backgroundColor: StyleTheme.black34Color,
            tap: () => cancel()),
        SizedBox(width: 30.w),
        _Btn(
            text: '确定',
            backgroundColor: StyleTheme.orange255Color,
            tap: () {
              cancel();
              sure();
            }),
      ],
    );
  }
}

class _Btn extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Function() tap;
  const _Btn(
      {Key? key,
      required this.text,
      required this.backgroundColor,
      required this.tap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: tap,
      child: Container(
        width: 136.w,
        height: 44.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(27.w)),
        ),
        child: Text(text, style: StyleTheme.font_white_255_17),
      ),
    );
  }
}
