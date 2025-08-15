import 'dart:async';

import 'package:hlw/model/response_model.dart';
import 'package:hlw/util/easy_pull_refresh.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:hlw/util/desktop_extension.dart';

import 'package:hlw/base/base_widget.dart';
import 'package:hlw/base/request_api.dart';
import 'package:hlw/util/load_status.dart';
import 'package:hlw/util/style_theme.dart';
import 'package:hlw/util/utils.dart';

import '../base/base_main_view.dart';

class PastPage extends BaseWidget {
  const PastPage({Key? key, this.isShow = false, this.type = 'history'})
      : super(key: key);
  final bool isShow;
  final String type;
  @override
  cState() => _PastPageState();
}

class _PastPageState extends BaseWidgetState<PastPage> {
  int page = 1;
  bool noMore = false;
  bool networkErr = false;
  bool isHud = true;
  String selectDay = DateUtil.formatDate(DateTime.now(), format: "yyyy-MM-dd");
  List _dataList = [];
  List<String> keys = [];

  @override
  void onCreate() {
    if (widget.isShow) {
      _getData();
    }
  }

  Future<bool> _getData({isShow = false}) async {
    final bool isToday =
        selectDay == DateUtil.formatDate(DateTime.now(), format: "yyyy-MM-dd");
    ResponseModel<dynamic>? res =
        await pastList(page: page, date: isToday ? '' : selectDay);
    if (res?.data == null) {
      networkErr = true;
      if (mounted) setState(() {});
      return false;
    }
    final List list = dealData(Map.from(res?.data["list"] ?? {}));
    if (page == 1) {
      _dataList = list;
      noMore = false;
    } else if (page > 1 && list.isNotEmpty) {
      _dataList.addAll(list);
      _dataList = Utils.listMapNoDuplicate(_dataList);
    } else {
      noMore = true;
    }
    isHud = false;
    if (mounted) setState(() {});
    return false;
  }

  List<dynamic> dealData(Map map) {
    if (map.isEmpty) return [];
    List ps = [];
    map.forEach((key, value) {
      List p = List.from(value);
      if (p.first['date'] == null && !keys.contains(key)) {
        p.first['date'] = key;
        keys.add(key);
      }
      ps.addAll(p);
    });
    return ps;
  }

  @override
  void didUpdateWidget(covariant PastPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_dataList.isEmpty &&
        oldWidget.isShow == false &&
        widget.isShow == true) {
      _getData();
    }
  }

  @override
  Widget appbar() => Container();

  @override
  void onDestroy() {}

  @override
  pageBody(BuildContext context) {
    return BaseMainView(
      paddingTop: 94.w,
      paddingBottom: 30.w,
      leftWidget: networkErr
          ? LoadStatus.netErrorWork(onTap: () {
              networkErr = false;
              _getData();
            })
          : SizedBox(
              height: ScreenHeight - 124.w,
              width: 640.w,
              child: isHud
                  ? LoadStatus.showLoading(mounted)
                  : _dataList.isEmpty
                      ? LoadStatus.noData()
                      : _RefreshWidget(
                          data: _dataList,
                          onRefresh: () {
                            keys = [];
                            page = 1;
                            return _getData();
                          },
                          onLoading: () {
                            page++;
                            return _getData();
                          },
                        ),
            ),
      dateWidget:
          _DateWidget(showAlertDate: showAlertDate, selectDay: selectDay),
    );
  }

  // Widget _buildDefaultSingleDatePickerWithValue() {
  //   final config = CalendarDatePicker2Config(
  //     selectedDayHighlightColor: Colors.amber[900],
  //     weekdayLabels: ['日', '一', '二', '三', '四', '五', '六'],
  //     weekdayLabelTextStyle: const TextStyle(
  //       color: Colors.black87,
  //       fontWeight: FontWeight.bold,
  //     ),
  //     firstDayOfWeek: 1,
  //     controlsHeight: 50,
  //     controlsTextStyle: const TextStyle(
  //       color: Colors.black,
  //       fontSize: 15,
  //       fontWeight: FontWeight.bold,
  //     ),
  //     dayTextStyle: const TextStyle(
  //       color: Colors.amber,
  //       fontWeight: FontWeight.bold,
  //     ),
  //     disabledDayTextStyle: const TextStyle(
  //       color: Colors.grey,
  //     ),
  //     selectableDayPredicate: (day) => !day
  //         .difference(DateTime.now().subtract(const Duration(days: 3)))
  //         .isNegative,
  //   );
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       const SizedBox(height: 10),
  //       const Text('Single Date Picker (With default value)'),
  //       CalendarDatePicker2(
  //         config: config,
  //         value: _singleDatePickerValueWithDefaultValue,
  //         onValueChanged: (dates) =>
  //             setState(() => _singleDatePickerValueWithDefaultValue = dates),
  //       ),
  //       const SizedBox(height: 10),
  //       Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           const Text('Selection(s):  '),
  //           const SizedBox(width: 10),
  //           Text(
  //             _getValueText(
  //               config.calendarType,
  //               _singleDatePickerValueWithDefaultValue,
  //             ),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 25),
  //     ],
  //   );
  // }

  // String _getValueText(
  //     CalendarDatePicker2Type datePickerType,
  //     List<DateTime?> values,
  //     ) {
  //   values =
  //       values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
  //   var valueText = (values.isNotEmpty ? values[0] : null)
  //       .toString()
  //       .replaceAll('00:00:00.000', '');
  //
  //   if (datePickerType == CalendarDatePicker2Type.multi) {
  //     valueText = values.isNotEmpty
  //         ? values
  //         .map((v) => v.toString().replaceAll('00:00:00.000', ''))
  //         .join(', ')
  //         : 'null';
  //   } else if (datePickerType == CalendarDatePicker2Type.range) {
  //     if (values.isNotEmpty) {
  //       final startDate = values[0].toString().replaceAll('00:00:00.000', '');
  //       final endDate = values.length > 1
  //           ? values[1].toString().replaceAll('00:00:00.000', '')
  //           : 'null';
  //       valueText = '$startDate to $endDate';
  //     } else {
  //       return 'null';
  //     }
  //   }
  //
  //   return valueText;
  // }

  void showAlertDate() {
    showDatePicker(
      // locale: const Locale('zh', 'CH'),
      context: context,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
      initialDate: DateTime.parse(selectDay),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
              textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                      foregroundColor: StyleTheme.orange255Color)),
              colorScheme: ColorScheme.light(
                primary: StyleTheme.orange255Color,
                onPrimary: Colors.white,
              )),
          child: child!,
        );
      },
    ).then((value) {
      if (value == null) return;
      selectDay = DateUtil.formatDate(value, format: "yyyy-MM-dd");
      keys = [];
      page = 1;
      _getData(isShow: true);
    });
  }
}

