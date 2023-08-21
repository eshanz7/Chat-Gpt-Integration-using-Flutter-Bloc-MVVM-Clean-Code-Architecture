import 'package:chatgptintegrationexample/ui/input_screen/input_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Chat Gpt Test', (WidgetTester tester) async {
    await tester.pumpWidget(createMainWidget());
    tester.printToConsole('Input Screen opens');
    await tester.pumpAndSettle(const Duration(seconds: 3));

    await addDelay(1000);
    await tester.enterText(find.byKey(Key('enter_text')), "What is Flutter");
    hideKeyBoard();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    await addDelay(3000);
    await tester.tap(find.byKey(Key('submit')));
    await tester.pumpAndSettle(const Duration(seconds: 3));

  });
}

Widget createMainWidget() {
  return MaterialApp(debugShowCheckedModeBanner: false, home: InputScreen());
}

Future<void> addDelay(int ms) async {
  await Future<void>.delayed(Duration(milliseconds: ms));
}

hideKeyBoard() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}
