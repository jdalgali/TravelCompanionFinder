class Config {
  static const String apiUrl = String.fromEnvironment('API_URL',
      defaultValue: 'http://localhost:3000/api/v1');
}
