import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/models/heart_rate_connection_status.dart';
import '../../domain/models/heart_rate_sample.dart';
import '../../domain/services/heart_rate_service.dart';

class FlutterBlueHeartRateService implements HeartRateService {
  static final Guid _heartRateServiceUuid = Guid('0000180d-0000-1000-8000-00805f9b34fb');
  static final Guid _heartRateMeasurementCharacteristicUuid =
  Guid('00002a37-0000-1000-8000-00805f9b34fb');

  final StreamController<HeartRateConnectionStatus> _statusController =
  StreamController<HeartRateConnectionStatus>.broadcast();
  final StreamController<HeartRateSample> _sampleController =
  StreamController<HeartRateSample>.broadcast();
  final StreamController<String?> _errorController =
  StreamController<String?>.broadcast();

  final List<StreamSubscription<dynamic>> _subscriptions = <StreamSubscription<dynamic>>[];

  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _measurementCharacteristic;

  HeartRateConnectionStatus _currentStatus = HeartRateConnectionStatus.disconnected;
  HeartRateSample? _latestSample;
  String? _latestError;

  bool _isDisposed = false;

  @override
  Stream<HeartRateConnectionStatus> get statusStream => _statusController.stream;

  @override
  Stream<HeartRateSample> get sampleStream => _sampleController.stream;

  @override
  Stream<String?> get errorStream => _errorController.stream;

  @override
  HeartRateConnectionStatus get currentStatus => _currentStatus;

  @override
  HeartRateSample? get latestSample => _latestSample;

  @override
  String? get latestError => _latestError;

  @override
  Future<void> connect() async {
    if (_isDisposed) {
      return;
    }

    if (_currentStatus == HeartRateConnectionStatus.connected ||
        _currentStatus == HeartRateConnectionStatus.scanning ||
        _currentStatus == HeartRateConnectionStatus.connecting ||
        _currentStatus == HeartRateConnectionStatus.requestingPermissions) {
      return;
    }

    _setError(null);

    try {
      _setStatus(HeartRateConnectionStatus.requestingPermissions);
      final hasPermissions = await _requestPermissions();

      if (!hasPermissions) {
        _setStatus(HeartRateConnectionStatus.permissionDenied);
        return;
      }

      final adapterState = await FlutterBluePlus.adapterState.first;

      if (adapterState == BluetoothAdapterState.unavailable) {
        _setStatus(HeartRateConnectionStatus.unsupported);
        return;
      }

      if (adapterState != BluetoothAdapterState.on) {
        _setStatus(HeartRateConnectionStatus.bluetoothOff);
        return;
      }

      await _disconnectInternal();

      final device = await _scanForHeartRateDevice();

      if (device == null) {
        _setStatus(HeartRateConnectionStatus.disconnected);
        return;
      }

      await _connectToDevice(device);
    } catch (error) {
      _setError(error.toString());
      _setStatus(HeartRateConnectionStatus.error);
      await _disconnectInternal();
    }
  }

  @override
  Future<void> disconnect() async {
    await _disconnectInternal();
    _setStatus(HeartRateConnectionStatus.disconnected);
  }

