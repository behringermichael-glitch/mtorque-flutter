enum HeartRateConnectionStatus {
  disconnected,
  requestingPermissions,
  bluetoothOff,
  scanning,
  connecting,
  connected,
  permissionDenied,
  unsupported,
  error,
}

extension HeartRateConnectionStatusX on HeartRateConnectionStatus {
  bool get isBusy {
    return this == HeartRateConnectionStatus.requestingPermissions ||
        this == HeartRateConnectionStatus.scanning ||
        this == HeartRateConnectionStatus.connecting;
  }

  bool get isConnected => this == HeartRateConnectionStatus.connected;
}