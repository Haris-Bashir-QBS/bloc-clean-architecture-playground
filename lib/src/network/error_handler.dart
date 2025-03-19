import 'dart:developer';

import 'package:dio/dio.dart';
import 'api_exceptions.dart';

class ApiErrorHandler {
  static Failure handleError(DioException error) {
    log("Type is ${error.type}");
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkException();
      case DioExceptionType.badResponse:
        return ServerException(
          message: _extractErrorMessage(error),
          requestOptions: error.requestOptions,
          response: error.response,
        );
      default:
        return UnknownException(
          requestOptions: error.requestOptions,
          message: _extractErrorMessage(error),
        );
    }
  }
}

String _extractErrorMessage(DioException error) {
  final data = error.response?.data;
  if (data is Map<String, dynamic> && data.containsKey("message")) {
    return "${data["message"]}";
  }

  return "Error ${error.response?.statusCode}: ${error.response?.statusMessage}";
}
