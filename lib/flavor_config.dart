/// Flavor/Environment configuration for the app
enum Flavor {
  dev,
  staging,
  prod;

  /// Parse flavor from string
  static Flavor fromString(String value) {
    switch (value.toLowerCase()) {
      case 'dev':
      case 'development':
        return Flavor.dev;
      case 'staging':
      case 'stg':
        return Flavor.staging;
      case 'prod':
      case 'production':
        return Flavor.prod;
      default:
        return Flavor.dev; // Default to dev if unknown
    }
  }

  /// Get the environment file name for this flavor
  String get envFileName {
    switch (this) {
      case Flavor.dev:
        return 'env_properties.dev.env';
      case Flavor.staging:
        return 'env_properties.staging.env';
      case Flavor.prod:
        return 'env_properties.prod.env';
    }
  }

}

/// Global flavor configuration
class FlavorConfig {
  static Flavor? _currentFlavor;

  /// Get the current flavor (reads from --dart-define=FLAVOR)
  static Flavor get flavor {
    if (_currentFlavor != null) {
      return _currentFlavor!;
    }

    // Read from --dart-define=FLAVOR
    const flavorString = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    _currentFlavor = Flavor.fromString(flavorString);
    return _currentFlavor!;
  }

  /// Set the current flavor (optional, can override dart-define)
  static void setFlavor(Flavor flavor) {
    _currentFlavor = flavor;
  }

  /// Check if running in development
  static bool get isDev => flavor == Flavor.dev;

  /// Check if running in staging
  static bool get isStaging => flavor == Flavor.staging;

  /// Check if running in production
  static bool get isProduction => flavor == Flavor.prod;

  /// Get the current environment file name
  static String get envFileName => flavor.envFileName;
}
