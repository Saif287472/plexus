/// CBOR encoding/decoding helpers for the Plexus protocol.
///
/// Uses the `cbor` package for deterministic CBOR encoding (RFC 8949 §4.2).
library plexus_protocol.codecs.cbor_codec;

import 'package:cbor/cbor.dart';

/// Encodes a map to CBOR bytes.
List<int> cborEncode(Map<String, dynamic> map) {
  return CborEncoder.encode(map);
}

/// Decodes CBOR bytes to a map.
Map<String, dynamic> cborDecode(List<int> bytes) {
  return CborDecoder.decode(bytes) as Map<String, dynamic>;
}

/// Encodes a value to CBOR bytes.
List<int> cborEncodeValue(dynamic value) {
  return CborEncoder.encode(value);
}

/// Decodes CBOR bytes to a value.
dynamic cborDecodeValue(List<int> bytes) {
  return CborDecoder.decode(bytes);
}

/// Encodes a list of bytes to CBOR byte string.
List<int> cborEncodeBytes(List<int> bytes) {
  return CborEncoder.encode(CborByteString(bytes));
}

/// Decodes a CBOR byte string to a list of bytes.
List<int> cborDecodeBytes(dynamic value) {
  if (value is CborByteString) {
    return List<int>.from(value.bytes);
  }
  if (value is List<int>) {
    return List<int>.from(value);
  }
  throw ArgumentError('Expected CBOR byte string, got ${value.runtimeType}');
}
