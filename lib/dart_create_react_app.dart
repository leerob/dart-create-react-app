library dart_create_react_app;

import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:colorize/colorize.dart';
import 'package:path/path.dart' as path;

class DartCreateReactApp {
  List<String> args;
  Directory dir;
  String appName;
  String appPath = path.current;
  final Logger logger;

  DartCreateReactApp(this.logger);

  Future run(List<String> args, Directory dir) async {
    this.args = args;
    this.dir = dir;
    checkForValidUsage();
    checkForValidName();
    displayStartMessage();
    await copyTemplateFiles();
    await runPubGet();
    displayEndMessage();
  }

  void checkForValidUsage() {
    if (args.length != 1 || args.single == '-h' || args.single == '--help') {
      logger.stderr('');
      logger.stderr('Dart Create React App', textColor: Styles.LIGHT_CYAN);
      logger.stderr('');
      logger.stderr('Usage: dart_create_react_app <app_name>');
      logger.stderr('');
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
      logger.stderr('');
      logger.stderr('Error! The app name is formatted incorrectly.', textColor: Styles.RED);
      logger.stderr('');
      logger.stderr('The name should be all lowercase, with underscores to separate words, just_like_this.');
      logger.stderr('Use only basic Latin letters and Arabic digits: [a-z0-9_].');
      logger.stderr('Make sure it doesn’t start with digits and isn’t a reserved word.');
      throw new ArgumentError('Invalid application name.');
    }
  }

  void displayStartMessage() {
    Colorize currentPath = new Colorize(appPath);
    logger.stdout('');
    logger.stdout('Creating a new React app in ${currentPath.green()}.');
    logger.stdout('');
    logger.stdout('Installing packages. This might take a couple of minutes.');
  }

  Future copyTemplateFiles() async {
    await for (var file in dir.list(recursive: true, followLinks: false)) {
      if (file.path.contains('.pub') ||
          file.path.contains('.packages') ||
          file.path.contains('pubspec.lock') ||
          file.path.contains('.DS_Store')) {
        continue;
      }

      String filePath = file.uri.toFilePath();
      if (filePath.contains('template')) {
        filePath = filePath.substring(filePath.indexOf('template') + 'template'.length);
      }

      String newPath = filePath.replaceAll('app_name', appName);
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
        logger.stdout(data);
      }, onDone: _outc.complete);
      process.stderr
          .transform(UTF8.decoder)
          .transform(new LineSplitter())
          .listen((data) {
        logger.stderr(data);
      }, onDone: _errc.complete);
      Future.wait([_outc.future, _errc.future]).then((_) => _donec.complete());
    });

    await _donec.future;
  }

  void displayEndMessage() {
    logger.stdout('');
    logger.stdout('Success! Created $appName at $appPath');
    logger.stdout('Inside that directory, you can run several commands:');
    logger.stdout('');
    logger.stdout('  pub serve', textColor: Styles.LIGHT_CYAN);
    logger.stdout('    Starts the development server.');
    logger.stdout('');
    logger.stdout('  pub build', textColor: Styles.LIGHT_CYAN);
    logger.stdout('    Bundles the app into static files for production.');
    logger.stdout('');
    logger.stdout('  pub run dart_dev test', textColor: Styles.LIGHT_CYAN);
    logger.stdout('    Starts the test runner.');
    logger.stdout('');
    logger.stdout('  pub run dart_dev format', textColor: Styles.LIGHT_CYAN);
    logger.stdout('    Formats the entire codebase.');
    logger.stdout('');
    logger.stdout('We suggest that you begin by typing:');
    logger.stdout('');
    logger.stdout('  cd $appName');
    logger.stdout('  pub serve', textColor: Styles.LIGHT_CYAN);
    logger.stdout('');
    logger.stdout('Happy hacking!');
  }
}

class Logger {
  void stdout(String message, {String textColor}) {
    if (textColor != null) {
      color(message, front: textColor);
    } else {
      print(message);
    }
  }
  void stderr(String message, {String textColor}) {
    if (textColor != null) {
      color(message, front: textColor);
    } else {
      print(message);
    }
  }
}