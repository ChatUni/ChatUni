import 'package:chatuni/store/app.dart';
import 'package:chatuni/store/auth.dart';
import 'package:chatuni/store/exam.dart';
import 'package:flutter/material.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

String cdVer = '';

App app = App();

// Initialize Auth with auto login enabled
Auth auth = Auth()..setAutoLoginEnabled(true);

Exam exam = Exam();
