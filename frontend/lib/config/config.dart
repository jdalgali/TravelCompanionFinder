class Config {
  static String apiUrl =
      const String.fromEnvironment('API_URL', defaultValue: '/api/v1');
}
