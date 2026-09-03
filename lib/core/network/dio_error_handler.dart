// ignore_for_file: strict_raw_type

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_foundation/core/logging/log_service.dart';
import 'package:flutter_app_foundation/core/services/navigation_service.dart';

class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException(this.message, {this.statusCode});
}

class DioErrorHandler {
  DioErrorHandler._();

  static Future<Never> handleError(DioException error) async {
    final message = await _processError(error);
    throw NetworkException(message, statusCode: error.response?.statusCode);
  }

  static Future<String> _processError(DioException error) async {
    // HTML yanıt kontrolü - JSON değil de HTML dönerse 401 gibi algıla
    final isHtmlResponse = _isHtmlResponse(error.response);
    final message = _getErrorMessage(error, isHtmlResponse: isHtmlResponse);

    // Hataları loglama sistemine gönder
    LogService.error('DioException: $message', exception: error, stackTrace: error.stackTrace);

    if (_requiresSessionRecovery(error, isHtmlResponse)) {
      debugPrint('[DioErrorHandler.handleError] Session recovery required, attempting...');
      final reloginSuccess = await _trySessionRecovery(error);
      debugPrint('[DioErrorHandler.handleError] Session recovery result: $reloginSuccess');
      if (!reloginSuccess) {
        debugPrint('[DioErrorHandler.handleError] Navigating to login');
        NavigationService.instance.navigateToLogin(message);
      } else {
        debugPrint('[DioErrorHandler.handleError] Session recovered, NOT navigating to login');
      }
    }

    return message;
  }

  static String _getErrorMessage(DioException error, {required bool isHtmlResponse}) {
    final apiMessage = tryExtractApiMessage(error.response);
    if (apiMessage != null) {
      return apiMessage;
    }

    if (isHtmlResponse) {
      return 'Oturum açmanız gerekiyor';
    }

    // Connection refused hatalarını timeout olarak ele al
    if (_isConnectionRefused(error)) {
      return 'Bağlantı zaman aşımına uğradı';
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Bağlantı zaman aşımına uğradı';
      case DioExceptionType.sendTimeout:
        return 'İstek gönderimi zaman aşımına uğradı';
      case DioExceptionType.receiveTimeout:
        return 'Yanıt alınamadı';
      case DioExceptionType.badResponse:
        return _handleResponseError(error.response?.statusCode);
      case DioExceptionType.cancel:
        return 'İstek iptal edildi';
      // ignore: no_default_cases
      default:
        return 'Bir ağ hatası oluştu';
    }
  }

  static bool _requiresSessionRecovery(DioException error, bool isHtmlResponse) {
    final statusCode = error.response?.statusCode;
    return isHtmlResponse || statusCode == 302 || statusCode == 401 || statusCode == 403 || statusCode == 503;
  }

  static bool _isAuthEndpoint(String path) {
    return path.contains('/Hesap/MobilLogin');
  }

  static Future<bool> _trySessionRecovery(DioException error) async {
    if (_isAuthEndpoint(error.requestOptions.path)) {
      debugPrint('[DioErrorHandler._trySessionRecovery] Auth endpoint, skipping');
      return false;
    }

    if (error.requestOptions.extra['authRecoveryTried'] == true) {
      debugPrint('[DioErrorHandler._trySessionRecovery] Already tried, skipping');
      return false;
    }

    error.requestOptions.extra['authRecoveryTried'] = true;
    debugPrint('[DioErrorHandler._trySessionRecovery] Calling retryLogin...');
    //final result = await NetworkManager.instance.retryLogin();
    //debugPrint('[DioErrorHandler._trySessionRecovery] retryLogin result: $result');
    return true; // TODO bunu result ile değiştir
  }

  // HTML yanıt kontrolü için helper metod
  static bool _isHtmlResponse(Response? response) {
    if (response == null) return false;

    // Content-Type kontrolü
    final contentType = response.headers.value('content-type');
    if (contentType != null && contentType.toLowerCase().contains('text/html')) {
      return true;
    }

    // Response data string kontrolü
    if (response.data is String) {
      final responseString = response.data as String;
      final trimmedResponse = responseString.trim().toLowerCase();

      // HTML etiketleri varlığını kontrol et
      return trimmedResponse.startsWith('<!doctype html') || trimmedResponse.startsWith('<html') || trimmedResponse.contains('<body') || trimmedResponse.contains('<head');
    }

    return false;
  }

  // Connection refused kontrolü için helper metod
  static bool _isConnectionRefused(DioException error) {
    // DioExceptionType.connectionError veya other türündeki hataları kontrol et
    if (error.type == DioExceptionType.connectionError || error.type == DioExceptionType.unknown) {
      final errorMessage = error.message?.toLowerCase() ?? '';
      final errorString = error.error?.toString().toLowerCase() ?? '';

      // Connection refused ile ilgili anahtar kelimeleri kontrol et
      return errorMessage.contains('connection refused') || errorMessage.contains('connection error') || errorString.contains('connection refused') || errorString.contains('socketexception');
    }

    return false;
  }

  static String? tryExtractApiMessage(Response? response) {
    if (response == null) return null;
    return _firstMessageFromDynamic(response.data);
  }

  static String? _firstMessageFromDynamic(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      final message = value.trim();
      return message.isEmpty ? null : message;
    }

    if (value is Map) {
      const candidates = [
        'message',
        'Message',
        'displayText',
        'DisplayText',
        'error',
        'Error',
        'title',
        'detail',
      ];

      for (final key in candidates) {
        final candidate = _firstMessageFromDynamic(value[key]);
        if (candidate != null) {
          return candidate;
        }
      }

      for (final entry in value.entries) {
        final candidate = _firstMessageFromDynamic(entry.value);
        if (candidate != null) {
          return candidate;
        }
      }
    }

    if (value is List) {
      for (final item in value) {
        final candidate = _firstMessageFromDynamic(item);
        if (candidate != null) {
          return candidate;
        }
      }
    }

    return null;
  }

  static String _handleResponseError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Geçersiz istek';
      case 401:
        return 'Oturum açmanız gerekiyor';
      case 403:
        return 'Erişim reddedildi';
      case 404:
        return 'İstek yapılan kaynak bulunamadı';
      case 500:
        return 'Sunucu hatası';
      default:
        return 'Beklenmeyen bir hata oluştu';
    }
  }
}
