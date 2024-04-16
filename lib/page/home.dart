import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:speech_to_assistant/component/featureBox.dart';
import 'package:speech_to_assistant/service/openai_service.dart';
import 'package:speech_to_assistant/util/stt_util.dart';
import 'package:speech_to_assistant/util/tts_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isListening = false;
  late STTUtil _sttUtil;
  late TTSUtil _ttsUtil;
  late OpenAIService _openAIService;
  late String _recordText;
  String? _generatedContent;
  String? _generatedImageUrl;

  @override
  void initState() {
    super.initState();
    // 初始化TTS
    _ttsUtil = TTSUtil();
    _ttsUtil.initTTS();
    // 初始化STT
    _sttUtil = STTUtil();
    // 初始化OpenAIService
    _openAIService = OpenAIService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await _listen();
          },
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Center(
                    child: Container(
                      width: 140,
                      height: 80,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      margin: const EdgeInsets.only(top: 10),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _generatedContent = null;
                        _generatedImageUrl = null;
                      });
                    },
                    child: Container(
                      height: 100,
                      margin: const EdgeInsets.only(top: 10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/ai-logo.png'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: _generatedImageUrl == null,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 50)
                      .copyWith(top: 40,bottom: 10),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius:
                    BorderRadius.circular(20).copyWith(topLeft: Radius.zero),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      _generatedContent ?? "How can I help you today?",
                      style: TextStyle(
                          fontSize: _generatedContent == null ? 30 : 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              if (_generatedImageUrl != null)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(_generatedImageUrl!),
                  ),
                ),
              Visibility(
                visible: _generatedImageUrl == null && _generatedContent == null,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(left: 8, top: 10),
                  child: const Text(
                    "Here are a few features",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Visibility(
                  visible:
                  _generatedContent == null && _generatedImageUrl == null,
                  child: const Column(
                    children: [
                      FeatureBox(
                          headerText: "ChatGPT",
                          descriptionText:
                          "A smarter way to stay organized and informed with ChatGPT",
                          backgroundColor: Colors.blue),
                      FeatureBox(
                          headerText: "Dall-E",
                          descriptionText:
                          "Get inspired and stay creative with your personal assistant powered by Dall-E",
                          backgroundColor: Colors.cyanAccent),
                      FeatureBox(
                          headerText: "Smart Voice Assistant",
                          descriptionText:
                          "Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT",
                          backgroundColor: Colors.deepOrangeAccent)
                    ],
                  ))
            ],
          ),
        )
    );
  }

  // 监听
  Future<void> _listen() async {
    if (!_isListening) {
      // 麦克风初始化
      bool available = await _sttUtil.initialize();
      if (available) {
        setState(() {
          _isListening = true;
          _recordText = "";
        });
        // 监听麦克风的内容
        _sttUtil.startListening((res) => {
              setState(() {
                _recordText = res;
              })
            });
      }
    } else {
      Future.delayed(const Duration(seconds: 2), () async {
        setState(() {
          _isListening = false;
        });
        log("监听到的内容：$_recordText");
        // 停止监听
        await _sttUtil.stopListening();
        await aiHandler(_recordText);
      });
    }
  }

  // AI处理
  Future<void> aiHandler(String prompt) async {
    // 判断是否绘图
    bool isArt = await _openAIService.isArtImagePrompt(prompt);
    String? aiMessage;
    if (isArt) {
      toTTS("好的，正在绘制中，请稍后");
      _generatedContent = null;
      aiMessage = await _openAIService.image(prompt);
      toTTS("绘制完成");
    } else {
      _generatedImageUrl = null;
      aiMessage = await _openAIService.simpleChat(prompt);
    }
    if (aiMessage.startsWith("https")) {
      setState(() {
        _generatedImageUrl = aiMessage;
      });
    } else {
      setState(() {
        _generatedContent = aiMessage;
      });
      await toTTS(aiMessage);
    }
  }

  // 文字转语音
  Future<void> toTTS(String text) async {
    await _ttsUtil.stop();
    await _ttsUtil.speak(text);
  }
}
