/// Gateway interfaces (ports) for transport, crypto, and platform concerns.
///
/// Implementations live in `plexus_transport`, `plexus_crypto`, and
/// `plexus_platform`. These interfaces define what the application layer
/// needs, not how it's done.
library plexus_core.gateways;

import 'dart:typed_data';

import '../failures/crypto_failure.dart';
import '../failures/database_failure.dart';
import '../failures/transport_failure.dart';
import '../result.dart';
import '../value_objects/device_id.dart';
import '../value_objects/fingerprint.dart';
import '../value_objects/peer_id.dart';
import '../value_objects/transport_type.dart';
/// A network transport that can discover, connect to, and send/receive frames.
abstract class TransportGateway {
  String get transportType;

  Result<bool, TransportFailure> isAvailable();

  Future<Result<void, TransportFailure>> advertise(
    PeerAdvertisement advertisement,
  );

  Stream<Result<PeerDiscoveredEvent, TransportFailure>> discover();

  Future<Result<TransportConnection, TransportFailure>> connect(
    PeerId peerId,
  );

  Stream<Result<InboundFrame, TransportFailure>> receiveStream();

  Future<Result<void, TransportFailure>> send(
    PeerId peerId,
    Uint8List frame,
  );

  Future<Result<void, TransportFailure>> disconnect(PeerId peerId);

  Stream<Result<TransportState, TransportFailure>> stateStream();
}

/// Advertisement broadcast by a peer during discovery.
class PeerAdvertisement {
  final PeerId peerId;
  final Fingerprint fingerprint;
  final String displayName;
  final Set<TransportType> supportedTransports;
  final bool meshRelayCapable;
  final int timestamp;

  const PeerAdvertisement({
    required this.peerId,
    required this.fingerprint,
    required this.displayName,
    required this.supportedTransports,
    this.meshRelayCapable = false,
    required this.timestamp,
  });
}

/// A discovered peer event from a transport.
class PeerDiscoveredEvent {
  final PeerId peerId;
  final Fingerprint fingerprint;
  final String displayName;
  final TransportType transportType;
  final String? address;
  final int timestamp;

  const PeerDiscoveredEvent({
    required this.peerId,
    required this.fingerprint,
    required this.displayName,
    required this.transportType,
    this.address,
    required this.timestamp,
  });
}

/// An active transport connection to a peer.
class TransportConnection {
  final PeerId peerId;
  final TransportType transportType;
  final String address;

  const TransportConnection({
    required this.peerId,
    required this.transportType,
    required this.address,
  });
}

/// An inbound frame received from a transport.
class InboundFrame {
  final PeerId fromPeerId;
  final Uint8List payload;
  final int receivedAt;

  const InboundFrame({
    required this.fromPeerId,
    required this.payload,
    required this.receivedAt,
  });
}

/// The current state of a transport.
class TransportState {
  final TransportType transportType;
  final bool isAvailable;
  final String? error;

  const TransportState({
    required this.transportType,
    required this.isAvailable,
    this.error,
  });
}

/// Cryptographic operations: key generation, encryption, decryption, ratchet.
abstract class CryptoGateway {
  /// Generate a new X25519 identity keypair.
  Future<Result<KeyPair, CryptoFailure>> generateKeyPair();

  /// Perform X3DH handshake with a peer's public key.
  Future<Result<SessionKey, CryptoFailure>> establishSession(
    PeerId peerId,
    String theirPublicKey,
  );

  /// Encrypt a message for a peer using the session key.
  Future<Result<EncryptedMessage, CryptoFailure>> encrypt(
    PeerId peerId,
    Uint8List plaintext,
  );

  /// Decrypt a message from a peer using the session key.
  Future<Result<Uint8List, CryptoFailure>> decrypt(
    PeerId peerId,
    EncryptedMessage encrypted,
  );

  /// Derive a database encryption key from device ID and unlock secret.
  Future<Result<String, CryptoFailure>> deriveDatabaseKey(
    DeviceId deviceId,
    String unlockSecret,
  );

  /// Compute SHA-256 fingerprint of a public key.
  Fingerprint fingerprintOf(String publicKey);
}

/// A generated key pair.
class KeyPair {
  final String publicKey;
  final String privateKey;

  const KeyPair({required this.publicKey, required this.privateKey});
}

/// A session key established via X3DH.
class SessionKey {
  final PeerId peerId;
  final String keyMaterial;
  final int createdAt;

  const SessionKey({
    required this.peerId,
    required this.keyMaterial,
    required this.createdAt,
  });
}

/// An encrypted message ready for transport.
class EncryptedMessage {
  final Uint8List ciphertext;
  final String nonce;
  final int messageKeyId;

  const EncryptedMessage({
    required this.ciphertext,
    required this.nonce,
    required this.messageKeyId,
  });
}

/// Local storage gateway (abstraction over encrypted SQLite).
abstract class StorageGateway {
  /// Execute a migration to bring the DB to the latest version.
  Future<Result<void, DatabaseFailure>> migrate();

  /// Check if the database is initialized and unlocked.
  Future<Result<bool, DatabaseFailure>> isReady();

  /// Unlock the database with the derived key.
  Future<Result<void, DatabaseFailure>> unlock(String databaseKey);

  /// Lock the database (close connection).
  Future<Result<void, DatabaseFailure>> lock();
}

/// Platform-specific services (biometrics, notifications, etc.).
abstract class PlatformGateway {
  /// Check if biometric authentication is available.
  Future<Result<bool, CryptoFailure>> isBiometricAvailable();

  /// Authenticate the user via biometrics.
  Future<Result<void, CryptoFailure>> authenticateBiometric();

  /// Store a secret in platform secure storage (Keystore/Keychain/DPAPI).
  Future<Result<void, CryptoFailure>> storeSecure(String key, String value);

  /// Read a secret from platform secure storage.
  Future<Result<String?, CryptoFailure>> readSecure(String key);

  /// Delete a secret from platform secure storage.
  Future<Result<void, CryptoFailure>> deleteSecure(String key);
}
