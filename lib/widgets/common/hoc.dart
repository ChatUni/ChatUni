import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

// Observer obs(Widget widget) => Observer(
//       builder: (_) => widget,
//     );

Observer obs<T>(Widget Function(T) builder) => Observer(
      builder: (context) {
        final t = Provider.of<T>(context);
        return builder(t);
      },
    );

Observer obsc<T>(Widget Function(T, BuildContext) builder) => Observer(
      builder: (context) {
        final t = Provider.of<T>(context);
        return builder(t, context);
      },
    );

// mount