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

  const HomePage({super.key, required this.onToggleTheme, required this.themeMode});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List _celebrities = [
    {
      "name": "Super Craig",
      "occupation": "Brutalist",
      "image": "images/Super-craig.webp",
      "introduction":
      "無論是不是在扮演超級英雄，超級克雷格·塔克永遠都是「超級」的。超級強壯，超級生氣，超級擅長豎中指讓敵人超級憤怒，然後再超級狠地錘他們一拳。",
    },
    {
      "name": "Human Kite",
      "occupation": "Elementalist-Blaster",
      "image": "images/Human-kite.webp",
      "introduction":
      "作為對抗風箏迫害的先鋒，風箏俠——亦稱凱爾·布羅夫洛夫斯基，是一位元素使和爆破者的混種，有著爆炸的雷射眼。命運宿敵：來自平行宇宙的風箏俠二號。",
    },
    {
      "name": "Fastpass",
      "occupation": "Speedster",
      "image": "images/Fastpass.webp",
      "introduction":
      "在白天，他是溫和的單口相聲演員吉米·瓦爾莫，在晚上，他就是一位經典的速行者。速行俠以他超快的速度，隱形的能力與強大的治療能力讓邪惡看不清路，他同時也提供一個非常貼心的快速移動服務。",
    },
    {
      "name": "Mosquito",
      "occupation": "Hunter-Vampire",
      "image": "images/Mosquito.webp",
      "introduction":
      "被一隻受輻射影響變異的蚊子咬過之後，克萊德·多諾萬就變成了這個超人般的，被稱為蚊子俠的疾病攜帶者。他很樂意吸光罪犯的血，而且他整個人，都噁心極了。",
    },
    {
      "name": "Captain Diabetes",
      "occupation": "Brutalist",
      "image": "images/Captain-diabetes.webp",
      "introduction":
      "作為糖尿病隊長，斯科特·馬爾金森使用糖尿病的毀滅性力量。身為蠻人，他會熟練運用自己暴力的擊退組合連擊，以及煩人的交友出遊欲望。謹奉告，他真的，真的有糖尿病。",
    },
    {
      "name": "The Coon",
      "occupation": "Ninja Manimal",
      "image": "images/The-coon.webp",
      "introduction":
      "浣熊俠是誰？一個忍者人獸，一個嗜血冷酷而致命的刺客。他是太空浣熊和以「何妨一試」為人生準則的動物管理員的後裔，其真實身份不明。",
    },
    {
      "name": "Toolshed",
      "occupation": "Gadgeteer",
      "image": "images/Toolshed.webp",
      "introduction":
      "一道可怕的閃電把亂七八糟的工具轉移到了和藹男孩斯坦·馬什的身上，讓它成為了工具俠，真正的工具大師。不過很可惜，如果只有個錘子，他就沒什麼錘子用了。",
    },
    {
      "name": "Call Girl",
      "occupation": "Gadgeteer",
      "image": "images/Call-girl.webp",
      "introduction":
      "電話女俠是一名有著好心腸的發明家兼白帽子（White-hat). 無論是在網絡上，還是現實生活中，她都會很暴力地坑罪犯。電話女俠精通於洩密，網絡釣魚，以及減益效果。",
    },
    {
      "name": "Professor Chaos",
      "occupation": "Blaster-Summoner",
      "image": "images/Professor-chaos.webp",
      "introduction":
      "混沌教授用無情的效率將混沌外包出去，他的那些有些邪惡的計劃得到實施，靠的是他的倉鼠小部下，混沌小孩們，還有墨西哥人。不過只有一個問題，他並不是一個有證的教授。",
    },
    {
      "name": "Mysterion",
      "occupation": "Netherborn",
      "image": "images/Mysterion.webp",
      "introduction":
      "身為一名無限重生的幽冥族，神秘俠具有人類不該擁有的力量與智慧。在最絕望的緊要關頭他可以變為他的究極形態：神秘俠鬼魂。",
    },
    {
      "name": "Tupperware",
      "occupation": "Cyborg",
      "image": "images/Tupperware.webp",
      "introduction":
      "一場極小概率的食品儲藏室意外將托肯·布萊克變成了保鮮盒俠，一名生化人超級英雄，他能夠運用自己的力量製造致命的保鮮炮台，也能保證食物的新鮮。",
    },
    {
      "name": "Wonder Tweek",
      "occupation": "Elementalist",
      "image": "images/Wonder-tweek.webp",
      "introduction":
      "在特維克·特威克人畜無害地觀看天氣頻道時，一場意外的太陽異常現象賦予了他掌控原始地球元素，閃電，水，和咖啡因的能力。",
    },
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
              .where(
                (celebrity) =>
            celebrity["name"].contains(keyword) ||
                celebrity["occupation"].contains(keyword),
          )
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