  Future<BluetoothDevice?> _scanForHeartRateDevice() async {
    _setStatus(HeartRateConnectionStatus.scanning);

    final completer = Completer<BluetoothDevice?>();
    Timer? timeoutTimer;

    late final StreamSubscription<List<ScanResult>> scanSubscription;

    scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      if (completer.isCompleted) {
        return;
      }

      for (final result in results) {
        final device = result.device;
        final deviceName = _deviceDisplayName(device);

        if (deviceName.trim().isNotEmpty || result.advertisementData.serviceUuids.isNotEmpty) {
          completer.complete(device);
          return;
        }
      }
    });

    _subscriptions.add(scanSubscription);

    timeoutTimer = Timer(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        completer.complete(null);
      }
    });

    try {
      await FlutterBluePlus.startScan(
        withServices: <Guid>[_heartRateServiceUuid],
        timeout: const Duration(seconds: 10),
      );

      final device = await completer.future;
      return device;
    } finally {
      timeoutTimer.cancel();

      try {
        await FlutterBluePlus.stopScan();
      } catch (_) {
        // Best-effort cleanup.
      }

      await scanSubscription.cancel();
      _subscriptions.remove(scanSubscription);
    }
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    _setStatus(HeartRateConnectionStatus.connecting);

    _connectedDevice = device;

    final connectionSubscription = device.connectionState.listen((connectionState) {
      if (connectionState == BluetoothConnectionState.disconnected &&
          _currentStatus == HeartRateConnectionStatus.connected) {
        _setStatus(HeartRateConnectionStatus.disconnected);
      }
    });

    _subscriptions.add(connectionSubscription);

    await device.connect(
      timeout: const Duration(seconds: 12),
      autoConnect: false,
    );

    final services = await device.discoverServices();

    BluetoothCharacteristic? measurementCharacteristic;

    for (final service in services) {
      if (service.uuid != _heartRateServiceUuid) {
        continue;
      }

      for (final characteristic in service.characteristics) {
        if (characteristic.uuid == _heartRateMeasurementCharacteristicUuid) {
          measurementCharacteristic = characteristic;
          break;
        }
      }

      if (measurementCharacteristic != null) {
        break;
      }
    }

    if (measurementCharacteristic == null) {
      throw StateError('Heart Rate Measurement characteristic not found.');
    }

    _measurementCharacteristic = measurementCharacteristic;

    final valueSubscription = measurementCharacteristic.lastValueStream.listen((value) {
      final bpm = parseHeartRateMeasurement(value);

      if (bpm == null) {
        return;
      }

      final sample = HeartRateSample(
        bpm: bpm,
        timestampMs: DateTime.now().millisecondsSinceEpoch,
        deviceName: _deviceDisplayName(device),
      );

      _latestSample = sample;
      _sampleController.add(sample);
    });

    _subscriptions.add(valueSubscription);

    await measurementCharacteristic.setNotifyValue(true);

    _setStatus(HeartRateConnectionStatus.connected);
  }

  Future<bool> _requestPermissions() async {
    final scanStatus = await Permission.bluetoothScan.request();
    final connectStatus = await Permission.bluetoothConnect.request();

    // Needed for Android <= 11 BLE scans. On Android 12+ this may be unnecessary,
    // but the app already needs location permissions for outdoor tracking.
    await Permission.locationWhenInUse.request();

    return _permissionAccepted(scanStatus) && _permissionAccepted(connectStatus);
  }

  bool _permissionAccepted(PermissionStatus status) {
    return status.isGranted || status.isLimited;
  }

  Future<void> _disconnectInternal() async {
    for (final subscription in List<StreamSubscription<dynamic>>.from(_subscriptions)) {
      await subscription.cancel();
    }

    _subscriptions.clear();

    final characteristic = _measurementCharacteristic;
    _measurementCharacteristic = null;

    if (characteristic != null) {
      try {
        await characteristic.setNotifyValue(false);
      } catch (_) {
        // The device may already be disconnected.
      }
    }

    final device = _connectedDevice;
    _connectedDevice = null;

    if (device != null) {
      try {
        await device.disconnect();
      } catch (_) {
        // The device may already be disconnected.
      }
    }

    try {
      await FlutterBluePlus.stopScan();
    } catch (_) {
      // Scan may not be running.
    }
  }

  void _setStatus(HeartRateConnectionStatus status) {
    if (_isDisposed || _currentStatus == status) {
      return;
    }

    _currentStatus = status;
    _statusController.add(status);
  }

  void _setError(String? error) {
    if (_isDisposed || _latestError == error) {
      return;
    }

    _latestError = error;
    _errorController.add(error);
  }

  String _deviceDisplayName(BluetoothDevice device) {
    final platformName = device.platformName.trim();

    if (platformName.isNotEmpty) {
      return platformName;
    }

    return device.remoteId.str;
  }

  @override
  Future<void> dispose() async {
    if (_isDisposed) {
      return;
    }

    await _disconnectInternal();

    _isDisposed = true;

    await _statusController.close();
    await _sampleController.close();
    await _errorController.close();
  }
}

int? parseHeartRateMeasurement(List<int> value) {
  if (value.length < 2) {
    return null;
  }

  final flags = value[0];
  final is16BitHeartRate = (flags & 0x01) == 0x01;

  if (is16BitHeartRate) {
    if (value.length < 3) {
      return null;
    }

    return value[1] | (value[2] << 8);
  }

  return value[1];
}