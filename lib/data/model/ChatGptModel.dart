import 'dart:convert';

class ChatGptModel {
  final String? prompt;
  final String model;
  final double temperature;
  final double topP;
  final int n;
  final bool stream;
  final int maxTokens;

  ChatGptModel({
    required this.model,
    this.temperature = 0.9,
    this.topP = 1,
    this.n = 1,
    this.stream = true,
    this.maxTokens = 2048,
    this.prompt,
  });

  ChatGptModel copyWith({
    String? prompt,
    String? model,
    double? temperature,
    double? topP,
    int? n,
    bool? stream,
    int? maxTokens,
  }) {
    return ChatGptModel(
      prompt: prompt ?? this.prompt,
      model: model ?? this.model,
      temperature: temperature ?? this.temperature,
      topP: topP ?? this.topP,
      n: n ?? this.n,
      stream: stream ?? this.stream,
      maxTokens: maxTokens ?? this.maxTokens,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'prompt': prompt,
      'model': model,
      "max_tokens": maxTokens,
      'temperature': temperature,
      'top_p': topP,
      'n': n,
      'stream': stream,
    };
  }

  String toJson() => json.encode(toMap());
}
