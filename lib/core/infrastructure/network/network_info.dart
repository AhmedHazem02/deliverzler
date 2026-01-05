import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../presentation/utils/riverpod_framework.dart';
import 'data_connection_checker.dart';

part 'network_info.g.dart';

@Riverpod(keepAlive: true)
NetworkInfo networkInfo(NetworkInfoRef ref) {
  // DataConnectionChecker uses dart:io (InternetAddress, Socket) which is not supported on web
  final dataConnectionChecker = kIsWeb ? null : DataConnectionChecker();
  return NetworkInfo(
    dataConnectionChecker,
    Connectivity(),
  );
}

class NetworkInfo {
  NetworkInfo(this.dataConnectionChecker, this.connectivity);

  final DataConnectionChecker? dataConnectionChecker;
  final Connectivity connectivity;

  Future<bool> get hasInternetConnection async {
    // On web, dart:io is not available, so we check connectivity instead
    if (dataConnectionChecker == null) {
      final result = await connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    }
    return dataConnectionChecker!.hasConnection;
  }

  Future<ConnectivityResult> get hasNetworkConnectivity => connectivity.checkConnectivity();
}
