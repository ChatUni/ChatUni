import 'package:app_links/app_links.dart';
import 'package:chatuni/router.dart';
import 'package:mobx/mobx.dart';

part 'app.g.dart';

class App = _App with _$App;

enum RouteGroup { tutor, course, meta, my }

final _appLinks = AppLinks();

abstract class _App with Store {
  @observable
  String title = '';

  @observable
  bool showMic = false;

  @observable
  RouteGroup routeGroup = RouteGroup.tutor;

  @action
  void setTitle(String value) {
    title = value;
  }

  @action
  void setShowMic(bool value) {
    showMic = value;
  }

  @action
  void setRouteGroup(RouteGroup value) {
    routeGroup = value;
  }

  _App() {
    _initAppListeners();
  }

  void _initAppListeners() {
    _appLinks.uriLinkStream.listen((uri) {
      if (uri.path.contains('/payment')) {
        router.go('/membership');
        // raiseEvent(onPaymentRedirectEvent, uri);
      }
    });
  }
}
