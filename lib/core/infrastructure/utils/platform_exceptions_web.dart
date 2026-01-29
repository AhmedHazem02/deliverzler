class SocketException implements Exception {
  final String message;
  final OSError? osError;
  final InternetAddress? address;
  final int? port;

  const SocketException(
    this.message, {
    this.osError,
    this.address,
    this.port,
  });

  @override
  String toString() {
    var msg = 'SocketException: $message';
    if (osError != null) {
      msg += ', osError: $osError';
    }
    if (address != null) {
      msg += ', address: ${address!.address}';
    }
    if (port != null) {
      msg += ', port: $port';
    }
    return msg;
  }
}

// Dummy classes to support SocketException signature
class OSError {
  final String message;
  final int errorCode;
  const OSError([this.message = "", this.errorCode = 0]);
  @override
  String toString() => "OSError: $message, errorCode: $errorCode";
}

class InternetAddress {
  final String address;
  final InternetAddressType type;
  const InternetAddress(this.address, {this.type = InternetAddressType.any});
}

class InternetAddressType {
  final int _value;
  const InternetAddressType._(this._value);
  static const InternetAddressType IPv4 = InternetAddressType._(0);
  static const InternetAddressType IPv6 = InternetAddressType._(1);
  static const InternetAddressType any = InternetAddressType._(2);
}
