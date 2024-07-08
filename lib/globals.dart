import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

final _appLinks = AppLinks();

void initListeners() {
  _appLinks.uriLinkStream.listen((uri) {
    print('deeplink - ${uri.pathSegments.join('-')}');
  });
}
