import 'package:celebrities/detail.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // getTemporaryDirectory
import 'package:just_audio/just_audio.dart'; // AudioPlayer
import 'package:record/record.dart'; // Record
import 'package:celebrities/stt.dart';
import 'package:celebrities/tts.dart';
import 'package:just_audio/just_audio.dart';

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
  List showCelebrities = [];
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    showCelebrities = List.from(_celebrities);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchCelebrities(String keyword) {
    setState(() {
      showCelebrities =
          _celebrities
              .where((celebrity) => celebrity["name"].contains(keyword))
              .toList();
    });
  }

  bool isRecording = false;

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
                      }
                      isRecording = true;
                    }
                    setState(() {});
                  },
                  backgroundColor: isRecording ? Colors.red : Colors.blue,
                  label: const Icon(Icons.mic, color: Colors.white, size: 20),
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
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _searchCelebrities(_searchController.text),
              ),
            ],
          ),
          /*Expanded(
            child: ListView.builder(
              itemCount: showCelebrities.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Image.asset(
                      showCelebrities[index]["image"],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(showCelebrities[index]["name"]),
                    subtitle: Text(showCelebrities[index]["occupation"]),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return CeleBrityDetail(
                                celebrity: showCelebrities[index],
                              );
                            },
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                );
              },
            ),
          ),*/
        ],
      ),
    );
  }
}
