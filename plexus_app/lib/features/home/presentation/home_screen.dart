/// Plexus home screen — main entry point after setup.
library plexus_app.features.home.presentation.home_screen;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plexus_app/features/onboarding/application/onboarding_notifier.dart';

/// Home screen widget.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plexus'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'Plexus',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(
                  Icons.wifi,
                  color: Color(0xFF6366F1),
                  size: 40,
                ),
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Plexus is an encrypted mesh messenger that works '
                    'without any central server or internet dependency. '
                    'Messages are persisted locally with encryption at rest.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hub,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Plexus',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              state.fingerprint != null
                  ? 'Fingerprint: ${state.fingerprint}'
                  : 'No identity',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Reset Identity'),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Reset Identity'),
                    content: const Text(
                      'This will destroy your identity keys and all data. '
                      'This cannot be undone.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true && context.mounted) {
                  context.go('/setup');
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Peer',
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Peer discovery coming soon')),
          );
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
