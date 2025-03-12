import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '/store/app.dart';
import '/widgets/common/hoc.dart';
import 'fab.dart';
import 'topbar.dart';

Observer scaffold(
  Widget body, {
  String title = '',
  bool showMic = false,
  RouteGroup routeGroup = RouteGroup.tutor,
  Color? bgColor,
}) =>
    obsc<App>((app, context) {
      app.setTitle(title);
      app.setShowMic(showMic);
      app.setRouteGroup(routeGroup);

      return Scaffold(
        extendBody: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: topBar(),
        ),
        body: Container(
          decoration: bgColor == null ? background() : null,
          color: bgColor,
          child: body,
        ),
        floatingActionButton: fabMic(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: null, // app.singleApp.isEmpty ? navBar() : null,
      );
    });

BoxDecoration background() => const BoxDecoration(
      // image: DecorationImage(
      //   image: AssetImage("images/background-gradient-lights.jpg"),
      //   fit: BoxFit.cover,
      // ),
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.blue,
          Colors.white,
        ],
      ),
    );
