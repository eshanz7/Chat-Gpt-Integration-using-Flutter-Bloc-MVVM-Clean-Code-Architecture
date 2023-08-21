import 'package:chatgptintegrationexample/ui/output_screen/output_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/chatgpt/chatgpt_bloc.dart';

class InputScreen extends StatelessWidget {
  TextEditingController ctx = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange,
        leading: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        title: Text(
          "Ask Question",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: TextField(
              key: Key('enter_text'),
              minLines: 5,
              controller: ctx,
              maxLines: 10,
              decoration: InputDecoration(
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  filled: true,
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  hintStyle: TextStyle(fontSize: 16),
                  hintText: "Ask a question"),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width / 2,
            child: ElevatedButton(
              key: Key('submit'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange)),
              child: Text(
                'Submit',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                if (ctx.text.trim().isEmpty) {
                  var snackBar = SnackBar(
                      content: Text('Please enter soemthing in field'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BlocProvider<ChatGptBloc>.value(
                                value: ChatGptBloc(),
                                child: OutputScreen(ctx.text),
                              )));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
