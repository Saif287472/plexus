/// Cryptographic operations implementation for Plexus.
///
/// Phase 1: SHA-256 fingerprints via crypto package, random key material.
/// Phase 2 will add proper X25519/X3DH/Double Ratchet via pointycastle.
library plexus_crypto.crypto_gateway_impl;

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:plexus_core/plexus_core.dart' as core;

/// Plexus crypto gateway implementation.
class PlexusCryptoGateway implements core.CryptoGateway {
  final _random = Random.secure();

  @override
  Future<core.Result<core.KeyPair, core.CryptoFailure>> generateKeyPair() async {
    try {
      // Phase 1: Generate 32-byte random public/private key material.
      // Phase 2: Replace with proper X25519 via pointycastle.
      final publicKeyBytes = List<int>.generate(32, (_) => _random.nextInt(256));
      final privateKeyBytes = List<int>.generate(32, (_) => _random.nextInt(256));

      return core.ok(core.KeyPair(
        publicKey: base64Url.encode(publicKeyBytes),
        privateKey: base64Url.encode(privateKeyBytes),
      ));
    } on Exception catch (e) {
      return core.err(core.CryptoFailure(
        message: 'Failed to generate key pair: $e',
        code: 'key_generation_failed',
        isRetryable: false,
      ));
    }
  }

  @override
  Future<core.Result<core.SessionKey, core.CryptoFailure>> establishSession(
    core.PeerId peerId,
    String theirPublicKey,
  ) async {
    try {
      // Phase 1: Derive session key from peer IDs using SHA-256.
      // Phase 2: Replace with proper X3DH X25519 Diffie-Hellman.
      final sharedInput = utf8.encode(
        'plexus-session:${peerId.value}:$theirPublicKey',
      );
      final digest = sha256.convert(sharedInput);

      return core.ok(core.SessionKey(
        peerId: peerId,
        keyMaterial: base64Url.encode(digest.bytes),
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ));
    } on Exception catch (e) {
      return core.err(core.CryptoFailure(
        message: 'Failed to establish session: $e',
        code: 'session_establishment_failed',
        isRetryable: false,
      ));
    }
  }

  @override
  Future<core.Result<core.EncryptedMessage, core.CryptoFailure>> encrypt(
    core.PeerId peerId,
    Uint8List plaintext,
  ) async {
    try {
      // Phase 1: Simple XOR encryption with session key.
      // Phase 2: Replace with ChaCha20-Poly1305 or AES-GCM.
      final sessionKey = await _deriveMessageKey(peerId);
      final ciphertext = plaintext.asMap().entries.map((entry) {
        final keyByte = sessionKey[entry.key % sessionKey.length];
        return entry.value ^ keyByte;
      }).toList();

      final nonce = List<int>.generate(12, (_) => _random.nextInt(256));

      return core.ok(core.EncryptedMessage(
        ciphertext: Uint8List.fromList(ciphertext),
        nonce: base64Url.encode(nonce),
        messageKeyId: 0,
      ));
    } on Exception catch (e) {
      return core.err(core.CryptoFailure(
        message: 'Failed to encrypt message: $e',
        code: 'encryption_failed',
        isRetryable: false,
      ));
    }
  }

  @override
  Future<core.Result<Uint8List, core.CryptoFailure>> decrypt(
    core.PeerId peerId,
    core.EncryptedMessage encrypted,
  ) async {
    try {
      // Phase 1: Simple XOR decryption (symmetric with encrypt).
      final sessionKey = await _deriveMessageKey(peerId);
      final decrypted = encrypted.ciphertext.asMap().entries.map((entry) {
        final keyByte = sessionKey[entry.key % sessionKey.length];
        return entry.value ^ keyByte;
      }).toList();

      return core.ok(Uint8List.fromList(decrypted));
    } on Exception catch (e) {
      return core.err(core.CryptoFailure(
        message: 'Failed to decrypt message: $e',
        code: 'decryption_failed',
        isRetryable: false,
      ));
    }
  }

  @override
  Future<core.Result<String, core.CryptoFailure>> deriveDatabaseKey(
    core.DeviceId deviceId,
    String unlockSecret,
  ) async {
    try {
      // Phase 1: SHA-256 + HKDF-style derivation.
      // Phase 2: Replace with Argon2id + HKDF.
      final input = utf8.encode(
        'plexus-db:${deviceId.value}:$unlockSecret',
      );
      final digest = sha256.convert(input);

      return core.ok(base64Url.encode(digest.bytes));
    } on Exception catch (e) {
      return core.err(core.CryptoFailure(
        message: 'Failed to derive database key: $e',
        code: 'key_derivation_failed',
        isRetryable: false,
      ));
    }
  }

  @override
  core.Fingerprint fingerprintOf(String publicKey) {
    final publicKeyBytes = base64Url.decode(publicKey);
    final digest = sha256.convert(publicKeyBytes);
    return core.Fingerprint(base64Url.encode(digest.bytes));
  }

  Future<Uint8List> _deriveMessageKey(core.PeerId peerId) async {
    final input = utf8.encode('plexus-message-key:${peerId.value}');
    final digest = sha256.convert(input);
    return Uint8List.fromList(digest.bytes);
  }
}
