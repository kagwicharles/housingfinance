
  import 'package:flutter/cupertino.dart';

void logLargeString(String message) {
    const int chunkSize = 1000; // Adjust chunk size if needed
    int start = 0;
    while (start < message.length) {
      int end = (start + chunkSize < message.length) ? start + chunkSize : message.length;
      debugPrint(message.substring(start, end));
      start = end;
    }
  }