/// Onboarding state notifier for Plexus setup flow.
///
/// Handles database initialization, identity generation, display name
/// entry, and first-launch setup.
library plexus_app.features.onboarding.application.onboarding_notifier;

import 'dart:async';

import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:plexus_core/plexus_core.dart' as core;
import 'package:plexus_crypto/plexus_crypto.dart';
import 'package:plexus_storage/plexus_storage.dart';

/// Onboarding state.
class OnboardingState {
  final bool isLoading;
  final bool isSetupComplete;
  final String? displayName;
  final String? error;
  final String? fingerprint;

  const OnboardingState({
    this.isLoading = false,
    this.isSetupComplete = false,
    this.displayName,
    this.error,
    this.fingerprint,
  });

  OnboardingState copyWith({
    bool? isLoading,
    bool? isSetupComplete,
    String? displayName,
    String? error,
    String? fingerprint,
  }) {
    return OnboardingState(
      isLoading: isLoading ?? this.isLoading,
      isSetupComplete: isSetupComplete ?? this.isSetupComplete,
      displayName: displayName ?? this.displayName,
      error: error ?? this.error,
      fingerprint: fingerprint ?? this.fingerprint,
    );
  }
}

/// Onboarding notifier using Riverpod 3.x Notifier.
class OnboardingNotifier extends Notifier<OnboardingState> {
  PlexusDatabase? _db;
  SqliteIdentityRepository? _identityRepo;
  PlexusCryptoGateway? _crypto;

  @override
  OnboardingState build() => const OnboardingState();

  /// Initialize the database, crypto gateway, and identity repository.
  Future<void> init() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Initialize crypto gateway
      _crypto = PlexusCryptoGateway();

      // Initialize database
      final docsDir = await getApplicationDocumentsDirectory();
      final dbPath = p.join(docsDir.path, 'plexus.db');

      final db = PlexusDatabase(
        LazyDatabase(() async {
          return NativeDatabase(File(dbPath));
        }),
      );

      // Run migrations
      await migrateDatabase(db);
      db.markUnlocked();

      _db = db;
      _identityRepo = SqliteIdentityRepository(db);

      // Check for existing identity
      await checkExistingIdentity(_identityRepo!);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to initialize: $e',
      );
    }
  }

  /// Check if an identity already exists in the database.
  Future<void> checkExistingIdentity(SqliteIdentityRepository repo) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await repo.getAll();
      result.when(
        onSuccess: (identities) {
          if (identities.isNotEmpty) {
            final identity = identities.first;
            state = state.copyWith(
              isLoading: false,
              isSetupComplete: true,
              fingerprint: identity.fingerprint.value,
              displayName: identity.displayName,
            );
          } else {
            state = state.copyWith(isLoading: false);
          }
        },
        onFailure: (failure) {
          state = state.copyWith(
            isLoading: false,
            error: failure.message,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to check existing identity: $e',
      );
    }
  }

  /// Generate a new identity and save it to the database.
  Future<bool> createIdentity({
    required String displayName,
  }) async {
    if (_crypto == null || _identityRepo == null) {
      state = state.copyWith(
        isLoading: false,
        error: 'Not initialized',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Generate key pair
      final keyResult = await _crypto!.generateKeyPair();
      final keyPair = keyResult.when(
        onSuccess: (kp) => kp,
        onFailure: (failure) {
          state = state.copyWith(isLoading: false, error: failure.message);
          return null;
        },
      );
      if (keyPair == null) return false;

      // Compute fingerprint
      final fingerprint = _crypto!.fingerprintOf(keyPair.publicKey);

      // Create identity entity
      final now = DateTime.now().millisecondsSinceEpoch;
      final identity = core.Identity(
        deviceId: core.DeviceId(
          'device-${fingerprint.value.substring(0, 16)}',
        ),
        publicKey: keyPair.publicKey,
        encryptedPrivateKey: keyPair.privateKey,
        fingerprint: fingerprint,
        displayName: displayName,
        createdAt: now,
        updatedAt: now,
      );

      // Save to database
      final saveResult = await _identityRepo!.save(identity);
      final saved = saveResult.when(
        onSuccess: (_) => true,
        onFailure: (failure) {
          state = state.copyWith(isLoading: false, error: failure.message);
          return false;
        },
      );

      if (saved) {
        state = state.copyWith(
          isLoading: false,
          isSetupComplete: true,
          fingerprint: fingerprint.value,
          displayName: displayName,
        );
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create identity: $e',
      );
      return false;
    }
  }

  /// Get the initialized database.
  PlexusDatabase? get database => _db;

  /// Get the identity repository.
  SqliteIdentityRepository? get identityRepository => _identityRepo;

  /// Get the crypto gateway.
  PlexusCryptoGateway? get crypto => _crypto;
}

/// Provider for the onboarding notifier.
final onboardingNotifierProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
  OnboardingNotifier.new,
);
