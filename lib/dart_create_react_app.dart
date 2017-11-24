library dart_create_react_app;

import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:colorize/colorize.dart';
import 'package:path/path.dart' as path;

class DartCreateReactApp {
  List<String> args;
  int exitCode;

  String appName;
  String appPath = path.current;

  DartCreateReactApp(this.args);

  Future run() async {
    checkForValidUsage();
    checkForValidName();
    displayStartMessage();
    await copyTemplateFiles();
    await runPubGet();
    displayEndMessage();
  }

  void checkForValidUsage() {
    if (args.length != 1 || args.single == '-h' || args.single == '--help') {
      print('');
      color('Dart Create React App', front: Styles.LIGHT_CYAN);
      print('Easily create React apps with Dart!');
      print('');
      print('Usage: dart_create_react_app <app_name>');
      print('');

      throw new ArgumentError('No application name provided.');
    } else {
      appName = args.single;
    }
  }

  void checkForValidName() {
    final String nonNumericStart = r'^(?![0-9])';
    final String alphaNumericLower = r'^[a-z0-9_]*$';
    RegExp exp = new RegExp('($nonNumericStart)($alphaNumericLower)');

    if (!exp.hasMatch(appName)) {
      print('');
      color('Error! The app name is formatted incorrectly.', front: Styles.RED);
      print('');
      print('The name should be all lowercase, with underscores to separate words, just_like_this.');
      print('Use only basic Latin letters and Arabic digits: [a-z0-9_].');
      print('Make sure it doesn’t start with digits and isn’t a reserved word.');

      throw new ArgumentError();
    }
  }

  void displayStartMessage() {
    Colorize currentPath = new Colorize(appPath);
    print('');
    print('Creating a new React app in ${currentPath.green()}.');
    print('');
    print('Installing packages. This might take a couple of minutes.');
  }

  Future copyTemplateFiles() async {
    // Might need to remove / before lib here
    final String templatePath = '$appPath/$appName/lib/template';
    var templateDir = new Directory(templatePath).list(recursive: true, followLinks: false);
    await for (var file in templateDir) {
      if (file.path.contains('.pub') ||
          file.path.contains('.packages') ||
          file.path.contains('pubspec.lock') ||
          file.path.contains('.DS_Store')) {
        continue;
      }

      List<String> segments = file.uri.pathSegments.toList();
      segments.removeRange(0, 6);
      Uri newUri = file.uri.replace(scheme: "file", pathSegments: segments);
      String newPath = newUri.path.replaceAll('app_name', appName);

      if (newPath.endsWith('/')) {
        await new Directory('$appName$newPath').create(recursive: true);
      } else if (file is File) {
        var newFile = new File('$appName$newPath');
        String contents = await file.readAsString();
        contents = contents.replaceAll('app_name', appName);
        newFile.writeAsStringSync(contents);
      }
    }
  }

  Future runPubGet() async {
    String directory = '$appPath/$appName';
    Completer _outc = new Completer();
    Completer _errc = new Completer();
    Completer _donec = new Completer();

    await Process.start('pub', ['get'], workingDirectory: directory).then((Process process) {
      process.stdout
          .transform(UTF8.decoder)
          .transform(new LineSplitter())
          .listen((data) {
        print(data);
      }, onDone: _outc.complete);
      process.stderr
          .transform(UTF8.decoder)
          .transform(new LineSplitter())
          .listen((data) {
        print(data);
      }, onDone: _errc.complete);
      Future.wait([_outc.future, _errc.future]).then((_) => _donec.complete());
    });

    await _donec.future;
  }

  void displayEndMessage() {
    print('');
    print('Success! Created $appName at $appPath');
    print('Inside that directory, you can run several commands:');
    print('');
    color('  pub serve', front: Styles.LIGHT_CYAN);
    print('    Starts the development server.');
    print('');
    color('  pub build', front: Styles.LIGHT_CYAN);
    print('    Bundles the app into static files for production.');
    print('');
    color('  pub run dart_dev test', front: Styles.LIGHT_CYAN);
    print('    Starts the test runner.');
    print('');
    color('  pub run dart_dev format', front: Styles.LIGHT_CYAN);
    print('    Formats the entire codebase.');
    print('');
    print('We suggest that you begin by typing:');
    print('');
    print('  cd $appName');
    color('  pub serve', front: Styles.LIGHT_CYAN);
    print('');
    print('Happy hacking!');
  }
}