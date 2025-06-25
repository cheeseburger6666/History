import 'package:celebrities/detail.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // getTemporaryDirectory
import 'package:just_audio/just_audio.dart'; // AudioPlayer
import 'package:record/record.dart'; // Record
import 'package:celebrities/stt.dart';
import 'package:celebrities/tts.dart';

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

  const HomePage({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List _celebrities = [
    {"name": "張明", "image": "images/張明.png"},
    {"name": "曹連美", "image": "images/曹連美.png"},
    {"name": "李應章", "image": "images/李應章.png"},
    {"name": "李長", "image": "images/李長.png"},
    {"name": "林龍", "image": "images/林龍.png"},
    {"name": "楊良", "image": "images/楊良.png"},
    {"name": "王崑山", "image": "images/王崑山.png"},
    {"name": "蔡瑞月", "image": "images/蔡瑞月.png"},
    {"name": "邱阿旺", "image": "images/邱阿旺.png"},
    {"name": "陳進", "image": "images/陳進.png"},
  ];

  Map<String, dynamic>? selectedCelebrity;

  final TextEditingController _searchController = TextEditingController();

  bool isRecording = false;

  void _searchCelebrities(String keyword) {
    final result = _celebrities
        .where((celebrity) => celebrity["name"].contains(keyword))
        .toList();
    setState(() {
      selectedCelebrity = result.isNotEmpty ? result.first : null;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Padding(
                padding: const EdgeInsets.only(left: 12.0), // 左邊留12像素空白，可自行調整
                child: SizedBox(
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
                          _searchController.value = TextEditingValue(
                            text: result,
                            selection: TextSelection.collapsed(offset: result.length),
                          );
                        } else {
                          _searchController.clear();
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
                        }
                        isRecording = true;
                      }
                      setState(() {});
                    },
                    backgroundColor: isRecording ? Colors.red : Colors.purple[300],
                    label: const Icon(Icons.mic, color: Colors.white, size: 20),
                  ),
                ),
              ),

              // 搜尋框
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  height: 50,
                  child: TextField(
                    controller: _searchController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      contentPadding: EdgeInsets.all(10),
                    ),
                    onSubmitted: _searchCelebrities,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  _searchCelebrities(_searchController.text);
                  if (selectedCelebrity == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('找不到人物')),
                    );
                  }
                },
              ),
            ],
          ),

          // 搜尋結果區塊
          Expanded(
            child: selectedCelebrity != null
                ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedCelebrity!["name"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  Image.asset(
                    selectedCelebrity!["image"],
                    height: 350,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
