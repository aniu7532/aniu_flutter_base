import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

class RandomGUIDUtils {
  static const List<String> _hexDigits = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'a',
    'b',
    'c',
    'd',
    'e',
    'f'
  ];

  static String getRandomGUID() {
    String nowDateStr = DateTime.now().toIso8601String();
    Random random = Random(DateTime.now().microsecondsSinceEpoch);
    return _getSymbolTextNoLine(_getFormattedText(
        _generateMd5("$nowDateStr${random.nextInt(9999999)}")));
  }

  // md5 加密
  static List<int> _generateMd5(String data) {
    List<int> content = const Utf8Encoder().convert(data);
    Digest digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return digest.bytes;
  }

  static String _getSymbolTextNoLine(List<String?> data) {
    int index;
    String result = "";
    for (index = 0; index < data.length; index++) {
      result += data[index]!;
    }
    return result;
  }

  static List<String?> _getFormattedText(List<int> bytes) {
    int len = bytes.length;
    List<String?> buf = List.filled(len * 2, null);
    // 把密文转换成十六进制的字符串形式
    for (int j = 0, i = 0; j < len; j++) {
      buf[i++] = _hexDigits[(bytes[j] >> 4) & 0x0f];
      buf[i++] = _hexDigits[bytes[j] & 0x0f];
    }
    return buf;
  }
}
