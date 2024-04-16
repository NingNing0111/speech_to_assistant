import 'package:speech_to_text/speech_to_text.dart';
import 'dart:developer';

// STT工具类 单例模式
class STTUtil {
  STTUtil._();

  static final STTUtil _manager = STTUtil._();

  factory STTUtil() {
    return _manager;
  }

  late SpeechToText _speechToText;

  /// 初始化语音识别。
  Future<bool> initialize() async {
    _speechToText = SpeechToText();
    return await _speechToText.initialize(
      onStatus: (status) {
        log('onStatus: $status');
      },
      onError: (error) {
        log('onError:$error');
      },
    );
  }

  /// 开始语音识别。
  Future<void> startListening(Function(String) onResult) async {
    if (_speechToText.isNotListening) {
      await _speechToText.listen(
          onResult: (result) {
            onResult(result.recognizedWords);
          },
          // 监听的语言
          localeId: "zh_CN",
          listenFor: const Duration(seconds: 10));
    }
  }

  /// 停止语音识别。
  Future<void> stopListening() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
    }
  }

  /// 获取语音识别的状态。
  SpeechToTextState getState() {
    return _speechToText.isListening
        ? SpeechToTextState.listening
        : SpeechToTextState.notListening;
  }

  /// 释放资源。
  Future<void> dispose() async {
    await _speechToText.cancel();
  }
}

enum SpeechToTextState {
  listening,
  notListening,
}
