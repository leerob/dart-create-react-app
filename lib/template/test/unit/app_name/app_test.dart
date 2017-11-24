import 'package:over_react_test/over_react_test.dart';
import 'package:test/test.dart';

import 'package:app_name/src/app_name/app.dart';

main() {
  test('renders without crasing', () {
    var renderedInstance = render(App()());
    expect(renderedInstance, isNotNull);
  });
}
