import 'package:mobx/mobx.dart';

part 'app.g.dart';

class App = _App with _$App;

enum RouteGroup { tutor, course, meta, my }

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
}
