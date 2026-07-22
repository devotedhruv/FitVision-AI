enum AppEnvironment {
  development,
  testing,
  production;

  static AppEnvironment parse(String value) {
    return switch (value.trim().toLowerCase()) {
      'development' => development,
      'testing' => testing,
      'production' => production,
      _ => throw ArgumentError.value(
        value,
        'APP_ENV',
        'Unsupported environment',
      ),
    };
  }
}
