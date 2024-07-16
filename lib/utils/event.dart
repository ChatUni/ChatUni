import 'dart:async';

final Map<String, StreamController> controllers = {};

void registerEvent<T>(String name) {
  if (!controllers.containsKey(name)) {
    controllers[name] = StreamController<T>.broadcast();
  }
}

void raiseEvent<T>(String name, T data) {
  if (!controllers.containsKey(name)) registerEvent(name);

  controllers[name]!.add(data);
}

void disposeEvent(String name) {
  if (controllers.containsKey(name)) {
    controllers[name]!.close();
    controllers.remove(name);
  }
}

void listenToEvent<T>(String name, void Function(T) callBack) {
  if (!controllers.containsKey(name)) registerEvent(name);

  controllers[name]!.stream.listen((data) => callBack(data));
}
