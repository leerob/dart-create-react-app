import 'dart:io';

import 'package:test/test.dart';

import 'package:dart_create_react_app/dart_create_react_app.dart';

void main() {
  group('DartCreateReactApp', () {
    LoggerMock logger;
    DartCreateReactApp app;
    Directory dir;

    setUp(() {
      logger = new LoggerMock();
      app = new DartCreateReactApp(logger);
      dir = new Directory('lib/template/');
    });

    void _expectOk([_]) {
      expect(logger.getStderr(), isEmpty);
      expect(logger.getStdout(), isNot(isEmpty));
    }

    void _expectError([_]) {
      expect(logger.getStderr(), isNot(isEmpty));
      expect(logger.getStdout(), isEmpty);
    }

    test('no arguments passed', () {
      return app.run([], dir).catchError((e) {
        _expectError();
        expect(e is ArgumentError, true);
        expect(e.message, contains('No application name provided.'));
      });
    });

    test('invalid application name', () {
      return app.run(['bad-name'], dir).catchError((e) {
        _expectError();
        expect(e is ArgumentError, true);
        expect(e.message, contains('Invalid application name.'));
      });
    });

    test('copies template files successfully', () {
      Directory newDir = new Directory('my_app');
      return app.run(['my_app'], dir).then((_) {
        _expectOk();
        expect(newDir.existsSync(), true);
        newDir.deleteSync(recursive: true);
      }).catchError((e) {
        print('Errored out');
        print(Directory.current.path);
        print(dir.path);
        print(newDir.path);
      });
    });
  });
}

class LoggerMock implements Logger {
  final StringBuffer _stdout = new StringBuffer();
  final StringBuffer _stderr = new StringBuffer();

  @override
  void stderr(String message, {String textColor}) => _stderr.write(message);

  @override
  void stdout(String message, {String textColor}) => _stdout.write(message);

  String getStdout() => _stdout.toString();
  String getStderr() => _stderr.toString();
}