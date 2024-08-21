@JS()
library jsutils;

import 'dart:js_interop';

@JS('console.log')
external void cl(String msg);

@JS('pusherParse')
external String pusherParse(JSObject data);
