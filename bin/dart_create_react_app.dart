import 'dart:io';

import 'package:dart_create_react_app/dart_create_react_app.dart';

void main(List<String> args) {
  String filePath = Platform.script.toFilePath();
  filePath = filePath.replaceFirst('bin/dart_create_react_app.dart', 'lib/template');
  Directory templateDir = new Directory(filePath);

  DartCreateReactApp app = new DartCreateReactApp(new Logger());
  app.run(args, templateDir).catchError((Object e, StackTrace st) {
    if (e is ArgumentError) {
      // These errors are expected.
      exit(1);
    } else {
      print('Unexpected error: $e\n$st');
      exit(1);
    }
  });
}