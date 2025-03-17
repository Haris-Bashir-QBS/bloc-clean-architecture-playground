import 'package:dio/dio.dart';

/// Base API Exception extending DioException
class Failure extends DioException {
  @override
  final String message;

  Failure({
    required this.message,
    RequestOptions? requestOptions,
    super.response,
    super.error,
    super.type,
  }) : super(
         message: message,
         requestOptions: requestOptions ?? RequestOptions(),
       );

  @override
  String toString() => message;
}

/// **Server Errors (5xx)**
class ServerException extends Failure {
  ServerException({
    int? statusCode,
    required super.message,
    RequestOptions? requestOptions,
    super.response,
  }) : super(
         type: DioExceptionType.badResponse,
         requestOptions: requestOptions ?? RequestOptions(),
       );
}

/// **Client Errors (4xx)**
class BadRequestException extends Failure {
  BadRequestException(
    int? statusCode,
    String message,
    RequestOptions requestOptions,
  ) : super(
        message: "Bad Request ($statusCode): $message",
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
      );
}

class UnauthorisedException extends Failure {
  UnauthorisedException(
    int? statusCode,
    String message,
    RequestOptions requestOptions,
  ) : super(
        message: "Unauthorized ($statusCode): $message",
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
      );
}

class ForbiddenException extends Failure {
  ForbiddenException(
    int? statusCode,
    String message,
    RequestOptions requestOptions,
  ) : super(
        message: "Forbidden ($statusCode): $message",
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
      );
}

class NotFoundRequestException extends Failure {
  NotFoundRequestException(
    int? statusCode,
    String message,
    RequestOptions requestOptions,
  ) : super(
        message: "Not Found ($statusCode): $message",
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
      );
}

/// **Timeout & Network Issues**
class NetworkException extends Failure {
  NetworkException(RequestOptions requestOptions)
    : super(
        message: "No Internet Connection.",
        requestOptions: requestOptions,
        type: DioExceptionType.connectionTimeout,
      );
}

class RequestTimeOutException extends Failure {
  RequestTimeOutException(
    int? statusCode,
    String message,
    RequestOptions requestOptions,
  ) : super(
        message: "Request Timeout ($statusCode): $message",
        requestOptions: requestOptions,
        type: DioExceptionType.sendTimeout,
      );
}

/// **Unprocessable Content (422)**
class UnprocessableContent extends Failure {
  UnprocessableContent(
    int? statusCode,
    String message,
    RequestOptions requestOptions,
  ) : super(
        message: "Unprocessable Entity ($statusCode): $message",
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
      );
}

/// **Unknown Error**
class UnknownException extends Failure {
  UnknownException({RequestOptions? requestOptions, String? message})
    : super(
        message: message ?? "Something went wrong.",
        requestOptions: requestOptions ?? RequestOptions(),
        type: DioExceptionType.unknown,
      );
}
