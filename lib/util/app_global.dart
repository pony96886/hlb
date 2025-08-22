// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

class AppGlobal {
  //全局路由实例
  static GoRouter? appRouter;
  static bool isRegisterJs = false;

  static Map appinfo = {};
  static String apiBaseURL = "";
  static List<String> apiLines = [
    'https://api4.klfskcrzm.com/api.php',
    'https://api5.klfskcrzm.com/api.php'
    // 'https://api1.zx4ds5wa.com/api.php',
    // 'https://api1.bjhjjuv.com/api.php',
    // 'https://api2.zx4ds5wa.com/api.php',
  ];

  static String uploadImgUrl = "";
  static String uploadImgKey = "";
  static String imgBaseUrl = "";
  static String uploadMp4Url = "";
  static String uploadMp4Key = "";
  static String apiToken = "";

  static Box? appBox;
  static Box? imageCacheBox;
  static Box? chats;

  static List<dynamic> banners = [];

  static int vipLevel = 0;
  static BuildContext? context;

  static String m3u8_encrypt = "0";

  static int maxLines = 1000; //纯txt最大行
  static String rules = ""; //上传规则

  static dynamic userMenu;
}
