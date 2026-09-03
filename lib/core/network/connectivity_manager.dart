import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_app_foundation/core/cache/secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

enum ConnectivityStatus { notDetermined, isConnected, isDisonnected }

class ConnectivityStatusNotifier extends StateNotifier<ConnectivityStatus> {
  ConnectivityStatusNotifier() : super(ConnectivityStatus.notDetermined) {
    _initialize();
  }

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Future<void> _initialize() async {
    _updateState(await _connectivity.checkConnectivity());
    _subscription = _connectivity.onConnectivityChanged.listen(_updateState);
  }

  void _updateState(List<ConnectivityResult> results) {
    final nextState = _resolveStatus(results);
    if (state != nextState) {
      state = nextState;
    }
  }

  ConnectivityStatus _resolveStatus(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return ConnectivityStatus.isDisonnected;
    }

    final hasNetwork = results.any(
      (result) => result == ConnectivityResult.mobile || result == ConnectivityResult.wifi || result == ConnectivityResult.ethernet || result == ConnectivityResult.bluetooth || result == ConnectivityResult.vpn,
    );

    return hasNetwork ? ConnectivityStatus.isConnected : ConnectivityStatus.notDetermined;
  }

  void setOffline() {
    state = ConnectivityStatus.isDisonnected;
  }

  void setOnline() {
    state = ConnectivityStatus.isConnected;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final connectivityStatusProviders = StateNotifierProvider<ConnectivityStatusNotifier, ConnectivityStatus>((ref) {
  return ConnectivityStatusNotifier();
});

Future<void> initializeConnectivityStatus(WidgetRef ref) async {
  final offlineMode = await SecureStorage.instance.readSecureData('offlineMode');
  final notifier = ref.read(connectivityStatusProviders.notifier);

  if (offlineMode == 'false') {
    notifier.setOffline();
    return;
  }

  if (offlineMode == 'true') {
    notifier.setOnline();
    return;
  }

  final connectivityResult = await Connectivity().checkConnectivity();
  final nextStatus = connectivityResult.isEmpty || connectivityResult.contains(ConnectivityResult.none) ? ConnectivityStatus.isDisonnected : ConnectivityStatus.isConnected;

  if (nextStatus == ConnectivityStatus.isConnected) {
    notifier.setOnline();
  } else {
    notifier.setOffline();
  }
}

Future<bool> checkInternet(WidgetRef ref, {bool isLogin = false}) async {
  final offlineMode = await SecureStorage.instance.readSecureData('offlineMode');
  if (offlineMode == 'false') {
    return false;
  }

  final connectivityResult = await Connectivity().checkConnectivity();
  final hasConnection = connectivityResult.isNotEmpty && !connectivityResult.contains(ConnectivityResult.none);

  if (!isLogin) {
    final currentStatus = ref.read(connectivityStatusProviders);
    return hasConnection && currentStatus == ConnectivityStatus.isConnected;
  }

  return hasConnection;
}

Future<void> offlineInternet(WidgetRef ref) async {
  ref.read(connectivityStatusProviders.notifier).setOffline();
  await SecureStorage.instance.writeSecureData('offlineMode', 'false');
}

Future<void> onlineInternet(WidgetRef ref) async {
  ref.read(connectivityStatusProviders.notifier).setOnline();
  await SecureStorage.instance.writeSecureData('offlineMode', 'true');
}
