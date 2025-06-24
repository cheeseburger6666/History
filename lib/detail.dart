import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CeleBrityDetail extends StatelessWidget {
  final Map<String, dynamic> celebrity;
  const CeleBrityDetail({super.key, required this.celebrity});

  @override
  Widget build(BuildContext context) {
    print(celebrity);

    final FlutterTts tts = FlutterTts();

    Future<void> speakText(String text) async {
      await tts.setLanguage("zh-TW");
      await tts.setSpeechRate(1.0);
      await tts.setVolume(1.0);
      await tts.speak(text);
    }

    return Scaffold(
      appBar: AppBar(title: Text(celebrity["name"])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Image.asset('${celebrity["image"]}', height: 250),
                const SizedBox(width: 25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${celebrity["name"] ?? ""}  ',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: '/${celebrity["occupation"] ?? ""}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "介紹：\n${wrapEveryNChars(celebrity["introduction"] ?? "", 20)}",
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed:
                          () => speakText(celebrity["introduction"] ?? "沒有介紹"),
                      child: const Text("語音播放：介紹內容"),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String wrapEveryNChars(String text, int n) {
  final buffer = StringBuffer();
  for (int i = 0; i < text.length; i++) {
    buffer.write(text[i]);
    if ((i + 1) % n == 0 && i != text.length - 1) {
      buffer.write('\n');
    }
  }
  return buffer.toString();
}
