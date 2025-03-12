import 'dart:developer';

import 'package:dio/dio.dart';
import 'api_exceptions.dart';

class ResponseValidator {
  static dynamic validateResponse(Response response) {
    log("Response code is ${response.statusCode}");
    switch (response.statusCode) {
      case 200:
      case 201:
      case 203:
        // return jsonDecode(response.data);
        return response.data;

      case 400:
        log("Here in throw");
        throw BadRequestException(
          response.statusCode,
          response.data.toString(),
          response.requestOptions,
        );

      case 401:
        throw UnauthorisedException(
          response.statusCode,
          response.data.toString(),
          response.requestOptions,
        );

      case 403:
        throw ForbiddenException(
          response.statusCode,
          response.data.toString(),
          response.requestOptions,
        );

      case 404:
        throw NotFoundRequestException(
          response.statusCode,
          response.data.toString(),
          response.requestOptions,
        );

      case 408:
        throw RequestTimeOutException(
          response.statusCode,
          response.data.toString(),
          response.requestOptions,
        );

      case 422:
        throw UnprocessableContent(
          response.statusCode,
          response.data.toString(),
          response.requestOptions,
        );

      case 423:
        throw UnauthorisedException(
          response.statusCode,
          response.data.toString(),
          response.requestOptions,
        );

      case 500:
        throw ServerException(
          statusCode: response.statusCode,
          message: "Server Error: ${response.data}",
          requestOptions: response.requestOptions,
        );

      default:
        throw Failure(
          message:
              "Unexpected error (${response.statusCode}): ${response.data}",
          requestOptions: response.requestOptions,
          response: response,
        );
    }
  }
}
