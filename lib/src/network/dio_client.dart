import 'package:dio/dio.dart';

import 'interceptors/logger_interceptor.dart';


class DioClient {
  static final DioClient _instance = DioClient._internal();
  late Dio _dio;
  String _baseUrl = "https://reqres.in/api/";

  factory DioClient() => _instance;

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    );

    _dio.interceptors.addAll([
      LoggerInterceptor(),
     // ConnectivityInterceptor(),
    ]);
  }

  /// Set Base URL dynamically
  void setBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
    _dio.options.baseUrl = baseUrl;
  }

  /// Set Authorization Token
  void setAuthToken(String token) {
    _dio.options.headers["Authorization"] = "Bearer $token";
  }

  /// Remove Authorization Token
  void removeAuthToken() {
    _dio.options.headers.remove("Authorization");
  }

  /// GET Request with Custom Base URL
  Future<Response> get(
      {
       required  String endpoint,
        String? customBaseUrl,
        Map<String, dynamic>? queryParams,
        Map<String, dynamic>? customHeaders,
        Duration? timeout,
      }) async {
    return _dio.get(
      (customBaseUrl ?? _dio.options.baseUrl) + endpoint,
      queryParameters: queryParams,
    );
  }


  Future<Response?> post(
      String endpoint, {
        String? customBaseUrl,
        dynamic data,
        Map<String, dynamic>? customHeaders,
        Duration? timeout,
      }) async {
    return _dio.post(
      (customBaseUrl ?? _dio.options.baseUrl) + endpoint,
      data: data,
      options: _getOptions(customHeaders, timeout),
    );
  }

  Future<Response?> put(
      String endpoint, {
        String? customBaseUrl,
        dynamic data,
        Map<String, dynamic>? customHeaders,
        Duration? timeout,
      }) async {
    return _dio.put(
      (customBaseUrl ?? _dio.options.baseUrl) + endpoint,
      data: data,
      options: _getOptions(customHeaders, timeout),
    );
  }

  /// DELETE Request with Custom Base URL
  Future<Response?> delete(
      String endpoint, {
        String? customBaseUrl,
        Map<String, dynamic>? customHeaders,
        Duration? timeout,
      }) async {
    return _dio.delete(
      (customBaseUrl ?? _dio.options.baseUrl) + endpoint,
      options: _getOptions(customHeaders, timeout),
    );
  }


  /// Get customized Dio options (headers & timeout)
  Options _getOptions(Map<String, dynamic>? customHeaders, Duration? timeout) {
    final options = Options();
    if (customHeaders != null) {
      options.headers = {..._dio.options.headers, ...customHeaders};
    }
    if (timeout != null) {
      _dio.options.connectTimeout = timeout;
      _dio.options.receiveTimeout = timeout;
    }
    return options;
  }
}
