import 'dart:html';

import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart' as react_client;

import 'package:app_name/app_name.dart';

void main() {
  react_client.setClientConfiguration();

  final container = querySelector('#root');
  react_dom.render(App()(), container);
}
