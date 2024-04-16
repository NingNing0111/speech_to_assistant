import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:speech_to_assistant/config/base.dart';

final class _OpenAIAPI {
  static const String Chat_Completions = "v1/chat/completions";
  static const String Images_Generations = "v1/images/generations";
}

class OpenAIService {
  final int _maxLength = 10;
  final List<Map<String, String>> _messages = [];
  late String _url;
  late String _token;
  late String _chatModel;
  late String _imageModel;
  late Dio _dio;

  OpenAIService(
      {String? chat_model, String? token, String? url, String? image_model}) {
    _chatModel = chat_model ?? "gpt-3.5-turbo";
    _url = url ?? BASE_URL;
    _token = token ?? API_KEY;
    _imageModel = image_model ?? "dall-e-2";

    _dio = Dio(BaseOptions(baseUrl: _url, headers: {
      "Authorization": "Bearer $_token",
      "Content-Type": "application/json",
    }));
  }

  // 简单对话
  Future<String> simpleChat(String prompt) async {
    try {
      _messages.add({"role": "user", "content": prompt});
      Response res = await _dio.post(_OpenAIAPI.Chat_Completions,
          data: {"model": _chatModel, "messages": _messages});
      String aiMessage = res.data['choices'][0]['message']['content'];
      _messages.add({"role": "assistant", "content": aiMessage});
      return aiMessage;
    } catch (err) {
      _messages.removeLast();
      return err.toString();
    } finally {
      // 检查是否超出最大对话长度
      if (_messages.length > _maxLength) {
        _messages.sublist(_maxLength - _messages.length - 1);
      }
    }
  }

  // 绘图
  Future<String> image(String prompt) async {
    try {
      Response res = await _dio.post(_OpenAIAPI.Images_Generations, data: {
        "model": _imageModel,
        "prompt": prompt,
        "n": 1,
        "size": "1024x1024"
      });
      var aiMessage = res.data['data'][0]['url'];
      return aiMessage;
    } catch (err) {
      return err.toString();
    }
  }

  // 判断是否要画图
  Future<bool> isArtImagePrompt(String prompt) async {
    String judgeIsArtImagePrompt =
        "Does this message want to generate an AI picture, image, art or anything similar? $prompt . Simply answer with a yes or no.";
    List<Map<String, String>> messages = [
      {"role": "user", "content": judgeIsArtImagePrompt}
    ];
    Response res = await _dio.post(_OpenAIAPI.Chat_Completions,
        data: {"model": "gpt-3.5-turbo", "messages": messages});
    log(res.toString());
    String aiMessage = res.data['choices'][0]['message']['content'];
    log("判断结果:$aiMessage");
    switch (aiMessage.toLowerCase()) {
      case "yes":
      case "yes.":
        return true;
      default:
        return false;
    }
  }
}
