import 'package:flutter_tts/flutter_tts.dart';
import 'dart:developer';
// 基于单例模式实现的工具类
class TTSUtil {
  TTSUtil._();

  static final TTSUtil _manager = TTSUtil._();

  factory TTSUtil() {
    return _manager;
  }

  late FlutterTts flutterTts;

  void initTTS() {
    flutterTts = FlutterTts();
  }

  Future<void> speak(String text) async {
    // 设置语言
    await flutterTts.setLanguage("zh-CN");

    // 设置音量
    await flutterTts.setVolume(0.8);

    // 设置语速
    await flutterTts.setSpeechRate(0.6);

    // 音调
    await flutterTts.setPitch(1.0);

    if (text.isNotEmpty) {
      log('需要转换的文本：$text');
      await flutterTts.speak(text);
    }
  }

  /// 暂停
  Future<void> pause() async {
    await flutterTts.pause();
  }

  /// 结束
  Future<void> stop() async {
    await flutterTts.stop();
  }

}
