import 'package:celebrities/detail.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // getTemporaryDirectory
import 'package:just_audio/just_audio.dart'; // AudioPlayer
import 'package:record/record.dart'; // Record
import 'package:celebrities/stt.dart';
import 'package:celebrities/tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:celebrities/tw_stt.dart'; // 台語 API
import 'dart:io';          // 提供 File 類別
import 'dart:convert';     // 提供 base64Encode、jsonDecode
import 'package:http/http.dart' as http; // 提供 http.post


final record = AudioRecorder();
final player = AudioPlayer();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  void toggleTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Celebrities',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: HomePage(onToggleTheme: toggleTheme, themeMode: _themeMode),
    );
  }
}

class HomePage extends StatefulWidget {
  final void Function(bool) onToggleTheme;
  final ThemeMode themeMode;

  const HomePage({super.key, required this.onToggleTheme, required this.themeMode});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List _celebrities = [{}];
  List showCelebrities = [];
  final TextEditingController _searchController = TextEditingController();
  final FlutterSoundRecorder _twRecorder = FlutterSoundRecorder();
  bool isTwRecording = false;
  String? _twFilePath;

  @override
  void initState() {
    super.initState();
    _twRecorder.openRecorder();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _twRecorder.closeRecorder();
    super.dispose();
  }

  bool isRecording = false;

  void _searchCelebrities(String keyword){
    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(title: const Text('Celebrities')),*/
      appBar: AppBar(
        title: const Text('Taiwanese History Figures'),
        actions: [
          Row(
            children: [
              const Icon(Icons.light_mode),
              Switch(
                value: widget.themeMode == ThemeMode.dark,
                onChanged: widget.onToggleTheme,
              ),
              const Icon(Icons.dark_mode),
            ],
          ),
        ],
      ),

      body: Column(
        children: [
          Row(
            children: [
              // 中文語音辨識按鈕（藍色）
              SizedBox(
                width: 40,
                height: 40,
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    final tempPath = await getTemporaryDirectory();
                    String path = "${tempPath.path}/audio.wav";

                    if (isRecording) {
                      // 停止錄音
                      await record.stop();
                      String? result = await request(path);
                      if (result != null) {
                        _searchController.text = result;
                      } else {
                        _searchController.text = "";
                      }
                      isRecording = false;
                    } else {
                      // 開始錄音
                      if (await record.hasPermission()) {
                        await record.start(
                          const RecordConfig(
                            sampleRate: 16000,
                            numChannels: 1,
                            encoder: AudioEncoder.wav,
                          ),
                          path: path,
                        );
                        isRecording = true;
                      }
                    }
                    setState(() {});
                  }
                  , // 用原本的 record + request
                  backgroundColor: isRecording ? Colors.red : Colors.blue,
                  label: const Icon(Icons.mic, color: Colors.white, size: 20),
                ),
              ),

              const SizedBox(width: 10), // 加一點間距

              // 台語語音辨識按鈕（綠色）
              SizedBox(
                width: 40,
                height: 40,
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    final tempDir = await getTemporaryDirectory();
                    String twPath = '${tempDir.path}/tw_temp.wav';

                    if (isTwRecording) {
                      // 停止錄音
                      await _twRecorder.stopRecorder();
                      isTwRecording = false;

                      // 呼叫 tw_stt.dart 中的辨識 API
                      final bytes = await File(twPath).readAsBytes();
                      final base64Audio = base64Encode(bytes);

                      try {
                        final response = await http.post(
                          Uri.parse('http://140.116.245.149:5002/proxy'),
                          body: {
                            'lang': 'TA and ZH Medical V1',
                            'token': '2025@test@asr',
                            'audio': base64Audio,
                          },
                        );

                        if (response.statusCode == 200) {
                          final result = jsonDecode(response.body);
                          if (result.containsKey('sentence')) {
                            _searchController.text = result['sentence'];
                          } else {
                            _searchController.text = 'API 回傳缺少 sentence 欄位';
                          }
                        } else {
                          _searchController.text = '辨識失敗：${response.body}';
                        }
                      } catch (e) {
                        _searchController.text = '辨識過程出錯：$e';
                      }
                    } else {
                      // 開始錄音
                      await Permission.microphone.request();
                      await _twRecorder.startRecorder(
                        toFile: twPath,
                        codec: Codec.pcm16WAV,
                        sampleRate: 16000,
                        numChannels: 1,
                      );
                      isTwRecording = true;
                    }

                    setState(() {});
                  }
                  , // 使用 flutter_sound + tw_stt
                  backgroundColor: isTwRecording ? Colors.red : Colors.green,
                  label: const Icon(Icons.mic_external_on, color: Colors.white, size: 20),
                ),
              ),

              // 搜尋框
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  height: 50,
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                ),
              ),

              // 搜尋按鈕
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _searchCelebrities(_searchController.text),
              ),
            ],
          )
        ],
      ),
    );
  }
}


