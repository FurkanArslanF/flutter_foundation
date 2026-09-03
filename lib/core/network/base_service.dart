// ignore_for_file: inference_failure_on_function_invocation

import 'package:dio/dio.dart';
import 'package:flutter_app_foundation/core/cache/secure_storage.dart';
import 'package:flutter_app_foundation/core/constants/app_constants.dart';
import 'package:flutter_app_foundation/core/network/dio_error_handler.dart';
import 'package:flutter_app_foundation/core/network/network_manager.dart';

abstract class BaseService {
  final Dio _dio = NetworkManager.instance.dio;

  Dio get dio => _dio;

  bool _isSuccessStatusCode(int? statusCode) => statusCode == 200 || statusCode == 201;

  Future<int> getCultureCode() async {
    final language = await SecureStorage.instance.readSecureData(AppConstants.languageKey) ?? 'tr';
    return language == AppConstants.languageTr ? AppConstants.cultureTurkish : AppConstants.cultureEnglish;
  }

  Future<Map<String, dynamic>> getHeaders() async {
    final cultureCode = await getCultureCode();
    return {'Cookie': 'culture=$cultureCode; cultureKod=$cultureCode; selectedEvent=null;'};
  }

  Options _withHeaders(Options? options, Map<String, dynamic> headers) {
    if (options == null) return Options(headers: headers);
    return options.copyWith(headers: {...headers, ...?options.headers});
  }

  Future<T> get<T>({required String path, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onReceiveProgress, required T Function(dynamic) parser}) async {
    try {
      final headers = await getHeaders();
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: _withHeaders(options, headers),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      if (!_isSuccessStatusCode(response.statusCode)) {
        final apiMessage = DioErrorHandler.tryExtractApiMessage(response);
        throw NetworkException(apiMessage ?? '$path islemi basarisiz oldu', statusCode: response.statusCode);
      }

      if (response.data != null) {
        return parser(response.data);
      }

      throw NetworkException('$path işlemi başarısız oldu');
    } on DioException catch (e) {
      await DioErrorHandler.handleError(e);
    }
  }

  Future<T> post<T>({required String path, dynamic data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress, required T Function(dynamic) parser}) async {
    try {
      final headers = await getHeaders();
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _withHeaders(options, headers),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      if (!_isSuccessStatusCode(response.statusCode)) {
        final apiMessage = DioErrorHandler.tryExtractApiMessage(response);
        throw NetworkException(apiMessage ?? '$path islemi basarisiz oldu', statusCode: response.statusCode);
      }

      if (response.data != null) {
        return parser(response.data);
      }

      throw NetworkException('$path işlemi başarısız oldu');
    } on DioException catch (e) {
      await DioErrorHandler.handleError(e);
    }
  }

  Future<T> put<T>({required String path, dynamic data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress, required T Function(dynamic) parser}) async {
    try {
      final headers = await getHeaders();
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _withHeaders(options, headers),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      if (!_isSuccessStatusCode(response.statusCode)) {
        final apiMessage = DioErrorHandler.tryExtractApiMessage(response);
        throw NetworkException(apiMessage ?? '$path islemi basarisiz oldu', statusCode: response.statusCode);
      }

      if (response.data != null) {
        return parser(response.data);
      }

      throw NetworkException('$path işlemi başarısız oldu');
    } on DioException catch (e) {
      await DioErrorHandler.handleError(e);
    }
  }

  Future<T> delete<T>({required String path, dynamic data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, required T Function(dynamic) parser}) async {
    try {
      final headers = await getHeaders();
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _withHeaders(options, headers),
        cancelToken: cancelToken,
      );

      if (!_isSuccessStatusCode(response.statusCode)) {
        final apiMessage = DioErrorHandler.tryExtractApiMessage(response);
        throw NetworkException(apiMessage ?? '$path islemi basarisiz oldu', statusCode: response.statusCode);
      }

      if (response.data != null) {
        return parser(response.data);
      }

      throw NetworkException('$path işlemi başarısız oldu');
    } on DioException catch (e) {
      await DioErrorHandler.handleError(e);
    }
  }

  Future<T> paginatedGet<T>({
    required String path,
    required int page,
    String pageParameterName = 'page',
    Map<String, dynamic>? queryParameters,
    int? pageSize,
    String pageSizeParameterName = 'pageSize',
    Map<String, dynamic>? additionalData,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    required T Function(dynamic) parser,
  }) async {
    return get(
      path: path,
      queryParameters: {
        pageParameterName: page,
        pageSizeParameterName: pageSize ?? AppConstants.defaultPageSize,
        ...?queryParameters,
        ...?additionalData,
      },
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      parser: parser,
    );
  }

  Future<void> requestWithoutResponse({required String method, required String path, dynamic data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress}) async {
    try {
      final headers = await getHeaders();
      await _dio.request<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _withHeaders(options?.copyWith(method: method), headers),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      await DioErrorHandler.handleError(e);
    }
  }

  // String buildQueryString(Map<String, dynamic> filters) {
  //   final params = filters.entries.where((e) => e.value != null && e.value.toString().isNotEmpty).map((e) => '${e.key}=${e.value}').join('&');
  //   return params.isEmpty ? '' : '?$params';
  // }

  // String buildUrl(String path, Map<String, dynamic>? queryParams) {
  //   if (queryParams == null || queryParams.isEmpty) {
  //     return path;
  //   }
  //   final queryString = buildQueryString(queryParams);
  //   return queryString.isEmpty ? path : '$path$queryString';
  // }
}
