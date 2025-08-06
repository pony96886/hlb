import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:hlw/util/app_global.dart';
import 'package:hlw/util/encdecrypt.dart';
import 'package:hlw/util/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:isolated_worker/js_isolated_worker.dart';
import 'package:worker_manager/worker_manager.dart';
import 'package:universal_html/html.dart' as html;

//异步加载数据
class ImageRequestAsync {
  static final HttpClient _httpClient = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

  static Future<Uint8List> getImageRequest(String url) async {
    //从缓存目录中查找图片是否存在
    final Uint8List? cacheBytes =
        await AppGlobal.imageCacheBox?.get(Utils.toMD5(url));
    if (cacheBytes != null) {
      return cacheBytes;
    }

    final Uint8List bys =
        await Executor().execute(fun1: isolatedImage, arg1: url);
    //将下载的图片数据保存到指定缓存文件中
    await AppGlobal.imageCacheBox?.put(Utils.toMD5(url), bys);

    return bys;
  }

  static Future<Uint8List> isolatedImage(String url, TypeSendPort port) async {
    Uint8List? bytes;
    if (kIsWeb) {
      html.HttpRequest xhr =
          await html.HttpRequest.request(url, responseType: 'arraybuffer');
      if (xhr.response != null) {
        ByteBuffer bb = xhr.response;
        bytes = bb.asUint8List();
      }
    } else {
      final Uri resolved = Uri.base.resolve(url);
      final HttpClientRequest request = await _httpClient.getUrl(resolved);
      final HttpClientResponse response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        throw Exception(
            'HTTP request failed, statusCode: ${response.statusCode}, $resolved');
      }
      bytes = await consolidateHttpClientResponseBytes(response);
    }
    if (bytes?.lengthInBytes == 0 || bytes == null) {
      throw Exception('HTTP request is an empty file');
    }
    //解密后的图片
    Uint8List? bys;
    if (kIsWeb) {
      if (AppGlobal.isRegisterJs) {
        bys = base64Decode(await JsIsolatedWorker().run(
          functionName: 'decryptImage',
          arguments: base64Encode(bytes),
        ));
      } else {
        throw Exception('Web worker is not available :(');
      }
    } else {
      bys = EncDecrypt.decryptImage(bytes);
    }
    if (bys == null) {
      throw Exception('EncDecrypt failed');
    }

    return bys;
  }
}
