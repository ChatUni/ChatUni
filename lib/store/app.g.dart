// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$App on _App, Store {
  late final _$titleAtom = Atom(name: '_App.title', context: context);

  @override
  String get title {
    _$titleAtom.reportRead();
    return super.title;
  }

  @override
  set title(String value) {
    _$titleAtom.reportWrite(value, super.title, () {
      super.title = value;
    });
  }

  late final _$showMicAtom = Atom(name: '_App.showMic', context: context);

  @override
  bool get showMic {
    _$showMicAtom.reportRead();
    return super.showMic;
  }

  @override
  set showMic(bool value) {
    _$showMicAtom.reportWrite(value, super.showMic, () {
      super.showMic = value;
    });
  }

  late final _$routeGroupAtom = Atom(name: '_App.routeGroup', context: context);

  @override
  RouteGroup get routeGroup {
    _$routeGroupAtom.reportRead();
    return super.routeGroup;
  }

  @override
  set routeGroup(RouteGroup value) {
    _$routeGroupAtom.reportWrite(value, super.routeGroup, () {
      super.routeGroup = value;
    });
  }

  late final _$_AppActionController =
      ActionController(name: '_App', context: context);

  @override
  void setTitle(String value) {
    final _$actionInfo =
        _$_AppActionController.startAction(name: '_App.setTitle');
    try {
      return super.setTitle(value);
    } finally {
      _$_AppActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setShowMic(bool value) {
    final _$actionInfo =
        _$_AppActionController.startAction(name: '_App.setShowMic');
    try {
      return super.setShowMic(value);
    } finally {
      _$_AppActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRouteGroup(RouteGroup value) {
    final _$actionInfo =
        _$_AppActionController.startAction(name: '_App.setRouteGroup');
    try {
      return super.setRouteGroup(value);
    } finally {
      _$_AppActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
title: ${title},
showMic: ${showMic},
routeGroup: ${routeGroup}
    ''';
  }
}
