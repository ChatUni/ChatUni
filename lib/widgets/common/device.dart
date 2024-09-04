import 'package:chatuni/globals.dart';
import 'package:flutter/material.dart';

class Window {
  Window._();

  static final List<int> _sizes = [600, 768, 992, 1200];

  static double width =
      MediaQuery.of(scaffoldMessengerKey.currentContext!).size.width;
  // WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width;
  static double height =
      MediaQuery.of(scaffoldMessengerKey.currentContext!).size.height;
  // WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.height;

  static bool isMobile() => width < _sizes[1];

  static bool isPad() => width >= _sizes[1] && width < _sizes[3];

  static bool isDesktop() => width >= _sizes[3];

  static bool isPortrait() => width < height;
}
