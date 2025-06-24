// lib/tw_stt.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<String?> taiwaneseSTT(String filePath) async {
  const String _apiUrl = 'http://140.116.245.149:5002/proxy';
  const String _token = '2025@test@asr';
  const String _lang = 'TA and ZH Medical V1';

  try {
    final bytes = await File(filePath).readAsBytes();
    final base64Audio = base64Encode(bytes);

    final response = await http.post(
      Uri.parse(_apiUrl),
      body: {
        'lang': _lang,
        'token': _token,
        'audio': base64Audio,
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['sentence'] ?? '';
    } else {
      print('台語 API 回傳錯誤：${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('台語語音辨識錯誤：$e');
    return null;
  }
}
