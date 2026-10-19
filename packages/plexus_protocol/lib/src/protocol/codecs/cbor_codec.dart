/// CBOR encoding/decoding helpers for the Plexus protocol.
library plexus_protocol.codecs.cbor_codec;

import 'package:cbor/cbor.dart';

/// The CBOR codec instance used for all Plexus wire encoding.
final _cbor = CborSimpleCodec();

/// Encodes a Dart object (map, list, string, int, etc.) to CBOR bytes.
List<int> cborEncode(Object? object) {
  return _cbor.encode(object);
}

/// Decodes CBOR bytes to a Dart object.
Object? cborDecode(List<int> bytes) {
  return _cbor.decode(bytes);
}

/// Encodes a map to CBOR bytes.
List<int> cborEncodeMap(Map<String, dynamic> map) {
  return _cbor.encode(map);
}

/// Decodes CBOR bytes to a map.
Map<String, dynamic> cborDecodeMap(List<int> bytes) {
  return cborDecode(bytes) as Map<String, dynamic>;
}

/// Encodes a list of bytes to CBOR byte string.
List<int> cborEncodeBytes(List<int> bytes) {
  return _cbor.encode(bytes);
}

/// Decodes a CBOR byte string to a list of bytes.
List<int> cborDecodeBytes(Object? value) {
  if (value is List<int>) {
    return List<int>.from(value);
  }
  throw ArgumentError('Expected CBOR byte string, got ${value.runtimeType}');
}
