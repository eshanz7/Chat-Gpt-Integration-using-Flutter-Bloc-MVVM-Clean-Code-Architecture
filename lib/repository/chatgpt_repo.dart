import 'dart:async';

import '../data/model/ChatGptModel.dart';

abstract class ChatGptRepo {
  Future textCompletions(
    ChatGptModel params, {
    Function(String)? onStreamValue,
    Function(StreamSubscription?)? onStreamCreated,
    Duration debounce = Duration.zero,
  });
}
