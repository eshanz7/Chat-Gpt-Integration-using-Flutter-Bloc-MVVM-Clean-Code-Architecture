

import 'dart:async';

import 'package:chatgptintegrationexample/bloc/chatgpt/chatgpt_event.dart';
import 'package:chatgptintegrationexample/bloc/chatgpt/chatgpt_state.dart';
import 'package:chatgptintegrationexample/data/model/ChatGptModel.dart';
import 'package:chatgptintegrationexample/repository/chatgpt_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/chatgpt_repo_imp.dart';

class ChatGptBloc extends Bloc<ChatGptEvent, ChatGptState> {
  final _chatgptRepo = ChatGptImp();

  ChatGptBloc() : super(ChatGptAnsInitial()) {
    on<ChatGptAnsFetchEvent>(_fetchAnswer);
  }

  FutureOr<void> _fetchAnswer(ChatGptAnsFetchEvent event, Emitter<ChatGptState> emit) async {
    emit(ChatGptAnsInitial());

    await _chatgptRepo
        .textCompletions(ChatGptModel(model:"text-davinci-003",prompt: event.prompt,stream: true),onStreamValue: (value){
      emit(ChatGptDataLoaded(value));
    })  .onError((error, stackTrace) => emit(ChatGptDataError()))
        .then((value) {
    });
  }
}
