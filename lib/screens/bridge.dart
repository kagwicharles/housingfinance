
import 'package:flutter/services.dart';

class NativeBridge {
  static const MethodChannel _channel = MethodChannel('native_bridge');

  static Future<String?> getPlatformVersion() async {
    return await _channel.invokeMethod('getPlatformVersion');
  }
}