class _RefreshWidget extends StatelessWidget {
  final List data;
  final Future<bool> Function() onRefresh, onLoading;
  const _RefreshWidget(
      {Key? key,
      required this.data,
      required this.onRefresh,
      required this.onLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '黑料大事纪',
          style: StyleTheme.font_black_34_30,
        ),
        SizedBox(height: 20.w),
        Expanded(
          child: EasyPullRefresh(
            onRefresh: onRefresh,
            onLoading: onLoading,
            sameChild: ListView.separated(
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
              cacheExtent: ScreenHeight * 3,
              shrinkWrap: true,
              separatorBuilder: (context, index) => SizedBox(height: 10.w),
              itemBuilder: (context, index) => index == data.length - 1
                  ? Column(
                      children: [
                        _PastItem(e: data[index], index: index),
                        SizedBox(height: 20.w),
                      ],
                    )
                  : _PastItem(e: data[index], index: index),
              itemCount: data.length,
            ),
          ),
        ),
        SizedBox(height: 20.w),
      ],
    );
  }
}

class _DateWidget extends StatelessWidget {
  final Function showAlertDate;
  final String selectDay;
  const _DateWidget(
      {Key? key, required this.showAlertDate, required this.selectDay})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      child: Column(
        children: [
          Text('选择日期', style: StyleTheme.font_black_34_17_bold),
          SizedBox(height: 10.w),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              showAlertDate();
            },
            child: Container(
              width: double.infinity, // 220.w,
              height: 64.w, // 225.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border:
                      Border.all(color: StyleTheme.gray238Color, width: 1.w),
                  borderRadius: BorderRadius.all(Radius.circular(10.w))),
              padding: EdgeInsets.all(10.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(selectDay, style: StyleTheme.font_black_31_14),
                  SizedBox(width: 5.w),
                  Icon(Icons.calendar_month_rounded,
                      size: 18.w, color: StyleTheme.black31Color)
                ],
              ),
            ),
          ),
          SizedBox(height: 30.w),
        ],
      ),
    );
  }
}

class _PastItem extends StatelessWidget {
  final int index;
  final dynamic e;
  const _PastItem({Key? key, required this.index, required this.e})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          e["date"] == null
              ? Container()
              : Center(
                  key: ValueKey(e["date"]),
                  child: Text(
                    DateUtil.formatDateStr("${e["date"]}",
                        format: "yyyy-MM-dd"),
                    style: StyleTheme.font_black_0_20,
                  ),
                ),
          SizedBox(height: e["date"] == null ? 0 : 20.w),
          GestureDetector(
            onTap: () {
              Utils.navTo(context, "/homecontentdetailpage/${e["id"]}");
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.w),
              decoration: BoxDecoration(
                  color: StyleTheme.gray245Color,
                  borderRadius: BorderRadius.all(Radius.circular(5.w))),
              child: Text(
                e["title"] ?? "",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                    color: StyleTheme.gray51Color,
                    height: 1.5),
                maxLines: 3,
                softWrap: true,
                textAlign: TextAlign.left,
              ),
            ),
          )
        ],
      ),
    );
  }
}
