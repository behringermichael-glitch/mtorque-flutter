import '../models/heart_rate_connection_status.dart';
import '../models/heart_rate_sample.dart';

abstract interface class HeartRateService {
  Stream<HeartRateConnectionStatus> get statusStream;

  Stream<HeartRateSample> get sampleStream;

  Stream<String?> get errorStream;

  HeartRateConnectionStatus get currentStatus;

  HeartRateSample? get latestSample;

  String? get latestError;

  Future<void> connect();

  Future<void> disconnect();

  Future<void> dispose();
}