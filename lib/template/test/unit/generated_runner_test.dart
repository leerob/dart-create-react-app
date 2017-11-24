@TestOn('browser')
library test.unit.generated_runner_test;

import 'package:test/test.dart';
import 'package:over_react/over_react.dart';

import './app_name/app_test.dart' as app_test;

void main() {
  setClientConfiguration();
  enableTestMode();

  app_test.main();
}
