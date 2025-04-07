import 'package:bloc_api_integration/src/services/connectivity_service.dart';
import 'package:dio/dio.dart';

class ConnectivityInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    bool isInternetConnected = await ConnectivityService.instance.isConnected;
    if (!isInternetConnected) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: "No Internet Connection",
          type: DioExceptionType.unknown,
        ),
      );
    } else {
      handler.next(options);
    }
  }
}
