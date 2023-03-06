import 'dart:convert';

import 'package:test/test.dart';

import 'classes/config.dart';

void main() {
  run();
}

void run() {
  group('Json', () {
    final encoder = JsonEncoder.withIndent('   ').convert;
    group('Scalars', () {
      test('String', () {
        final c = Config('prop', 'value');
        final json = c.toJson();
        expect(json, equals(encoder({'prop': 'value'})));
      });

      test('String starting with -', () {
        final c = Config('prop', '- not a list');
        final json = c.toJson();
        expect(json, equals(encoder({'prop': '- not a list'})));
      });

      test('String with #', () {
        final c = Config('prop', 'string with a # character');
        final json = c.toJson();
        expect(json, equals(encoder({'prop': 'string with a # character'})));
      });

      test('String with \'', () {
        final c = Config('prop', 'string with a \' character');
        final json = c.toJson();
        expect(json, equals(encoder({'prop': 'string with a \' character'})));
      });

      test('String with "', () {
        final c = Config('prop', 'string with a " character');
        final json = c.toJson();
        expect(json, equals(encoder({'prop': 'string with a " character'})));
      });

      test('String with \\', () {
        final c = Config('prop', 'string with a \\ character');
        final json = c.toJson();
        expect(json, equals(encoder({'prop': 'string with a \\ character'})));
      });

      test('String with \\ and "', () {
        final c = Config('prop', 'string with \\ and " characters');
        final json = c.toJson();
        expect(
            json, equals(encoder({'prop': 'string with \\ and " characters'})));
      });

      test('int', () {
        final c = Config('prop', 1);
        final json = c.toJson();
        expect(json, equals(encoder({'prop': 1})));
      });

      test('double', () {
        final c = Config('prop', 1.2);
        final json = c.toJson();
        expect(json, equals(encoder({'prop': 1.2})));
      });

      test('bool', () {
        var c = Config('prop', true);
        var json = c.toJson();
        expect(json, equals(encoder({'prop': true})));

        c = Config('prop', false);
        json = c.toJson();
        expect(json, equals(encoder({'prop': false})));
      });
    });

    group('Lists', () {
      test('Strings', () {
        final c = Config('prop', ['val 1', 'val 2', 'val 3']);
        final json = c.toJson();
        expect(
            json,
            equals(encoder({
              'prop': ['val 1', 'val 2', 'val 3']
            })));
      });

      test('Strings starting with -', () {
        final c = Config('prop', ['val 1', '-val 2']);
        final json = c.toJson();
        expect(
            json,
            equals(encoder({
              'prop': ['val 1', '-val 2']
            })));
      });

      test('Strings with #', () {
        final c = Config('prop', ['val #1', 'val #2']);
        final json = c.toJson();
        expect(
            json,
            equals(encoder({
              'prop': ['val #1', 'val #2']
            })));
      });

      test('Strings with \'', () {
        final c = Config('prop', ['val \'a\'', 'val \'b\'']);
        final json = c.toJson();
        expect(
            json,
            equals(encoder({
              'prop': ['val \'a\'', 'val \'b\'']
            })));
      });

      test('String with "', () {
        final c = Config('prop', ['val "a"', 'val "b"']);
        final json = c.toJson();
        expect(
            json,
            equals(encoder({
              'prop': ['val "a"', 'val "b"']
            })));
      });

      test('int', () {
        final c = Config('prop', [2, 3, 5, 7]);
        final json = c.toJson();
        expect(
            json,
            equals(encoder({
              'prop': [2, 3, 5, 7]
            })));
      });

      test('double', () {
        final c = Config('prop', [1.2, 3.4]);
        final json = c.toJson();
        expect(
            json,
            equals(encoder({
              'prop': [1.2, 3.4]
            })));
      });

      test('bool', () {
        final c = Config('prop', [true, false]);
        final json = c.toJson();
        expect(
            json,
            equals(encoder({
              'prop': [true, false]
            })));
      });
    });

    group('Maps', () {
      test('Strings', () {
        final c = Config('prop', {'a': 'val 1', 'b': 'val 2', 'c': 'val 3'});
        final json = c.toJson();
        expect(
            json,
            equals(encoder({
              'prop': {'a': 'val 1', 'b': 'val 2', 'c': 'val 3'}
            })));
      });

      test('Strings starting with -', () {
        final c = Config('prop', {'a': 'val 1', 'b': '-val 2'});
        final json = c.toJson();
        expect(
            json,
            equals(encoder({
              'prop': {'a': 'val 1', 'b': '-val 2'}
            })));
      });

      test('Strings with #', () {
        final c = Config('prop', {'a': 'val #1', 'b': 'val #2'});
        final json = c.toJson();
        expect(
            json,
            equals(encoder({
              'prop': {'a': 'val #1', 'b': 'val #2'}
            })));
      });

      test('Strings with \'', () {
        final c = Config('prop', {'a': 'val \'a\'', 'b': 'val \'b\''});
        final json = c.toJson();
        expect(
            json,
            equals(encoder({
              'prop': {'a': 'val \'a\'', 'b': 'val \'b\''}
            })));
      });

      test('String with "', () {
        final c = Config('prop', {'a': 'val "a"', 'b': 'val "b"'});
        final json = c.toJson();
        expect(
            json,
            equals(encoder({
              'prop': {'a': 'val "a"', 'b': 'val "b"'}
            })));
      });

      test('int', () {
        final c = Config('prop', {'a': 2, 'b': 3, 'c': 5});
        final json = c.toJson();
        expect(
            json,
            equals(encoder({
              'prop': {'a': 2, 'b': 3, 'c': 5}
            })));
      });

      test('double', () {
        final c = Config('prop', {'a': 1.2, 'b': 3.4});
        final json = c.toJson();
        expect(
            json,
            equals(encoder({
              'prop': {'a': 1.2, 'b': 3.4}
            })));
      });

      test('bool', () {
        final c = Config('prop', {'ok': true, 'ko': false});
        final json = c.toJson();
        expect(
            json,
            equals(encoder({
              'prop': {'ok': true, 'ko': false}
            })));
      });
    });

    test('Nested', () {
      final c = Config('root', {
        'timeout': 20,
        'paths': [
          Config('/a/b', '/bin'),
          Config('/c', '/.conf'),
        ],
      });
      final json = c.toJson();
      expect(
          json,
          equals(encoder({
            'root': {
              'timeout': 20,
              'paths': [
                {'/a/b': '/bin'},
                {'/c': '/.conf'},
              ],
            }
          })));
    });
  });

  group('Yaml', () {
    group('Scalars', () {
      test('String', () {
        final c = Config('prop', 'value');
        final yaml = c.toYaml();
        expect(yaml, equals('prop: value'));
      });

      test('String starting with -', () {
        final c = Config('prop', '- not a list');
        final yaml = c.toYaml();
        expect(yaml, equals('prop: \'- not a list\''));
      });

      test('String with #', () {
        final c = Config('prop', 'string with a # character');
        final yaml = c.toYaml();
        expect(yaml, equals('prop: \'string with a # character\''));
      });

      test('String with \'', () {
        final c = Config('prop', 'string with a \' character');
        final yaml = c.toYaml();
        expect(yaml, equals('prop: \'string with a \'\' character\''));
      });

      test('String with "', () {
        final c = Config('prop', 'string with a " character');
        final yaml = c.toYaml();
        expect(yaml, equals('prop: "string with a \\" character"'));
      });

      test('String with \\', () {
        final c = Config('prop', 'string with a \\ character');
        final yaml = c.toYaml();
        expect(yaml, equals('prop: "string with a \\\\ character"'));
      });

      test('String with \\ and "', () {
        final c = Config('prop', 'string with \\ and " characters');
        final yaml = c.toYaml();
        expect(yaml, equals('prop: "string with \\\\ and \\" characters"'));
      });

      test('int', () {
        final c = Config('prop', 1);
        final yaml = c.toYaml();
        expect(yaml, equals('prop: 1'));
      });

      test('double', () {
        final c = Config('prop', 1.2);
        final yaml = c.toYaml();
        expect(yaml, equals('prop: 1.2'));
      });

      test('bool', () {
        var c = Config('prop', true);
        var yaml = c.toYaml();
        expect(yaml, equals('prop: true'));

        c = Config('prop', false);
        yaml = c.toYaml();
        expect(yaml, equals('prop: false'));
      });
    });

    group('Lists', () {
      test('Strings', () {
        final c = Config('prop', ['val 1', 'val 2', 'val 3']);
        final yaml = c.toYaml();
        expect(yaml, equals('prop:\n  - val 1\n  - val 2\n  - val 3'));
      });

      test('Strings starting with -', () {
        final c = Config('prop', ['val 1', '-val 2']);
        final yaml = c.toYaml();
        expect(yaml, equals('prop:\n  - val 1\n  - \'-val 2\''));
      });

      test('Strings with #', () {
        final c = Config('prop', ['val #1', 'val #2']);
        final yaml = c.toYaml();
        expect(yaml, equals('prop:\n  - \'val #1\'\n  - \'val #2\''));
      });

      test('Strings with \'', () {
        final c = Config('prop', ['val \'a\'', 'val \'b\'']);
        final yaml = c.toYaml();
        expect(yaml,
            equals('prop:\n  - \'val \'\'a\'\'\'\n  - \'val \'\'b\'\'\''));
      });

      test('String with "', () {
        final c = Config('prop', ['val "a"', 'val "b"']);
        final yaml = c.toYaml();
        expect(yaml, equals('prop:\n  - "val \\"a\\""\n  - "val \\"b\\""'));
      });

      test('int', () {
        final c = Config('prop', [2, 3, 5, 7]);
        final yaml = c.toYaml();
        expect(yaml, equals('prop:\n  - 2\n  - 3\n  - 5\n  - 7'));
      });

      test('double', () {
        final c = Config('prop', [1.2, 3.4]);
        final yaml = c.toYaml();
        expect(yaml, equals('prop:\n  - 1.2\n  - 3.4'));
      });

      test('bool', () {
        final c = Config('prop', [true, false]);
        final yaml = c.toYaml();
        expect(yaml, equals('prop:\n  - true\n  - false'));
      });
    });

    group('Maps', () {
      test('Strings', () {
        final c = Config('prop', {'a': 'val 1', 'b': 'val 2', 'c': 'val 3'});
        final yaml = c.toYaml();
        expect(yaml, equals('prop:\n  a: val 1\n  b: val 2\n  c: val 3'));
      });

      test('Strings starting with -', () {
        final c = Config('prop', {'a': 'val 1', 'b': '-val 2'});
        final yaml = c.toYaml();
        expect(yaml, equals('prop:\n  a: val 1\n  b: \'-val 2\''));
      });

      test('Strings with #', () {
        final c = Config('prop', {'a': 'val #1', 'b': 'val #2'});
        final yaml = c.toYaml();
        expect(yaml, equals('prop:\n  a: \'val #1\'\n  b: \'val #2\''));
      });

      test('Strings with \'', () {
        final c = Config('prop', {'a': 'val \'a\'', 'b': 'val \'b\''});
        final yaml = c.toYaml();
        expect(yaml,
            equals('prop:\n  a: \'val \'\'a\'\'\'\n  b: \'val \'\'b\'\'\''));
      });

      test('String with "', () {
        final c = Config('prop', {'a': 'val "a"', 'b': 'val "b"'});
        final yaml = c.toYaml();
        expect(yaml, equals('prop:\n  a: "val \\"a\\""\n  b: "val \\"b\\""'));
      });

      test('int', () {
        final c = Config('prop', {'a': 2, 'b': 3, 'c': 5});
        final yaml = c.toYaml();
        expect(yaml, equals('prop:\n  a: 2\n  b: 3\n  c: 5'));
      });

      test('double', () {
        final c = Config('prop', {'a': 1.2, 'b': 3.4});
        final yaml = c.toYaml();
        expect(yaml, equals('prop:\n  a: 1.2\n  b: 3.4'));
      });

      test('bool', () {
        final c = Config('prop', {'ok': true, 'ko': false});
        final yaml = c.toYaml();
        expect(yaml, equals('prop:\n  ok: true\n  ko: false'));
      });
    });

    test('Nested', () {
      var c = Config('root', {
        'timeout': 20,
        'clean': true,
        'paths': [
          Config('/a/b', '/bin'),
          Config('/c', '/.conf'),
          Config('/t', '/tmp'),
        ],
      });
      var yaml = c.toYaml();
      expect(yaml, equals('''root:
  timeout: 20
  clean: true
  paths:
    - /a/b: /bin
    - /c: /.conf
    - /t: /tmp'''));

      final timeout = Config('timeout', 20);
      final clean = Config('clean', true);
      final paths = Config('paths', [
        {'/a/b': '/bin', '/c': '/.conf'},
        {'/t': '/tmp'}
      ]);
      c = Config('root', [
        timeout,
        clean,
        paths,
      ]);
      yaml = c.toYaml();
      expect(yaml, equals('''root:
  - timeout: 20
  - clean: true
  - paths:
      - /a/b: /bin
        /c: /.conf
      - /t: /tmp'''));
    });
  });
}
