import 'package:chatgpt_completions/chatgpt_completions.dart';
import 'package:chatgptintegrationexample/data/remote/base_api_service.dart';
import 'package:chatgptintegrationexample/ui/input_screen/input_screen.dart';
import 'package:flutter/material.dart';

void main() {
  ChatGPTCompletions.instance.initialize(apiKey:'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');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {


  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Gpt Sample App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  InputScreen(),
    );
  }
}