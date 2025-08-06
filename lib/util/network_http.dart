import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:hlw/util/app_global.dart';
import 'package:hlw/util/encdecrypt.dart';
import 'package:hlw/util/utils.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:universal_html/html.dart' as html;

import '../model/response_model.dart';

//网络加载
class NetworkHttp {
  //是否因token失效跳转到登录页
  static bool _isJump = false;

  //获取token
  static String _getToken() {
    return AppGlobal.appBox?.get('hlw_token') ?? "";
  }

  static final Dio _uploadDio = Dio(BaseOptions(
    connectTimeout: 60 * 1000,
    receiveTimeout: 300 * 1000,
  ));

  static final Dio _apiDio = Dio(
    BaseOptions(
      connectTimeout: 60 * 1000,
      receiveTimeout: 300 * 1000,
      validateStatus: (status) {
        return (status ?? 0) < 500;
      },
      contentType: Headers.formUrlEncodedContentType,
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          Map _data = {};
          String _token = _getToken();
          if (_token.isNotEmpty) AppGlobal.apiToken = _token;
          _data.addAll(AppGlobal.appinfo);
          _data.addAll({'token': _token});
          if (options.data != null) _data.addAll(options.data);
          Utils.log("params: $_data");
          options.data = await EncDecrypt.encryptReqParams(jsonEncode(_data));
          return handler.next(options);
        },
        onResponse: (response, handler) async {
          if (response.data is Map && response.data['data'] != null) {
            String _data = await EncDecrypt.decryptResData(response.data);
            Utils.log("data: $_data");
            response.data = jsonDecode(_data);
          }
          if (response.data is Map &&
              response.data["msg"] == "token无效" &&
              !_isJump &&
              AppGlobal.context != null) {
            Utils.showText(Utils.txt("dlsx"));
            //清空数据
            AppGlobal.apiToken = '';
            AppGlobal.appBox?.delete('hlw_token');
            _isJump = false;
          }
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          return handler.next(e);
        },
      ),
    );

  static Future xfileUploadImage({
    PlatformFile? file,
    String? id,
    String position = 'head',
    ProgressCallback? progressCallback,
  }) async {
    try {
      id ??= DateTime.now().millisecondsSinceEpoch.toString();
      var imgKey = AppGlobal.uploadImgKey.replaceFirst('head', '');
      var newKey = 'id=$id&position=$position$imgKey';
      var tmpSha256 = EncDecrypt.toSha256(newKey);
      var sign = Utils.toMD5(tmpSha256);
      var ext = file?.name.split(".").last;

      FormData formData = FormData.fromMap({
        'id': id,
        'position': position,
        'sign': sign,
        'cover': await MultipartFile.fromFile(
          file?.path ?? "",
          filename: file?.name ?? "",
          contentType: MediaType.parse('image/$ext'),
        ),
      });

      Response response = await _uploadDio.post(
        AppGlobal.uploadImgUrl,
        data: formData,
        onSendProgress: progressCallback,
        options: Options(contentType: 'multipart/form-data'),
      );
      Utils.log('${jsonDecode(response.data)}');
      return jsonDecode(response.data);
    } catch (e) {
      Utils.log(e);
      return null;
    }
  }

  static Future xfileHtmlUploadImage(
      {PlatformFile? file,
      String? id,
      String position = 'head',
      Function(html.ProgressEvent)? progressCallback}) async {
    try {
      id ??= DateTime.now().millisecondsSinceEpoch.toString();
      var imgKey = AppGlobal.uploadImgKey.replaceFirst('head', '');
      var newKey = 'id=$id&position=$position$imgKey';
      var tmpSha256 = EncDecrypt.toSha256(newKey);
      var sign = Utils.toMD5(tmpSha256);
      var ext = file?.extension ?? "";

      final html.FormData formData = html.FormData()
        ..append('id', id)
        ..append('position', position)
        ..append('sign', sign)
        ..appendBlob(
          "cover",
          html.Blob([file?.bytes], "image/$ext"),
        );

      html.HttpRequest httpRequest = await html.HttpRequest.request(
          AppGlobal.uploadImgUrl,
          method: "POST",
          mimeType: "image/$ext",
          sendData: formData,
          onProgress: progressCallback);
      Utils.log('${jsonDecode(httpRequest.response)}');
      return jsonDecode(httpRequest.response);
    } catch (e) {
      Utils.log(e);
      return null;
    }
  }

  static Future xfileBytesUploadMp4(
      {PlatformFile? file,
      String position = 'head',
      CancelToken? cancelToken,
      ProgressCallback? progressCallback}) async {
    try {
      String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
      var videoKey = AppGlobal.uploadMp4Key.replaceFirst('head', '');
      var newKey = '$timeStamp$videoKey';
      var sign = Utils.toMD5(newKey);

      FormData formData = FormData.fromMap({
        'timestamp': timeStamp,
        'uuid': '9544f11ed4381ebcef5429b6f20e69c1',
        'sign': sign,
        'video': MultipartFile.fromBytes(
          file?.bytes ?? [],
          filename: file?.name,
          contentType: MediaType.parse('video/mp4'),
        ),
      });

      Response response = await _uploadDio.post(
        AppGlobal.uploadMp4Url,
        data: formData,
        onSendProgress: progressCallback,
        options: Options(contentType: 'multipart/form-data'),
        cancelToken: cancelToken,
      );
      Utils.log('${response.data}');
      return response.data;
    } catch (e) {
      Utils.log(e);
      return null;
    }
  }

  static Future xfileUploadMp4({
    PlatformFile? file,
    String position = 'head',
    CancelToken? cancelToken,
    ProgressCallback? progressCallback,
  }) async {
    try {
      String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
      var imageName = Utils.toMD5(timeStamp);
      var filename = '$imageName.mp4';

      int length = file?.size ?? 0;

      ///这里固
      if (length / (1024 * 1024) > 100) {
        return r2fileUploadMp4(
          file: file,
          progressCallback: progressCallback,
        );
      }

      var videoKey = AppGlobal.uploadMp4Key.replaceFirst('head', '');
      var newKey = '$timeStamp$videoKey';
      var sign = Utils.toMD5(newKey);

      FormData formData = FormData.fromMap({
        'timestamp': timeStamp,
        'uuid': '9544f11ed4381ebcef5429b6f20e69c1',
        'sign': sign,
        'video': await MultipartFile.fromFile(
          file?.path ?? "",
          filename: filename,
          contentType: MediaType.parse('video/mp4'),
        ),
      });

      Response response = await _uploadDio.post(
        AppGlobal.uploadMp4Url,
        data: formData,
        onSendProgress: progressCallback,
        cancelToken: cancelToken,
        options: Options(contentType: 'multipart/form-data'),
      );
      Utils.log('${response.data}');
      return response.data;
    } catch (e) {
      Utils.log(e);
      return null;
    }
  }

  static Future r2fileUploadMp4({
    PlatformFile? file,
    ProgressCallback? progressCallback,
    CancelToken? cancelToken,
  }) async {
    try {
      Response data = await NetworkHttp.post('/api/index/uploadToR2');
      Utils.log(data.data);
      var res = ResponseModel.fromJson(data.data, ((json) => json));
      if (res.status == 1 && res.data is Map) {
        final String url = res.data['uploadUrl'];
        final String uploadName = res.data['UploadName'];
        final String publicUrl = res.data['publicUrl'];
        FormData formData = FormData.fromMap({
          "video": await MultipartFile.fromFile(
            file?.path ?? "",
            filename: uploadName,
            contentType: MediaType.parse('video/mp4'),
          ),
        });

        Response response = await _uploadDio.put(
          url,
          data: formData.files.first.value.finalize(),
          onSendProgress: progressCallback,
          cancelToken: cancelToken,
          options: Options(
            contentType: 'video/mp4',
            headers: {
              Headers.contentLengthHeader: formData.files.first.value.length
            },
          ),
        );
        Map resString;
        if (response.statusCode == 200) {
          resString = {'code': 1, 'msg': publicUrl};
        } else {
          resString = {'code': -1, 'msg': '上传失败'};
        }
        return jsonEncode(resString);
      } else {
        Map res = {'code': -1, 'msg': '上传失败'};
        return jsonEncode(res);
      }
    } catch (e) {
      Utils.log(e);
      if (e is DioError && CancelToken.isCancel(e)) {
        return jsonEncode({'code': -1, 'msg': '已取消上传'});
      } else {
        Map res = {'code': -1, 'msg': e.toString()};
        return jsonEncode(res);
      }
    }
  }

  // // 获取S3 地址 - 不分片
  // static Future<ResponseModel<dynamic>?> getS3Url() async {
  //   try {
  //     Response<dynamic> res = await NetworkHttp.post('/api/index/uploadToS3');
  //     Utils.log(res.data);
  //     return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  //   } catch (e) {
  //     Utils.log(e);
  //     return null;
  //   }
  // }

  static Future s3fileUploadMp4({
    PlatformFile? file,
    ProgressCallback? progressCallback,
    CancelToken? cancelToken,
  }) async {
    try {
      Response data = await NetworkHttp.post('/api/index/uploadToS3');
      var res = ResponseModel.fromJson(data.data, ((json) => json));
      if (res.status == 1 && res.data is Map) {
        final String url = res.data['uploadUrl'];
        final String uploadName = res.data['UploadName'];
        final String publicUrl = res.data['publicUrl'];
        FormData formData = FormData.fromMap({
          "video": await MultipartFile.fromFile(
            file?.path ?? "",
            filename: uploadName,
            contentType: MediaType.parse('video/mp4'),
          ),
        });

        Response response = await _uploadDio.put(
          url,
          data: formData.files.first.value.finalize(),
          onSendProgress: progressCallback,
          cancelToken: cancelToken,
          options: Options(
            contentType: 'video/mp4',
            headers: {
              Headers.contentLengthHeader: formData.files.first.value.length
            },
          ),
        );
        Map resString;
        if (response.statusCode == 200) {
          resString = {'code': 1, 'msg': publicUrl};
        } else {
          resString = {'code': -1, 'msg': '上传失败'};
        }
        return jsonEncode(resString);
      } else {
        Map res = {'code': -1, 'msg': '上传失败'};
        return jsonEncode(res);
      }
    } catch (e) {
      if (e is DioError && CancelToken.isCancel(e)) {
        return jsonEncode({'code': -1, 'msg': '已取消上传'});
      } else {
        Map res = {'code': -1, 'msg': e.toString()};
        return jsonEncode(res);
      }
    }
  }

  // // 获取S3 地址 - 分片上传
  // static Future<ResponseModel<dynamic>?> getSliceS3Url() async {
  //   try {
  //     Response<dynamic> res = await NetworkHttp.post('/api/index/getS3Url');
  //     Utils.log(res.data);
  //     return ResponseModel<dynamic>.fromJson(res.data, ((json) => json));
  //   } catch (e) {
  //     Utils.log(e);
  //     return null;
  //   }
  // }

  static Future r2ChunkedUploadMp4({
    required PlatformFile file,
    CancelToken? cancelToken,
    ProgressCallback? progressCallback,
  }) async {
    try {
      String baseUrl = 'https://r2.microservices.vip';
      const String signKey = 'd2bf7126723ea8f6005ba141ea3c3e2c';

      const int chunkSize = 5242880; // 5MB
      final int fileSize = file.size;
      final int numberOfChunks = (fileSize / chunkSize).ceil();
      String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
      String signature =
          md5.convert(utf8.encode('$timeStamp$signKey')).toString();
      Utils.log(baseUrl);
      final Response uploadResponse = await Dio().post(
        '$baseUrl/multipart_upload',
        data: FormData.fromMap({
          'sign': signature,
          'timestamp': timeStamp,
          'total': numberOfChunks,
        }),
        options: Options(contentType: 'multipart/form-data'),
        cancelToken: cancelToken,
      );

      final uploadData = uploadResponse.data;
      if (uploadData['status'] != 'success') {
        return jsonEncode({
          'code': -1,
          'msg': uploadData['msg'] + '，请重试. (upload 1001)',
        });
      }

      final String uploadUrl = uploadData['data']['uploadUrl'];
      final String uploadName = uploadData['data']['UploadName'];
      final String uploadId = uploadData['data']['uploadId'];
      final List<dynamic> slices = uploadData['data']['slices'];
      final String chunkUploadUrl = uploadUrl
          .replaceAll('{UploadName}', uploadName)
          .replaceAll('{uploadId}', uploadId);
      final List<Map<String, dynamic>> sliceTags = [];

      int uploadedSize = 0;

      final tempFile = File(file.path!); // 零时文件
      for (var i = 0; i < slices.length; i++) {
        final int start = i * chunkSize;
        final int end = min(start + chunkSize, fileSize);
        final int sliceSize = end - start;
        final Stream<List<int>> chunkFile = tempFile.openRead(start, end);
        final Response response = await Dio().put(
          chunkUploadUrl
              .replaceAll('{number}', slices[i]['number'].toString())
              .replaceAll('{signature}', slices[i]['signature']),
          data: chunkFile,
          cancelToken: cancelToken,
          onSendProgress: (int sent, int total) {
            if (progressCallback != null) {}
          },
          options: Options(
            contentType: 'application/octet-stream',
            headers: {
              Headers.contentLengthHeader: sliceSize,
            },
          ),
        );

        if (response.statusCode == 200) {
          sliceTags.add({
            'number': i + 1,
            'e_tag': response.headers['etag']![0].replaceAll('"', ''),
          });
          if (progressCallback != null) {
            uploadedSize += sliceSize;
            progressCallback(uploadedSize, fileSize);
          }
        } else {
          return jsonEncode({
            'code': -1,
            'msg': '上传失败',
          });
        }
      }
      Utils.log(sliceTags);
      if (sliceTags.isEmpty) {
        return jsonEncode({
          'code': -1,
          'msg': '上传失败',
        });
      }

      /// s3 需要重新获取完整地址
      Response completeResponse = await Dio().post(
        '$baseUrl/multipart_complete',
        data: FormData.fromMap({
          'sign': signature,
          'timestamp': timeStamp,
          'upload_name': uploadName,
          'upload_id': uploadId,
          'slice_tag': jsonEncode(sliceTags),
        }),
        cancelToken: cancelToken,
        options: Options(contentType: 'multipart/form-data'),
      );

      Utils.log('--> upload finish $completeResponse');
      if (completeResponse.statusCode == 200 &&
          completeResponse.data is Map &&
          completeResponse.data['status'] == 'success') {
        return jsonEncode({
          'code': 1,
          'msg': completeResponse.data['data']['publicUrl'],
        });
      } else {
        return jsonEncode({
          'code': -1,
          'msg': '上传失败：${completeResponse.data['msg']}',
        });
      }
    } on Exception catch (e) {
      if (e is DioError && CancelToken.isCancel(e)) {
        return jsonEncode({'code': -1, 'msg': '已取消上传'});
      } else {
        Map res = {'code': -1, 'msg': e.toString()};
        return jsonEncode(res);
      }
    }
  }

  static Future s3ChunkedUploadMp4({
    required PlatformFile file,
    ProgressCallback? progressCallback,
    CancelToken? cancelToken,
  }) async {
    try {
      String baseUrl = 'https://s3.microservices.vip';
      const String signKey = 'd2bf7126723ea8f6005ba141ea3c3e2c';

      Response data = await NetworkHttp.post('/api/index/getS3Url');
      Utils.log(data.data);
      var res = ResponseModel.fromJson(data.data, ((json) => json));
      if (res.status == 1 && res.data is Map) {
        String url = res.data['uploadUrl'] ?? '';
        if (url.isNotEmpty) baseUrl = url;
      }

      const int chunkSize = 5242880; // 5MB
      final int fileSize = file.size;
      final int numberOfChunks = (fileSize / chunkSize).ceil();
      String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
      String signature =
          md5.convert(utf8.encode('$timeStamp$signKey')).toString();
      Utils.log(baseUrl);
      final Response uploadResponse = await Dio().post(
        '$baseUrl/multipart_upload',
        data: FormData.fromMap({
          'sign': signature,
          'timestamp': timeStamp,
          'total': numberOfChunks,
        }),
        options: Options(contentType: 'multipart/form-data'),
        cancelToken: cancelToken,
      );

      final uploadData = uploadResponse.data;
      if (uploadData['status'] != 'success') {
        return jsonEncode({
          'code': -1,
          'msg': uploadData['msg'] + '，请重试. (upload 1001)',
        });
      }

      final String uploadUrl = uploadData['data']['uploadUrl'];
      final String uploadName = uploadData['data']['UploadName'];
      final String uploadId = uploadData['data']['uploadId'];
      final List<dynamic> slices = uploadData['data']['slices'];
      final String chunkUploadUrl = uploadUrl
          .replaceAll('{UploadName}', uploadName)
          .replaceAll('{uploadId}', uploadId);
      final List<Map<String, dynamic>> sliceTags = [];

      int uploadedSize = 0;

      final tempFile = File(file.path!); // 零时文件
      for (var i = 0; i < slices.length; i++) {
        final int start = i * chunkSize;
        final int end = min(start + chunkSize, fileSize);
        final int sliceSize = end - start;
        final Stream<List<int>> chunkFile = tempFile.openRead(start, end);
        final Response response = await Dio().put(
          chunkUploadUrl
              .replaceAll('{number}', slices[i]['number'].toString())
              .replaceAll('{signature}', slices[i]['signature']),
          data: chunkFile,
          cancelToken: cancelToken,
          onSendProgress: (int sent, int total) {
            if (progressCallback != null) {}
          },
          options: Options(
            contentType: 'application/octet-stream',
            headers: {
              Headers.contentLengthHeader: sliceSize,
            },
          ),
        );

        if (response.statusCode == 200) {
          sliceTags.add({
            'number': '${i + 1}',
            'e_tag': response.headers['etag']![0].replaceAll('"', ''),
          });
          if (progressCallback != null) {
            uploadedSize += sliceSize;
            progressCallback(uploadedSize, fileSize);
          }
        } else {
          return jsonEncode({
            'code': -1,
            'msg': '上传失败',
          });
        }
      }
      Utils.log(sliceTags);
      if (sliceTags.isEmpty) {
        return jsonEncode({
          'code': -1,
          'msg': '上传失败',
        });
      }

      /// s3 需要重新获取完整地址
      Response completeResponse = await Dio().post(
        '$baseUrl/multipart_complete',
        data: FormData.fromMap({
          'sign': signature,
          'timestamp': timeStamp,
          'upload_name': uploadName,
          'upload_id': uploadId,
          'slice_tag': jsonEncode(sliceTags),
        }),
        cancelToken: cancelToken,
        options: Options(contentType: 'multipart/form-data'),
      );

      Utils.log('--> upload finish $completeResponse');
      if (completeResponse.statusCode == 200 &&
          completeResponse.data is Map &&
          completeResponse.data['status'] == 'success') {
        final completeResponse = await NetworkHttp.post(
          '/api/index/getS3PublicUrl',
          data: {
            'uploadname': uploadName,
            'upload_name': uploadName,
          },
        );
        if (completeResponse.statusCode == 200 &&
            completeResponse.data is Map &&
            completeResponse.data['status'] == 1) {
          return jsonEncode({
            'code': 1,
            'msg': completeResponse.data['data']['publicUrl'],
          });
        } else {
          return jsonEncode({
            'code': -1,
            'msg': '上传失败：${completeResponse.data['msg']}',
          });
        }
      } else {
        return jsonEncode({
          'code': -1,
          'msg': '上传失败：${completeResponse.data['msg']}',
        });
      }
    } on Exception catch (e) {
      if (e is DioError && CancelToken.isCancel(e)) {
        return jsonEncode({'code': -1, 'msg': '已取消上传'});
      } else {
        Map res = {'code': -1, 'msg': e.toString()};
        return jsonEncode(res);
      }
    }
  }

  //post请求
  static Future post(String path, {Map? data, CancelToken? cancelToken}) {
    Utils.log("request url: ${AppGlobal.apiBaseURL + path}");
    return _apiDio.post(
      AppGlobal.apiBaseURL + path,
      data: data,
      cancelToken: cancelToken,
    );
  }

  //get请求
  static Future get(String url) {
    Utils.log("request url: $url");
    return Dio().get(url);
  }

  static Future<Response> download(String urlPath, String savePath,
      {ProgressCallback? onReceiveProgress}) {
    return _uploadDio.download(
      urlPath,
      savePath,
      onReceiveProgress: onReceiveProgress,
    );
  }
}
