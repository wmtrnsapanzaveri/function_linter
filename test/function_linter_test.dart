import 'package:function_linter/function_linter.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    const awesome = FunctionLinterException();

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(awesome, isTrue);
    });
  });
}
