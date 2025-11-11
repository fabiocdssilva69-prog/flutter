import 'dart:io';

import 'package:dio/dio.dart';

/// Serviço de rede e HTTP

class NetworkService {
  static NetworkService? _instance;
  late Dio _dio;

  NetworkService._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.barbergo.com/v1',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ),
    );

    // Add interceptors
    _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true, error: true));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token if available
          final token = await _getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Handle token refresh on 401
          if (error.response?.statusCode == 401) {
            final refreshed = await _refreshToken();
            if (refreshed) {
              return handler.resolve(await _retry(error.requestOptions));
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  static NetworkService getInstance() {
    _instance ??= NetworkService._();
    return _instance!;
  }

  // ============================================
  // GET
  // ============================================

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ============================================
  // POST
  // ============================================

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ============================================
  // PUT
  // ============================================

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ============================================
  // DELETE
  // ============================================

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ============================================
  // PATCH
  // ============================================

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ============================================
  // UPLOAD
  // ============================================

  Future<Response> uploadFile(
    String path,
    File file, {
    String fieldName = 'file',
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
  }) async {
    final filename = file.path.split('/').last;
    final formData = FormData.fromMap({
      fieldName: await MultipartFile.fromFile(file.path, filename: filename),
      ...?data,
    });

    return await post(path, data: formData, onSendProgress: onSendProgress);
  }

  // ============================================
  // DOWNLOAD
  // ============================================

  Future<Response> downloadFile(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.download(urlPath, savePath, onReceiveProgress: onReceiveProgress, cancelToken: cancelToken);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ============================================
  // HELPERS
  // ============================================

  Future<String?> _getAuthToken() async {
    // Get token from storage
    return null; // Implement with StorageService
  }

  Future<bool> _refreshToken() async {
    // Implement token refresh logic
    return false;
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(method: requestOptions.method, headers: requestOptions.headers);

    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  NetworkException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Timeout: A conexão demorou muito', type: NetworkExceptionType.timeout);

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data['message'] ?? 'Erro desconhecido';

        if (statusCode == 401) {
          return NetworkException('Não autorizado', type: NetworkExceptionType.unauthorized, statusCode: statusCode);
        } else if (statusCode == 404) {
          return NetworkException(
            'Recurso não encontrado',
            type: NetworkExceptionType.notFound,
            statusCode: statusCode,
          );
        } else if (statusCode != null && statusCode >= 500) {
          return NetworkException('Erro no servidor', type: NetworkExceptionType.serverError, statusCode: statusCode);
        } else {
          return NetworkException(message, type: NetworkExceptionType.badRequest, statusCode: statusCode);
        }

      case DioExceptionType.cancel:
        return NetworkException('Requisição cancelada', type: NetworkExceptionType.cancelled);

      default:
        return NetworkException('Erro de conexão: Verifique sua internet', type: NetworkExceptionType.connectionError);
    }
  }

  void cancelRequests({CancelToken? cancelToken}) {
    if (cancelToken != null) {
      cancelToken.cancel('Request cancelled by user');
    }
  }
}

// ============================================
// EXCEPTIONS
// ============================================

enum NetworkExceptionType { timeout, unauthorized, notFound, serverError, badRequest, cancelled, connectionError }

class NetworkException implements Exception {
  final String message;
  final NetworkExceptionType type;
  final int? statusCode;
  final dynamic data;

  NetworkException(this.message, {required this.type, this.statusCode, this.data});

  @override
  String toString() => message;
}
