/// The type of network transport used to communicate with a peer.
enum TransportType {
  /// Wi-Fi LAN (mDNS + TCP/TLS).
  wifi,

  /// Bluetooth Low Energy (BLE advertising + GATT).
  ble,

  /// Cellular data (TCP over mobile data, direct IP).
  cellular,

  /// USB tethering / RNDIS.
  usb,

  /// Manual direct IP:port entry.
  directIp,

  /// An optional rendezvous relay (internet, never required).
  rendezvous,
}

extension TransportTypeX on TransportType {
  /// Human-readable label for UI.
  String get label {
    switch (this) {
      case TransportType.wifi:
        return 'Wi-Fi';
      case TransportType.ble:
        return 'Bluetooth';
      case TransportType.cellular:
        return 'Cellular';
      case TransportType.usb:
        return 'USB';
      case TransportType.directIp:
        return 'Direct IP';
      case TransportType.rendezvous:
        return 'Rendezvous';
    }
  }

  /// Whether this transport can operate without internet access.
  bool get worksOffline {
    switch (this) {
      case TransportType.rendezvous:
        return false;
      default:
        return true;
    }
  }
}
