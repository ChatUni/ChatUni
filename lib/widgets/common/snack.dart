import 'package:flutter/material.dart';

import '/globals.dart' as globals;

void snack(String text) {
  globals.scaffoldMessengerKey.currentState!.showSnackBar(
    SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 1),
    ),
  );
}
