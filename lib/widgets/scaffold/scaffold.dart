import 'package:flutter/material.dart';
import 'fab.dart';
import 'navbar.dart';
import 'topbar.dart';

Scaffold scaffold(Widget body) => Scaffold(
      extendBody: true,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: TopBar(),
      ),
      body: Container(
        decoration: background(),
        child: body,
      ),
      floatingActionButton: const FabMic(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const NavBar(),
    );

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


// Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children