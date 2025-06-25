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
                        ],
                      ),
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
