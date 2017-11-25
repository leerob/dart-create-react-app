library dart_create_react_app;

import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:colorize/colorize.dart';
import 'package:path/path.dart' as path;

/// Dart Create React App allows you to easily set up React apps with Dart.
///
/// It is a simple command-line application that takes in an app
/// name and creates a new directory containing the same template as 
/// the original create-react-app module created by Facebook.
/// 
/// See: https://github.com/facebookincubator/create-react-app
/// 
/// Unlike JavaScript, Dart comes with all the tooling you need to get 
/// up and running fast. For that reason, there is no "eject" like the JS 
/// version.
/// 
/// To use the application, run:
///
/// ```sh
/// $ dart_create_react_app my_app
/// ```
class DartCreateReactApp {
  List<String> args;
  Directory dir;
  String appName;
  final String appPath = path.current;
  final Logger logger;

  /// Instantiate a new instance of this CLI application.
  DartCreateReactApp(this.logger);

  /// Run the application with the given [args] in the working directory [dir].
  /// 
  /// If any of the subsequent functions called by `run()` fail, it will either
  /// throw an error or log errors to stderr. Otherwise, the successful run
  /// will be passed to stdout.
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

  /// Check if the correct arguments were passed from the command line.
  /// 
  /// Only one argument is required, which is the new application's name. 
  /// If any other arguments are passed, or the user asks for help, 
  /// display the usage message.
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

  /// Check for a valid application name for the `pubspec.yaml`.
  /// 
  /// A valid name must be all lowercase and use underscores to separate words.
  /// It also can't start with digits or be a reserved word.
  void checkForValidName() {
    final String nonNumericStart = r'^(?![0-9])';
    final String alphaNumericLower = r'^[a-z0-9_]*$';
    final RegExp exp = new RegExp('($nonNumericStart)($alphaNumericLower)');

    if (!exp.hasMatch(appName)) {
      logger.stderr('');
      logger.stderr('Error! The app name is formatted incorrectly.', textColor: Styles.RED);
      logger.stderr('');
      logger.stderr('The name should be all lowercase with underscores to separate words, just_like_this.');
      logger.stderr('Use only basic Latin letters and Arabic digits: [a-z0-9_].');
      logger.stderr('Make sure it doesn’t start with digits and isn’t a reserved word.');
      throw new ArgumentError('Invalid application name.');
    }
  }

  /// Display a message to the user that the run has started.
  void displayStartMessage() {
    Colorize currentPath = new Colorize(appPath);
    logger.stdout('');
    logger.stdout('Creating a new React app in ${currentPath.green()}.');
    logger.stdout('');
    logger.stdout('Installing packages. This might take a couple of minutes.');
  }

  /// Copy the sample React application from `lib/template` into a new folder for appName.
  /// 
  /// A completed React app has been placed in the template folder. This function will 
  /// copy the contents of that directory over to a new folder defined by the appName.
  /// Any instances of `app_name` in files or paths will be replaced with the 
  /// given appName.
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

  /// Start a process to run `pub get` in the newly created project folder.
  /// 
  /// This will retrieve all the dependencies for the generated project so that
  /// you can `cd` into the new directory and run `pub serve` to get started.
  Future runPubGet() async {
    final String directory = '$appPath/$appName';
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

  /// Display a message to the user that the run has ended.
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