import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static ConnectivityService? _connectivityManager;
  static Connectivity? _connectivity;

  ConnectivityService._createInstance();

  factory ConnectivityService() {
    if (_connectivityManager == null) {
      _connectivityManager = ConnectivityService._createInstance();
      _connectivity = _getConnectivity();
    }
    return _connectivityManager!;
  }

  static Connectivity _getConnectivity() {
    return _connectivity ??= Connectivity();
  }

  static Future<bool> get isConnected async {
    final connectivityResults = await _connectivity?.checkConnectivity();
    return connectivityResults?.any(
          (result) => result == ConnectivityResult.mobile ||
              result == ConnectivityResult.wifi,
    )??false;
  }
}