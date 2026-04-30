import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/flutter_blue_heart_rate_service.dart';
import '../../domain/models/heart_rate_connection_status.dart';
import '../../domain/models/heart_rate_sample.dart';
import '../../domain/services/heart_rate_service.dart';

class HeartRateState {
  const HeartRateState({
    required this.status,
    this.latestSample,
    this.errorMessage,
  });

  final HeartRateConnectionStatus status;
  final HeartRateSample? latestSample;
  final String? errorMessage;

  int? get bpm => latestSample?.bpm;

  bool get isConnected => status == HeartRateConnectionStatus.connected;

  bool get isBusy => status.isBusy;

  HeartRateState copyWith({
    HeartRateConnectionStatus? status,
    HeartRateSample? latestSample,
    String? errorMessage,
    bool clearSample = false,
    bool clearError = false,
  }) {
    return HeartRateState(
      status: status ?? this.status,
      latestSample: clearSample ? null : latestSample ?? this.latestSample,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  static const initial = HeartRateState(
    status: HeartRateConnectionStatus.disconnected,
  );
}

final heartRateServiceProvider = Provider.autoDispose<HeartRateService>((ref) {
  final service = FlutterBlueHeartRateService();

  ref.onDispose(() {
    unawaited(service.dispose());
  });

  return service;
});

final heartRateControllerProvider =
NotifierProvider.autoDispose<HeartRateController, HeartRateState>(
  HeartRateController.new,
);

class HeartRateController extends Notifier<HeartRateState> {
  StreamSubscription<HeartRateConnectionStatus>? _statusSubscription;
  StreamSubscription<HeartRateSample>? _sampleSubscription;
  StreamSubscription<String?>? _errorSubscription;

  @override
  HeartRateState build() {
    final service = ref.watch(heartRateServiceProvider);

    _statusSubscription = service.statusStream.listen((status) {
      state = state.copyWith(
        status: status,
        clearError: status != HeartRateConnectionStatus.error,
      );
    });

    _sampleSubscription = service.sampleStream.listen((sample) {
      state = state.copyWith(
        latestSample: sample,
        status: HeartRateConnectionStatus.connected,
        clearError: true,
      );
    });

    _errorSubscription = service.errorStream.listen((error) {
      state = state.copyWith(
        errorMessage: error,
      );
    });

    ref.onDispose(() {
      unawaited(_statusSubscription?.cancel());
      unawaited(_sampleSubscription?.cancel());
      unawaited(_errorSubscription?.cancel());
    });

    return HeartRateState(
      status: service.currentStatus,
      latestSample: service.latestSample,
      errorMessage: service.latestError,
    );
  }

  Future<void> connect() async {
    await ref.read(heartRateServiceProvider).connect();
  }

  Future<void> disconnect() async {
    await ref.read(heartRateServiceProvider).disconnect();
  }

  Future<void> toggleConnection() async {
    if (state.status == HeartRateConnectionStatus.connected ||
        state.status == HeartRateConnectionStatus.scanning ||
        state.status == HeartRateConnectionStatus.connecting ||
        state.status == HeartRateConnectionStatus.requestingPermissions) {
      await disconnect();
      return;
    }

    await connect();
  }
}