// ignore_for_file: inference_failure_on_function_invocation

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_foundation/core/logging/log_model.dart';
import 'package:flutter_app_foundation/core/network/network_manager.dart';

class LogSender {
  static Null get page => null;
  static final Dio _dio = NetworkManager.instance.dio;

  static Future<void> send(String endpoint, LogModel log) async {
    try {
      if (kDebugMode) {
        debugPrint("📤 Sending log to $endpoint");
        debugPrint("📄 Log message: ${log.toJson()}");
      }

      final data = await _dio.post(endpoint, data: {"LogMesaj": log.exception, "AktifIslem": log.message, "LgLogIslemTuruId": 30});
      if (kDebugMode) {
        debugPrint("✅ Log sent successfully. Response data: ${data.data}");
      }
    } catch (e) {
      // Burada recursive log göndermemek için sadece print ediyoruz
      if (kDebugMode) debugPrint("❌ Failed to send log: $e");
    }
  }
}
