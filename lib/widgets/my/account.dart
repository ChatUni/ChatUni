import 'package:flutter/material.dart';

import '/store/auth.dart';
import '/widgets/common/hoc.dart';
import 'login.dart';
import 'profile.dart';

Widget account() => obs<Auth>((auth) => auth.isLoggedIn ? profile() : login());
