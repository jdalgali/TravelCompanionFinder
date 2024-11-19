class Config {
  static final String apiUrl =
      String.fromEnvironment('API_URL', defaultValue: '/api/v1');
}
