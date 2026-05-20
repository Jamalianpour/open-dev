import 'package:flutter_test/flutter_test.dart';
import 'package:open_dev/utils/case_utils.dart';

void main() {
  group('CaseUtils', () {
    test('handles empty input', () {
      expect(CaseUtils.camel(''), '');
      expect(CaseUtils.pascal(''), '');
      expect(CaseUtils.snake(''), '');
      expect(CaseUtils.title(''), '');
      expect(CaseUtils.sentence(''), '');
    });

    test('tokenizer splits camelCase into words', () {
      expect(CaseUtils.snake('helloWorldFooBar'), 'hello_world_foo_bar');
    });

    test('tokenizer splits acronym + word boundaries', () {
      // HTTPRequest -> HTTP Request
      expect(CaseUtils.snake('HTTPRequest'), 'http_request');
      expect(CaseUtils.pascal('http_request'), 'HttpRequest');
    });

    test('camelCase output', () {
      expect(CaseUtils.camel('hello world foo'), 'helloWorldFoo');
      expect(CaseUtils.camel('HELLO_WORLD'), 'helloWorld');
    });

    test('PascalCase output', () {
      expect(CaseUtils.pascal('hello world'), 'HelloWorld');
      expect(CaseUtils.pascal('foo-bar-baz'), 'FooBarBaz');
    });

    test('snake_case and SCREAMING_SNAKE', () {
      expect(CaseUtils.snake('Hello World'), 'hello_world');
      expect(CaseUtils.screamingSnake('hello world'), 'HELLO_WORLD');
    });

    test('kebab-case and COBOL-CASE', () {
      expect(CaseUtils.kebab('Hello World'), 'hello-world');
      expect(CaseUtils.cobol('hello world'), 'HELLO-WORLD');
    });

    test('dot.case and path/case', () {
      expect(CaseUtils.dot('Hello World'), 'hello.world');
      expect(CaseUtils.path('Hello World'), 'hello/world');
    });

    test('Title Case and Sentence case', () {
      expect(CaseUtils.title('hello world foo'), 'Hello World Foo');
      expect(CaseUtils.sentence('hello world foo'), 'Hello world foo');
    });

    test('mixed input with separators', () {
      expect(CaseUtils.camel('hello-world_foo.bar/baz'),
          'helloWorldFooBarBaz');
    });
  });
}
