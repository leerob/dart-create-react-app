# Dart Create React App
[![Pub](https://img.shields.io/pub/v/dart_create_react_app.svg)](https://pub.dartlang.org/packages/dart_create_react_app)
[![Build Status](https://travis-ci.org/leerob/dart-create-react-app.svg)](https://travis-ci.org/leerob/dart-create-react-app)
[![Strong Mode Compliant](https://img.shields.io/badge/strong_mode-on-brightgreen.svg)](https://github.com/leerob/dart-create-react-app/blob/master/analysis_options.yaml#L2)

Create Dart + React apps with no build configuration.

* [Getting Started](#getting-started) – How to create a new app.
* [Todo List Example](https://github.com/leerob/dart-react-todo) – How to develop an app bootstrapped with Dart Create React App.

## Quick Overview

```sh
pub global activate dart_create_react_app
export PATH=$PATH:~/.pub-cache/bin

dart-create-react-app my_app
cd my_app/
pub serve
```

Then open [http://localhost:8080/](http://localhost:8080/) to see your app.

When you’re ready to deploy to production, create a minified bundle with `pub build`.

<img src='https://i.imgur.com/abWXNKu.gif' width='600' alt='dart-create-react-app'>

### Get Started Immediately

You **don’t** need to install or configure any extra tooling. They are preconfigured so that you can focus on the code.

Just create a project, and you’re good to go.

## Getting Started

### Installation

If you don't already have Dart installed, you can install using Homebrew on macOS.

```sh
$ brew tap dart-lang/dart
$ brew install dart --with-content-shell --with-dartium
```

Then, you can install dart-create-react-app globally.

```sh
pub global activate dart_create_react_app
export PATH=$PATH:~/.pub-cache/bin
```


### Creating an App

To create a new app, run:

```sh
dart-create-react-app my_app
cd my_app/
```

It will create a directory called `my_app` inside the current folder.

Inside that directory, it will generate the initial project structure and install the transitive dependencies:

```
my_app/
├── lib/
│   └── src/
│   |   └── my_app 
│   |   |    └── app.dart
│   └── my_app.dart
├── tool/
├── test/
│   └── unit/
│   |   └── my_app 
│   |   |    └── my_app_test.dart
├── web/
│   └── main.dart
│   └── index.css
│   └── index.html
│   └── logo.svg
├── .gitignore
├── pubspec.lock
├── pubspec.yaml
└── README.md
```

No configuration or complicated folder structures, just the files you need to build your app. Once the installation is done, you can run some commands inside the project folder:

### `pub serve`

Runs the app in development mode.

Open [http://localhost:8080](http://localhost:8080) to view it in the browser.


### `pub run dart_dev test`

Runs all tests located in the `/test` folder.


### `pub build`

Builds the app for production to the `build` folder.

It correctly bundles React in production mode and optimizes the build for the best performance.
