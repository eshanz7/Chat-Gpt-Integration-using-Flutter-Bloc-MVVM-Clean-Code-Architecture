import 'package:chatgptintegrationexample/bloc/chatgpt/chatgpt_bloc.dart';
import 'package:chatgptintegrationexample/bloc/chatgpt/chatgpt_event.dart';
import 'package:chatgptintegrationexample/bloc/chatgpt/chatgpt_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OutputScreen extends StatefulWidget {
  String prompt;

  OutputScreen(this.prompt);

  @override
  State<OutputScreen> createState() => _OutputScreenState();
}

class _OutputScreenState extends State<OutputScreen> {
  late ChatGptBloc _chatGptBloc;

  @override
  void initState() {
    _chatGptBloc = BlocProvider.of(context);
    _chatGptBloc.add(ChatGptAnsFetchEvent(prompt: widget.prompt));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        backgroundColor: Colors.orange,
        title: Text(
          "Answer",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ChatGptBloc, ChatGptState>(
        builder: (context, state) {
          if (state is ChatGptAnsInitial) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.orange,
            ));
          } else if (state is ChatGptDataLoaded) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Answer :",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 22),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      state.data,
                      maxLines: null,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ChatGptDataError) {
            return Text("Some Error");
          } else {
            return Text("Some Error Occured");
          }
        },
        listener: (context, state) {},
      ),
    );
  }
}
