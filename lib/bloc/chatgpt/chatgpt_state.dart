

abstract class ChatGptState {}

class ChatGptAnsInitial extends ChatGptState {}

class ChatGptDataLoaded extends ChatGptState {
  late final String data;
  ChatGptDataLoaded(this.data);
}

class ChatGptDataError extends ChatGptState {}