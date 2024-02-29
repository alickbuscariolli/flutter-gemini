import 'package:flutter/material.dart';
import 'package:geminii_test/app_config.dart';
import 'package:geminii_test/controllers/gemini_controller.dart';
import 'package:geminii_test/models/message_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiScreen extends StatefulWidget {
  const GeminiScreen({super.key});

  @override
  State<GeminiScreen> createState() => _GeminiScreenState();
}

class _GeminiScreenState extends State<GeminiScreen> {
  final textTEC = TextEditingController();
  late final GeminiController _controller;

  @override
  void initState() {
    _controller = GeminiController(
      GenerativeModel(model: 'gemini-pro', apiKey: AppConfig.geminiApiKey),
    )..startChat();
    super.initState();
  }

  void _onSendMessage() {
    if (textTEC.text.isNotEmpty) {
      _controller.onSendMessage(textTEC.text);
      textTEC.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: _controller.isLoading,
          builder: (_, bool isLoading, __) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _controller.messages.length,
                    itemBuilder: (_, int index) {
                      final message = _controller.messages[index];

                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: message.who == WhoEnum.me
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.sizeOf(context).width / 2,
                                margin: const EdgeInsets.all(16),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: switch (message.who) {
                                    WhoEnum.bot => Colors.blueGrey,
                                    WhoEnum.me =>
                                      const Color.fromARGB(255, 6, 33, 6),
                                  },
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  message.message,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (isLoading &&
                              index == _controller.messages.length - 1) ...[
                            const SizedBox(height: 12),
                            const CircularProgressIndicator()
                          ]
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            controller: textTEC),
                      ),
                      IconButton(
                        onPressed: _onSendMessage,
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
