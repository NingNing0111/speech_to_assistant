import 'package:flutter/material.dart';
import 'package:speech_to_assistant/page/home.dart';

class BaseLayout extends StatefulWidget {
  const BaseLayout({super.key});
  @override
  State<StatefulWidget> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Speech To Assistant"),
        centerTitle: true,
        leading: const Icon(Icons.menu),
        backgroundColor: Colors.deepOrange,
      ),
      body: const HomePage(),
    );
  }

}