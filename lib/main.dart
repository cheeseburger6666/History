import 'package:celebrities/detail.dart';
import 'package:flutter/material.dart';
//import 'package:tw_celebrities/home.dart';
import 'package:path_provider/path_provider.dart'; // getTemporaryDirectory
import 'package:just_audio/just_audio.dart'; // AudioPlayer
import 'package:record/record.dart'; // Record
import 'package:celebrities/stt.dart';
import 'package:celebrities/tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:celebrities/tw_stt.dart'; // 台語 API

final record = AudioRecorder();
final player = AudioPlayer();

void main() {
  runApp(const MyApp());
}

/*class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}*/
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

/*
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}*/

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

  void searchCelebrities(String keyword){
    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(title: const Text('Celebrities')),*/
      appBar: AppBar(
        title: const Text('Celebrities'),
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
                  onPressed: () async { ... }, // 用原本的 record + request
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
                  onPressed: () async { ... }, // 使用 flutter_sound + tw_stt
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


