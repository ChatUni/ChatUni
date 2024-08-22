@JS()
library jsutils;

import 'package:js/js.dart';

@JS('console.log')
external void cl(String msg);

@JS('pusherParse')
external String pusherParse(Object data);
