import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:developer';

import 'package:chatgptintegrationexample/data/remote/api_endPoints.dart';
import 'package:chatgptintegrationexample/repository/chatgpt_repo.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../data/model/ChatGptModel.dart';
import '../data/remote/DecoderQueueService.dart';
import '../data/remote/base_api_service.dart';

class ChatGptImp extends ChatGptRepo {
  final String matchResultString = '"text":';
  final Dio _openAIClient = Dio(
    BaseOptions(
      baseUrl: BaseApiService.baseurl,
    ),
  );

  Map<String, String> _getHeaders(String apiKey) {
    return {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json; charset=UTF-8',
      'Connection': 'keep-alive',
      'Accept': '*/*',
      'Accept-Encoding': 'gzip, deflate, br',
    };
  }

  Options _getOptions(String apiKey, {ResponseType? responseType}) {
    return Options(
      validateStatus: (status) {
        return true;
      },
      headers: _getHeaders(apiKey),
      responseType: responseType,
    );
  }

  @override
  Future textCompletions(
    ChatGptModel params, {
    Function(String p1)? onStreamValue,
    Function(StreamSubscription? p1)? onStreamCreated,
    Duration debounce = Duration.zero,
  }) async {
    try {
      String responseText = '';

      final Response<ResponseBody> response = await _openAIClient.post(
        ApiEndPoints.textCompletion,
        data: params.toMap(),
        options: _getOptions(BaseApiService.apiKey,
            responseType: ResponseType.stream),
      );

      DecoderQueueService.instance.initialize();

      final StreamSubscription<Uint8List>? responseStream = response
          .data?.stream
          .asyncExpand((event) => Rx.timer(event, debounce))
          .doOnData((event) {})
          .listen(
        (bodyBytes) {
          DecoderQueueService.instance.addQueue(() {
            _handleListenBodyBytes(bodyBytes, response, (p0) {
              responseText += p0;
              onStreamValue?.call(responseText);
            });
          });
        },
      );

      onStreamCreated?.call(responseStream);

      await responseStream?.asFuture();
      responseStream?.cancel();
      return responseText;
    } catch (e) {
      rethrow;
    }
  }

  void _handleListenBodyBytes(
    Uint8List bodyBytes,
    Response response,
    Function(String) handleNewValue,
  ) {
    final String data = utf8.decode(bodyBytes, allowMalformed: false);
    if (data.contains(matchResultString)) {
      final List<String> dataSplit = data.split("[{");

      final int indexOfResult = dataSplit.indexWhere(
        (element) => element.contains(matchResultString),
      );

      final List<String> textSplit =
          indexOfResult == -1 ? [] : dataSplit[indexOfResult].split(",");

      final indexOfText = textSplit.indexWhere(
        (element) => element.contains(matchResultString),
      );

      if (indexOfText != -1) {
        try {
          final Map dataJson = jsonDecode('{${textSplit[indexOfText]}}');
          handleNewValue(dataJson['text'].toString());
        } on Exception catch (_, __) {
          return;
        }
      }
    } else {
      Map errorJson = {};
      try {
        errorJson = jsonDecode(data);
        // ignore: empty_catches
      } catch (error) {}

      if (errorJson['error'] != null) {
        throw Exception(
          "status code: ${response.statusCode}, error: ${errorJson['error']['message']}",
        );
      }
    }
  }
}
