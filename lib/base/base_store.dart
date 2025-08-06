import 'package:hlw/model/config_model.dart';
import 'package:hlw/model/sysnotice_model.dart';
import 'package:hlw/model/user_model.dart';
import 'package:flutter/foundation.dart';

//数据状态持久化
class BaseStore with ChangeNotifier, DiagnosticableTreeMixin {
  //基础数据
  ConfigModel? _config;
  ConfigModel? get config => _config;
  //用户数据
  UserModel? _user;
  UserModel? get user => _user;
  //消息中心
  SysNoticeModel? _notice;
  SysNoticeModel? get notice => _notice;
  // mid
  String? _mid;
  String? get mid => _mid;

  void setConfig(ConfigModel newConfig) {
    _config = newConfig;
    notifyListeners();
  }

  void setUser(UserModel newUser) {
    _user = newUser;
    notifyListeners();
  }

  void setNotice(SysNoticeModel newNotice) {
    _notice = newNotice;
    notifyListeners();
  }

  void setMid(String mid) {
    _mid = mid;
    notifyListeners();
  }
}
