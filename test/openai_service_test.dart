

import 'package:flutter_test/flutter_test.dart';
import 'package:speech_to_assistant/service/openai_service.dart';

void main() {
  group("OpenAI Service API 测试", () {
    OpenAIService aiService = OpenAIService();
    test("对话接口测试", () async {
      var res = await aiService.simpleChat("你好");
      print(res);
    });

    test("绘画接口测试", () async {
      var res = await aiService.image("a boy");
      print(res);
    });
  });
}