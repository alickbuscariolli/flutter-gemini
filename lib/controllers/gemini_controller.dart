import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geminii_test/models/message_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiController {
  final GenerativeModel _model;

  GeminiController(this._model);

  final isLoading = ValueNotifier(false);

  late final ChatSession _chat;

  final messages = <MessageModel>[];

  void startChat() {
    _chat = _model.startChat();
  }

  Future<void> onSendMessage(String prompt) async {
    isLoading.value = true;

    messages.add(MessageModel(message: prompt, who: WhoEnum.me));

    final botMessageResponse = await _chat.sendMessage(Content.text(prompt));

    if (botMessageResponse.text != null) {
      messages.add(MessageModel(
        message: botMessageResponse.text!,
        who: WhoEnum.bot,
      ));
    }

    isLoading.value = false;
  }
}
