# Speech To Assistant

&emsp;基于OpenAI实现的AI应用，支持语音对话和语音绘图。目前该项目只作为demo。

## 实现原理

&emsp;使用[flutter_tts](https://pub.dev/packages/flutter_tts)和[speech_to_text](https://pub.dev/packages/speech_to_text)实现语音和文本的互转。

&emsp;如何判断是对话还是绘图？

&emsp;让AI自行判断，详情见:[openai_service.dart](https://github.com/NingNing0111/speech_to_assistant/blob/master/lib/service/openai_service.dart)

