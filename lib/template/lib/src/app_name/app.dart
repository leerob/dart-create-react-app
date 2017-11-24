import 'package:over_react/over_react.dart';

@Factory()
UiFactory<AppProps> App;

@Props()
class AppProps extends UiProps {}

@Component()
class AppComponent extends UiComponent<AppProps> {
  @override
  render() {
    return (Dom.div()..className = 'App')(
      (Dom.header()..className = 'App-header')(
        (Dom.img()
          ..className = 'App-logo'
          ..src = 'logo.svg'
          ..alt = 'logo')(),
        (Dom.h1()..className = 'App-title')('Welcome to React'),
      ),
      (Dom.p()..className = 'App-intro')(
        'To get started, edit ',
        Dom.code()('lib/src/app_name/app.dart'),
        ', save, and reload.',
      ),
    );
  }
}
