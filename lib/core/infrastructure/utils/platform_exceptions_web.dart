class SocketException implements Exception {
  const SocketException(
    this.message, {
    this.osError,
    this.address,
    this.port,
  });
  final String message;
  final OSError? osError;
  final InternetAddress? address;
  final int? port;

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
  const OSError([this.message = '', this.errorCode = 0]);
  final String message;
  final int errorCode;
  @override
  String toString() => 'OSError: $message, errorCode: $errorCode';
}

class InternetAddress {
  const InternetAddress(this.address, {this.type = InternetAddressType.any});
  final String address;
  final InternetAddressType type;
}

enum InternetAddressType {
  IPv4._(0),
  IPv6._(1),
  any._(2);

  const InternetAddressType._(this._value);
  // ignore: unused_field
  final int _value;
}
