import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance =
      ConnectivityService._createInstance();
  static final Connectivity _connectivity = Connectivity();

  ConnectivityService._createInstance();

  factory ConnectivityService() => _instance;

  static ConnectivityService get instance => _instance;

  Future<bool> get isConnected async {
    final connectivityResults = await _connectivity.checkConnectivity();
    connectivityResults.forEach((r) => print("Connectivity result : $r"));
    return connectivityResults.any(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi,
    );
  }
}
