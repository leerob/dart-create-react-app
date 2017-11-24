import "package:test/test.dart";

import 'package:dart_create_react_app/dart_create_react_app.dart';

void main() {
  test('no arguments passed', () {
    List<String> args = [];
    DartCreateReactApp app = new DartCreateReactApp(args);

    return app.run().then((_) {
      fail('should have thrown');
    }).catchError((e) {
      expect(e is ArgumentError, true);
      expect(e.message, contains('No application name provided.'));
    });
  });
}