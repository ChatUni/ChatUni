import 'package:app_links/app_links.dart';
import 'package:chatuni/api/cd.dart';
import 'package:chatuni/router.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

import '/globals.dart' as globals;

part 'app.g.dart';

class App = _App with _$App;

enum RouteGroup { tutor, exam, course, resource, my }

final _appLinks = AppLinks();
const _uuid = Uuid();

final sessionId = _uuid.v4();

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
    _getCDVer();
  }

  void _initAppListeners() {
    _appLinks.uriLinkStream.listen((uri) {
      if (uri.path.contains('/payment')) {
        router.go('/membership');
        // raiseEvent(onPaymentRedirectEvent, uri);
      }
    });
  }

  Future<void> _getCDVer() async {
    globals.cdVer = await cdVersion();
  }
}
