import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract interface class ConnectivityMonitor {
  Stream<void> get reconnects;
  Future<bool> get hasNetworkInterface;
}

class ConnectivityPlusMonitor implements ConnectivityMonitor {
  ConnectivityPlusMonitor([Connectivity? connectivity])
    : _connectivity = connectivity ?? Connectivity();
  final Connectivity _connectivity;
  @override
  Stream<void> get reconnects =>
      _connectivity.onConnectivityChanged.where(_available).map((_) {});
  @override
  Future<bool> get hasNetworkInterface async =>
      _available(await _connectivity.checkConnectivity());
  bool _available(List<ConnectivityResult> values) =>
      values.any((value) => value != ConnectivityResult.none);
}
