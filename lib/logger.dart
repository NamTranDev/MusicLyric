import 'package:flutter/foundation.dart';

const TAG_CORE = 'NamTranDev';

void logger(Object? object, {String? tag}) {
  try {
    StringBuffer log =
        StringBuffer('$TAG_CORE ---- ${tag == null ? '' : '$tag : '}');
    log.write(object);
    log.write(" ");
    log.write(StackTrace.fromString(getLine(StackTrace.current)));
    debugPrint(log.toString());
  } catch (e) {
    print("Error: $e");
  }
}

String getLine(StackTrace trace) {
  return trace.toString().split("\n")[1].split("(")[1].split(")")[0];
}
