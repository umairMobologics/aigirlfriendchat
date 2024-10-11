import 'package:flutter/material.dart';

class ChatAI extends StatelessWidget {
  const ChatAI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Chat"),
      ),
      body: const Center(
        child: Text("Chat AI..."),
      ),
    );
  }
}
