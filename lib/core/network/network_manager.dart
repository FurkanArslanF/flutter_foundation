// ignore_for_file: inference_failure_on_function_invocation

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_foundation/core/cache/secure_storage.dart';
import 'package:flutter_app_foundation/core/constants/app_constants.dart';
import 'package:flutter_app_foundation/env.dart';
import 'package:kartal/kartal.dart';

class NetworkManager {
  static final NetworkManager _instance = NetworkManager._();
  static NetworkManager get instance => _instance;

  late final Dio dio;
  final String _baseUrl = Env.baseUrl;

  NetworkManager._() {
    dio = Dio(BaseOptions(baseUrl: _baseUrl, contentType: Headers.jsonContentType, followRedirects: true, maxRedirects: 5))..interceptors.addAll(_getInterceptors());
  }

  List<Interceptor> _getInterceptors() => [
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        await authorizationToken(options);
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        await getToken(response);
        return handler.next(response);
      },
      onError: (error, handler) async {
        await refreshToken(error, handler);
        return handler.next(error);
      },
    ),
    if (kDebugMode) LogInterceptor(responseBody: true, requestBody: true, logPrint: (obj) => debugPrint('[Dio] ${obj.toString().length > 300 ? '${obj.toString().substring(0, 300)}...' : obj}')) else LogInterceptor(responseHeader: false),
  ];

  Future<void> refreshToken(DioException error, ErrorInterceptorHandler handler) async {
    if (error.response?.statusCode == 401) {
      debugPrint('[NetworkManager] onError - Unauthorized, attempting to refresh token...');
      final refreshToken = await SecureStorage.instance.readSecureData(AppConstants.refreshTokenKey);
      if (refreshToken != null && refreshToken.ext.isNotNullOrNoEmpty) {
        try {
          final response = await dio.post('/api/Auth/RefreshToken', options: Options(headers: {'Authorization': 'Bearer $refreshToken'}));
          final newAccessToken = _extractAccessTokenFromCookie(response);
          final newRefreshToken = _extractRefreshTokenFromCookie(response);
          await SecureStorage.instance.writeSecureData(AppConstants.accessTokenKey, newAccessToken ?? '');
          await SecureStorage.instance.writeSecureData(AppConstants.refreshTokenKey, newRefreshToken ?? '');
          debugPrint('[NetworkManager] Token refreshed successfully. Retrying original request...');
          final retryResponse = await dio.fetch(error.requestOptions);
          return handler.resolve(retryResponse);
        } catch (e) {
          debugPrint('[NetworkManager] Token refresh failed: $e');
        }
      }
    }
  }

  Future<void> getToken(Response<dynamic> response) async {
    if (response.requestOptions.path == '/api/Auth/Token') {
      final newAccessToken = _extractAccessTokenFromCookie(response);
      final newRefreshToken = _extractRefreshTokenFromCookie(response);
      if (newAccessToken != null && newAccessToken.ext.isNotNullOrNoEmpty) {
        await SecureStorage.instance.writeSecureData(AppConstants.accessTokenKey, newAccessToken);
      }
      if (newRefreshToken != null && newRefreshToken.ext.isNotNullOrNoEmpty) {
        await SecureStorage.instance.writeSecureData(AppConstants.refreshTokenKey, newRefreshToken);
      }
      debugPrint('[NetworkManager] onResponse - accessToken: $newAccessToken, refreshToken: $newRefreshToken, path: ${response.requestOptions.path}');
    }
  }

  Future<void> authorizationToken(RequestOptions options) async {
    if (options.path != '/api/Auth/Token') {
      final accessToken = await SecureStorage.instance.readSecureData(AppConstants.accessTokenKey);
      if (accessToken != null && accessToken.ext.isNotNullOrNoEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }
  }

  String? _extractAccessTokenFromCookie(Response<dynamic> response) {
    final cookie = response.headers['set-cookie'];
    if (cookie != null) {
      for (final token in cookie) {
        if (token.contains('accessToken')) {
          final accessToken = token.split(';').first;
          return accessToken.split('=').last;
        }
      }
    }
    return null;
  }

  String? _extractRefreshTokenFromCookie(Response<dynamic> response) {
    final cookie = response.headers['set-cookie'];
    if (cookie != null) {
      for (final token in cookie) {
        if (token.contains('refreshToken')) {
          final refreshToken = token.split(';').first;
          return refreshToken.split('=').last;
        }
      }
    }
    return null;
  }
}

class Math {
  static double random() {
    return DateTime.now().microsecondsSinceEpoch % 1000 / 1000;
  }
}
