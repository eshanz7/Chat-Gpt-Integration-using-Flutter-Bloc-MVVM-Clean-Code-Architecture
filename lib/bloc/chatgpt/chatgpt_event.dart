

abstract class ChatGptEvent {}

class ChatGptAnsFetchEvent extends ChatGptEvent {
  String? prompt;
  ChatGptAnsFetchEvent({this.prompt});
}
