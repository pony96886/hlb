import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:hlw/util/utils.dart';
import 'package:encrypt/encrypt.dart';
import 'package:convert/convert.dart';

final key = Key.fromUtf8("2acf7e91e9864673");
final iv = IV.fromUtf8("1c29882d3ddfcfd6");
const appkey = "5589d41f92a597d016b037ac37db243d";

final mediaKey = Key.fromUtf8("f5d965df75336270");
final mediaIv = IV.fromUtf8("97b60394abc2fbe1");

class EncDecrypt {
  //签名
  static String toSign(Map obj) {
    String md5Text;
    List keyValues = [];
    keyValues.add("client=${obj['client']}");
    keyValues.add("data=${obj['data']}");
    keyValues.add("timestamp=${obj['timestamp']}");
    String text = '${keyValues.join('&')}$appkey';
    Digest _digest = sha256.convert(utf8.encode(text));
    md5Text = md5.convert(utf8.encode(_digest.toString())).toString();
    return md5Text;
  }

  static Future<dynamic> encryptReqParams(String word) async {
    Encrypter encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    Encrypted encrypted = encrypter.encryptBytes(utf8.encode(word), iv: iv);
    String data = utf8.decode(encrypted.base64.codeUnits);
    int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    String sign =
        toSign({"client": "pwa", "data": data, "timestamp": timestamp});
    return "client=pwa&timestamp=$timestamp&data=$data&sign=$sign";
  }

  static Future<String> decryptResData(dynamic data) async {
    Encrypter encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    Encrypted encrypted = Encrypted.fromBase64(data['data']);
    String decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }

  static Uint8List? decryptImage(data) {
    try {
      Encrypter encrypter = Encrypter(AES(mediaKey, mode: AESMode.cbc));
      Encrypted encrypted = Encrypted.fromBase64(base64Encode(data));
      // final stopwatch = Stopwatch()..start();
      List<int> decrypted = encrypter.decryptBytes(encrypted, iv: mediaIv);
      return Uint8List.fromList(decrypted);
    } catch (err) {
      Utils.log(err);
      return null;
    }
  }

  static dynamic decryptM3U8(data) {
    try {
      Encrypter encrypter = Encrypter(AES(mediaKey, mode: AESMode.cbc));
      Encrypted encrypted = Encrypted.fromBase64(data);
      // final stopwatch = Stopwatch()..start();
      String decrypted = encrypter.decrypt(encrypted, iv: mediaIv);
      return decrypted;
    } catch (err) {
      return null;
    }
  }

  static String toSha256(String data) {
    var content = const Utf8Encoder().convert(data);
    var digest = sha256.convert(content);
    var text = hex.encode(digest.bytes);
    return text;
  }

  static String encry(plainText) {
    try {
      final encrypter = Encrypter(AES(mediaKey, mode: AESMode.cbc));
      final encrypted = encrypter.encrypt(plainText, iv: mediaIv);
      return encrypted.base16;
    } catch (err) {
      Utils.log("aes encode error:$err");
      return plainText;
    }
  }

  static String decry(encrypted) {
    try {
      final encrypter = Encrypter(AES(mediaKey, mode: AESMode.cbc));
      final decrypted = encrypter.decrypt16(encrypted, iv: mediaIv);
      return decrypted;
    } catch (err) {
      Utils.log("aes decode error:$err");
      return encrypted;
    }
  }

  //IM加密专用
  static Future<String> encryptReqParamsWithKey(
      String word, String key, String iv) async {
    Encrypter encrypter = Encrypter(AES(Key.fromUtf8(key), mode: AESMode.cbc));
    Encrypted encrypted =
        encrypter.encryptBytes(utf8.encode(word), iv: IV.fromUtf8(iv));
    String data = utf8.decode(encrypted.base64.codeUnits);
    return data;
  }

  //IM解密专用
  static Future<String> decryptResDataWithKey(
    dynamic data,
    String key,
    String iv,
  ) async {
    Encrypter encrypter = Encrypter(AES(Key.fromUtf8(key), mode: AESMode.cbc));
    Encrypted encrypted = Encrypted.fromBase64(data['data']);
    String decrypted = encrypter.decrypt(encrypted, iv: IV.fromUtf8(iv));
    return decrypted;
  }
}
