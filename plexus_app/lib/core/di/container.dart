/// Dependency injection container for Plexus.
///
/// Registers all repositories, gateways, and use cases.
/// Uses manual constructor injection (no service locator) for clarity
/// and testability.
library plexus_app.core.di.container;

/// Dependency injection container.
///
/// All dependencies are instantiated here and injected into use cases
/// and providers. This keeps the dependency graph explicit and avoids
/// service locator anti-patterns.
class Container {
  Container._();

  /// Singleton instance.
  static final Container instance = Container._();

  /// Initializes all dependencies.
  /// Must be called before [runApp].
  Future<void> init() async {
    // Dependencies are initialized in the onboarding notifier
    // See onboarding_notifier.dart for database + crypto setup
  }
}
