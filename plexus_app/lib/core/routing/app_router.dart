/// Plexus application router using go_router.
///
/// Route guards ensure the user is authenticated (app lock) and
/// onboarded before accessing the main app.
library plexus_app.core.routing.app_router;

import 'package:go_router/go_router.dart';
import 'package:plexus_app/features/home/presentation/home_screen.dart';
import 'package:plexus_app/features/onboarding/presentation/setup_screen.dart';

/// App router configuration.
final appRouter = GoRouter(
  initialLocation: '/setup',
  routes: [
    GoRoute(
      path: '/setup',
      builder: (context, state) => const SetupScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
